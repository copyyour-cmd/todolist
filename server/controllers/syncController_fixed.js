import { executeTransaction, query } from '../config/database.js';

/**
 * 将ISO日期字符串转换为MySQL datetime格式
 */
function toMySQLDatetime(isoString) {
  if (!isoString) return null;
  try {
    const date = new Date(isoString);
    return date.toISOString().slice(0, 19).replace('T', ' ');
  } catch {
    return null;
  }
}

/**
 * 批量同步任务（上传本地变更 + 下载服务器变更）- 带事务支持
 * 匹配实际数据库表结构
 */
export async function syncTasks(req, res) {
  const userId = req.userId;
  const {
    device_id,
    last_sync_at,
    tasks = [],
    deleted_task_ids = []
  } = req.body;

  try {
    // 使用事务确保所有操作的原子性
    const syncResult = await executeTransaction(async (conn) => {
      const result = {
        uploaded_tasks: 0,
        downloaded_tasks: [],
        conflicts: [],
        deleted_tasks: 0,
        sync_at: new Date().toISOString()
      };

      // ==================== 任务同步 ====================

      // 1. 上传客户端任务到服务器
      for (const task of tasks) {
        try {
          const [existingTasks] = await conn.execute(
            'SELECT * FROM user_tasks WHERE client_id = ? AND user_id = ?',
            [task.id, userId]
          );

          if (existingTasks.length > 0) {
            const serverTask = existingTasks[0];

            // 版本冲突检测
            if (task.version && task.version < serverTask.version) {
              result.conflicts.push({
                type: 'task',
                client_id: task.id,
                conflict_type: 'version',
                server_version: serverTask.version,
                client_version: task.version,
                server_data: formatTaskResponse(serverTask),
                client_data: task
              });
              continue;
            }

            // 更新任务
            await conn.execute(
              `UPDATE user_tasks SET
                title = ?, notes = ?, list_id = ?, priority = ?, status = ?,
                due_at = ?, remind_at = ?, completed_at = ?, deleted_at = ?, version = ?
              WHERE client_id = ? AND user_id = ?`,
              [
                task.title,
                task.description || task.notes,
                task.list_id,
                task.priority || 'none',
                task.status || 'pending',
                toMySQLDatetime(task.due_at),
                toMySQLDatetime(task.remind_at),
                toMySQLDatetime(task.completed_at),
                toMySQLDatetime(task.deleted_at),
                (task.version || serverTask.version) + 1,
                task.id,
                userId
              ]
            );
          } else {
            // 创建新任务
            await conn.execute(
              `INSERT INTO user_tasks (
                user_id, client_id, title, notes, list_id, priority, status,
                due_at, remind_at, completed_at, deleted_at, version
              ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
              [
                userId,
                task.id,
                task.title,
                task.description || task.notes || '',
                task.list_id,
                task.priority || 'none',
                task.status || 'pending',
                toMySQLDatetime(task.due_at),
                toMySQLDatetime(task.remind_at),
                toMySQLDatetime(task.completed_at),
                toMySQLDatetime(task.deleted_at),
                task.version || 1
              ]
            );
          }

          result.uploaded_tasks++;
        } catch (error) {
          console.error(`上传任务 ${task.id} 失败:`, error);
          // 在事务中，任何错误都会导致整个事务回滚
          throw error;
        }
      }

      // 2. 处理客户端删除的任务
      if (deleted_task_ids.length > 0) {
        const placeholders = deleted_task_ids.map(() => '?').join(',');
        const [deleteResult] = await conn.execute(
          `UPDATE user_tasks SET deleted_at = NOW(), version = version + 1
           WHERE client_id IN (${placeholders}) AND user_id = ? AND deleted_at IS NULL`,
          [...deleted_task_ids, userId]
        );
        result.deleted_tasks = deleteResult.affectedRows;
      }

      // 3. 下载服务器端的新任务和更新
      let downloadSql = 'SELECT * FROM user_tasks WHERE user_id = ?';
      const downloadParams = [userId];

      if (last_sync_at) {
        downloadSql += ' AND updated_at > ?';
        downloadParams.push(last_sync_at);
      }

      downloadSql += ' ORDER BY updated_at DESC';
      const [serverTasks] = await conn.execute(downloadSql, downloadParams);
      result.downloaded_tasks = serverTasks.map(formatTaskResponse);

      // 4. 记录同步日志（在事务内）
      await conn.execute(
        'INSERT INTO sync_logs (user_id, device_id, sync_type, records_count, status) VALUES (?, ?, ?, ?, ?)',
        [userId, device_id, 'full', result.uploaded_tasks, 'success']
      );

      return result;
    });

    // 事务成功提交，返回结果
    res.json({
      success: true,
      message: '同步成功',
      data: syncResult
    });
  } catch (error) {
    console.error('同步失败（事务已回滚）:', error);

    // 记录失败日志（不在事务中）
    try {
      await query(
        'INSERT INTO sync_logs (user_id, device_id, sync_type, status, error_message) VALUES (?, ?, ?, ?, ?)',
        [userId, device_id, 'full', 'failed', error.message]
      );
    } catch (logError) {
      console.error('记录同步日志失败:', logError);
    }

    res.status(500).json({
      success: false,
      message: '同步失败，所有操作已回滚',
      error: error.message
    });
  }
}

/**
 * 获取同步状态
 */
export async function getSyncStatus(req, res) {
  const userId = req.userId;

  try {
    const logs = await query(
      'SELECT * FROM sync_logs WHERE user_id = ? ORDER BY sync_at DESC LIMIT 10',
      [userId]
    );

    const pendingTasks = await query(
      'SELECT COUNT(*) as count FROM user_tasks WHERE user_id = ? AND sync_status > 0',
      [userId]
    );

    res.json({
      success: true,
      data: {
        last_sync: logs.length > 0 ? logs[0].sync_at : null,
        sync_history: logs,
        pending_sync_count: pendingTasks[0].count
      }
    });
  } catch (error) {
    console.error('获取同步状态失败:', error);
    res.status(500).json({
      success: false,
      message: '获取同步状态失败',
      error: error.message
    });
  }
}

/**
 * 强制全量同步（用于解决冲突）
 */
export async function forceFullSync(req, res) {
  const userId = req.userId;

  try {
    const tasks = await query(
      'SELECT * FROM user_tasks WHERE user_id = ?',
      [userId]
    );

    res.json({
      success: true,
      message: '全量同步数据获取成功',
      data: {
        tasks: tasks.map(formatTaskResponse),
        sync_at: new Date().toISOString()
      }
    });
  } catch (error) {
    console.error('全量同步失败:', error);
    res.status(500).json({
      success: false,
      message: '全量同步失败',
      error: error.message
    });
  }
}

// ==================== 辅助函数 ====================

function formatTaskResponse(task) {
  return {
    id: task.client_id,
    server_id: task.id,
    title: task.title,
    description: task.notes,  // 映射notes到description给客户端
    notes: task.notes,
    list_id: task.list_id,
    priority: task.priority,
    status: task.status,
    due_at: task.due_at,
    remind_at: task.remind_at,
    completed_at: task.completed_at,
    deleted_at: task.deleted_at,
    version: task.version,
    sync_status: task.sync_status,
    created_at: task.created_at,
    updated_at: task.updated_at
  };
}
