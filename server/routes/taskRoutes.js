import express from 'express';
import {
  getTasks,
  getTask,
  createTask,
  updateTask,
  deleteTask,
  restoreTask,
  batchUpdateTasks,
  uploadTaskAttachment,
  deleteTaskAttachment
} from '../controllers/taskController.js';
import { authenticateToken } from '../middleware/auth.js';
import { uploadAttachment, handleUploadError } from '../middleware/upload.js';

const router = express.Router();

// 所有任务路由都需要认证
router.use(authenticateToken);

/**
 * @route   GET /api/tasks
 * @desc    获取任务列表
 * @access  Private
 * @query   page, limit, listId, status, priority, includeDeleted, updatedAfter
 */
router.get('/', getTasks);

/**
 * @route   GET /api/tasks/:taskId
 * @desc    获取单个任务详情
 * @access  Private
 */
router.get('/:taskId', getTask);

/**
 * @route   POST /api/tasks
 * @desc    创建任务
 * @access  Private
 */
router.post('/', createTask);

/**
 * @route   PUT /api/tasks/:taskId
 * @desc    更新任务
 * @access  Private
 */
router.put('/:taskId', updateTask);

/**
 * @route   DELETE /api/tasks/:taskId
 * @desc    删除任务（软删除）
 * @access  Private
 * @query   permanent=true 永久删除
 */
router.delete('/:taskId', deleteTask);

/**
 * @route   POST /api/tasks/:taskId/restore
 * @desc    恢复已删除的任务
 * @access  Private
 */
router.post('/:taskId/restore', restoreTask);

/**
 * @route   POST /api/tasks/batch
 * @desc    批量更新任务
 * @access  Private
 */
router.post('/batch/update', batchUpdateTasks);

/**
 * @route   POST /api/tasks/:taskId/attachments
 * @desc    上传任务附件（支持多文件）
 * @access  Private
 */
router.post('/:taskId/attachments', uploadAttachment.array('attachments', 10), handleUploadError, uploadTaskAttachment);

/**
 * @route   DELETE /api/tasks/:taskId/attachments/:attachmentId
 * @desc    删除任务附件
 * @access  Private
 */
router.delete('/:taskId/attachments/:attachmentId', deleteTaskAttachment);

export default router;
