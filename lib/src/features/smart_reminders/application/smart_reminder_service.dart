import 'package:hive/hive.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/smart_reminder.dart';
import 'package:todolist/src/features/smart_reminders/application/location_reminder_service.dart';
import 'package:todolist/src/features/smart_reminders/application/natural_language_parser.dart';
import 'package:todolist/src/infrastructure/notifications/notification_service.dart';

/// Service for managing smart reminders
class SmartReminderService {
  SmartReminderService({
    required Clock clock,
    required IdGenerator idGenerator,
    required NotificationService notificationService,
    required LocationReminderService locationService,
  })  : _clock = clock,
        _idGenerator = idGenerator,
        _notificationService = notificationService,
        _locationService = locationService,
        _nlpParser = NaturalLanguageParser(clock);

  final Clock _clock;
  final IdGenerator _idGenerator;
  final NotificationService _notificationService;
  final LocationReminderService _locationService;
  final NaturalLanguageParser _nlpParser;

  Box<SmartReminder> get _remindersBox => Hive.box<SmartReminder>('smart_reminders');
  Box<ReminderHistory> get _historyBox => Hive.box<ReminderHistory>('reminder_history');

  /// Parse natural language and create a time-based reminder
  Future<SmartReminder?> createFromNaturalLanguage({
    required String taskId,
    required String input,
  }) async {
    final parsed = _nlpParser.parse(input);
    if (parsed == null) return null;

    final reminder = SmartReminder(
      id: _idGenerator.generate(),
      taskId: taskId,
      type: ReminderType.time,
      scheduledAt: parsed.dateTime,
      createdAt: _clock.now(),
      isActive: true,
    );

    await _remindersBox.put(reminder.id, reminder);
    await _scheduleNotification(reminder);

    return reminder;
  }

  /// Create a location-based reminder
  Future<SmartReminder> createLocationReminder({
    required String taskId,
    required LocationTrigger location,
  }) async {
    final reminder = SmartReminder(
      id: _idGenerator.generate(),
      taskId: taskId,
      type: ReminderType.location,
      locationTrigger: location,
      createdAt: _clock.now(),
      isActive: true,
    );

    await _remindersBox.put(reminder.id, reminder);
    await _refreshLocationMonitoring();

    return reminder;
  }

  /// Create a repeating reminder
  Future<SmartReminder> createRepeatingReminder({
    required String taskId,
    required DateTime firstScheduledAt,
    required int intervalMinutes,
    required int maxRepeats,
  }) async {
    final reminder = SmartReminder(
      id: _idGenerator.generate(),
      taskId: taskId,
      type: ReminderType.repeating,
      scheduledAt: firstScheduledAt,
      repeatConfig: RepeatConfig(
        intervalMinutes: intervalMinutes,
        maxRepeats: maxRepeats,
        currentCount: 0,
      ),
      createdAt: _clock.now(),
      isActive: true,
    );

    await _remindersBox.put(reminder.id, reminder);
    await _scheduleNotification(reminder);

    return reminder;
  }

  /// Get all reminders for a task
  Future<List<SmartReminder>> getTaskReminders(String taskId) async {
    return _remindersBox.values.where((r) => r.taskId == taskId).toList();
  }

  /// Get all active reminders
  Future<List<SmartReminder>> getActiveReminders() async {
    return _remindersBox.values.where((r) => r.isActive).toList();
  }

  /// Trigger a reminder (called by notification or location service)
  Future<void> triggerReminder(SmartReminder reminder, String taskTitle) async {
    final now = _clock.now();

    // Record history
    final history = ReminderHistory(
      id: _idGenerator.generate(),
      reminderId: reminder.id,
      taskId: reminder.taskId,
      taskTitle: taskTitle,
      triggeredAt: now,
      type: reminder.type,
      locationName: reminder.locationTrigger?.placeName,
    );
    await _historyBox.add(history);

    // Update reminder
    final updated = reminder.copyWith(lastTriggeredAt: now);

    // Handle repeating reminders
    if (reminder.type == ReminderType.repeating && reminder.repeatConfig != null) {
      final config = reminder.repeatConfig!;
      final newCount = config.currentCount + 1;

      if (newCount < config.maxRepeats) {
        // Schedule next repeat
        final nextTime = now.add(Duration(minutes: config.intervalMinutes));
        final nextReminder = updated.copyWith(
          scheduledAt: nextTime,
          repeatConfig: config.copyWith(currentCount: newCount),
        );
        await _remindersBox.put(reminder.id, nextReminder);
        await _scheduleNotification(nextReminder);
      } else {
        // Max repeats reached, deactivate
        final deactivated = updated.copyWith(isActive: false);
        await _remindersBox.put(reminder.id, deactivated);
      }
    } else {
      // One-time reminder, deactivate after triggering
      final deactivated = updated.copyWith(isActive: false);
      await _remindersBox.put(reminder.id, deactivated);
    }
  }

  /// Delete a reminder
  Future<void> deleteReminder(String reminderId) async {
    await _remindersBox.delete(reminderId);
    await _notificationService.cancelNotification(reminderId.hashCode);
    await _refreshLocationMonitoring();
  }

  /// Get reminder history
  Future<List<ReminderHistory>> getHistory({int? limit}) async {
    var history = _historyBox.values.toList()
      ..sort((a, b) => b.triggeredAt.compareTo(a.triggeredAt));

    if (limit != null && history.length > limit) {
      history = history.take(limit).toList();
    }

    return history;
  }

  /// Mark history entry as completed
  Future<void> markHistoryCompleted(String historyId) async {
    final history = _historyBox.values.firstWhere((h) => h.id == historyId);
    final updated = history.copyWith(wasCompleted: true);
    final key = _historyBox.keys.firstWhere(
      (k) => (_historyBox.get(k)!).id == historyId,
    );
    await _historyBox.put(key, updated);
  }

  /// Mark history entry as dismissed
  Future<void> markHistoryDismissed(String historyId) async {
    final history = _historyBox.values.firstWhere((h) => h.id == historyId);
    final updated = history.copyWith(wasDismissed: true);
    final key = _historyBox.keys.firstWhere(
      (k) => (_historyBox.get(k)!).id == historyId,
    );
    await _historyBox.put(key, updated);
  }

  // Private helper methods

  Future<void> _scheduleNotification(SmartReminder reminder) async {
    if (reminder.scheduledAt == null) return;

    await _notificationService.scheduleNotification(
      id: reminder.id.hashCode,
      title: 'Task Reminder',
      body: 'Time to work on your task',
      scheduledDate: reminder.scheduledAt!,
      payload: reminder.taskId,
    );
  }

  Future<void> _refreshLocationMonitoring() async {
    final activeReminders = await getActiveReminders();
    await _locationService.startMonitoring(activeReminders);
  }
}
