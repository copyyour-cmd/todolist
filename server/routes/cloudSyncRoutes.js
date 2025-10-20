import express from 'express';
import {
  uploadAll,
  downloadAll,
  createSnapshot,
  restoreFromSnapshot,
  getSnapshots,
  deleteSnapshot,
  getSyncStatus,
} from '../controllers/cloudSyncController.js';
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

// 所有路由都需要认证
router.use(authenticateToken);

// 全量同步
router.post('/upload', uploadAll);
router.get('/download', downloadAll);

// 快照管理
router.post('/snapshots', createSnapshot);
router.get('/snapshots', getSnapshots);
router.post('/snapshots/:snapshotId/restore', restoreFromSnapshot);
router.delete('/snapshots/:snapshotId', deleteSnapshot);

// 同步状态
router.get('/status', getSyncStatus);

export default router;

