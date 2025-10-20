import { query } from '../config/database.js';
import bcrypt from 'bcryptjs';
import crypto from 'crypto';

/**
 * 请求密码重置
 */
export async function requestPasswordReset(req, res) {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({
      success: false,
      message: '请提供邮箱地址'
    });
  }

  try {
    // 检查用户是否存在
    const users = await query(
      'SELECT id FROM users WHERE email = ?',
      [email]
    );

    // 无论用户是否存在都返回成功（安全考虑，不暴露用户是否存在）
    if (users.length === 0) {
      return res.json({
        success: true,
        message: '如果该邮箱存在，重置链接已发送'
      });
    }

    const userId = users[0].id;

    // 生成重置令牌
    const resetToken = crypto.randomBytes(32).toString('hex');
    const hashedToken = crypto
      .createHash('sha256')
      .update(resetToken)
      .digest('hex');

    // 设置过期时间（1小时）
    const expiresAt = new Date(Date.now() + 60 * 60 * 1000);

    // 保存重置令牌
    await query(
      'INSERT INTO password_resets (user_id, reset_token, expires_at) VALUES (?, ?, ?)',
      [userId, hashedToken, expiresAt]
    );

    // TODO: 发送邮件
    // 这里应该发送包含重置链接的邮件
    // 重置链接格式: https://your-domain.com/reset-password?token=${resetToken}

    console.log(`密码重置令牌（开发环境）: ${resetToken}`);

    res.json({
      success: true,
      message: '重置链接已发送到您的邮箱',
      // 仅在开发环境返回 token
      ...(process.env.NODE_ENV === 'development' && { resetToken })
    });
  } catch (error) {
    console.error('请求密码重置失败:', error);
    res.status(500).json({
      success: false,
      message: '请求密码重置失败',
      error: error.message
    });
  }
}

/**
 * 验证重置令牌
 */
export async function verifyResetToken(req, res) {
  const { token } = req.body;

  if (!token) {
    return res.status(400).json({
      success: false,
      message: '请提供重置令牌'
    });
  }

  try {
    const hashedToken = crypto
      .createHash('sha256')
      .update(token)
      .digest('hex');

    const resets = await query(
      'SELECT user_id FROM password_resets WHERE reset_token = ? AND expires_at > NOW() AND used = 0',
      [hashedToken]
    );

    if (resets.length === 0) {
      return res.status(400).json({
        success: false,
        message: '重置令牌无效或已过期'
      });
    }

    res.json({
      success: true,
      message: '令牌有效'
    });
  } catch (error) {
    console.error('验证重置令牌失败:', error);
    res.status(500).json({
      success: false,
      message: '验证重置令牌失败',
      error: error.message
    });
  }
}

/**
 * 重置密码
 */
export async function resetPassword(req, res) {
  const { token, new_password } = req.body;

  if (!token || !new_password) {
    return res.status(400).json({
      success: false,
      message: '请提供重置令牌和新密码'
    });
  }

  if (new_password.length < 6) {
    return res.status(400).json({
      success: false,
      message: '密码长度至少为6个字符'
    });
  }

  try {
    const hashedToken = crypto
      .createHash('sha256')
      .update(token)
      .digest('hex');

    // 查找有效的重置记录
    const resets = await query(
      'SELECT user_id FROM password_resets WHERE reset_token = ? AND expires_at > NOW() AND used = 0',
      [hashedToken]
    );

    if (resets.length === 0) {
      return res.status(400).json({
        success: false,
        message: '重置令牌无效或已过期'
      });
    }

    const userId = resets[0].user_id;

    // 加密新密码
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(new_password, salt);

    // 更新密码
    await query(
      'UPDATE users SET password_hash = ? WHERE id = ?',
      [passwordHash, userId]
    );

    // 标记令牌为已使用
    await query(
      'UPDATE password_resets SET used = 1 WHERE reset_token = ?',
      [hashedToken]
    );

    // 清除该用户的所有会话（强制重新登录）
    await query(
      'DELETE FROM user_sessions WHERE user_id = ?',
      [userId]
    );

    res.json({
      success: true,
      message: '密码重置成功'
    });
  } catch (error) {
    console.error('重置密码失败:', error);
    res.status(500).json({
      success: false,
      message: '重置密码失败',
      error: error.message
    });
  }
}

/**
 * 清理过期的重置令牌
 */
export async function cleanupExpiredTokens() {
  try {
    await query(
      'DELETE FROM password_resets WHERE expires_at < NOW()'
    );
  } catch (error) {
    console.error('清理过期令牌失败:', error);
  }
}

// 每小时清理一次过期令牌
setInterval(cleanupExpiredTokens, 60 * 60 * 1000);
