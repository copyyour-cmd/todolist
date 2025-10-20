import express from 'express';
import {
  getTags,
  getTag,
  createTag,
  updateTag,
  deleteTag,
  restoreTag,
  getTagStats,
} from '../controllers/tagController.js';
import { authenticateToken } from '../middleware/auth.js';

const router = express.Router();

// 所有路由都需要认证
router.use(authenticateToken);

// 标签路由
router.get('/', getTags);                  // 获取标签
router.get('/stats', getTagStats);         // 获取标签统计（放在:tagId之前）
router.get('/:tagId', getTag);             // 获取单个标签
router.post('/', createTag);               // 创建标签
router.put('/:tagId', updateTag);          // 更新标签
router.delete('/:tagId', deleteTag);       // 删除标签
router.post('/:tagId/restore', restoreTag);// 恢复标签

export default router;
