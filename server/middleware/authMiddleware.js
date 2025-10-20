import jwt from 'jsonwebtoken';
import { query } from '../config/database.js';

// 验证 JWT Token
export async function authenticateToken(req, res, next) {
  try {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

    if (!token) {
      return res.status(401).json({
        success: false,
        message: '未提供认证令牌'
      });
    }

    // 验证 token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // 检查会话是否存在且未过期
    const sessions = await query(
      'SELECT * FROM user_sessions WHERE token = ? AND user_id = ? AND expires_at > NOW()',
      [token, decoded.userId]
    );

    if (sessions.length === 0) {
      return res.status(401).json({
        success: false,
        message: '会话已过期，请重新登录'
      });
    }

    // 更新最后使用时间
    await query(
      'UPDATE user_sessions SET last_used_at = NOW() WHERE token = ?',
      [token]
    );

    // 将用户ID添加到请求对象
    req.userId = decoded.userId;
    req.session = sessions[0];
    next();

  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        message: '令牌已过期，请刷新或重新登录'
      });
    }

    if (error.name === 'JsonWebTokenError') {
      return res.status(403).json({
        success: false,
        message: '无效的令牌'
      });
    }

    console.error('认证错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
}

// 可选的认证中间件（不强制要求登录）
export async function optionalAuth(req, res, next) {
  try {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
      req.userId = null;
      return next();
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const sessions = await query(
      'SELECT * FROM user_sessions WHERE token = ? AND user_id = ? AND expires_at > NOW()',
      [token, decoded.userId]
    );

    if (sessions.length > 0) {
      req.userId = decoded.userId;
      req.session = sessions[0];
    } else {
      req.userId = null;
    }

    next();

  } catch (error) {
    req.userId = null;
    next();
  }
}
