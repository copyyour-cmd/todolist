import { query } from '../config/database.js';

/**
 * 获取用户的所有列表
 */
export async function getLists(req, res) {
  try {
    const userId = req.user.id;
    const { includeDeleted = 'false' } = req.query;

    let sql = 'SELECT * FROM user_lists WHERE user_id = ?';
    const params = [userId];

    if (includeDeleted === 'false') {
      sql += ' AND deleted_at IS NULL';
    }

    sql += ' ORDER BY sort_order ASC, created_at DESC';

    const lists = await query(sql, params);

    res.json({
      success: true,
      data: {
        lists: lists.map(formatListResponse),
        total: lists.length,
      },
    });
  } catch (error) {
    console.error('获取列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取列表失败',
    });
  }
}

/**
 * 获取单个列表详情
 */
export async function getList(req, res) {
  try {
    const userId = req.user.id;
    const { listId } = req.params;

    const lists = await query(
      'SELECT * FROM user_lists WHERE id = ? AND user_id = ?',
      [listId, userId]
    );

    if (lists.length === 0) {
      return res.status(404).json({
        success: false,
        message: '列表不存在',
      });
    }

    res.json({
      success: true,
      data: formatListResponse(lists[0]),
    });
  } catch (error) {
    console.error('获取列表详情失败:', error);
    res.status(500).json({
      success: false,
      message: '获取列表详情失败',
    });
  }
}

/**
 * 创建列表
 */
export async function createList(req, res) {
  try {
    const userId = req.user.id;
    const { id, name, color, icon, sort_order = 0, is_default = false } = req.body;

    // 验证必填字段
    if (!id || !name) {
      return res.status(400).json({
        success: false,
        message: '列表ID和名称不能为空',
      });
    }

    // 检查列表ID是否已存在
    const existingLists = await query(
      'SELECT id FROM user_lists WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    if (existingLists.length > 0) {
      return res.status(409).json({
        success: false,
        message: '列表ID已存在',
        error: 'DUPLICATE_LIST_ID',
      });
    }

    // 如果设置为默认列表，取消其他列表的默认状态
    if (is_default) {
      await query(
        'UPDATE user_lists SET is_default = FALSE WHERE user_id = ?',
        [userId]
      );
    }

    // 创建列表
    await query(
      `INSERT INTO user_lists (
        id, user_id, name, color, icon, sort_order, is_default
      ) VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [id, userId, name, color || '#2196F3', icon, sort_order, is_default]
    );

    // 获取创建的列表
    const newLists = await query(
      'SELECT * FROM user_lists WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    res.status(201).json({
      success: true,
      message: '列表创建成功',
      data: formatListResponse(newLists[0]),
    });
  } catch (error) {
    console.error('创建列表失败:', error);
    res.status(500).json({
      success: false,
      message: '创建列表失败',
    });
  }
}

/**
 * 更新列表
 */
export async function updateList(req, res) {
  try {
    const userId = req.user.id;
    const { listId } = req.params;
    const { name, color, icon, sort_order, is_default } = req.body;

    // 检查列表是否存在
    const existingLists = await query(
      'SELECT * FROM user_lists WHERE id = ? AND user_id = ?',
      [listId, userId]
    );

    if (existingLists.length === 0) {
      return res.status(404).json({
        success: false,
        message: '列表不存在',
      });
    }

    // 如果设置为默认列表，取消其他列表的默认状态
    if (is_default === true) {
      await query(
        'UPDATE user_lists SET is_default = FALSE WHERE user_id = ? AND id != ?',
        [userId, listId]
      );
    }

    // 构建更新字段
    const updates = [];
    const values = [];

    if (name !== undefined) {
      updates.push('name = ?');
      values.push(name);
    }
    if (color !== undefined) {
      updates.push('color = ?');
      values.push(color);
    }
    if (icon !== undefined) {
      updates.push('icon = ?');
      values.push(icon);
    }
    if (sort_order !== undefined) {
      updates.push('sort_order = ?');
      values.push(sort_order);
    }
    if (is_default !== undefined) {
      updates.push('is_default = ?');
      values.push(is_default);
    }

    if (updates.length === 0) {
      return res.status(400).json({
        success: false,
        message: '没有可更新的字段',
      });
    }

    // 添加更新时间和条件参数
    updates.push('updated_at = NOW()');
    values.push(listId, userId);

    await query(
      `UPDATE user_lists SET ${updates.join(', ')} WHERE id = ? AND user_id = ?`,
      values
    );

    // 获取更新后的列表
    const updatedLists = await query(
      'SELECT * FROM user_lists WHERE id = ? AND user_id = ?',
      [listId, userId]
    );

    res.json({
      success: true,
      message: '列表更新成功',
      data: formatListResponse(updatedLists[0]),
    });
  } catch (error) {
    console.error('更新列表失败:', error);
    res.status(500).json({
      success: false,
      message: '更新列表失败',
    });
  }
}

/**
 * 删除列表
 */
export async function deleteList(req, res) {
  try {
    const userId = req.user.id;
    const { listId } = req.params;
    const { permanent = 'false' } = req.query;

    // 检查列表是否存在
    const existingLists = await query(
      'SELECT * FROM user_lists WHERE id = ? AND user_id = ?',
      [listId, userId]
    );

    if (existingLists.length === 0) {
      return res.status(404).json({
        success: false,
        message: '列表不存在',
      });
    }

    // 检查是否是默认列表
    if (existingLists[0].is_default) {
      return res.status(400).json({
        success: false,
        message: '不能删除默认列表',
      });
    }

    // 检查列表中是否有任务
    const tasks = await query(
      'SELECT COUNT(*) as count FROM user_tasks WHERE list_id = ? AND user_id = ?',
      [listId, userId]
    );

    if (tasks[0].count > 0) {
      return res.status(400).json({
        success: false,
        message: `列表中还有 ${tasks[0].count} 个任务，请先移动或删除任务`,
      });
    }

    if (permanent === 'true') {
      // 永久删除
      await query(
        'DELETE FROM user_lists WHERE id = ? AND user_id = ?',
        [listId, userId]
      );
    } else {
      // 软删除
      await query(
        'UPDATE user_lists SET deleted_at = NOW() WHERE id = ? AND user_id = ?',
        [listId, userId]
      );
    }

    res.json({
      success: true,
      message: permanent === 'true' ? '列表已永久删除' : '列表已删除',
    });
  } catch (error) {
    console.error('删除列表失败:', error);
    res.status(500).json({
      success: false,
      message: '删除列表失败',
    });
  }
}

/**
 * 恢复已删除的列表
 */
export async function restoreList(req, res) {
  try {
    const userId = req.user.id;
    const { listId } = req.params;

    // 检查列表是否存在且已删除
    const existingLists = await query(
      'SELECT * FROM user_lists WHERE id = ? AND user_id = ? AND deleted_at IS NOT NULL',
      [listId, userId]
    );

    if (existingLists.length === 0) {
      return res.status(404).json({
        success: false,
        message: '列表不存在或未被删除',
      });
    }

    // 恢复列表
    await query(
      'UPDATE user_lists SET deleted_at = NULL WHERE id = ? AND user_id = ?',
      [listId, userId]
    );

    // 获取恢复后的列表
    const restoredLists = await query(
      'SELECT * FROM user_lists WHERE id = ? AND user_id = ?',
      [listId, userId]
    );

    res.json({
      success: true,
      message: '列表已恢复',
      data: formatListResponse(restoredLists[0]),
    });
  } catch (error) {
    console.error('恢复列表失败:', error);
    res.status(500).json({
      success: false,
      message: '恢复列表失败',
    });
  }
}

/**
 * 格式化列表响应
 */
function formatListResponse(list) {
  return {
    id: list.id,
    name: list.name,
    color: list.color,
    icon: list.icon,
    sort_order: list.sort_order,
    is_default: Boolean(list.is_default),
    created_at: list.created_at,
    updated_at: list.updated_at,
    deleted_at: list.deleted_at,
  };
}
