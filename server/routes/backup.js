const express = require('express');
const { pool } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// 所有路由都需要认证
router.use(authenticateToken);

// 创建备份
router.post('/create', async (req, res) => {
  try {
    const { backupName, backupData, deviceInfo } = req.body;
    const userId = req.user.id;

    if (!backupData) {
      return res.status(400).json({ error: '备份数据不能为空' });
    }

    const backupDataStr = JSON.stringify(backupData);
    const backupSize = Buffer.byteLength(backupDataStr, 'utf8');

    const [result] = await pool.query(
      'INSERT INTO user_backups (user_id, backup_name, backup_data, backup_size, device_info) VALUES (?, ?, ?, ?, ?)',
      [userId, backupName || `备份_${new Date().toLocaleDateString('zh-CN')}`, backupDataStr, backupSize, deviceInfo]
    );

    res.status(201).json({
      message: '备份创建成功',
      backupId: result.insertId,
      backupSize
    });
  } catch (error) {
    console.error('创建备份错误:', error);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 获取用户的所有备份列表
router.get('/list', async (req, res) => {
  try {
    const userId = req.user.id;

    const [backups] = await pool.query(
      'SELECT id, backup_name, backup_size, device_info, created_at FROM user_backups WHERE user_id = ? ORDER BY created_at DESC',
      [userId]
    );

    res.json({ backups });
  } catch (error) {
    console.error('获取备份列表错误:', error);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 获取特定备份的数据
router.get('/:backupId', async (req, res) => {
  try {
    const { backupId } = req.params;
    const userId = req.user.id;

    const [backups] = await pool.query(
      'SELECT * FROM user_backups WHERE id = ? AND user_id = ?',
      [backupId, userId]
    );

    if (backups.length === 0) {
      return res.status(404).json({ error: '备份不存在' });
    }

    const backup = backups[0];
    res.json({
      id: backup.id,
      backupName: backup.backup_name,
      backupData: JSON.parse(backup.backup_data),
      deviceInfo: backup.device_info,
      createdAt: backup.created_at
    });
  } catch (error) {
    console.error('获取备份错误:', error);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 删除备份
router.delete('/:backupId', async (req, res) => {
  try {
    const { backupId } = req.params;
    const userId = req.user.id;

    const [result] = await pool.query(
      'DELETE FROM user_backups WHERE id = ? AND user_id = ?',
      [backupId, userId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: '备份不存在' });
    }

    res.json({ message: '备份删除成功' });
  } catch (error) {
    console.error('删除备份错误:', error);
    res.status(500).json({ error: '服务器错误' });
  }
});

module.exports = router;
