import { executeTransaction, query } from '../config/database.js';

/**
 * 批量同步任务（上传本地变更 + 下载服务器变更）- 带事务支持
 */
export async function syncTasks(req, res) {
  const userId = req.userId;
  const {
    device_id,
    last_sync_at,
    tasks = [],
    deleted_task_ids = [],
    lists = [],
    deleted_list_ids = [],
    tags = [],
    deleted_tag_ids = []
  } = req.body;

  try {
    // 使用事务确保所有操作的原子性
    const syncResult = await executeTransaction(async (conn) => {
      const result = {
        uploaded_tasks: 0,
        downloaded_tasks: [],
        conflicts: [],
        deleted_tasks: 0,
        uploaded_lists: 0,
        downloaded_lists: [],
        uploaded_tags: 0,
        downloaded_tags: [],
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
                title = ?, description = ?, list_id = ?, tags = ?, priority = ?, status = ?,
                due_at = ?, remind_at = ?, repeat_type = ?, repeat_rule = ?, sub_tasks = ?,
                attachments = ?, smart_reminders = ?, estimated_minutes = ?, actual_minutes = ?,
                focus_sessions = ?, location_reminder = ?, sort_order = ?, is_pinned = ?,
                color = ?, template_id = ?, completed_at = ?, deleted_at = ?, version = ?
              WHERE client_id = ? AND user_id = ?`,
              [
                task.title,
                task.description,
                task.list_id,
                task.tags ? JSON.stringify(task.tags) : null,
                task.priority,
                task.status,
                task.due_at,
                task.remind_at,
                task.repeat_type,
                task.repeat_rule ? JSON.stringify(task.repeat_rule) : null,
                task.sub_tasks ? JSON.stringify(task.sub_tasks) : null,
                task.attachments ? JSON.stringify(task.attachments) : null,
                task.smart_reminders ? JSON.stringify(task.smart_reminders) : null,
                task.estimated_minutes,
                task.actual_minutes,
                task.focus_sessions ? JSON.stringify(task.focus_sessions) : null,
                task.location_reminder ? JSON.stringify(task.location_reminder) : null,
                task.sort_order,
                task.is_pinned ? 1 : 0,
                task.color,
                task.template_id,
                task.completed_at,
                task.deleted_at,
                (task.version || serverTask.version) + 1,
                task.id,
                userId
              ]
            );
          } else {
            // 创建新任务
            await conn.execute(
              `INSERT INTO user_tasks (
                user_id, client_id, title, description, list_id, tags, priority, status,
                due_at, remind_at, repeat_type, repeat_rule, sub_tasks, attachments,
                smart_reminders, estimated_minutes, actual_minutes, focus_sessions,
                location_reminder, sort_order, is_pinned, color, template_id,
                completed_at, deleted_at, version, created_at, updated_at
              ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
              [
                userId,
                task.id,
                task.title,
                task.description,
                task.list_id,
                task.tags ? JSON.stringify(task.tags) : null,
                task.priority || 'none',
                task.status || 'pending',
                task.due_at,
                task.remind_at,
                task.repeat_type,
                task.repeat_rule ? JSON.stringify(task.repeat_rule) : null,
                task.sub_tasks ? JSON.stringify(task.sub_tasks) : null,
                task.attachments ? JSON.stringify(task.attachments) : null,
                task.smart_reminders ? JSON.stringify(task.smart_reminders) : null,
                task.estimated_minutes,
                task.actual_minutes,
                task.focus_sessions ? JSON.stringify(task.focus_sessions) : null,
                task.location_reminder ? JSON.stringify(task.location_reminder) : null,
                task.sort_order || 0,
                task.is_pinned ? 1 : 0,
                task.color,
                task.template_id,
                task.completed_at,
                task.deleted_at,
                task.version || 1,
                task.created_at || new Date(),
                task.updated_at || new Date()
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

      // ==================== 列表同步 ====================

      // 4. 上传列表
      for (const list of lists) {
        try {
          const [existingLists] = await conn.execute(
            'SELECT * FROM user_lists WHERE client_id = ? AND user_id = ?',
            [list.id, userId]
          );

          if (existingLists.length > 0) {
            await conn.execute(
              'UPDATE user_lists SET name = ?, icon = ?, color = ?, sort_order = ?, is_default = ?, deleted_at = ? WHERE client_id = ? AND user_id = ?',
              [list.name, list.icon, list.color, list.sort_order, list.is_default ? 1 : 0, list.deleted_at, list.id, userId]
            );
          } else {
            await conn.execute(
              'INSERT INTO user_lists (user_id, client_id, name, icon, color, sort_order, is_default, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
              [userId, list.id, list.name, list.icon, list.color, list.sort_order || 0, list.is_default ? 1 : 0, list.created_at || new Date(), list.updated_at || new Date()]
            );
          }
          result.uploaded_lists++;
        } catch (error) {
          console.error(`上传列表 ${list.id} 失败:`, error);
          throw error;
        }
      }

      // 5. 处理删除的列表
      if (deleted_list_ids.length > 0) {
        const placeholders = deleted_list_ids.map(() => '?').join(',');
        await conn.execute(
          `UPDATE user_lists SET deleted_at = NOW() WHERE client_id IN (${placeholders}) AND user_id = ?`,
          [...deleted_list_ids, userId]
        );
      }

      // 6. 下载服务器列表
      let listDownloadSql = 'SELECT * FROM user_lists WHERE user_id = ?';
      const listDownloadParams = [userId];

      if (last_sync_at) {
        listDownloadSql += ' AND updated_at > ?';
        listDownloadParams.push(last_sync_at);
      }

      const [serverLists] = await conn.execute(listDownloadSql, listDownloadParams);
      result.downloaded_lists = serverLists.map(formatListResponse);

      // ==================== 标签同步 ====================

      // 7. 上传标签
      for (const tag of tags) {
        try {
          const [existingTags] = await conn.execute(
            'SELECT * FROM user_tags WHERE client_id = ? AND user_id = ?',
            [tag.id, userId]
          );

          if (existingTags.length > 0) {
            await conn.execute(
              'UPDATE user_tags SET name = ?, color = ?, deleted_at = ? WHERE client_id = ? AND user_id = ?',
              [tag.name, tag.color, tag.deleted_at, tag.id, userId]
            );
          } else {
            await conn.execute(
              'INSERT INTO user_tags (user_id, client_id, name, color, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)',
              [userId, tag.id, tag.name, tag.color, tag.created_at || new Date(), tag.updated_at || new Date()]
            );
          }
          result.uploaded_tags++;
        } catch (error) {
          console.error(`上传标签 ${tag.id} 失败:`, error);
          throw error;
        }
      }

      // 8. 处理删除的标签
      if (deleted_tag_ids.length > 0) {
        const placeholders = deleted_tag_ids.map(() => '?').join(',');
        await conn.execute(
          `UPDATE user_tags SET deleted_at = NOW() WHERE client_id IN (${placeholders}) AND user_id = ?`,
          [...deleted_tag_ids, userId]
        );
      }

      // 9. 下载服务器标签
      let tagDownloadSql = 'SELECT * FROM user_tags WHERE user_id = ?';
      const tagDownloadParams = [userId];

      if (last_sync_at) {
        tagDownloadSql += ' AND updated_at > ?';
        tagDownloadParams.push(last_sync_at);
      }

      const [serverTags] = await conn.execute(tagDownloadSql, tagDownloadParams);
      result.downloaded_tags = serverTags.map(formatTagResponse);

      // 10. 记录同步日志（在事务内）
      await conn.execute(
        'INSERT INTO sync_logs (user_id, device_id, sync_type, records_count, status) VALUES (?, ?, ?, ?, ?)',
        [userId, device_id, 'full', result.uploaded_tasks + result.uploaded_lists + result.uploaded_tags, 'success']
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

    const lists = await query(
      'SELECT * FROM user_lists WHERE user_id = ?',
      [userId]
    );

    const tags = await query(
      'SELECT * FROM user_tags WHERE user_id = ?',
      [userId]
    );

    res.json({
      success: true,
      message: '全量同步数据获取成功',
      data: {
        tasks: tasks.map(formatTaskResponse),
        lists: lists.map(formatListResponse),
        tags: tags.map(formatTagResponse),
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
    description: task.description,
    list_id: task.list_id,
    tags: task.tags ? (typeof task.tags === 'string' ? JSON.parse(task.tags) : task.tags) : [],
    priority: task.priority,
    status: task.status,
    due_at: task.due_at,
    remind_at: task.remind_at,
    repeat_type: task.repeat_type,
    repeat_rule: task.repeat_rule ? (typeof task.repeat_rule === 'string' ? JSON.parse(task.repeat_rule) : task.repeat_rule) : null,
    sub_tasks: task.sub_tasks ? (typeof task.sub_tasks === 'string' ? JSON.parse(task.sub_tasks) : task.sub_tasks) : [],
    attachments: task.attachments ? (typeof task.attachments === 'string' ? JSON.parse(task.attachments) : task.attachments) : [],
    smart_reminders: task.smart_reminders ? (typeof task.smart_reminders === 'string' ? JSON.parse(task.smart_reminders) : task.smart_reminders) : [],
    estimated_minutes: task.estimated_minutes,
    actual_minutes: task.actual_minutes,
    focus_sessions: task.focus_sessions ? (typeof task.focus_sessions === 'string' ? JSON.parse(task.focus_sessions) : task.focus_sessions) : [],
    location_reminder: task.location_reminder ? (typeof task.location_reminder === 'string' ? JSON.parse(task.location_reminder) : task.location_reminder) : null,
    sort_order: task.sort_order,
    is_pinned: task.is_pinned === 1,
    color: task.color,
    template_id: task.template_id,
    completed_at: task.completed_at,
    deleted_at: task.deleted_at,
    version: task.version,
    created_at: task.created_at,
    updated_at: task.updated_at
  };
}

function formatListResponse(list) {
  return {
    id: list.client_id,
    server_id: list.id,
    name: list.name,
    icon: list.icon,
    color: list.color,
    sort_order: list.sort_order,
    is_default: list.is_default === 1,
    deleted_at: list.deleted_at,
    created_at: list.created_at,
    updated_at: list.updated_at
  };
}

function formatTagResponse(tag) {
  return {
    id: tag.client_id,
    server_id: tag.id,
    name: tag.name,
    color: tag.color,
    deleted_at: tag.deleted_at,
    created_at: tag.created_at,
    updated_at: tag.updated_at
  };
}
