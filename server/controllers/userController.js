import { query } from '../config/database.js';
import bcrypt from 'bcryptjs';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/**
 * 获取用户资料
 */
export async function getProfile(req, res) {
  const userId = req.userId;

  try {
    const users = await query(
      'SELECT id, username, email, nickname, avatar_url, phone, status, created_at, updated_at, last_login_at FROM users WHERE id = ?',
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
    console.error('获取用户资料失败:', error);
    res.status(500).json({
      success: false,
      message: '获取用户资料失败',
      error: error.message
    });
  }
}

/**
 * 更新用户资料
 */
export async function updateProfile(req, res) {
  const userId = req.userId;
  const { nickname, email, phone } = req.body;

  try {
    const updates = [];
    const params = [];

    if (nickname !== undefined) {
      updates.push('nickname = ?');
      params.push(nickname);
    }

    if (email !== undefined) {
      // 检查邮箱是否已被使用
      const existingUsers = await query(
        'SELECT id FROM users WHERE email = ? AND id != ?',
        [email, userId]
      );

      if (existingUsers.length > 0) {
        return res.status(400).json({
          success: false,
          message: '该邮箱已被使用'
        });
      }

      updates.push('email = ?');
      params.push(email);
    }

    if (phone !== undefined) {
      // 检查手机号是否已被使用
      if (phone) {
        const existingUsers = await query(
          'SELECT id FROM users WHERE phone = ? AND id != ?',
          [phone, userId]
        );

        if (existingUsers.length > 0) {
          return res.status(400).json({
            success: false,
            message: '该手机号已被使用'
          });
        }
      }

      updates.push('phone = ?');
      params.push(phone);
    }

    if (updates.length === 0) {
      return res.status(400).json({
        success: false,
        message: '没有提供要更新的字段'
      });
    }

    params.push(userId);

    await query(
      `UPDATE users SET ${updates.join(', ')} WHERE id = ?`,
      params
    );

    // 获取更新后的用户信息
    const users = await query(
      'SELECT id, username, email, nickname, avatar_url, phone, status, created_at, updated_at FROM users WHERE id = ?',
      [userId]
    );

    res.json({
      success: true,
      message: '资料更新成功',
      data: users[0]
    });
  } catch (error) {
    console.error('更新用户资料失败:', error);
    res.status(500).json({
      success: false,
      message: '更新用户资料失败',
      error: error.message
    });
  }
}

/**
 * 修改密码
 */
export async function changePassword(req, res) {
  const userId = req.userId;
  const { old_password, new_password } = req.body;

  if (!old_password || !new_password) {
    return res.status(400).json({
      success: false,
      message: '请提供旧密码和新密码'
    });
  }

  if (new_password.length < 6) {
    return res.status(400).json({
      success: false,
      message: '新密码长度至少为6个字符'
    });
  }

  try {
    // 获取用户当前密码
    const users = await query(
      'SELECT password_hash FROM users WHERE id = ?',
      [userId]
    );

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }

    // 验证旧密码
    const isPasswordValid = await bcrypt.compare(old_password, users[0].password_hash);
    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        message: '旧密码不正确'
      });
    }

    // 加密新密码
    const salt = await bcrypt.genSalt(10);
    const newPasswordHash = await bcrypt.hash(new_password, salt);

    // 更新密码
    await query(
      'UPDATE users SET password_hash = ? WHERE id = ?',
      [newPasswordHash, userId]
    );

    res.json({
      success: true,
      message: '密码修改成功'
    });
  } catch (error) {
    console.error('修改密码失败:', error);
    res.status(500).json({
      success: false,
      message: '修改密码失败',
      error: error.message
    });
  }
}

/**
 * 上传头像
 */
export async function uploadAvatar(req, res) {
  const userId = req.user.id;

  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: '请上传头像文件'
      });
    }

    // 获取旧头像
    const users = await query(
      'SELECT avatar_url FROM users WHERE id = ?',
      [userId]
    );

    const oldAvatarUrl = users[0]?.avatar_url;

    // 生成新头像URL
    const avatarUrl = `/uploads/avatars/${req.file.filename}`;

    // 更新用户头像
    await query(
      'UPDATE users SET avatar_url = ? WHERE id = ?',
      [avatarUrl, userId]
    );

    // 删除旧头像文件（如果存在）
    if (oldAvatarUrl && oldAvatarUrl.startsWith('/uploads/avatars/')) {
      const oldFilename = oldAvatarUrl.split('/').pop();
      const oldFilePath = path.join(__dirname, '../uploads/avatars', oldFilename);
      if (fs.existsSync(oldFilePath)) {
        fs.unlinkSync(oldFilePath);
      }
    }

    const host = process.env.HOST || 'localhost';
    const port = process.env.PORT || 3000;
    const fullUrl = `http://${host}:${port}${avatarUrl}`;

    res.json({
      success: true,
      message: '头像上传成功',
      data: {
        avatar_url: avatarUrl,
        full_url: fullUrl,
        filename: req.file.filename,
        size: req.file.size
      }
    });
  } catch (error) {
    console.error('上传头像失败:', error);
    res.status(500).json({
      success: false,
      message: '上传头像失败',
      error: error.message
    });
  }
}

/**
 * 删除账户
 */
export async function deleteAccount(req, res) {
  const userId = req.userId;
  const { password } = req.body;

  if (!password) {
    return res.status(400).json({
      success: false,
      message: '请提供密码以确认删除'
    });
  }

  try {
    // 验证密码
    const users = await query(
      'SELECT password_hash FROM users WHERE id = ?',
      [userId]
    );

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }

    const isPasswordValid = await bcrypt.compare(password, users[0].password_hash);
    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        message: '密码不正确'
      });
    }

    // 删除用户（级联删除相关数据）
    await query('DELETE FROM users WHERE id = ?', [userId]);

    res.json({
      success: true,
      message: '账户已删除'
    });
  } catch (error) {
    console.error('删除账户失败:', error);
    res.status(500).json({
      success: false,
      message: '删除账户失败',
      error: error.message
    });
  }
}
