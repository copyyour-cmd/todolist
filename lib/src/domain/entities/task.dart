import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/domain/entities/attachment.dart';
import 'package:todolist/src/domain/entities/recurrence_rule.dart';
import 'package:todolist/src/domain/entities/sub_task.dart';
import 'package:todolist/src/features/reminders/domain/reminder_mode.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@HiveType(typeId: 0, adapterName: 'TaskAdapter')
@freezed
class Task with _$Task {
  const factory Task({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(3) required String listId,
    @HiveField(12) required DateTime createdAt,
    @HiveField(13) required DateTime updatedAt,
    @HiveField(2) String? notes,
    @HiveField(4) @Default(<String>[]) List<String> tagIds,
    @HiveField(5) @Default(TaskPriority.none) TaskPriority priority,
    @HiveField(6) @Default(TaskStatus.pending) TaskStatus status,
    @HiveField(7) DateTime? dueAt,
    @HiveField(8) DateTime? remindAt,
    @HiveField(9)
    @JsonKey(fromJson: _subTasksFromJson, toJson: _subTasksToJson)
    @Default(<SubTask>[]) List<SubTask> subtasks,
    @HiveField(10)
    @JsonKey(fromJson: _attachmentsFromJson, toJson: _attachmentsToJson)
    @Default(<Attachment>[]) List<Attachment> attachments,
    @HiveField(11) DateTime? completedAt,
    @HiveField(14) @Default(0) int version,
    @HiveField(15)
    @JsonKey(fromJson: _recurrenceRuleFromJson, toJson: _recurrenceRuleToJson)
    RecurrenceRule? recurrenceRule,
    @HiveField(16) String? parentRecurringTaskId,
    @HiveField(17) @Default(0) int recurrenceCount,
    @HiveField(18) @Default(0) int sortOrder,
    @HiveField(19) int? estimatedMinutes,
    @HiveField(20) @Default(0) int actualMinutes,
    @HiveField(21) @Default(0) int focusSessionCount,
    @HiveField(22) @Default(<String>[]) List<String> smartReminderIds,
    @HiveField(23) @Default(ReminderMode.notification) ReminderMode reminderMode,
  }) = _Task;

  const Task._();

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  bool get isCompleted => status == TaskStatus.completed;
  bool get isRecurring => recurrenceRule != null;
  bool get hasSmartReminders => smartReminderIds.isNotEmpty;

  /// Get time estimation accuracy (0-1, where 1 is perfect)
  double get estimationAccuracy {
    if (estimatedMinutes == null || estimatedMinutes == 0 || actualMinutes == 0) {
      return 0;
    }
    final ratio = actualMinutes / estimatedMinutes!;
    // Perfect if within 20% of estimate
    if (ratio >= 0.8 && ratio <= 1.2) return 1;
    // Degrade based on how far off
    return 1.0 - (ratio - 1.0).abs().clamp(0.0, 1.0);
  }

  /// Suggested pomodoros based on estimate (25 min each)
  int get suggestedPomodoros {
    if (estimatedMinutes == null || estimatedMinutes == 0) return 1;
    return (estimatedMinutes! / 25).ceil();
  }
}

RecurrenceRule? _recurrenceRuleFromJson(Map<String, dynamic>? json) {
  if (json == null) return null;
  return RecurrenceRule.fromJson(json);
}

Map<String, dynamic>? _recurrenceRuleToJson(RecurrenceRule? rule) {
  return rule?.toJson();
}

List<Attachment> _attachmentsFromJson(List<dynamic>? json) {
  if (json == null) return [];
  return json.map((e) => Attachment.fromJson(e as Map<String, dynamic>)).toList();
}

List<Map<String, dynamic>> _attachmentsToJson(List<Attachment> attachments) {
  return attachments.map((e) => e.toJson()).toList();
}

@HiveType(typeId: 4, adapterName: 'TaskPriorityAdapter')
@JsonEnum()
enum TaskPriority {
  @HiveField(0)
  none,
  @HiveField(1)
  low,
  @HiveField(2)
  medium,
  @HiveField(3)
  high,
  @HiveField(4)
  critical,
}

@HiveType(typeId: 5, adapterName: 'TaskStatusAdapter')
@JsonEnum()
enum TaskStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  completed,
  @HiveField(3)
  cancelled,
  @HiveField(4)
  archived,
}

List<SubTask> _subTasksFromJson(List<dynamic>? value) {
  if (value == null) {
    return const <SubTask>[];
  }
  return value
      .map((item) => SubTask.fromJson(item as Map<String, dynamic>))
      .toList();
}

List<Map<String, dynamic>> _subTasksToJson(List<SubTask> value) {
  return value.map((item) => item.toJson()).toList();
}
