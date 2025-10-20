const express = require('express');
const { pool } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// 所有路由都需要认证
router.use(authenticateToken);

// 上传同步数据
router.post('/upload', async (req, res) => {
  try {
    const { syncData, deviceInfo, lastSyncTime } = req.body;
    const userId = req.user.id;

    if (!syncData) {
      return res.status(400).json({ error: '同步数据不能为空' });
    }

    const syncDataStr = JSON.stringify(syncData);
    const dataSize = Buffer.byteLength(syncDataStr, 'utf8');

    // 保存同步记录
    const [result] = await pool.query(
      'INSERT INTO sync_records (user_id, sync_data, data_size, device_info, last_sync_time) VALUES (?, ?, ?, ?, ?)',
      [userId, syncDataStr, dataSize, deviceInfo, lastSyncTime || new Date()]
    );

    res.status(201).json({
      message: '数据同步成功',
      syncId: result.insertId,
      syncTime: new Date()
    });
  } catch (error) {
    console.error('上传同步数据错误:', error);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 下载同步数据（获取最新的同步记录）
router.get('/download', async (req, res) => {
  try {
    const userId = req.user.id;
    const { deviceId } = req.query;

    // 获取最新的同步记录
    const [records] = await pool.query(
      'SELECT * FROM sync_records WHERE user_id = ? ORDER BY created_at DESC LIMIT 1',
      [userId]
    );

    if (records.length === 0) {
      return res.json({
        message: '暂无同步数据',
        syncData: null
      });
    }

    const record = records[0];
    res.json({
      syncId: record.id,
      syncData: JSON.parse(record.sync_data),
      deviceInfo: record.device_info,
      lastSyncTime: record.last_sync_time,
      createdAt: record.created_at
    });
  } catch (error) {
    console.error('下载同步数据错误:', error);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 获取同步历史记录
router.get('/history', async (req, res) => {
  try {
    const userId = req.user.id;
    const { limit = 20, offset = 0 } = req.query;

    const [records] = await pool.query(
      'SELECT id, data_size, device_info, last_sync_time, created_at FROM sync_records WHERE user_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?',
      [userId, parseInt(limit), parseInt(offset)]
    );

    res.json({ records });
  } catch (error) {
    console.error('获取同步历史错误:', error);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 获取用户的所有设备列表
router.get('/devices', async (req, res) => {
  try {
    const userId = req.user.id;

    const [devices] = await pool.query(
      'SELECT * FROM user_devices WHERE user_id = ? ORDER BY last_active_at DESC',
      [userId]
    );

    res.json({ devices });
  } catch (error) {
    console.error('获取设备列表错误:', error);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 注册或更新设备信息
router.post('/device/register', async (req, res) => {
  try {
    const { deviceId, deviceName, deviceType, osVersion } = req.body;
    const userId = req.user.id;

    if (!deviceId) {
      return res.status(400).json({ error: '设备ID不能为空' });
    }

    // 检查设备是否已存在
    const [existing] = await pool.query(
      'SELECT id FROM user_devices WHERE user_id = ? AND device_id = ?',
      [userId, deviceId]
    );

    if (existing.length > 0) {
      // 更新设备信息
      await pool.query(
        'UPDATE user_devices SET device_name = ?, device_type = ?, os_version = ?, last_active_at = NOW() WHERE user_id = ? AND device_id = ?',
        [deviceName, deviceType, osVersion, userId, deviceId]
      );

      res.json({ message: '设备信息已更新' });
    } else {
      // 注册新设备
      const [result] = await pool.query(
        'INSERT INTO user_devices (user_id, device_id, device_name, device_type, os_version) VALUES (?, ?, ?, ?, ?)',
        [userId, deviceId, deviceName, deviceType, osVersion]
      );

      res.status(201).json({
        message: '设备注册成功',
        deviceId: result.insertId
      });
    }
  } catch (error) {
    console.error('注册设备错误:', error);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 删除设备
router.delete('/device/:deviceId', async (req, res) => {
  try {
    const { deviceId } = req.params;
    const userId = req.user.id;

    const [result] = await pool.query(
      'DELETE FROM user_devices WHERE user_id = ? AND device_id = ?',
      [userId, deviceId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: '设备不存在' });
    }

    res.json({ message: '设备删除成功' });
  } catch (error) {
    console.error('删除设备错误:', error);
    res.status(500).json({ error: '服务器错误' });
  }
});

module.exports = router;
