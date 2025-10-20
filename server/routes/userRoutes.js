import express from 'express';
import {
  getProfile,
  updateProfile,
  changePassword,
  uploadAvatar,
  deleteAccount
} from '../controllers/userController.js';
import { authenticateToken } from '../middleware/auth.js';
import { uploadAvatar as uploadAvatarMiddleware, handleUploadError } from '../middleware/upload.js';

const router = express.Router();

// 所有用户路由都需要认证
router.use(authenticateToken);

/**
 * @route   GET /api/user/profile
 * @desc    获取用户资料
 * @access  Private
 */
router.get('/profile', getProfile);

/**
 * @route   PUT /api/user/profile
 * @desc    更新用户资料
 * @access  Private
 */
router.put('/profile', updateProfile);

/**
 * @route   POST /api/user/change-password
 * @desc    修改密码
 * @access  Private
 */
router.post('/change-password', changePassword);

/**
 * @route   POST /api/user/avatar
 * @desc    上传头像
 * @access  Private
 */
router.post('/avatar', uploadAvatarMiddleware.single('avatar'), handleUploadError, uploadAvatar);

/**
 * @route   DELETE /api/user/account
 * @desc    删除账户
 * @access  Private
 */
router.delete('/account', deleteAccount);

export default router;
