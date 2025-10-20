// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationTriggerAdapter extends TypeAdapter<LocationTrigger> {
  @override
  final int typeId = 65;

  @override
  LocationTrigger read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationTrigger(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      radiusMeters: fields[2] as double,
      placeName: fields[3] as String,
      placeAddress: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LocationTrigger obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.radiusMeters)
      ..writeByte(3)
      ..write(obj.placeName)
      ..writeByte(4)
      ..write(obj.placeAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationTriggerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RepeatConfigAdapter extends TypeAdapter<RepeatConfig> {
  @override
  final int typeId = 66;

  @override
  RepeatConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepeatConfig(
      intervalMinutes: fields[0] as int,
      maxRepeats: fields[1] as int,
      currentCount: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RepeatConfig obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.intervalMinutes)
      ..writeByte(1)
      ..write(obj.maxRepeats)
      ..writeByte(2)
      ..write(obj.currentCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepeatConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SmartReminderAdapter extends TypeAdapter<SmartReminder> {
  @override
  final int typeId = 67;

  @override
  SmartReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmartReminder(
      id: fields[0] as String,
      taskId: fields[1] as String,
      type: fields[2] as ReminderType,
      createdAt: fields[6] as DateTime,
      scheduledAt: fields[3] as DateTime?,
      locationTrigger: fields[4] as LocationTrigger?,
      repeatConfig: fields[5] as RepeatConfig?,
      lastTriggeredAt: fields[7] as DateTime?,
      isActive: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SmartReminder obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.scheduledAt)
      ..writeByte(4)
      ..write(obj.locationTrigger)
      ..writeByte(5)
      ..write(obj.repeatConfig)
      ..writeByte(7)
      ..write(obj.lastTriggeredAt)
      ..writeByte(8)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderHistoryAdapter extends TypeAdapter<ReminderHistory> {
  @override
  final int typeId = 68;

  @override
  ReminderHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderHistory(
      id: fields[0] as String,
      reminderId: fields[1] as String,
      taskId: fields[2] as String,
      taskTitle: fields[3] as String,
      triggeredAt: fields[4] as DateTime,
      type: fields[5] as ReminderType,
      locationName: fields[6] as String?,
      wasCompleted: fields[7] as bool,
      wasDismissed: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderHistory obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.reminderId)
      ..writeByte(2)
      ..write(obj.taskId)
      ..writeByte(3)
      ..write(obj.taskTitle)
      ..writeByte(4)
      ..write(obj.triggeredAt)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.locationName)
      ..writeByte(7)
      ..write(obj.wasCompleted)
      ..writeByte(8)
      ..write(obj.wasDismissed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderTypeAdapter extends TypeAdapter<ReminderType> {
  @override
  final int typeId = 64;

  @override
  ReminderType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReminderType.time;
      case 1:
        return ReminderType.location;
      case 2:
        return ReminderType.repeating;
      default:
        return ReminderType.time;
    }
  }

  @override
  void write(BinaryWriter writer, ReminderType obj) {
    switch (obj) {
      case ReminderType.time:
        writer.writeByte(0);
        break;
      case ReminderType.location:
        writer.writeByte(1);
        break;
      case ReminderType.repeating:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationTriggerImpl _$$LocationTriggerImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationTriggerImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusMeters: (json['radiusMeters'] as num).toDouble(),
      placeName: json['placeName'] as String,
      placeAddress: json['placeAddress'] as String?,
    );

Map<String, dynamic> _$$LocationTriggerImplToJson(
        _$LocationTriggerImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radiusMeters': instance.radiusMeters,
      'placeName': instance.placeName,
      'placeAddress': instance.placeAddress,
    };

_$RepeatConfigImpl _$$RepeatConfigImplFromJson(Map<String, dynamic> json) =>
    _$RepeatConfigImpl(
      intervalMinutes: (json['intervalMinutes'] as num).toInt(),
      maxRepeats: (json['maxRepeats'] as num).toInt(),
      currentCount: (json['currentCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$RepeatConfigImplToJson(_$RepeatConfigImpl instance) =>
    <String, dynamic>{
      'intervalMinutes': instance.intervalMinutes,
      'maxRepeats': instance.maxRepeats,
      'currentCount': instance.currentCount,
    };

_$SmartReminderImpl _$$SmartReminderImplFromJson(Map<String, dynamic> json) =>
    _$SmartReminderImpl(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      type: $enumDecode(_$ReminderTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      locationTrigger: json['locationTrigger'] == null
          ? null
          : LocationTrigger.fromJson(
              json['locationTrigger'] as Map<String, dynamic>),
      repeatConfig: json['repeatConfig'] == null
          ? null
          : RepeatConfig.fromJson(json['repeatConfig'] as Map<String, dynamic>),
      lastTriggeredAt: json['lastTriggeredAt'] == null
          ? null
          : DateTime.parse(json['lastTriggeredAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$SmartReminderImplToJson(_$SmartReminderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'type': _$ReminderTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'locationTrigger': instance.locationTrigger,
      'repeatConfig': instance.repeatConfig,
      'lastTriggeredAt': instance.lastTriggeredAt?.toIso8601String(),
      'isActive': instance.isActive,
    };

const _$ReminderTypeEnumMap = {
  ReminderType.time: 'time',
  ReminderType.location: 'location',
  ReminderType.repeating: 'repeating',
};

_$ReminderHistoryImpl _$$ReminderHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ReminderHistoryImpl(
      id: json['id'] as String,
      reminderId: json['reminderId'] as String,
      taskId: json['taskId'] as String,
      taskTitle: json['taskTitle'] as String,
      triggeredAt: DateTime.parse(json['triggeredAt'] as String),
      type: $enumDecode(_$ReminderTypeEnumMap, json['type']),
      locationName: json['locationName'] as String?,
      wasCompleted: json['wasCompleted'] as bool? ?? false,
      wasDismissed: json['wasDismissed'] as bool? ?? false,
    );

Map<String, dynamic> _$$ReminderHistoryImplToJson(
        _$ReminderHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reminderId': instance.reminderId,
      'taskId': instance.taskId,
      'taskTitle': instance.taskTitle,
      'triggeredAt': instance.triggeredAt.toIso8601String(),
      'type': _$ReminderTypeEnumMap[instance.type]!,
      'locationName': instance.locationName,
      'wasCompleted': instance.wasCompleted,
      'wasDismissed': instance.wasDismissed,
    };
