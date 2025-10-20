import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import '../../infrastructure/hive/type_ids.dart';

part 'smart_reminder.freezed.dart';
part 'smart_reminder.g.dart';

/// Type of smart reminder
@HiveType(typeId: HiveTypeIds.reminderType, adapterName: 'ReminderTypeAdapter')
enum ReminderType {
  @HiveField(0)
  time, // Standard time-based reminder
  @HiveField(1)
  location, // Location-based reminder
  @HiveField(2)
  repeating, // Repeating reminder
}

/// Location trigger for reminder
@HiveType(typeId: HiveTypeIds.locationTrigger, adapterName: 'LocationTriggerAdapter')
@freezed
class LocationTrigger with _$LocationTrigger {
  const factory LocationTrigger({
    @HiveField(0) required double latitude,
    @HiveField(1) required double longitude,
    @HiveField(2) required double radiusMeters,
    @HiveField(3) required String placeName,
    @HiveField(4) String? placeAddress,
  }) = _LocationTrigger;

  const LocationTrigger._();

  factory LocationTrigger.fromJson(Map<String, dynamic> json) =>
      _$LocationTriggerFromJson(json);
}

/// Repeat configuration for reminders
@HiveType(typeId: HiveTypeIds.repeatConfig, adapterName: 'RepeatConfigAdapter')
@freezed
class RepeatConfig with _$RepeatConfig {
  const factory RepeatConfig({
    @HiveField(0) required int intervalMinutes,
    @HiveField(1) required int maxRepeats,
    @HiveField(2) @Default(0) int currentCount,
  }) = _RepeatConfig;

  const RepeatConfig._();

  factory RepeatConfig.fromJson(Map<String, dynamic> json) =>
      _$RepeatConfigFromJson(json);
}

/// Smart reminder configuration
@HiveType(typeId: HiveTypeIds.smartReminder, adapterName: 'SmartReminderAdapter')
@freezed
class SmartReminder with _$SmartReminder {
  const factory SmartReminder({
    @HiveField(0) required String id,
    @HiveField(1) required String taskId,
    @HiveField(2) required ReminderType type,
    @HiveField(6) required DateTime createdAt, @HiveField(3) DateTime? scheduledAt,
    @HiveField(4) LocationTrigger? locationTrigger,
    @HiveField(5) RepeatConfig? repeatConfig,
    @HiveField(7) DateTime? lastTriggeredAt,
    @HiveField(8) @Default(true) bool isActive,
  }) = _SmartReminder;

  const SmartReminder._();

  factory SmartReminder.fromJson(Map<String, dynamic> json) =>
      _$SmartReminderFromJson(json);
}

/// Reminder history entry
@HiveType(typeId: HiveTypeIds.reminderHistory, adapterName: 'ReminderHistoryAdapter')
@freezed
class ReminderHistory with _$ReminderHistory {
  const factory ReminderHistory({
    @HiveField(0) required String id,
    @HiveField(1) required String reminderId,
    @HiveField(2) required String taskId,
    @HiveField(3) required String taskTitle,
    @HiveField(4) required DateTime triggeredAt,
    @HiveField(5) required ReminderType type,
    @HiveField(6) String? locationName,
    @HiveField(7) @Default(false) bool wasCompleted,
    @HiveField(8) @Default(false) bool wasDismissed,
  }) = _ReminderHistory;

  const ReminderHistory._();

  factory ReminderHistory.fromJson(Map<String, dynamic> json) =>
      _$ReminderHistoryFromJson(json);
}
