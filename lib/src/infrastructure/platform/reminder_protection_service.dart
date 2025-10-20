import 'package:flutter/services.dart';
import 'package:todolist/src/core/logging/app_logger.dart';

/// 提醒保护服务 - 防止应用被系统杀死
class ReminderProtectionService {
  ReminderProtectionService(this._logger);

  final AppLogger _logger;
  static const _channel = MethodChannel('com.example.todolist/reminder_protection');

  /// 启动前台服务
  Future<bool> startForegroundService() async {
    try {
      final result = await _channel.invokeMethod<bool>('startForegroundService');
      _logger.info('前台服务已启动');
      return result ?? false;
    } catch (e, st) {
      _logger.error('启动前台服务失败', e, st);
      return false;
    }
  }

  /// 停止前台服务
  Future<bool> stopForegroundService() async {
    try {
      final result = await _channel.invokeMethod<bool>('stopForegroundService');
      _logger.info('前台服务已停止');
      return result ?? false;
    } catch (e, st) {
      _logger.error('停止前台服务失败', e, st);
      return false;
    }
  }

  /// 检查是否已加入电池优化白名单
  Future<bool> checkBatteryOptimization() async {
    try {
      final result = await _channel.invokeMethod<bool>('checkBatteryOptimization');
      return result ?? false;
    } catch (e, st) {
      _logger.error('检查电池优化状态失败', e, st);
      return false;
    }
  }

  /// 请求加入电池优化白名单
  Future<bool> requestBatteryOptimizationExemption() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestBatteryOptimizationExemption');
      _logger.info('已请求电池优化豁免');
      return result ?? false;
    } catch (e, st) {
      _logger.error('请求电池优化豁免失败', e, st);
      return false;
    }
  }

  /// 打开应用设置页面
  Future<bool> openAppSettings() async {
    try {
      final result = await _channel.invokeMethod<bool>('openAppSettings');
      _logger.info('已打开应用设置');
      return result ?? false;
    } catch (e, st) {
      _logger.error('打开应用设置失败', e, st);
      return false;
    }
  }
}
