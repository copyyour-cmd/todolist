import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/domain/entities/task.dart';

/// 系统闹钟服务
/// 用于调用系统闹钟应用创建闹钟
class SystemAlarmService {
  SystemAlarmService({
    required AppLogger logger,
  }) : _logger = logger;

  final AppLogger _logger;
  static const _platform = MethodChannel('com.example.todolist/alarm');

  /// 创建系统闹钟
  ///
  /// 对于Android，会调用系统闹钟Intent
  /// 对于iOS，目前使用通知（iOS不支持直接创建闹钟）
  Future<bool> createSystemAlarm({
    required String id,
    required String title,
    required DateTime scheduledTime,
    String? message,
  }) async {
    try {
      if (!Platform.isAndroid) {
        _logger.warning('System alarm only supported on Android');
        return false;
      }

      _logger.info('Creating system alarm', {
        'id': id,
        'title': title,
        'time': scheduledTime.toIso8601String(),
      });

      // 调用原生代码创建闹钟
      final result = await _platform.invokeMethod<bool>('setAlarm', {
        'hour': scheduledTime.hour,
        'minute': scheduledTime.minute,
        'message': title,
        'skipUi': false, // 显示闹钟界面
      });

      if (result == true) {
        _logger.info('System alarm created successfully', id);
        return true;
      } else {
        _logger.warning('Failed to create system alarm', id);
        return false;
      }
    } on PlatformException catch (e) {
      _logger.error('Platform exception creating system alarm', e, StackTrace.current);
      return false;
    } catch (e, stackTrace) {
      _logger.error('Error creating system alarm', e, stackTrace);
      return false;
    }
  }

  /// 为任务创建系统闹钟
  Future<bool> createAlarmForTask(Task task) async {
    final remindAt = task.remindAt;
    if (remindAt == null) {
      _logger.warning('Task has no remind time', task.id);
      return false;
    }

    return createSystemAlarm(
      id: task.id,
      title: task.title,
      scheduledTime: remindAt,
      message: task.notes,
    );
  }

  /// 检查是否支持系统闹钟
  Future<bool> isSupported() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final result = await _platform.invokeMethod<bool>('canScheduleAlarm');
      return result ?? false;
    } catch (e) {
      _logger.warning('Error checking alarm support', e);
      return false;
    }
  }

  /// 打开系统闹钟应用
  Future<void> openAlarmApp() async {
    try {
      if (Platform.isAndroid) {
        await _platform.invokeMethod('openAlarmApp');
        _logger.info('Opened alarm app');
      }
    } catch (e, stackTrace) {
      _logger.error('Error opening alarm app', e, stackTrace);
    }
  }
}

final systemAlarmServiceProvider = Provider<SystemAlarmService>((ref) {
  return SystemAlarmService(
    logger: ref.watch(appLoggerProvider),
  );
});
