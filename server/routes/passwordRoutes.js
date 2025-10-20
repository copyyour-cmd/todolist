import express from 'express';
import {
  requestPasswordReset,
  verifyResetToken,
  resetPassword
} from '../controllers/passwordController.js';

const router = express.Router();

/**
 * @route   POST /api/password/reset-request
 * @desc    请求密码重置（发送邮件）
 * @access  Public
 */
router.post('/reset-request', requestPasswordReset);

/**
 * @route   POST /api/password/verify-token
 * @desc    验证重置令牌是否有效
 * @access  Public
 */
router.post('/verify-token', verifyResetToken);

/**
 * @route   POST /api/password/reset
 * @desc    重置密码
 * @access  Public
 */
router.post('/reset', resetPassword);

export default router;
