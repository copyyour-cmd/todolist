import 'package:hive_flutter/hive_flutter.dart';
import '../../../infrastructure/hive/type_ids.dart';

part 'reminder_mode.g.dart';

/// 提醒模式
@HiveType(typeId: 69, adapterName: 'ReminderModeAdapter')
enum ReminderMode {
  /// 标准通知 - 普通的本地通知
  @HiveField(0)
  notification,

  /// 全屏提醒 - 高优先级全屏显示
  @HiveField(1)
  fullScreen,

  /// 系统闹钟 - 调用系统闹钟应用
  @HiveField(2)
  systemAlarm,
}

extension ReminderModeExtension on ReminderMode {
  /// 获取显示名称
  String get displayName {
    switch (this) {
      case ReminderMode.notification:
        return '标准通知';
      case ReminderMode.fullScreen:
        return '全屏提醒';
      case ReminderMode.systemAlarm:
        return '系统闹钟';
    }
  }

  /// 获取描述
  String get description {
    switch (this) {
      case ReminderMode.notification:
        return '在通知栏显示提醒，适合日常任务';
      case ReminderMode.fullScreen:
        return '全屏显示，声音+震动，适合重要任务';
      case ReminderMode.systemAlarm:
        return '使用系统闹钟，最可靠，适合超级重要的事';
    }
  }

  /// 获取图标
  String get icon {
    switch (this) {
      case ReminderMode.notification:
        return '🔔';
      case ReminderMode.fullScreen:
        return '📢';
      case ReminderMode.systemAlarm:
        return '⏰';
    }
  }

  /// 获取优先级（数字越大优先级越高）
  int get priority {
    switch (this) {
      case ReminderMode.notification:
        return 1;
      case ReminderMode.fullScreen:
        return 2;
      case ReminderMode.systemAlarm:
        return 3;
    }
  }
}
