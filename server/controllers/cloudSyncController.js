import { query } from '../config/database.js';

// 全量上传数据到云端
export async function uploadAll(req, res) {
  try {
    const userId = req.userId;
    const {
      tasks = [],
      lists = [],
      tags = [],
      ideas = [],
      settings = null,
    } = req.body;

    console.log('收到上传请求，用户ID:', userId);
    console.log('数据统计:', {
      tasks: tasks.length,
      lists: lists.length,
      tags: tags.length,
      ideas: ideas.length,
      hasSettings: !!settings
    });

    let totalUploaded = 0;

    // 开始事务
    const connection = await query('SELECT 1');

    // 1. 同步列表
    if (lists.length > 0) {
      console.log('开始同步列表:', lists.length);
      for (const list of lists) {
        try {
          await query(
            `INSERT INTO user_lists 
             (user_id, client_id, name, color_hex, sort_order, is_default, created_at, updated_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)
             ON DUPLICATE KEY UPDATE 
             name = VALUES(name), 
             color_hex = VALUES(color_hex),
             sort_order = VALUES(sort_order),
             updated_at = VALUES(updated_at)`,
            [
              userId,
              list.id,
              list.name,
              list.colorHex || '#4C83FB',
              list.sortOrder || 0,
              list.isDefault ? 1 : 0,
              list.createdAt,
              list.updatedAt,
            ]
          );
        } catch (err) {
          console.error('列表同步失败:', list.id, err.message);
          throw err;
        }
      }
      totalUploaded += lists.length;
      console.log('✓ 列表同步完成');
    }

    // 2. 同步标签
    if (tags.length > 0) {
      console.log('开始同步标签:', tags.length);
      for (const tag of tags) {
        try {
          await query(
            `INSERT INTO user_tags 
             (user_id, client_id, name, color_hex, created_at, updated_at)
             VALUES (?, ?, ?, ?, ?, ?)
             ON DUPLICATE KEY UPDATE 
             name = VALUES(name), 
             color_hex = VALUES(color_hex),
             updated_at = VALUES(updated_at)`,
            [
              userId,
              tag.id,
              tag.name,
              tag.colorHex || '#10B981',
              tag.createdAt,
              tag.updatedAt,
            ]
          );
        } catch (err) {
          console.error('标签同步失败:', tag.id, err.message);
          throw err;
        }
      }
      totalUploaded += tags.length;
      console.log('✓ 标签同步完成');
    }

    // 3. 同步任务
    if (tasks.length > 0) {
      console.log('开始同步任务:', tasks.length);
      for (const task of tasks) {
        try {
          await query(
            `INSERT INTO user_tasks 
             (user_id, client_id, title, notes, list_id, priority, status, due_at, remind_at, completed_at, created_at, updated_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
             ON DUPLICATE KEY UPDATE 
             title = VALUES(title),
             notes = VALUES(notes),
             list_id = VALUES(list_id),
             priority = VALUES(priority),
             status = VALUES(status),
             due_at = VALUES(due_at),
             remind_at = VALUES(remind_at),
             completed_at = VALUES(completed_at),
             updated_at = VALUES(updated_at)`,
            [
              userId,
              task.id,
              task.title,
              task.notes || null,
              task.listId || null,
              task.priority || 'none',
              task.status || 'pending',
              task.dueAt || null,
              task.remindAt || null,
              task.completedAt || null,
              task.createdAt,
              task.updatedAt,
            ]
          );
        } catch (err) {
          console.error('任务同步失败:', task.id, task.title, err.message);
          throw err;
        }
      }
      totalUploaded += tasks.length;
      console.log('✓ 任务同步完成');
    }

    // 4. 同步灵感
    if (ideas.length > 0) {
      for (const idea of ideas) {
        await query(
          `INSERT INTO user_ideas 
           (user_id, client_id, title, content, category, tags, is_favorite, related_task_id, color, status, implemented_at, created_at, updated_at)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
           ON DUPLICATE KEY UPDATE 
           title = VALUES(title),
           content = VALUES(content),
           category = VALUES(category),
           tags = VALUES(tags),
           is_favorite = VALUES(is_favorite),
           related_task_id = VALUES(related_task_id),
           color = VALUES(color),
           status = VALUES(status),
           implemented_at = VALUES(implemented_at),
           updated_at = VALUES(updated_at)`,
          [
            userId,
            idea.id,
            idea.title,
            idea.content || null,
            idea.category || 'general',
            JSON.stringify(idea.tags || []),
            idea.isFavorite ? 1 : 0,
            idea.relatedTaskId || null,
            idea.color || null,
            idea.status || 'draft',
            idea.implementedAt || null,
            idea.createdAt,
            idea.updatedAt,
          ]
        );
      }
      totalUploaded += ideas.length;
    }

    // 5. 同步设置
    if (settings) {
      await query(
        `INSERT INTO user_settings 
         (user_id, theme_mode, theme_color, enable_notifications, language_code, settings_json, updated_at)
         VALUES (?, ?, ?, ?, ?, ?, ?)
         ON DUPLICATE KEY UPDATE 
         theme_mode = VALUES(theme_mode),
         theme_color = VALUES(theme_color),
         enable_notifications = VALUES(enable_notifications),
         language_code = VALUES(language_code),
         settings_json = VALUES(settings_json),
         updated_at = VALUES(updated_at)`,
        [
          userId,
          settings.themeMode,
          settings.themeColor,
          settings.enableNotifications ? 1 : 0,
          settings.languageCode,
          JSON.stringify(settings),
          new Date(),
        ]
      );
      totalUploaded += 1;
    }

    // 记录同步日志
    await query(
      `INSERT INTO cloud_sync_records 
       (user_id, sync_type, data_type, records_uploaded, status, device_id, completed_at, duration_ms)
       VALUES (?, 'upload', 'all', ?, 'success', ?, NOW(), ?)`,
      [userId, totalUploaded, req.body.deviceId || null, Date.now() - (req.startTime || Date.now())]
    );

    res.json({
      success: true,
      message: '数据上传成功',
      data: {
        uploaded: totalUploaded,
        summary: {
          tasks: tasks.length,
          lists: lists.length,
          tags: tags.length,
          ideas: ideas.length,
          settings: settings ? 1 : 0,
        },
      },
    });
  } catch (error) {
    console.error('上传数据错误:', error);
    res.status(500).json({
      success: false,
      message: '上传失败',
      error: error.message,
    });
  }
}

// 全量下载云端数据
export async function downloadAll(req, res) {
  try {
    const userId = req.userId;

    // 1. 获取列表
    const lists = await query(
      'SELECT * FROM user_lists WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );

    // 2. 获取标签
    const tags = await query(
      'SELECT * FROM user_tags WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );

    // 3. 获取任务
    const tasks = await query(
      'SELECT * FROM user_tasks WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );

    // 4. 获取灵感
    const ideas = await query(
      'SELECT * FROM user_ideas WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );

    // 5. 获取设置
    const settingsResult = await query(
      'SELECT * FROM user_settings WHERE user_id = ?',
      [userId]
    );
    const settings = settingsResult.length > 0 ? settingsResult[0] : null;

    // 转换数据格式
    const data = {
      lists: lists.map((l) => ({
        id: l.client_id,
        name: l.name,
        colorHex: l.color_hex,
        sortOrder: l.sort_order,
        isDefault: l.is_default === 1,
        createdAt: l.created_at,
        updatedAt: l.updated_at,
      })),
      tags: tags.map((t) => ({
        id: t.client_id,
        name: t.name,
        colorHex: t.color_hex,
        createdAt: t.created_at,
        updatedAt: t.updated_at,
      })),
      tasks: tasks.map((t) => ({
        id: t.client_id,
        title: t.title,
        notes: t.notes,
        listId: t.list_id,
        priority: t.priority,
        status: t.status,
        dueAt: t.due_at,
        remindAt: t.remind_at,
        completedAt: t.completed_at,
        createdAt: t.created_at,
        updatedAt: t.updated_at,
      })),
      ideas: ideas.map((i) => ({
        id: i.client_id,
        title: i.title,
        content: i.content,
        category: i.category,
        tags: JSON.parse(i.tags || '[]'),
        isFavorite: i.is_favorite === 1,
        relatedTaskId: i.related_task_id,
        color: i.color,
        status: i.status,
        implementedAt: i.implemented_at,
        createdAt: i.created_at,
        updatedAt: i.updated_at,
      })),
      settings: settings
        ? {
            themeMode: settings.theme_mode,
            themeColor: settings.theme_color,
            enableNotifications: settings.enable_notifications === 1,
            languageCode: settings.language_code,
            ...JSON.parse(settings.settings_json || '{}'),
          }
        : null,
    };

    // 记录同步日志
    const totalDownloaded =
      lists.length + tags.length + tasks.length + ideas.length + (settings ? 1 : 0);
    await query(
      `INSERT INTO cloud_sync_records 
       (user_id, sync_type, data_type, records_downloaded, status, device_id, completed_at, duration_ms)
       VALUES (?, 'download', 'all', ?, 'success', ?, NOW(), ?)`,
      [userId, totalDownloaded, req.body.deviceId || null, Date.now() - (req.startTime || Date.now())]
    );

    res.json({
      success: true,
      message: '数据下载成功',
      data: data,
      summary: {
        tasks: tasks.length,
        lists: lists.length,
        tags: tags.length,
        ideas: ideas.length,
        settings: settings ? 1 : 0,
      },
    });
  } catch (error) {
    console.error('下载数据错误:', error);
    res.status(500).json({
      success: false,
      message: '下载失败',
      error: error.message,
    });
  }
}

// 创建数据快照
export async function createSnapshot(req, res) {
  try {
    const userId = req.userId;
    const { name, description } = req.body;

    // 获取所有数据
    const lists = await query(
      'SELECT * FROM user_lists WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );
    const tags = await query(
      'SELECT * FROM user_tags WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );
    const tasks = await query(
      'SELECT * FROM user_tasks WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );
    const ideas = await query(
      'SELECT * FROM user_ideas WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );
    const settingsResult = await query(
      'SELECT * FROM user_settings WHERE user_id = ?',
      [userId]
    );

    // 构建快照数据
    const snapshotData = {
      lists,
      tags,
      tasks,
      ideas,
      settings: settingsResult[0] || null,
      createdAt: new Date().toISOString(),
    };

    const dataJson = JSON.stringify(snapshotData);
    const dataSize = Buffer.byteLength(dataJson, 'utf8');

    // 保存快照
    const result = await query(
      `INSERT INTO cloud_snapshots 
       (user_id, snapshot_name, description, data_json, data_size)
       VALUES (?, ?, ?, ?, ?)`,
      [userId, name || `备份_${new Date().toLocaleString('zh-CN')}`, description, dataJson, dataSize]
    );

    res.json({
      success: true,
      message: '快照创建成功',
      data: {
        snapshotId: result.insertId,
        name: name || `备份_${new Date().toLocaleString('zh-CN')}`,
        dataSize,
        recordsCount:
          lists.length + tags.length + tasks.length + ideas.length,
      },
    });
  } catch (error) {
    console.error('创建快照错误:', error);
    res.status(500).json({
      success: false,
      message: '创建快照失败',
      error: error.message,
    });
  }
}

// 从快照恢复数据
export async function restoreFromSnapshot(req, res) {
  try {
    const userId = req.userId;
    const { snapshotId } = req.params;

    // 获取快照
    const snapshots = await query(
      'SELECT * FROM cloud_snapshots WHERE id = ? AND user_id = ?',
      [snapshotId, userId]
    );

    if (snapshots.length === 0) {
      return res.status(404).json({
        success: false,
        message: '快照不存在',
      });
    }

    const snapshot = snapshots[0];
    const snapshotData = JSON.parse(snapshot.data_json);

    // 恢复数据（先清空再导入）
    await query('DELETE FROM user_lists WHERE user_id = ?', [userId]);
    await query('DELETE FROM user_tags WHERE user_id = ?', [userId]);
    await query('DELETE FROM user_tasks WHERE user_id = ?', [userId]);
    await query('DELETE FROM user_ideas WHERE user_id = ?', [userId]);

    let totalRestored = 0;

    // 恢复列表
    for (const list of snapshotData.lists || []) {
      await query(
        `INSERT INTO user_lists 
         (user_id, client_id, name, color_hex, sort_order, is_default, created_at, updated_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          userId,
          list.client_id,
          list.name,
          list.color_hex,
          list.sort_order,
          list.is_default,
          list.created_at,
          list.updated_at,
        ]
      );
      totalRestored++;
    }

    // 恢复标签
    for (const tag of snapshotData.tags || []) {
      await query(
        `INSERT INTO user_tags 
         (user_id, client_id, name, color_hex, created_at, updated_at)
         VALUES (?, ?, ?, ?, ?, ?)`,
        [
          userId,
          tag.client_id,
          tag.name,
          tag.color_hex,
          tag.created_at,
          tag.updated_at,
        ]
      );
      totalRestored++;
    }

    // 恢复任务
    for (const task of snapshotData.tasks || []) {
      await query(
        `INSERT INTO user_tasks 
         (user_id, client_id, title, notes, list_id, priority, status, due_at, remind_at, completed_at, created_at, updated_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          userId,
          task.client_id,
          task.title,
          task.notes,
          task.list_id,
          task.priority,
          task.status,
          task.due_at,
          task.remind_at,
          task.completed_at,
          task.created_at,
          task.updated_at,
        ]
      );
      totalRestored++;
    }

    // 恢复灵感
    for (const idea of snapshotData.ideas || []) {
      await query(
        `INSERT INTO user_ideas 
         (user_id, client_id, title, content, category, tags, is_favorite, related_task_id, color, status, implemented_at, created_at, updated_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          userId,
          idea.client_id,
          idea.title,
          idea.content,
          idea.category,
          idea.tags,
          idea.is_favorite,
          idea.related_task_id,
          idea.color,
          idea.status,
          idea.implemented_at,
          idea.created_at,
          idea.updated_at,
        ]
      );
      totalRestored++;
    }

    res.json({
      success: true,
      message: '数据恢复成功',
      data: {
        restored: totalRestored,
      },
    });
  } catch (error) {
    console.error('恢复数据错误:', error);
    res.status(500).json({
      success: false,
      message: '恢复失败',
      error: error.message,
    });
  }
}

// 获取快照列表
export async function getSnapshots(req, res) {
  try {
    const userId = req.userId;

    const snapshots = await query(
      'SELECT id, snapshot_name, description, data_size, created_at FROM cloud_snapshots WHERE user_id = ? ORDER BY created_at DESC',
      [userId]
    );

    res.json({
      success: true,
      data: snapshots,
    });
  } catch (error) {
    console.error('获取快照列表错误:', error);
    res.status(500).json({
      success: false,
      message: '获取失败',
      error: error.message,
    });
  }
}

// 删除快照
export async function deleteSnapshot(req, res) {
  try {
    const userId = req.userId;
    const { snapshotId } = req.params;

    const result = await query(
      'DELETE FROM cloud_snapshots WHERE id = ? AND user_id = ?',
      [snapshotId, userId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: '快照不存在',
      });
    }

    res.json({
      success: true,
      message: '快照删除成功',
    });
  } catch (error) {
    console.error('删除快照错误:', error);
    res.status(500).json({
      success: false,
      message: '删除失败',
      error: error.message,
    });
  }
}

// 获取同步状态
export async function getSyncStatus(req, res) {
  try {
    const userId = req.userId;

    // 获取最近的同步记录
    const recentSyncs = await query(
      `SELECT * FROM cloud_sync_records 
       WHERE user_id = ? 
       ORDER BY started_at DESC 
       LIMIT 10`,
      [userId]
    );

    // 统计云端数据数量
    const [taskCount] = await query(
      'SELECT COUNT(*) as count FROM user_tasks WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );
    const [listCount] = await query(
      'SELECT COUNT(*) as count FROM user_lists WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );
    const [tagCount] = await query(
      'SELECT COUNT(*) as count FROM user_tags WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );
    const [ideaCount] = await query(
      'SELECT COUNT(*) as count FROM user_ideas WHERE user_id = ? AND deleted_at IS NULL',
      [userId]
    );

    res.json({
      success: true,
      data: {
        recentSyncs,
        cloudDataCount: {
          tasks: taskCount.count,
          lists: listCount.count,
          tags: tagCount.count,
          ideas: ideaCount.count,
        },
      },
    });
  } catch (error) {
    console.error('获取同步状态错误:', error);
    res.status(500).json({
      success: false,
      message: '获取失败',
      error: error.message,
    });
  }
}

