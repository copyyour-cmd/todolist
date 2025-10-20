import express from 'express';
import {
  register,
  login,
  getCurrentUser,
  logout,
  refreshToken
} from '../controllers/authController.js';
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

// 公开路由
router.post('/register', register);
router.post('/login', login);
router.post('/refresh-token', refreshToken);

// 需要认证的路由
router.get('/me', authenticateToken, getCurrentUser);
router.post('/logout', authenticateToken, logout);

export default router;
