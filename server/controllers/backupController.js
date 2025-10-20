import { query } from '../config/database.js';
import crypto from 'crypto';
import zlib from 'zlib';
import { promisify } from 'util';

const gzip = promisify(zlib.gzip);
const gunzip = promisify(zlib.gunzip);

/**
 * 创建完整备份
 */
export async function createBackup(req, res) {
  const userId = req.userId;
  const {
    backupName,
    backupType = 'full',
    deviceId,
    deviceName,
    deviceType,
    appVersion,
    enableCompression = false,
    enableEncryption = false
  } = req.body;

  try {
    // 1. 获取用户所有任务
    const tasks = await query(
      'SELECT * FROM user_tasks WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );

    // 2. 获取用户列表
    const lists = await query(
      'SELECT * FROM user_lists WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );

    // 3. 获取用户标签
    const tags = await query(
      'SELECT * FROM user_tags WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );

    // 4. 获取用户设置
    const settings = await query(
      'SELECT settings_data FROM user_app_settings WHERE user_id = ?',
      [userId]
    );

    // 5. 组装备份数据
    const backupData = {
      version: '1.0',
      timestamp: new Date().toISOString(),
      user_id: userId,
      data: {
        tasks: tasks,
        lists: lists,
        tags: tags,
        settings: settings.length > 0 ? JSON.parse(settings[0].settings_data) : {}
      },
      metadata: {
        tasks_count: tasks.length,
        lists_count: lists.length,
        tags_count: tags.length,
        backup_type: backupType
      }
    };

    let backupDataString = JSON.stringify(backupData);
    let backupSize = Buffer.byteLength(backupDataString, 'utf8');
    let isCompressed = 0;
    let isEncrypted = 0;

    // 6. 压缩处理
    if (enableCompression) {
      const compressed = await gzip(backupDataString);
      backupDataString = compressed.toString('base64');
      backupSize = compressed.length;
      isCompressed = 1;
    }

    // 7. 加密处理（简单示例，生产环境需要更安全的实现）
    if (enableEncryption) {
      // 这里使用简单的加密示例，实际应该使用用户密钥
      // 生产环境建议使用 AES-256-GCM
      const cipher = crypto.createCipher('aes-256-cbc', process.env.BACKUP_ENCRYPTION_KEY || 'default-key');
      let encrypted = cipher.update(backupDataString, 'utf8', 'base64');
      encrypted += cipher.final('base64');
      backupDataString = encrypted;
      isEncrypted = 1;
    }

    // 8. 计算数据哈希
    const dataHash = crypto
      .createHash('sha256')
      .update(backupDataString)
      .digest('hex');

    // 9. 保存备份记录
    const result = await query(
      `INSERT INTO user_backups (
        user_id, backup_name, backup_type, backup_size,
        device_id, device_name, device_type, app_version,
        backup_data, data_hash, is_encrypted, is_compressed, backup_status
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        userId,
        backupName || `备份_${new Date().toLocaleString('zh-CN')}`,
        backupType,
        backupSize,
        deviceId,
        deviceName,
        deviceType,
        appVersion,
        backupDataString,
        dataHash,
        isEncrypted,
        isCompressed,
        'completed'
      ]
    );

    const backupId = result.insertId;

    // 10. 记录备份历史
    await query(
      `INSERT INTO backup_restore_history (
        user_id, backup_id, operation_type, status, items_count, device_id, ip_address
      ) VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        userId,
        backupId,
        'backup',
        'success',
        tasks.length + lists.length + tags.length,
        deviceId,
        req.ip
      ]
    );

    res.status(201).json({
      success: true,
      message: '备份创建成功',
      data: {
        backup_id: backupId,
        backup_name: backupName || `备份_${new Date().toLocaleString('zh-CN')}`,
        backup_size: backupSize,
        items_count: tasks.length + lists.length + tags.length,
        is_compressed: isCompressed === 1,
        is_encrypted: isEncrypted === 1,
        created_at: new Date()
      }
    });
  } catch (error) {
    console.error('创建备份失败:', error);

    // 记录失败历史
    try {
      await query(
        `INSERT INTO backup_restore_history (
          user_id, operation_type, status, error_message, device_id, ip_address
        ) VALUES (?, ?, ?, ?, ?, ?)`,
        [userId, 'backup', 'failed', error.message, req.body.deviceId, req.ip]
      );
    } catch (historyError) {
      console.error('记录备份历史失败:', historyError);
    }

    res.status(500).json({
      success: false,
      message: '备份创建失败',
      error: error.message
    });
  }
}

/**
 * 恢复备份
 */
export async function restoreBackup(req, res) {
  const userId = req.userId;
  const { backupId } = req.params;
  const { deviceId, mergeMode = 'replace' } = req.body;

  try {
    // 1. 获取备份记录
    const backups = await query(
      'SELECT * FROM user_backups WHERE id = ? AND user_id = ? AND backup_status = ?',
      [backupId, userId, 'completed']
    );

    if (backups.length === 0) {
      return res.status(404).json({
        success: false,
        message: '备份不存在或已损坏'
      });
    }

    const backup = backups[0];
    let backupDataString = backup.backup_data;

    // 2. 解密处理
    if (backup.is_encrypted) {
      const decipher = crypto.createDecipher('aes-256-cbc', process.env.BACKUP_ENCRYPTION_KEY || 'default-key');
      let decrypted = decipher.update(backupDataString, 'base64', 'utf8');
      decrypted += decipher.final('utf8');
      backupDataString = decrypted;
    }

    // 3. 解压处理
    if (backup.is_compressed) {
      const compressed = Buffer.from(backupDataString, 'base64');
      const decompressed = await gunzip(compressed);
      backupDataString = decompressed.toString('utf8');
    }

    // 4. 验证数据完整性
    const dataHash = crypto
      .createHash('sha256')
      .update(backup.backup_data)
      .digest('hex');

    if (dataHash !== backup.data_hash) {
      return res.status(400).json({
        success: false,
        message: '备份数据已损坏，哈希校验失败'
      });
    }

    // 5. 解析备份数据
    const backupData = JSON.parse(backupDataString);
    const { tasks, lists, tags, settings } = backupData.data;

    let restoredCount = 0;

    // 6. 开始事务
    await query('START TRANSACTION');

    try {
      // 7. 恢复模式：replace - 清空现有数据，merge - 合并数据
      if (mergeMode === 'replace') {
        await query('DELETE FROM user_tasks WHERE user_id = ?', [userId]);
        await query('DELETE FROM user_lists WHERE user_id = ?', [userId]);
        await query('DELETE FROM user_tags WHERE user_id = ?', [userId]);
        await query('DELETE FROM user_app_settings WHERE user_id = ?', [userId]);
      }

      // 8. 恢复列表
      for (const list of lists) {
        await query(
          `INSERT INTO user_lists (user_id, client_id, name, icon, color, sort_order, is_default, created_at, updated_at)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
           ON DUPLICATE KEY UPDATE name=VALUES(name), icon=VALUES(icon), color=VALUES(color), sort_order=VALUES(sort_order)`,
          [userId, list.client_id, list.name, list.icon, list.color, list.sort_order, list.is_default, list.created_at, list.updated_at]
        );
        restoredCount++;
      }

      // 9. 恢复标签
      for (const tag of tags) {
        await query(
          `INSERT INTO user_tags (user_id, client_id, name, color, created_at, updated_at)
           VALUES (?, ?, ?, ?, ?, ?)
           ON DUPLICATE KEY UPDATE name=VALUES(name), color=VALUES(color)`,
          [userId, tag.client_id, tag.name, tag.color, tag.created_at, tag.updated_at]
        );
        restoredCount++;
      }

      // 10. 恢复任务
      for (const task of tasks) {
        await query(
          `INSERT INTO user_tasks (
            user_id, client_id, title, description, is_completed, priority,
            due_date, reminder_time, repeat_type, list_id, tags,
            created_at, updated_at, completed_at
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
          ON DUPLICATE KEY UPDATE
            title=VALUES(title), description=VALUES(description),
            is_completed=VALUES(is_completed), priority=VALUES(priority),
            due_date=VALUES(due_date), reminder_time=VALUES(reminder_time),
            repeat_type=VALUES(repeat_type), list_id=VALUES(list_id),
            tags=VALUES(tags), updated_at=VALUES(updated_at), completed_at=VALUES(completed_at)`,
          [
            userId, task.client_id, task.title, task.description, task.is_completed,
            task.priority, task.due_date, task.reminder_time, task.repeat_type,
            task.list_id, task.tags, task.created_at, task.updated_at, task.completed_at
          ]
        );
        restoredCount++;
      }

      // 11. 恢复设置
      if (settings && Object.keys(settings).length > 0) {
        await query(
          `INSERT INTO user_app_settings (user_id, settings_data)
           VALUES (?, ?)
           ON DUPLICATE KEY UPDATE settings_data=VALUES(settings_data)`,
          [userId, JSON.stringify(settings)]
        );
        restoredCount++;
      }

      // 12. 提交事务
      await query('COMMIT');

      // 13. 记录恢复历史
      await query(
        `INSERT INTO backup_restore_history (
          user_id, backup_id, operation_type, status, items_count, device_id, ip_address
        ) VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [userId, backupId, 'restore', 'success', restoredCount, deviceId, req.ip]
      );

      res.json({
        success: true,
        message: '数据恢复成功',
        data: {
          restored_count: restoredCount,
          backup_name: backup.backup_name,
          backup_date: backup.created_at,
          merge_mode: mergeMode
        }
      });
    } catch (error) {
      // 回滚事务
      await query('ROLLBACK');
      throw error;
    }
  } catch (error) {
    console.error('恢复备份失败:', error);

    // 记录失败历史
    try {
      await query(
        `INSERT INTO backup_restore_history (
          user_id, backup_id, operation_type, status, error_message, device_id, ip_address
        ) VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [userId, backupId, 'restore', 'failed', error.message, deviceId, req.ip]
      );
    } catch (historyError) {
      console.error('记录恢复历史失败:', historyError);
    }

    res.status(500).json({
      success: false,
      message: '数据恢复失败',
      error: error.message
    });
  }
}

/**
 * 获取备份列表
 */
export async function getBackupList(req, res) {
  const userId = req.userId;
  const { page = 1, limit = 20, backupType } = req.query;
  const offset = (page - 1) * limit;

  try {
    let sql = `
      SELECT
        id, backup_name, backup_type, backup_size,
        device_id, device_name, device_type, app_version,
        data_hash, is_encrypted, is_compressed, backup_status,
        created_at, updated_at
      FROM user_backups
      WHERE user_id = ?
    `;
    const params = [userId];

    if (backupType) {
      sql += ' AND backup_type = ?';
      params.push(backupType);
    }

    sql += ' ORDER BY created_at DESC LIMIT ? OFFSET ?';
    params.push(parseInt(limit), offset);

    const backups = await query(sql, params);

    // 获取总数
    let countSql = 'SELECT COUNT(*) as total FROM user_backups WHERE user_id = ?';
    const countParams = [userId];

    if (backupType) {
      countSql += ' AND backup_type = ?';
      countParams.push(backupType);
    }

    const countResult = await query(countSql, countParams);
    const total = countResult[0].total;

    res.json({
      success: true,
      data: {
        backups: backups.map(backup => ({
          ...backup,
          backup_size_mb: (backup.backup_size / 1024 / 1024).toFixed(2),
          is_encrypted: backup.is_encrypted === 1,
          is_compressed: backup.is_compressed === 1
        })),
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          total_pages: Math.ceil(total / limit)
        }
      }
    });
  } catch (error) {
    console.error('获取备份列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取备份列表失败',
      error: error.message
    });
  }
}

/**
 * 获取备份详情
 */
export async function getBackupDetail(req, res) {
  const userId = req.userId;
  const { backupId } = req.params;

  try {
    const backups = await query(
      `SELECT
        id, backup_name, backup_type, backup_size,
        device_id, device_name, device_type, app_version,
        data_hash, is_encrypted, is_compressed, backup_status,
        error_message, created_at, updated_at
      FROM user_backups
      WHERE id = ? AND user_id = ?`,
      [backupId, userId]
    );

    if (backups.length === 0) {
      return res.status(404).json({
        success: false,
        message: '备份不存在'
      });
    }

    const backup = backups[0];

    // 获取备份统计信息（不解析完整数据）
    res.json({
      success: true,
      data: {
        ...backup,
        backup_size_mb: (backup.backup_size / 1024 / 1024).toFixed(2),
        is_encrypted: backup.is_encrypted === 1,
        is_compressed: backup.is_compressed === 1
      }
    });
  } catch (error) {
    console.error('获取备份详情失败:', error);
    res.status(500).json({
      success: false,
      message: '获取备份详情失败',
      error: error.message
    });
  }
}

/**
 * 删除备份
 */
export async function deleteBackup(req, res) {
  const userId = req.userId;
  const { backupId } = req.params;

  try {
    const result = await query(
      'DELETE FROM user_backups WHERE id = ? AND user_id = ?',
      [backupId, userId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: '备份不存在'
      });
    }

    res.json({
      success: true,
      message: '备份删除成功'
    });
  } catch (error) {
    console.error('删除备份失败:', error);
    res.status(500).json({
      success: false,
      message: '删除备份删除失败',
      error: error.message
    });
  }
}

/**
 * 获取备份/恢复历史
 */
export async function getBackupHistory(req, res) {
  const userId = req.userId;
  const { page = 1, limit = 20, operationType } = req.query;
  const offset = (page - 1) * limit;

  try {
    let sql = `
      SELECT
        h.id, h.backup_id, h.operation_type, h.status,
        h.items_count, h.error_message, h.device_id, h.ip_address,
        h.created_at, b.backup_name
      FROM backup_restore_history h
      LEFT JOIN user_backups b ON h.backup_id = b.id
      WHERE h.user_id = ?
    `;
    const params = [userId];

    if (operationType) {
      sql += ' AND h.operation_type = ?';
      params.push(operationType);
    }

    sql += ' ORDER BY h.created_at DESC LIMIT ? OFFSET ?';
    params.push(parseInt(limit), offset);

    const history = await query(sql, params);

    // 获取总数
    let countSql = 'SELECT COUNT(*) as total FROM backup_restore_history WHERE user_id = ?';
    const countParams = [userId];

    if (operationType) {
      countSql += ' AND operation_type = ?';
      countParams.push(operationType);
    }

    const countResult = await query(countSql, countParams);
    const total = countResult[0].total;

    res.json({
      success: true,
      data: {
        history,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          total_pages: Math.ceil(total / limit)
        }
      }
    });
  } catch (error) {
    console.error('获取备份历史失败:', error);
    res.status(500).json({
      success: false,
      message: '获取备份历史失败',
      error: error.message
    });
  }
}
