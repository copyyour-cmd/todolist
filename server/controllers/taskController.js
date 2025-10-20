import { query } from '../config/database.js';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/**
 * 获取任务列表
 */
export async function getTasks(req, res) {
  const userId = req.userId;
  const {
    page = 1,
    limit = 100,
    listId,
    status,
    priority,
    includeDeleted = false,
    updatedAfter // 用于增量同步
  } = req.query;

  try {
    const offset = (page - 1) * limit;
    let sql = 'SELECT * FROM user_tasks WHERE user_id = ?';
    const params = [userId];

    // 过滤条件
    if (!includeDeleted || includeDeleted === 'false') {
      sql += ' AND deleted_at IS NULL';
    }

    if (listId) {
      sql += ' AND list_id = ?';
      params.push(listId);
    }

    if (status) {
      sql += ' AND status = ?';
      params.push(status);
    }

    if (priority) {
      sql += ' AND priority = ?';
      params.push(priority);
    }

    // 增量同步：只返回指定时间后更新的任务
    if (updatedAfter) {
      sql += ' AND updated_at > ?';
      params.push(updatedAfter);
    }

    sql += ' ORDER BY sort_order ASC, created_at DESC LIMIT ? OFFSET ?';
    params.push(parseInt(limit), offset);

    const tasks = await query(sql, params);

    // 获取总数
    let countSql = 'SELECT COUNT(*) as total FROM user_tasks WHERE user_id = ?';
    const countParams = [userId];

    if (!includeDeleted || includeDeleted === 'false') {
      countSql += ' AND deleted_at IS NULL';
    }
    if (listId) {
      countSql += ' AND list_id = ?';
      countParams.push(listId);
    }
    if (status) {
      countSql += ' AND status = ?';
      countParams.push(status);
    }
    if (priority) {
      countSql += ' AND priority = ?';
      countParams.push(priority);
    }

    const countResult = await query(countSql, countParams);
    const total = countResult[0].total;

    res.json({
      success: true,
      data: {
        tasks: tasks.map(formatTaskResponse),
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          total_pages: Math.ceil(total / limit)
        }
      }
    });
  } catch (error) {
    console.error('获取任务列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取任务列表失败',
      error: error.message
    });
  }
}

/**
 * 获取单个任务详情
 */
export async function getTask(req, res) {
  const userId = req.userId;
  const { taskId } = req.params;

  try {
    const tasks = await query(
      'SELECT * FROM user_tasks WHERE client_id = ? AND user_id = ?',
      [taskId, userId]
    );

    if (tasks.length === 0) {
      return res.status(404).json({
        success: false,
        message: '任务不存在'
      });
    }

    res.json({
      success: true,
      data: formatTaskResponse(tasks[0])
    });
  } catch (error) {
    console.error('获取任务详情失败:', error);
    res.status(500).json({
      success: false,
      message: '获取任务详情失败',
      error: error.message
    });
  }
}

/**
 * 创建任务
 */
export async function createTask(req, res) {
  const userId = req.userId;
  const taskData = req.body;

  try {
    const result = await query(
      `INSERT INTO user_tasks (
        user_id, client_id, title, description, list_id, tags, priority, status,
        due_at, remind_at, repeat_type, repeat_rule, sub_tasks, attachments,
        smart_reminders, estimated_minutes, actual_minutes, focus_sessions,
        location_reminder, sort_order, is_pinned, color, template_id, version
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        userId,
        taskData.client_id || taskData.id,
        taskData.title,
        taskData.description || taskData.notes,
        taskData.list_id,
        taskData.tags ? JSON.stringify(taskData.tags) : null,
        taskData.priority || 'none',
        taskData.status || 'pending',
        taskData.due_at,
        taskData.remind_at,
        taskData.repeat_type,
        taskData.repeat_rule ? JSON.stringify(taskData.repeat_rule) : null,
        taskData.sub_tasks ? JSON.stringify(taskData.sub_tasks) : null,
        taskData.attachments ? JSON.stringify(taskData.attachments) : null,
        taskData.smart_reminders ? JSON.stringify(taskData.smart_reminders) : null,
        taskData.estimated_minutes,
        taskData.actual_minutes,
        taskData.focus_sessions ? JSON.stringify(taskData.focus_sessions) : null,
        taskData.location_reminder ? JSON.stringify(taskData.location_reminder) : null,
        taskData.sort_order || 0,
        taskData.is_pinned ? 1 : 0,
        taskData.color,
        taskData.template_id,
        1
      ]
    );

    // 获取创建的任务
    const tasks = await query(
      'SELECT * FROM user_tasks WHERE id = ?',
      [result.insertId]
    );

    res.status(201).json({
      success: true,
      message: '任务创建成功',
      data: formatTaskResponse(tasks[0])
    });
  } catch (error) {
    console.error('创建任务失败:', error);

    // 处理重复的client_id
    if (error.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({
        success: false,
        message: '任务ID已存在',
        error: 'DUPLICATE_TASK_ID'
      });
    }

    res.status(500).json({
      success: false,
      message: '创建任务失败',
      error: error.message
    });
  }
}

/**
 * 更新任务
 */
export async function updateTask(req, res) {
  const userId = req.userId;
  const { taskId } = req.params;
  const taskData = req.body;

  try {
    // 检查任务是否存在
    const existingTasks = await query(
      'SELECT * FROM user_tasks WHERE client_id = ? AND user_id = ?',
      [taskId, userId]
    );

    if (existingTasks.length === 0) {
      return res.status(404).json({
        success: false,
        message: '任务不存在'
      });
    }

    const existingTask = existingTasks[0];

    // 版本冲突检测
    if (taskData.version && taskData.version < existingTask.version) {
      return res.status(409).json({
        success: false,
        message: '任务版本冲突',
        error: 'VERSION_CONFLICT',
        data: {
          server_version: existingTask.version,
          client_version: taskData.version,
          server_task: formatTaskResponse(existingTask)
        }
      });
    }

    // 更新任务
    await query(
      `UPDATE user_tasks SET
        title = ?, description = ?, list_id = ?, tags = ?, priority = ?, status = ?,
        due_at = ?, remind_at = ?, repeat_type = ?, repeat_rule = ?, sub_tasks = ?,
        attachments = ?, smart_reminders = ?, estimated_minutes = ?, actual_minutes = ?,
        focus_sessions = ?, location_reminder = ?, sort_order = ?, is_pinned = ?,
        color = ?, template_id = ?, completed_at = ?, version = version + 1
      WHERE client_id = ? AND user_id = ?`,
      [
        taskData.title !== undefined ? taskData.title : existingTask.title,
        taskData.description !== undefined ? taskData.description : existingTask.description,
        taskData.list_id !== undefined ? taskData.list_id : existingTask.list_id,
        taskData.tags !== undefined ? JSON.stringify(taskData.tags) : existingTask.tags,
        taskData.priority !== undefined ? taskData.priority : existingTask.priority,
        taskData.status !== undefined ? taskData.status : existingTask.status,
        taskData.due_at !== undefined ? taskData.due_at : existingTask.due_at,
        taskData.remind_at !== undefined ? taskData.remind_at : existingTask.remind_at,
        taskData.repeat_type !== undefined ? taskData.repeat_type : existingTask.repeat_type,
        taskData.repeat_rule !== undefined ? JSON.stringify(taskData.repeat_rule) : existingTask.repeat_rule,
        taskData.sub_tasks !== undefined ? JSON.stringify(taskData.sub_tasks) : existingTask.sub_tasks,
        taskData.attachments !== undefined ? JSON.stringify(taskData.attachments) : existingTask.attachments,
        taskData.smart_reminders !== undefined ? JSON.stringify(taskData.smart_reminders) : existingTask.smart_reminders,
        taskData.estimated_minutes !== undefined ? taskData.estimated_minutes : existingTask.estimated_minutes,
        taskData.actual_minutes !== undefined ? taskData.actual_minutes : existingTask.actual_minutes,
        taskData.focus_sessions !== undefined ? JSON.stringify(taskData.focus_sessions) : existingTask.focus_sessions,
        taskData.location_reminder !== undefined ? JSON.stringify(taskData.location_reminder) : existingTask.location_reminder,
        taskData.sort_order !== undefined ? taskData.sort_order : existingTask.sort_order,
        taskData.is_pinned !== undefined ? (taskData.is_pinned ? 1 : 0) : existingTask.is_pinned,
        taskData.color !== undefined ? taskData.color : existingTask.color,
        taskData.template_id !== undefined ? taskData.template_id : existingTask.template_id,
        taskData.completed_at !== undefined ? taskData.completed_at : existingTask.completed_at,
        taskId,
        userId
      ]
    );

    // 获取更新后的任务
    const updatedTasks = await query(
      'SELECT * FROM user_tasks WHERE client_id = ? AND user_id = ?',
      [taskId, userId]
    );

    res.json({
      success: true,
      message: '任务更新成功',
      data: formatTaskResponse(updatedTasks[0])
    });
  } catch (error) {
    console.error('更新任务失败:', error);
    res.status(500).json({
      success: false,
      message: '更新任务失败',
      error: error.message
    });
  }
}

/**
 * 删除任务（软删除）
 */
export async function deleteTask(req, res) {
  const userId = req.userId;
  const { taskId } = req.params;
  const { permanent = false } = req.query;

  try {
    if (permanent === 'true') {
      // 永久删除
      const result = await query(
        'DELETE FROM user_tasks WHERE client_id = ? AND user_id = ?',
        [taskId, userId]
      );

      if (result.affectedRows === 0) {
        return res.status(404).json({
          success: false,
          message: '任务不存在'
        });
      }

      res.json({
        success: true,
        message: '任务已永久删除'
      });
    } else {
      // 软删除
      const result = await query(
        'UPDATE user_tasks SET deleted_at = NOW(), version = version + 1 WHERE client_id = ? AND user_id = ? AND deleted_at IS NULL',
        [taskId, userId]
      );

      if (result.affectedRows === 0) {
        return res.status(404).json({
          success: false,
          message: '任务不存在或已删除'
        });
      }

      res.json({
        success: true,
        message: '任务已删除'
      });
    }
  } catch (error) {
    console.error('删除任务失败:', error);
    res.status(500).json({
      success: false,
      message: '删除任务失败',
      error: error.message
    });
  }
}

/**
 * 恢复已删除的任务
 */
export async function restoreTask(req, res) {
  const userId = req.userId;
  const { taskId } = req.params;

  try {
    const result = await query(
      'UPDATE user_tasks SET deleted_at = NULL, version = version + 1 WHERE client_id = ? AND user_id = ? AND deleted_at IS NOT NULL',
      [taskId, userId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: '任务不存在或未被删除'
      });
    }

    // 获取恢复后的任务
    const tasks = await query(
      'SELECT * FROM user_tasks WHERE client_id = ? AND user_id = ?',
      [taskId, userId]
    );

    res.json({
      success: true,
      message: '任务已恢复',
      data: formatTaskResponse(tasks[0])
    });
  } catch (error) {
    console.error('恢复任务失败:', error);
    res.status(500).json({
      success: false,
      message: '恢复任务失败',
      error: error.message
    });
  }
}

/**
 * 批量操作任务
 */
export async function batchUpdateTasks(req, res) {
  const userId = req.userId;
  const { task_ids, updates } = req.body;

  if (!task_ids || !Array.isArray(task_ids) || task_ids.length === 0) {
    return res.status(400).json({
      success: false,
      message: '请提供要更新的任务ID列表'
    });
  }

  try {
    const updateFields = [];
    const updateValues = [];

    // 构建更新字段
    if (updates.status !== undefined) {
      updateFields.push('status = ?');
      updateValues.push(updates.status);
    }
    if (updates.priority !== undefined) {
      updateFields.push('priority = ?');
      updateValues.push(updates.priority);
    }
    if (updates.list_id !== undefined) {
      updateFields.push('list_id = ?');
      updateValues.push(updates.list_id);
    }
    if (updates.is_pinned !== undefined) {
      updateFields.push('is_pinned = ?');
      updateValues.push(updates.is_pinned ? 1 : 0);
    }
    if (updates.deleted_at !== undefined) {
      updateFields.push('deleted_at = ?');
      updateValues.push(updates.deleted_at);
    }

    if (updateFields.length === 0) {
      return res.status(400).json({
        success: false,
        message: '没有提供要更新的字段'
      });
    }

    updateFields.push('version = version + 1');

    // 构建SQL
    const placeholders = task_ids.map(() => '?').join(',');
    const sql = `UPDATE user_tasks SET ${updateFields.join(', ')} WHERE client_id IN (${placeholders}) AND user_id = ?`;
    const params = [...updateValues, ...task_ids, userId];

    const result = await query(sql, params);

    res.json({
      success: true,
      message: '批量更新成功',
      data: {
        updated_count: result.affectedRows
      }
    });
  } catch (error) {
    console.error('批量更新任务失败:', error);
    res.status(500).json({
      success: false,
      message: '批量更新失败',
      error: error.message
    });
  }
}

/**
 * 上传任务附件
 */
export async function uploadTaskAttachment(req, res) {
  const userId = req.user.id;
  const { taskId } = req.params;

  try {
    if (!req.files || req.files.length === 0) {
      return res.status(400).json({
        success: false,
        message: '请上传附件文件'
      });
    }

    // 检查任务是否存在
    const tasks = await query(
      'SELECT * FROM user_tasks WHERE client_id = ? AND user_id = ?',
      [taskId, userId]
    );

    if (tasks.length === 0) {
      // 删除已上传的文件
      req.files.forEach(file => {
        const filePath = path.join(__dirname, '../uploads/attachments', file.filename);
        if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
      });

      return res.status(404).json({
        success: false,
        message: '任务不存在'
      });
    }

    const task = tasks[0];
    const existingAttachments = task.attachments
      ? (typeof task.attachments === 'string' ? JSON.parse(task.attachments) : task.attachments)
      : [];

    // 生成附件信息
    const host = process.env.HOST || 'localhost';
    const port = process.env.PORT || 3000;
    const baseUrl = `http://${host}:${port}`;

    const newAttachments = req.files.map(file => ({
      id: `att_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      name: file.originalname,
      filename: file.filename,
      url: `/uploads/attachments/${file.filename}`,
      full_url: `${baseUrl}/uploads/attachments/${file.filename}`,
      size: file.size,
      mime_type: file.mimetype,
      uploaded_at: new Date().toISOString()
    }));

    // 合并附件列表
    const allAttachments = [...existingAttachments, ...newAttachments];

    // 更新任务附件
    await query(
      'UPDATE user_tasks SET attachments = ?, version = version + 1 WHERE client_id = ? AND user_id = ?',
      [JSON.stringify(allAttachments), taskId, userId]
    );

    res.json({
      success: true,
      message: `成功上传 ${req.files.length} 个附件`,
      data: {
        task_id: taskId,
        uploaded: newAttachments,
        total_attachments: allAttachments.length
      }
    });
  } catch (error) {
    console.error('上传任务附件失败:', error);

    // 删除已上传的文件
    if (req.files) {
      req.files.forEach(file => {
        const filePath = path.join(__dirname, '../uploads/attachments', file.filename);
        if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
      });
    }

    res.status(500).json({
      success: false,
      message: '上传任务附件失败',
      error: error.message
    });
  }
}

/**
 * 删除任务附件
 */
export async function deleteTaskAttachment(req, res) {
  const userId = req.user.id;
  const { taskId, attachmentId } = req.params;

  try {
    // 检查任务是否存在
    const tasks = await query(
      'SELECT * FROM user_tasks WHERE client_id = ? AND user_id = ?',
      [taskId, userId]
    );

    if (tasks.length === 0) {
      return res.status(404).json({
        success: false,
        message: '任务不存在'
      });
    }

    const task = tasks[0];
    const existingAttachments = task.attachments
      ? (typeof task.attachments === 'string' ? JSON.parse(task.attachments) : task.attachments)
      : [];

    // 查找要删除的附件
    const attachmentIndex = existingAttachments.findIndex(att => att.id === attachmentId);

    if (attachmentIndex === -1) {
      return res.status(404).json({
        success: false,
        message: '附件不存在'
      });
    }

    const attachment = existingAttachments[attachmentIndex];

    // 删除物理文件
    if (attachment.filename) {
      const filePath = path.join(__dirname, '../uploads/attachments', attachment.filename);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }
    }

    // 从附件列表中移除
    existingAttachments.splice(attachmentIndex, 1);

    // 更新任务
    await query(
      'UPDATE user_tasks SET attachments = ?, version = version + 1 WHERE client_id = ? AND user_id = ?',
      [JSON.stringify(existingAttachments), taskId, userId]
    );

    res.json({
      success: true,
      message: '附件已删除',
      data: {
        task_id: taskId,
        deleted_attachment_id: attachmentId,
        remaining_attachments: existingAttachments.length
      }
    });
  } catch (error) {
    console.error('删除任务附件失败:', error);
    res.status(500).json({
      success: false,
      message: '删除任务附件失败',
      error: error.message
    });
  }
}

/**
 * 格式化任务响应数据
 */
function formatTaskResponse(task) {
  return {
    id: task.client_id,
    server_id: task.id,
    title: task.title,
    description: task.description,
    notes: task.notes,
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
    sync_status: task.sync_status,
    created_at: task.created_at,
    updated_at: task.updated_at
  };
}
