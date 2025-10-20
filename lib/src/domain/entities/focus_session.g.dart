// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InterruptionAdapter extends TypeAdapter<Interruption> {
  @override
  final int typeId = 71;

  @override
  Interruption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Interruption(
      timestamp: fields[0] as DateTime,
      reason: fields[1] as String,
      resumedAfterSeconds: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Interruption obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.reason)
      ..writeByte(2)
      ..write(obj.resumedAfterSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterruptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FocusSessionAdapter extends TypeAdapter<FocusSession> {
  @override
  final int typeId = 70;

  @override
  FocusSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FocusSession(
      id: fields[0] as String,
      durationMinutes: fields[2] as int,
      startedAt: fields[3] as DateTime,
      taskId: fields[1] as String?,
      completedAt: fields[4] as DateTime?,
      isCompleted: fields[5] as bool,
      wasCancelled: fields[6] as bool,
      notes: fields[7] as String?,
      interruptions: (fields[8] as List).cast<Interruption>(),
      pausedSeconds: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FocusSession obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.durationMinutes)
      ..writeByte(3)
      ..write(obj.startedAt)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(4)
      ..write(obj.completedAt)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.wasCancelled)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.interruptions)
      ..writeByte(9)
      ..write(obj.pausedSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InterruptionImpl _$$InterruptionImplFromJson(Map<String, dynamic> json) =>
    _$InterruptionImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      reason: json['reason'] as String,
      resumedAfterSeconds: (json['resumedAfterSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$InterruptionImplToJson(_$InterruptionImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'reason': instance.reason,
      'resumedAfterSeconds': instance.resumedAfterSeconds,
    };

_$FocusSessionImpl _$$FocusSessionImplFromJson(Map<String, dynamic> json) =>
    _$FocusSessionImpl(
      id: json['id'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      startedAt: DateTime.parse(json['startedAt'] as String),
      taskId: json['taskId'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      wasCancelled: json['wasCancelled'] as bool? ?? false,
      notes: json['notes'] as String?,
      interruptions: json['interruptions'] == null
          ? const <Interruption>[]
          : _interruptionsFromJson(json['interruptions'] as List?),
      pausedSeconds: (json['pausedSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$FocusSessionImplToJson(_$FocusSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'durationMinutes': instance.durationMinutes,
      'startedAt': instance.startedAt.toIso8601String(),
      'taskId': instance.taskId,
      'completedAt': instance.completedAt?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'wasCancelled': instance.wasCancelled,
      'notes': instance.notes,
      'interruptions': _interruptionsToJson(instance.interruptions),
      'pausedSeconds': instance.pausedSeconds,
    };
