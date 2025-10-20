import express from 'express';
import {
  getLists,
  getList,
  createList,
  updateList,
  deleteList,
  restoreList,
} from '../controllers/listController.js';
import { authenticateToken } from '../middleware/auth.js';

const router = express.Router();

// 所有路由都需要认证
router.use(authenticateToken);

// 列表路由
router.get('/', getLists);                    // 获取列表
router.get('/:listId', getList);              // 获取单个列表
router.post('/', createList);                 // 创建列表
router.put('/:listId', updateList);           // 更新列表
router.delete('/:listId', deleteList);        // 删除列表
router.post('/:listId/restore', restoreList); // 恢复列表

export default router;
