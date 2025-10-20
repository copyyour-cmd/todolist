import express from 'express';
import {
  getDevices,
  getDeviceDetail,
  logoutDevice,
  logoutOtherDevices,
  updateDeviceName
} from '../controllers/deviceController.js';
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

// 所有设备路由都需要认证
router.use(authenticateToken);

/**
 * @route   GET /api/devices
 * @desc    获取用户所有登录设备
 * @access  Private
 */
router.get('/', getDevices);

/**
 * @route   GET /api/devices/:deviceId
 * @desc    获取设备详情
 * @access  Private
 */
router.get('/:deviceId', getDeviceDetail);

/**
 * @route   DELETE /api/devices/:deviceId
 * @desc    登出指定设备
 * @access  Private
 */
router.delete('/:deviceId', logoutDevice);

/**
 * @route   POST /api/devices/logout-others
 * @desc    登出所有其他设备
 * @access  Private
 */
router.post('/logout-others', logoutOtherDevices);

/**
 * @route   PUT /api/devices/:deviceId/name
 * @desc    更新设备名称
 * @access  Private
 */
router.put('/:deviceId/name', updateDeviceName);

export default router;
