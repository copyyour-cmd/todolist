import { query } from '../config/database.js';

/**
 * 获取用户所有登录设备
 */
export async function getDevices(req, res) {
  const userId = req.userId;

  try {
    const sessions = await query(
      `SELECT
        id, device_id, device_name, device_type,
        ip_address, user_agent, created_at, last_used_at,
        expires_at > NOW() as is_active
      FROM user_sessions
      WHERE user_id = ?
      ORDER BY last_used_at DESC`,
      [userId]
    );

    // 获取当前会话的 token
    const currentToken = req.headers.authorization?.split(' ')[1];

    const devices = sessions.map(session => ({
      id: session.id,
      device_id: session.device_id,
      device_name: session.device_name,
      device_type: session.device_type,
      ip_address: session.ip_address,
      user_agent: session.user_agent,
      created_at: session.created_at,
      last_used_at: session.last_used_at,
      is_active: session.is_active === 1,
      is_current: false // 需要比对 token 才能确定
    }));

    res.json({
      success: true,
      data: {
        devices,
        total: devices.length,
        active_count: devices.filter(d => d.is_active).length
      }
    });
  } catch (error) {
    console.error('获取设备列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取设备列表失败',
      error: error.message
    });
  }
}

/**
 * 获取设备详情
 */
export async function getDeviceDetail(req, res) {
  const userId = req.userId;
  const { deviceId } = req.params;

  try {
    const sessions = await query(
      `SELECT
        id, device_id, device_name, device_type,
        ip_address, user_agent, created_at, last_used_at,
        expires_at, expires_at > NOW() as is_active
      FROM user_sessions
      WHERE id = ? AND user_id = ?`,
      [deviceId, userId]
    );

    if (sessions.length === 0) {
      return res.status(404).json({
        success: false,
        message: '设备不存在'
      });
    }

    const session = sessions[0];

    res.json({
      success: true,
      data: {
        id: session.id,
        device_id: session.device_id,
        device_name: session.device_name,
        device_type: session.device_type,
        ip_address: session.ip_address,
        user_agent: session.user_agent,
        created_at: session.created_at,
        last_used_at: session.last_used_at,
        expires_at: session.expires_at,
        is_active: session.is_active === 1
      }
    });
  } catch (error) {
    console.error('获取设备详情失败:', error);
    res.status(500).json({
      success: false,
      message: '获取设备详情失败',
      error: error.message
    });
  }
}

/**
 * 登出指定设备
 */
export async function logoutDevice(req, res) {
  const userId = req.userId;
  const { deviceId } = req.params;

  try {
    const result = await query(
      'DELETE FROM user_sessions WHERE id = ? AND user_id = ?',
      [deviceId, userId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: '设备不存在'
      });
    }

    res.json({
      success: true,
      message: '设备已登出'
    });
  } catch (error) {
    console.error('登出设备失败:', error);
    res.status(500).json({
      success: false,
      message: '登出设备失败',
      error: error.message
    });
  }
}

/**
 * 登出所有其他设备
 */
export async function logoutOtherDevices(req, res) {
  const userId = req.userId;
  const currentToken = req.headers.authorization?.split(' ')[1];

  if (!currentToken) {
    return res.status(400).json({
      success: false,
      message: '无法确定当前设备'
    });
  }

  try {
    const result = await query(
      'DELETE FROM user_sessions WHERE user_id = ? AND token != ?',
      [userId, currentToken]
    );

    res.json({
      success: true,
      message: '已登出所有其他设备',
      data: {
        logged_out_count: result.affectedRows
      }
    });
  } catch (error) {
    console.error('登出其他设备失败:', error);
    res.status(500).json({
      success: false,
      message: '登出其他设备失败',
      error: error.message
    });
  }
}

/**
 * 更新设备名称
 */
export async function updateDeviceName(req, res) {
  const userId = req.userId;
  const { deviceId } = req.params;
  const { device_name } = req.body;

  if (!device_name) {
    return res.status(400).json({
      success: false,
      message: '请提供设备名称'
    });
  }

  try {
    const result = await query(
      'UPDATE user_sessions SET device_name = ? WHERE id = ? AND user_id = ?',
      [device_name, deviceId, userId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: '设备不存在'
      });
    }

    res.json({
      success: true,
      message: '设备名称已更新'
    });
  } catch (error) {
    console.error('更新设备名称失败:', error);
    res.status(500).json({
      success: false,
      message: '更新设备名称失败',
      error: error.message
    });
  }
}

/**
 * 清理过期会话
 */
export async function cleanupExpiredSessions() {
  try {
    const result = await query(
      'DELETE FROM user_sessions WHERE expires_at < NOW()'
    );
    console.log(`清理了 ${result.affectedRows} 个过期会话`);
  } catch (error) {
    console.error('清理过期会话失败:', error);
  }
}

// 每小时清理一次过期会话
setInterval(cleanupExpiredSessions, 60 * 60 * 1000);
