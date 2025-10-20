import 'package:todolist/src/infrastructure/notifications/notification_service.dart';

class FocusNotificationService {
  FocusNotificationService(this._notificationService);

  final NotificationService _notificationService;

  // Notification IDs
  static const _completionNotificationId = 9999;
  static const _startNotificationId = 9998;
  static const _breakNotificationId = 9997;

  /// Show notification when focus session starts
  Future<void> showStartNotification({
    required int durationMinutes,
    String? taskTitle,
  }) async {
    const title = '专注模式已开始 🎯';
    final body = taskTitle != null
        ? '开始专注于: $taskTitle\n时长: $durationMinutes 分钟'
        : '开始专注 $durationMinutes 分钟';

    await _notificationService.showNotification(
      id: _startNotificationId,
      title: title,
      body: body,
      playSound: true,
      enableVibration: true,
      priority: NotificationPriority.high,
    );
  }

  /// Show notification when focus session is completed
  Future<void> showCompletionNotification({
    required int durationMinutes,
    String? taskTitle,
  }) async {
    const title = '专注完成! 🎉';
    final body = taskTitle != null
        ? '完成了 $durationMinutes 分钟专注\n任务: $taskTitle'
        : '完成了 $durationMinutes 分钟专注';

    await _notificationService.showNotification(
      id: _completionNotificationId,
      title: title,
      body: body,
      playSound: true,
      enableVibration: true,
      priority: NotificationPriority.high,
    );
  }

  /// Show notification for break reminder
  Future<void> showBreakNotification({
    required int breakMinutes,
  }) async {
    const title = '该休息啦! ☕';
    final body = '你已经专注了很久,建议休息 $breakMinutes 分钟';

    await _notificationService.showNotification(
      id: _breakNotificationId,
      title: title,
      body: body,
      playSound: true,
      enableVibration: false,
      priority: NotificationPriority.low,
    );
  }

  /// Show notification when session is paused
  Future<void> showPauseNotification() async {
    const title = '专注已暂停 ⏸️';
    const body = '记得尽快回来继续专注哦';

    await _notificationService.showNotification(
      id: _startNotificationId,
      title: title,
      body: body,
      playSound: false,
      enableVibration: false,
      priority: NotificationPriority.low,
    );
  }

  /// Show notification when session is resumed
  Future<void> showResumeNotification() async {
    const title = '继续专注 ▶️';
    const body = '专注模式已恢复';

    await _notificationService.showNotification(
      id: _startNotificationId,
      title: title,
      body: body,
      playSound: false,
      enableVibration: true,
      priority: NotificationPriority.low,
    );
  }

  /// Cancel all focus-related notifications
  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelNotification(_completionNotificationId);
    await _notificationService.cancelNotification(_startNotificationId);
    await _notificationService.cancelNotification(_breakNotificationId);
  }
}
