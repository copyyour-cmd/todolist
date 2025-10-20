import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { query } from '../config/database.js';

// 生成 JWT Token
function generateToken(userId) {
  return jwt.sign(
    { userId },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
  );
}

// 生成刷新 Token
function generateRefreshToken(userId) {
  return jwt.sign(
    { userId, type: 'refresh' },
    process.env.JWT_SECRET,
    { expiresIn: process.env.REFRESH_TOKEN_EXPIRES_IN || '30d' }
  );
}

// 用户注册
export async function register(req, res) {
  try {
    const { username, email, password, nickname } = req.body;

    // 验证必填字段
    if (!username || !email || !password) {
      return res.status(400).json({
        success: false,
        message: '用户名、邮箱和密码为必填项'
      });
    }

    // 验证用户名格式（3-20个字符，字母数字下划线）
    if (!/^[a-zA-Z0-9_]{3,20}$/.test(username)) {
      return res.status(400).json({
        success: false,
        message: '用户名格式不正确，应为3-20个字符的字母、数字或下划线'
      });
    }

    // 验证邮箱格式
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({
        success: false,
        message: '邮箱格式不正确'
      });
    }

    // 验证密码长度
    if (password.length < 6) {
      return res.status(400).json({
        success: false,
        message: '密码长度至少为6个字符'
      });
    }

    // 检查用户名是否已存在
    const existingUsername = await query(
      'SELECT id FROM users WHERE username = ?',
      [username]
    );
    if (existingUsername.length > 0) {
      return res.status(400).json({
        success: false,
        message: '用户名已存在'
      });
    }

    // 检查邮箱是否已存在
    const existingEmail = await query(
      'SELECT id FROM users WHERE email = ?',
      [email]
    );
    if (existingEmail.length > 0) {
      return res.status(400).json({
        success: false,
        message: '邮箱已被注册'
      });
    }

    // 加密密码
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    // 创建用户
    const result = await query(
      'INSERT INTO users (username, email, password_hash, nickname, status) VALUES (?, ?, ?, ?, 1)',
      [username, email, passwordHash, nickname || username]
    );

    const userId = result.insertId;

    // 生成 token
    const token = generateToken(userId);
    const refreshToken = generateRefreshToken(userId);

    // 保存会话
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // 7天后过期
    await query(
      `INSERT INTO user_sessions
       (user_id, token, refresh_token, device_type, ip_address, user_agent, expires_at)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        userId,
        token,
        refreshToken,
        req.body.deviceType || 'unknown',
        req.ip || req.connection.remoteAddress || 'unknown',
        req.headers['user-agent'] || 'unknown',
        expiresAt
      ]
    );

    // 获取用户信息
    const [user] = await query(
      'SELECT id, username, email, nickname, avatar_url, created_at FROM users WHERE id = ?',
      [userId]
    );

    res.status(201).json({
      success: true,
      message: '注册成功',
      data: {
        user,
        token,
        refreshToken
      }
    });

  } catch (error) {
    console.error('注册错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误',
      error: error.message
    });
  }
}

// 用户登录
export async function login(req, res) {
  try {
    const { username, password, deviceType, deviceId, deviceName } = req.body;

    // 验证必填字段
    if (!username || !password) {
      return res.status(400).json({
        success: false,
        message: '用户名和密码为必填项'
      });
    }

    // 查找用户（支持用户名或邮箱登录）
    const users = await query(
      'SELECT * FROM users WHERE username = ? OR email = ?',
      [username, username]
    );

    if (users.length === 0) {
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      });
    }

    const user = users[0];

    // 检查用户状态
    if (user.status !== 1) {
      return res.status(403).json({
        success: false,
        message: '账户已被禁用'
      });
    }

    // 验证密码
    const isPasswordValid = await bcrypt.compare(password, user.password_hash);
    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      });
    }

    // 生成 token
    const token = generateToken(user.id);
    const refreshToken = generateRefreshToken(user.id);

    // 删除该用户在该设备的旧会话（如果存在）
    if (deviceId) {
      await query(
        'DELETE FROM user_sessions WHERE user_id = ? AND device_id = ?',
        [user.id, deviceId]
      );
    }

    // 保存新会话
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
    await query(
      `INSERT INTO user_sessions
       (user_id, token, refresh_token, device_id, device_name, device_type, ip_address, user_agent, expires_at)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        user.id,
        token,
        refreshToken,
        deviceId || null,
        deviceName || null,
        deviceType || 'unknown',
        req.ip || req.connection.remoteAddress,
        req.headers['user-agent'],
        expiresAt
      ]
    );

    // 更新最后登录时间和IP
    await query(
      'UPDATE users SET last_login_at = NOW(), last_login_ip = ? WHERE id = ?',
      [req.ip || req.connection.remoteAddress, user.id]
    );

    // 返回用户信息（不包含密码）
    const { password_hash, ...userInfo } = user;

    res.json({
      success: true,
      message: '登录成功',
      data: {
        user: userInfo,
        token,
        refreshToken
      }
    });

  } catch (error) {
    console.error('登录错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误',
      error: error.message
    });
  }
}

// 获取当前用户信息
export async function getCurrentUser(req, res) {
  try {
    const userId = req.userId; // 从中间件获取

    const users = await query(
      'SELECT id, username, email, nickname, avatar_url, phone, status, created_at, last_login_at FROM users WHERE id = ?',
      [userId]
    );

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }

    res.json({
      success: true,
      data: users[0]
    });

  } catch (error) {
    console.error('获取用户信息错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误',
      error: error.message
    });
  }
}

// 退出登录
export async function logout(req, res) {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');

    if (token) {
      // 删除会话
      await query('DELETE FROM user_sessions WHERE token = ?', [token]);
    }

    res.json({
      success: true,
      message: '退出登录成功'
    });

  } catch (error) {
    console.error('退出登录错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误',
      error: error.message
    });
  }
}

// 刷新 Token
export async function refreshToken(req, res) {
  try {
    const { refreshToken: oldRefreshToken } = req.body;

    if (!oldRefreshToken) {
      return res.status(400).json({
        success: false,
        message: '刷新令牌为必填项'
      });
    }

    // 验证刷新令牌
    const decoded = jwt.verify(oldRefreshToken, process.env.JWT_SECRET);

    if (decoded.type !== 'refresh') {
      return res.status(400).json({
        success: false,
        message: '无效的刷新令牌'
      });
    }

    // 检查会话是否存在
    const sessions = await query(
      'SELECT * FROM user_sessions WHERE refresh_token = ? AND user_id = ?',
      [oldRefreshToken, decoded.userId]
    );

    if (sessions.length === 0) {
      return res.status(401).json({
        success: false,
        message: '会话不存在或已过期'
      });
    }

    // 生成新的 token
    const newToken = generateToken(decoded.userId);
    const newRefreshToken = generateRefreshToken(decoded.userId);
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);

    // 更新会话
    await query(
      'UPDATE user_sessions SET token = ?, refresh_token = ?, expires_at = ?, last_used_at = NOW() WHERE refresh_token = ?',
      [newToken, newRefreshToken, expiresAt, oldRefreshToken]
    );

    res.json({
      success: true,
      message: '令牌刷新成功',
      data: {
        token: newToken,
        refreshToken: newRefreshToken
      }
    });

  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        message: '刷新令牌已过期，请重新登录'
      });
    }

    console.error('刷新令牌错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误',
      error: error.message
    });
  }
}
