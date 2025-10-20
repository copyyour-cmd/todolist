// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'traffic_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrafficInfoAdapter extends TypeAdapter<TrafficInfo> {
  @override
  final int typeId = 75;

  @override
  TrafficInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrafficInfo(
      id: fields[0] as String,
      routeName: fields[1] as String,
      originLat: fields[2] as double,
      originLng: fields[3] as double,
      destLat: fields[4] as double,
      destLng: fields[5] as double,
      originAddress: fields[6] as String,
      destAddress: fields[7] as String,
      durationSeconds: fields[8] as int,
      durationInTrafficSeconds: fields[9] as int,
      distanceMeters: fields[10] as int,
      trafficCondition: fields[11] as TrafficCondition,
      fetchedAt: fields[12] as DateTime,
      validUntil: fields[13] as DateTime,
      polyline: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TrafficInfo obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.routeName)
      ..writeByte(2)
      ..write(obj.originLat)
      ..writeByte(3)
      ..write(obj.originLng)
      ..writeByte(4)
      ..write(obj.destLat)
      ..writeByte(5)
      ..write(obj.destLng)
      ..writeByte(6)
      ..write(obj.originAddress)
      ..writeByte(7)
      ..write(obj.destAddress)
      ..writeByte(8)
      ..write(obj.durationSeconds)
      ..writeByte(9)
      ..write(obj.durationInTrafficSeconds)
      ..writeByte(10)
      ..write(obj.distanceMeters)
      ..writeByte(11)
      ..write(obj.trafficCondition)
      ..writeByte(12)
      ..write(obj.fetchedAt)
      ..writeByte(13)
      ..write(obj.validUntil)
      ..writeByte(14)
      ..write(obj.polyline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrafficInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TravelTriggerAdapter extends TypeAdapter<TravelTrigger> {
  @override
  final int typeId = 77;

  @override
  TravelTrigger read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TravelTrigger(
      id: fields[0] as String,
      taskId: fields[1] as String,
      originLat: fields[2] as double,
      originLng: fields[3] as double,
      destLat: fields[4] as double,
      destLng: fields[5] as double,
      originAddress: fields[6] as String,
      destAddress: fields[7] as String,
      appointmentTime: fields[8] as DateTime,
      bufferMinutes: fields[9] as int,
      enabled: fields[10] as bool,
      createdAt: fields[11] as DateTime,
      lastCheckedAt: fields[12] as DateTime?,
      reminderScheduledFor: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TravelTrigger obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.originLat)
      ..writeByte(3)
      ..write(obj.originLng)
      ..writeByte(4)
      ..write(obj.destLat)
      ..writeByte(5)
      ..write(obj.destLng)
      ..writeByte(6)
      ..write(obj.originAddress)
      ..writeByte(7)
      ..write(obj.destAddress)
      ..writeByte(8)
      ..write(obj.appointmentTime)
      ..writeByte(9)
      ..write(obj.bufferMinutes)
      ..writeByte(10)
      ..write(obj.enabled)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.lastCheckedAt)
      ..writeByte(13)
      ..write(obj.reminderScheduledFor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelTriggerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TrafficConditionAdapter extends TypeAdapter<TrafficCondition> {
  @override
  final int typeId = 76;

  @override
  TrafficCondition read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TrafficCondition.unknown;
      case 1:
        return TrafficCondition.clear;
      case 2:
        return TrafficCondition.moderate;
      case 3:
        return TrafficCondition.heavy;
      case 4:
        return TrafficCondition.severe;
      default:
        return TrafficCondition.unknown;
    }
  }

  @override
  void write(BinaryWriter writer, TrafficCondition obj) {
    switch (obj) {
      case TrafficCondition.unknown:
        writer.writeByte(0);
        break;
      case TrafficCondition.clear:
        writer.writeByte(1);
        break;
      case TrafficCondition.moderate:
        writer.writeByte(2);
        break;
      case TrafficCondition.heavy:
        writer.writeByte(3);
        break;
      case TrafficCondition.severe:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrafficConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoutePreferenceAdapter extends TypeAdapter<RoutePreference> {
  @override
  final int typeId = 78;

  @override
  RoutePreference read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RoutePreference.fastest;
      case 1:
        return RoutePreference.shortest;
      case 2:
        return RoutePreference.avoidHighways;
      case 3:
        return RoutePreference.avoidTolls;
      default:
        return RoutePreference.fastest;
    }
  }

  @override
  void write(BinaryWriter writer, RoutePreference obj) {
    switch (obj) {
      case RoutePreference.fastest:
        writer.writeByte(0);
        break;
      case RoutePreference.shortest:
        writer.writeByte(1);
        break;
      case RoutePreference.avoidHighways:
        writer.writeByte(2);
        break;
      case RoutePreference.avoidTolls:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutePreferenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrafficInfoImpl _$$TrafficInfoImplFromJson(Map<String, dynamic> json) =>
    _$TrafficInfoImpl(
      id: json['id'] as String,
      routeName: json['routeName'] as String,
      originLat: (json['originLat'] as num).toDouble(),
      originLng: (json['originLng'] as num).toDouble(),
      destLat: (json['destLat'] as num).toDouble(),
      destLng: (json['destLng'] as num).toDouble(),
      originAddress: json['originAddress'] as String,
      destAddress: json['destAddress'] as String,
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      durationInTrafficSeconds:
          (json['durationInTrafficSeconds'] as num).toInt(),
      distanceMeters: (json['distanceMeters'] as num).toInt(),
      trafficCondition:
          $enumDecode(_$TrafficConditionEnumMap, json['trafficCondition']),
      fetchedAt: DateTime.parse(json['fetchedAt'] as String),
      validUntil: DateTime.parse(json['validUntil'] as String),
      polyline: json['polyline'] as String?,
    );

Map<String, dynamic> _$$TrafficInfoImplToJson(_$TrafficInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routeName': instance.routeName,
      'originLat': instance.originLat,
      'originLng': instance.originLng,
      'destLat': instance.destLat,
      'destLng': instance.destLng,
      'originAddress': instance.originAddress,
      'destAddress': instance.destAddress,
      'durationSeconds': instance.durationSeconds,
      'durationInTrafficSeconds': instance.durationInTrafficSeconds,
      'distanceMeters': instance.distanceMeters,
      'trafficCondition': _$TrafficConditionEnumMap[instance.trafficCondition]!,
      'fetchedAt': instance.fetchedAt.toIso8601String(),
      'validUntil': instance.validUntil.toIso8601String(),
      'polyline': instance.polyline,
    };

const _$TrafficConditionEnumMap = {
  TrafficCondition.unknown: 'unknown',
  TrafficCondition.clear: 'clear',
  TrafficCondition.moderate: 'moderate',
  TrafficCondition.heavy: 'heavy',
  TrafficCondition.severe: 'severe',
};

_$TravelTriggerImpl _$$TravelTriggerImplFromJson(Map<String, dynamic> json) =>
    _$TravelTriggerImpl(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      originLat: (json['originLat'] as num).toDouble(),
      originLng: (json['originLng'] as num).toDouble(),
      destLat: (json['destLat'] as num).toDouble(),
      destLng: (json['destLng'] as num).toDouble(),
      originAddress: json['originAddress'] as String,
      destAddress: json['destAddress'] as String,
      appointmentTime: DateTime.parse(json['appointmentTime'] as String),
      bufferMinutes: (json['bufferMinutes'] as num?)?.toInt() ?? 15,
      enabled: json['enabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastCheckedAt: json['lastCheckedAt'] == null
          ? null
          : DateTime.parse(json['lastCheckedAt'] as String),
      reminderScheduledFor: json['reminderScheduledFor'] == null
          ? null
          : DateTime.parse(json['reminderScheduledFor'] as String),
    );

Map<String, dynamic> _$$TravelTriggerImplToJson(_$TravelTriggerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'originLat': instance.originLat,
      'originLng': instance.originLng,
      'destLat': instance.destLat,
      'destLng': instance.destLng,
      'originAddress': instance.originAddress,
      'destAddress': instance.destAddress,
      'appointmentTime': instance.appointmentTime.toIso8601String(),
      'bufferMinutes': instance.bufferMinutes,
      'enabled': instance.enabled,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastCheckedAt': instance.lastCheckedAt?.toIso8601String(),
      'reminderScheduledFor': instance.reminderScheduledFor?.toIso8601String(),
    };
