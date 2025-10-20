// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      listId: fields[3] as String,
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
      notes: fields[2] as String?,
      tagIds: (fields[4] as List).cast<String>(),
      priority: fields[5] as TaskPriority,
      status: fields[6] as TaskStatus,
      dueAt: fields[7] as DateTime?,
      remindAt: fields[8] as DateTime?,
      subtasks: (fields[9] as List).cast<SubTask>(),
      attachments: (fields[10] as List).cast<Attachment>(),
      completedAt: fields[11] as DateTime?,
      version: fields[14] as int,
      recurrenceRule: fields[15] as RecurrenceRule?,
      parentRecurringTaskId: fields[16] as String?,
      recurrenceCount: fields[17] as int,
      sortOrder: fields[18] as int,
      estimatedMinutes: fields[19] as int?,
      actualMinutes: fields[20] as int,
      focusSessionCount: fields[21] as int,
      smartReminderIds: (fields[22] as List).cast<String>(),
      reminderMode: fields[23] as ReminderMode,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.listId)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.tagIds)
      ..writeByte(5)
      ..write(obj.priority)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.dueAt)
      ..writeByte(8)
      ..write(obj.remindAt)
      ..writeByte(9)
      ..write(obj.subtasks)
      ..writeByte(10)
      ..write(obj.attachments)
      ..writeByte(11)
      ..write(obj.completedAt)
      ..writeByte(14)
      ..write(obj.version)
      ..writeByte(15)
      ..write(obj.recurrenceRule)
      ..writeByte(16)
      ..write(obj.parentRecurringTaskId)
      ..writeByte(17)
      ..write(obj.recurrenceCount)
      ..writeByte(18)
      ..write(obj.sortOrder)
      ..writeByte(19)
      ..write(obj.estimatedMinutes)
      ..writeByte(20)
      ..write(obj.actualMinutes)
      ..writeByte(21)
      ..write(obj.focusSessionCount)
      ..writeByte(22)
      ..write(obj.smartReminderIds)
      ..writeByte(23)
      ..write(obj.reminderMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final int typeId = 4;

  @override
  TaskPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskPriority.none;
      case 1:
        return TaskPriority.low;
      case 2:
        return TaskPriority.medium;
      case 3:
        return TaskPriority.high;
      case 4:
        return TaskPriority.critical;
      default:
        return TaskPriority.none;
    }
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    switch (obj) {
      case TaskPriority.none:
        writer.writeByte(0);
        break;
      case TaskPriority.low:
        writer.writeByte(1);
        break;
      case TaskPriority.medium:
        writer.writeByte(2);
        break;
      case TaskPriority.high:
        writer.writeByte(3);
        break;
      case TaskPriority.critical:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final int typeId = 5;

  @override
  TaskStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskStatus.pending;
      case 1:
        return TaskStatus.inProgress;
      case 2:
        return TaskStatus.completed;
      case 3:
        return TaskStatus.cancelled;
      case 4:
        return TaskStatus.archived;
      default:
        return TaskStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    switch (obj) {
      case TaskStatus.pending:
        writer.writeByte(0);
        break;
      case TaskStatus.inProgress:
        writer.writeByte(1);
        break;
      case TaskStatus.completed:
        writer.writeByte(2);
        break;
      case TaskStatus.cancelled:
        writer.writeByte(3);
        break;
      case TaskStatus.archived:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      listId: json['listId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      notes: json['notes'] as String?,
      tagIds: (json['tagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
          TaskPriority.none,
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
          TaskStatus.pending,
      dueAt: json['dueAt'] == null
          ? null
          : DateTime.parse(json['dueAt'] as String),
      remindAt: json['remindAt'] == null
          ? null
          : DateTime.parse(json['remindAt'] as String),
      subtasks: json['subtasks'] == null
          ? const <SubTask>[]
          : _subTasksFromJson(json['subtasks'] as List?),
      attachments: json['attachments'] == null
          ? const <Attachment>[]
          : _attachmentsFromJson(json['attachments'] as List?),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      version: (json['version'] as num?)?.toInt() ?? 0,
      recurrenceRule: _recurrenceRuleFromJson(
          json['recurrenceRule'] as Map<String, dynamic>?),
      parentRecurringTaskId: json['parentRecurringTaskId'] as String?,
      recurrenceCount: (json['recurrenceCount'] as num?)?.toInt() ?? 0,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
      actualMinutes: (json['actualMinutes'] as num?)?.toInt() ?? 0,
      focusSessionCount: (json['focusSessionCount'] as num?)?.toInt() ?? 0,
      smartReminderIds: (json['smartReminderIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      reminderMode:
          $enumDecodeNullable(_$ReminderModeEnumMap, json['reminderMode']) ??
              ReminderMode.notification,
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'listId': instance.listId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'notes': instance.notes,
      'tagIds': instance.tagIds,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'dueAt': instance.dueAt?.toIso8601String(),
      'remindAt': instance.remindAt?.toIso8601String(),
      'subtasks': _subTasksToJson(instance.subtasks),
      'attachments': _attachmentsToJson(instance.attachments),
      'completedAt': instance.completedAt?.toIso8601String(),
      'version': instance.version,
      'recurrenceRule': _recurrenceRuleToJson(instance.recurrenceRule),
      'parentRecurringTaskId': instance.parentRecurringTaskId,
      'recurrenceCount': instance.recurrenceCount,
      'sortOrder': instance.sortOrder,
      'estimatedMinutes': instance.estimatedMinutes,
      'actualMinutes': instance.actualMinutes,
      'focusSessionCount': instance.focusSessionCount,
      'smartReminderIds': instance.smartReminderIds,
      'reminderMode': _$ReminderModeEnumMap[instance.reminderMode]!,
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.none: 'none',
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
  TaskPriority.critical: 'critical',
};

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.completed: 'completed',
  TaskStatus.cancelled: 'cancelled',
  TaskStatus.archived: 'archived',
};

const _$ReminderModeEnumMap = {
  ReminderMode.notification: 'notification',
  ReminderMode.fullScreen: 'fullScreen',
  ReminderMode.systemAlarm: 'systemAlarm',
};
