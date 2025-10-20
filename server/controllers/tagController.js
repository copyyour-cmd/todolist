import { query } from '../config/database.js';

/**
 * 获取用户的所有标签
 */
export async function getTags(req, res) {
  try {
    const userId = req.user.id;
    const { includeDeleted = 'false' } = req.query;

    let sql = 'SELECT * FROM user_tags WHERE user_id = ?';
    const params = [userId];

    if (includeDeleted === 'false') {
      sql += ' AND deleted_at IS NULL';
    }

    sql += ' ORDER BY name ASC';

    const tags = await query(sql, params);

    res.json({
      success: true,
      data: {
        tags: tags.map(formatTagResponse),
        total: tags.length,
      },
    });
  } catch (error) {
    console.error('获取标签失败:', error);
    res.status(500).json({
      success: false,
      message: '获取标签失败',
    });
  }
}

/**
 * 获取单个标签详情
 */
export async function getTag(req, res) {
  try {
    const userId = req.user.id;
    const { tagId } = req.params;

    const tags = await query(
      'SELECT * FROM user_tags WHERE id = ? AND user_id = ?',
      [tagId, userId]
    );

    if (tags.length === 0) {
      return res.status(404).json({
        success: false,
        message: '标签不存在',
      });
    }

    res.json({
      success: true,
      data: formatTagResponse(tags[0]),
    });
  } catch (error) {
    console.error('获取标签详情失败:', error);
    res.status(500).json({
      success: false,
      message: '获取标签详情失败',
    });
  }
}

/**
 * 创建标签
 */
export async function createTag(req, res) {
  try {
    const userId = req.user.id;
    const { id, name, color } = req.body;

    // 验证必填字段
    if (!id || !name) {
      return res.status(400).json({
        success: false,
        message: '标签ID和名称不能为空',
      });
    }

    // 检查标签ID是否已存在
    const existingTags = await query(
      'SELECT id FROM user_tags WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    if (existingTags.length > 0) {
      return res.status(409).json({
        success: false,
        message: '标签ID已存在',
        error: 'DUPLICATE_TAG_ID',
      });
    }

    // 检查同名标签
    const duplicateNames = await query(
      'SELECT id FROM user_tags WHERE name = ? AND user_id = ? AND deleted_at IS NULL',
      [name, userId]
    );

    if (duplicateNames.length > 0) {
      return res.status(409).json({
        success: false,
        message: '标签名称已存在',
        error: 'DUPLICATE_TAG_NAME',
      });
    }

    // 创建标签
    await query(
      `INSERT INTO user_tags (id, user_id, name, color) VALUES (?, ?, ?, ?)`,
      [id, userId, name, color || '#9C27B0']
    );

    // 获取创建的标签
    const newTags = await query(
      'SELECT * FROM user_tags WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    res.status(201).json({
      success: true,
      message: '标签创建成功',
      data: formatTagResponse(newTags[0]),
    });
  } catch (error) {
    console.error('创建标签失败:', error);
    res.status(500).json({
      success: false,
      message: '创建标签失败',
    });
  }
}

/**
 * 更新标签
 */
export async function updateTag(req, res) {
  try {
    const userId = req.user.id;
    const { tagId } = req.params;
    const { name, color } = req.body;

    // 检查标签是否存在
    const existingTags = await query(
      'SELECT * FROM user_tags WHERE id = ? AND user_id = ?',
      [tagId, userId]
    );

    if (existingTags.length === 0) {
      return res.status(404).json({
        success: false,
        message: '标签不存在',
      });
    }

    // 如果修改名称，检查新名称是否已存在
    if (name && name !== existingTags[0].name) {
      const duplicateNames = await query(
        'SELECT id FROM user_tags WHERE name = ? AND user_id = ? AND id != ? AND deleted_at IS NULL',
        [name, userId, tagId]
      );

      if (duplicateNames.length > 0) {
        return res.status(409).json({
          success: false,
          message: '标签名称已存在',
          error: 'DUPLICATE_TAG_NAME',
        });
      }
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

    if (updates.length === 0) {
      return res.status(400).json({
        success: false,
        message: '没有可更新的字段',
      });
    }

    // 添加更新时间和条件参数
    updates.push('updated_at = NOW()');
    values.push(tagId, userId);

    await query(
      `UPDATE user_tags SET ${updates.join(', ')} WHERE id = ? AND user_id = ?`,
      values
    );

    // 获取更新后的标签
    const updatedTags = await query(
      'SELECT * FROM user_tags WHERE id = ? AND user_id = ?',
      [tagId, userId]
    );

    res.json({
      success: true,
      message: '标签更新成功',
      data: formatTagResponse(updatedTags[0]),
    });
  } catch (error) {
    console.error('更新标签失败:', error);
    res.status(500).json({
      success: false,
      message: '更新标签失败',
    });
  }
}

/**
 * 删除标签
 */
export async function deleteTag(req, res) {
  try {
    const userId = req.user.id;
    const { tagId } = req.params;
    const { permanent = 'false' } = req.query;

    // 检查标签是否存在
    const existingTags = await query(
      'SELECT * FROM user_tags WHERE id = ? AND user_id = ?',
      [tagId, userId]
    );

    if (existingTags.length === 0) {
      return res.status(404).json({
        success: false,
        message: '标签不存在',
      });
    }

    // 检查是否有任务使用该标签
    const tasks = await query(
      `SELECT COUNT(*) as count FROM user_tasks
       WHERE user_id = ? AND JSON_CONTAINS(tags, ?)`,
      [userId, JSON.stringify(tagId)]
    );

    if (tasks[0].count > 0) {
      return res.status(400).json({
        success: false,
        message: `还有 ${tasks[0].count} 个任务使用此标签`,
        data: {
          task_count: tasks[0].count,
        },
      });
    }

    if (permanent === 'true') {
      // 永久删除
      await query(
        'DELETE FROM user_tags WHERE id = ? AND user_id = ?',
        [tagId, userId]
      );
    } else {
      // 软删除
      await query(
        'UPDATE user_tags SET deleted_at = NOW() WHERE id = ? AND user_id = ?',
        [tagId, userId]
      );
    }

    res.json({
      success: true,
      message: permanent === 'true' ? '标签已永久删除' : '标签已删除',
    });
  } catch (error) {
    console.error('删除标签失败:', error);
    res.status(500).json({
      success: false,
      message: '删除标签失败',
    });
  }
}

/**
 * 恢复已删除的标签
 */
export async function restoreTag(req, res) {
  try {
    const userId = req.user.id;
    const { tagId } = req.params;

    // 检查标签是否存在且已删除
    const existingTags = await query(
      'SELECT * FROM user_tags WHERE id = ? AND user_id = ? AND deleted_at IS NOT NULL',
      [tagId, userId]
    );

    if (existingTags.length === 0) {
      return res.status(404).json({
        success: false,
        message: '标签不存在或未被删除',
      });
    }

    // 恢复标签
    await query(
      'UPDATE user_tags SET deleted_at = NULL WHERE id = ? AND user_id = ?',
      [tagId, userId]
    );

    // 获取恢复后的标签
    const restoredTags = await query(
      'SELECT * FROM user_tags WHERE id = ? AND user_id = ?',
      [tagId, userId]
    );

    res.json({
      success: true,
      message: '标签已恢复',
      data: formatTagResponse(restoredTags[0]),
    });
  } catch (error) {
    console.error('恢复标签失败:', error);
    res.status(500).json({
      success: false,
      message: '恢复标签失败',
    });
  }
}

/**
 * 获取标签统计信息
 */
export async function getTagStats(req, res) {
  try {
    const userId = req.user.id;

    const stats = await query(
      `SELECT
        t.id,
        t.name,
        t.color,
        COUNT(DISTINCT ut.id) as task_count
       FROM user_tags t
       LEFT JOIN user_tasks ut ON JSON_CONTAINS(ut.tags, JSON_QUOTE(t.id)) AND ut.user_id = t.user_id
       WHERE t.user_id = ? AND t.deleted_at IS NULL
       GROUP BY t.id, t.name, t.color
       ORDER BY task_count DESC, t.name ASC`,
      [userId]
    );

    res.json({
      success: true,
      data: {
        stats: stats.map((s) => ({
          id: s.id,
          name: s.name,
          color: s.color,
          task_count: Number(s.task_count),
        })),
      },
    });
  } catch (error) {
    console.error('获取标签统计失败:', error);
    res.status(500).json({
      success: false,
      message: '获取标签统计失败',
    });
  }
}

/**
 * 格式化标签响应
 */
function formatTagResponse(tag) {
  return {
    id: tag.id,
    name: tag.name,
    color: tag.color,
    created_at: tag.created_at,
    updated_at: tag.updated_at,
    deleted_at: tag.deleted_at,
  };
}
