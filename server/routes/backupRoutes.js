import express from 'express';
import {
  createBackup,
  restoreBackup,
  getBackupList,
  getBackupDetail,
  deleteBackup,
  getBackupHistory
} from '../controllers/backupController.js';
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

// 所有备份路由都需要认证
router.use(authenticateToken);

/**
 * @route   POST /api/backup/create
 * @desc    创建数据备份
 * @access  Private
 */
router.post('/create', createBackup);

/**
 * @route   POST /api/backup/restore/:backupId
 * @desc    恢复数据备份
 * @access  Private
 */
router.post('/restore/:backupId', restoreBackup);

/**
 * @route   GET /api/backup/list
 * @desc    获取备份列表
 * @access  Private
 */
router.get('/list', getBackupList);

/**
 * @route   GET /api/backup/:backupId
 * @desc    获取备份详情
 * @access  Private
 */
router.get('/:backupId', getBackupDetail);

/**
 * @route   DELETE /api/backup/:backupId
 * @desc    删除备份
 * @access  Private
 */
router.delete('/:backupId', deleteBackup);

/**
 * @route   GET /api/backup/history/list
 * @desc    获取备份/恢复历史记录
 * @access  Private
 */
router.get('/history/list', getBackupHistory);

export default router;
