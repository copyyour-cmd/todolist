import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todolist/l10n/app_localizations.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/features/reminders/domain/reminder_mode.dart';
import 'package:todolist/src/features/reminders/application/system_alarm_service.dart';

class NotificationService {
  NotificationService({
    required Clock clock,
    required AppLogger logger,
    required bool enabled,
    SystemAlarmService? systemAlarmService,
    FlutterLocalNotificationsPlugin? plugin,
    void Function(String? payload)? onNotificationTap,
  })  : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
        _clock = clock,
        _logger = logger,
        _enabled = enabled,
        _systemAlarmService = systemAlarmService,
        _onNotificationTap = onNotificationTap;

  final FlutterLocalNotificationsPlugin _plugin;
  final Clock _clock;
  final AppLogger _logger;
  final bool _enabled;
  final SystemAlarmService? _systemAlarmService;
  final void Function(String? payload)? _onNotificationTap;
  bool _initialized = false;
  AppLocalizations? _localizations;

  Future<void> init() async {
    if (_initialized || !_enabled) {
      return;
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const linux = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );
    const settings = InitializationSettings(
      android: android,
      iOS: ios,
      linux: linux,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        _logger.info('Notification tapped', {'payload': payload});
        if (_onNotificationTap != null && payload != null) {
          _onNotificationTap(payload);
        }
      },
    );

    // Request notification permissions for Android 13+ with timeout
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission()
          .timeout(const Duration(seconds: 5));
    } catch (error) {
      _logger.warning('Notification permission request failed or timed out', error);
    }

    // Request exact alarm permission for Android 12+ with timeout
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission()
          .timeout(const Duration(seconds: 5));
    } catch (error) {
      _logger.warning('Exact alarm permission request failed or timed out', error);
    }

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _logger.info('Launched from notification', launchDetails?.notificationResponse);
    }

    tz.initializeTimeZones();
    final zoneName = DateTime.now().timeZoneName;
    try {
      tz.setLocalLocation(tz.getLocation(zoneName));
      _logger.info('Timezone set', zoneName);
    } catch (error) {
      tz.setLocalLocation(tz.getLocation('UTC'));
      _logger.warning('Falling back to UTC timezone', error);
    }

    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    try {
      _localizations = await AppLocalizations.delegate.load(locale);
    } catch (error) {
      _logger.warning('Failed to load localizations for notifications', error);
      _localizations = await AppLocalizations.delegate.load(const Locale('en'));
    }

    _initialized = true;
  }

  Future<void> syncTaskReminder(Task task) async {
    if (!_enabled) {
      return;
    }
    if (task.remindAt == null) {
      await cancelTaskReminder(task.id);
      return;
    }
    if (task.isCompleted || task.status == TaskStatus.cancelled) {
      await cancelTaskReminder(task.id);
      return;
    }

    // 根据提醒模式选择不同的提醒方式
    switch (task.reminderMode) {
      case ReminderMode.notification:
        // 标准通知
        await scheduleTaskReminder(task, fullScreen: false);
        break;
      case ReminderMode.fullScreen:
        // 全屏提醒
        await scheduleTaskReminder(task, fullScreen: true);
        break;
      case ReminderMode.systemAlarm:
        // 系统闹钟
        if (_systemAlarmService != null) {
          try {
            final success = await _systemAlarmService.createAlarmForTask(task);
            if (success) {
              _logger.info('System alarm scheduled', {
                'taskId': task.id,
                'when': task.remindAt!.toIso8601String(),
              });
            } else {
              // 创建失败，降级到全屏提醒
              _logger.warning('System alarm creation failed, fallback to fullscreen');
              await scheduleTaskReminder(task, fullScreen: true);
            }
          } catch (e, stackTrace) {
            _logger.error('Failed to schedule system alarm', e, stackTrace);
            // 降级到全屏提醒
            await scheduleTaskReminder(task, fullScreen: true);
          }
        } else {
          // 没有SystemAlarmService,降级到全屏提醒
          _logger.warning('SystemAlarmService not available, fallback to fullscreen');
          await scheduleTaskReminder(task, fullScreen: true);
        }
        break;
    }
  }

  Future<void> scheduleTaskReminder(Task task, {bool fullScreen = false}) async {
    if (!_enabled) {
      return;
    }
    final remindAt = task.remindAt;
    if (remindAt == null) {
      return;
    }
    if (remindAt.isBefore(_clock.now())) {
      _logger.warning('Skipping reminder in the past', task.id);
      return;
    }

    final scheduledDate = tz.TZDateTime.from(remindAt, tz.local);

    // 构建详细的通知内容
    final notificationTitle = '任务提醒';
    final notificationBody = _buildNotificationBody(task);

    final android = AndroidNotificationDetails(
      fullScreen ? 'tasks_fullscreen' : 'tasks',
      fullScreen ? '重要任务提醒' : '任务提醒',
      channelDescription: fullScreen ? '重要任务全屏提醒通知' : '任务定时提醒通知',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: fullScreen, // 🔥 全屏显示
      category: fullScreen ? AndroidNotificationCategory.alarm : null,
      styleInformation: BigTextStyleInformation(
        notificationBody,
        contentTitle: notificationTitle,
        summaryText: _getPriorityText(task.priority),
      ),
      sound: fullScreen ? const RawResourceAndroidNotificationSound('notification') : null,
      enableVibration: true,
      playSound: true,
    );
    const ios = DarwinNotificationDetails();

    await _plugin.zonedSchedule(
      _taskNotificationId(task.id),
      notificationTitle,
      notificationBody,
      scheduledDate,
      NotificationDetails(android: android, iOS: ios),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: task.id,
    );
    _logger.info('Reminder scheduled', {
      'taskId': task.id,
      'when': scheduledDate.toIso8601String(),
      'fullScreen': fullScreen,
    });
  }

  String _buildNotificationBody(Task task) {
    final parts = <String>[];

    // 任务标题
    parts.add('📋 ${task.title}');

    // 截止时间
    if (task.dueAt != null) {
      final dueDate = task.dueAt!;
      final now = _clock.now();
      final diff = dueDate.difference(now);

      String timeText;
      if (diff.inDays > 0) {
        timeText = '${diff.inDays}天后到期';
      } else if (diff.inHours > 0) {
        timeText = '${diff.inHours}小时后到期';
      } else if (diff.inMinutes > 0) {
        timeText = '${diff.inMinutes}分钟后到期';
      } else if (diff.inMinutes < 0) {
        timeText = '已过期';
      } else {
        timeText = '即将到期';
      }

      parts.add('⏰ $timeText (${dueDate.month}/${dueDate.day} ${dueDate.hour.toString().padLeft(2, '0')}:${dueDate.minute.toString().padLeft(2, '0')})');
    }

    // 备注
    if (task.notes != null && task.notes!.isNotEmpty) {
      final notes = task.notes!.length > 50
          ? '${task.notes!.substring(0, 50)}...'
          : task.notes!;
      parts.add('📝 $notes');
    }

    // 子任务数量
    if (task.subtasks.isNotEmpty) {
      final completed = task.subtasks.where((s) => s.isCompleted).length;
      parts.add('✅ 子任务: $completed/${task.subtasks.length}');
    }

    return parts.join('\n');
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.critical:
        return '🔴 紧急重要';
      case TaskPriority.high:
        return '🟠 重要';
      case TaskPriority.medium:
        return '🟡 一般';
      case TaskPriority.low:
        return '🟢 低';
      case TaskPriority.none:
        return '';
    }
  }

  Future<void> cancelTaskReminder(String taskId) async {
    if (!_enabled) {
      return;
    }
    await _plugin.cancel(_taskNotificationId(taskId));
    _logger.info('Reminder cancelled', taskId);
  }

  /// Schedule a generic notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_enabled) {
      return;
    }
    if (scheduledDate.isBefore(_clock.now())) {
      _logger.warning('Skipping notification in the past', id);
      return;
    }

    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
    final l10n = _localizations;

    final android = AndroidNotificationDetails(
      'smart_reminders',
      l10n?.notificationChannelName ?? 'Smart reminders',
      channelDescription:
          l10n?.notificationChannelDescription ?? 'Smart reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      NotificationDetails(android: android, iOS: ios),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: payload,
    );
    _logger.info('Notification scheduled', {
      'id': id,
      'when': tzScheduledDate.toIso8601String(),
    });
  }

  /// Cancel a notification by ID
  Future<void> cancelNotification(int id) async {
    if (!_enabled) {
      return;
    }
    await _plugin.cancel(id);
    _logger.info('Notification cancelled', id);
  }

  /// Show an immediate notification (not scheduled)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool playSound = true,
    bool enableVibration = true,
    NotificationPriority priority = NotificationPriority.high,
  }) async {
    if (!_enabled) {
      return;
    }

    final l10n = _localizations;

    final android = AndroidNotificationDetails(
      'focus_timer',
      l10n?.notificationChannelName ?? 'Focus Timer',
      channelDescription:
          l10n?.notificationChannelDescription ?? 'Focus session notifications',
      importance: _mapPriority(priority),
      priority: priority == NotificationPriority.high ? Priority.high : Priority.defaultPriority,
      playSound: playSound,
      enableVibration: enableVibration,
      // 使用系统默认通知音（不指定sound参数即为默认）
    );

    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(android: android, iOS: ios),
      payload: payload,
    );

    _logger.info('Immediate notification shown', {
      'id': id,
      'title': title,
    });
  }

  Importance _mapPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.high:
        return Importance.max;
      case NotificationPriority.low:
        return Importance.low;
    }
  }
}

enum NotificationPriority {
  high,
  low,
}

int _taskNotificationId(String id) => id.hashCode & 0x7fffffff;

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError('NotificationService must be overridden');
});






