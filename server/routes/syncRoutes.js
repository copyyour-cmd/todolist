import express from 'express';
import {
  syncTasks,
  getSyncStatus,
  forceFullSync
} from '../controllers/syncController.js';
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

// 所有同步路由都需要认证
router.use(authenticateToken);

/**
 * @route   POST /api/sync
 * @desc    批量同步任务、列表、标签
 * @access  Private
 */
router.post('/', syncTasks);

/**
 * @route   GET /api/sync/status
 * @desc    获取同步状态
 * @access  Private
 */
router.get('/status', getSyncStatus);

/**
 * @route   GET /api/sync/full
 * @desc    强制全量同步
 * @access  Private
 */
router.get('/full', forceFullSync);

export default router;
