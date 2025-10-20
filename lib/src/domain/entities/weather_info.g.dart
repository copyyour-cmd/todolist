// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherInfoAdapter extends TypeAdapter<WeatherInfo> {
  @override
  final int typeId = 72;

  @override
  WeatherInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherInfo(
      id: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      locationName: fields[3] as String,
      condition: fields[4] as WeatherCondition,
      temperature: fields[5] as double,
      feelsLike: fields[6] as double,
      humidity: fields[7] as int,
      windSpeed: fields[8] as double,
      description: fields[9] as String,
      fetchedAt: fields[10] as DateTime,
      validUntil: fields[11] as DateTime,
      precipitationProbability: fields[12] as double?,
      iconCode: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherInfo obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.locationName)
      ..writeByte(4)
      ..write(obj.condition)
      ..writeByte(5)
      ..write(obj.temperature)
      ..writeByte(6)
      ..write(obj.feelsLike)
      ..writeByte(7)
      ..write(obj.humidity)
      ..writeByte(8)
      ..write(obj.windSpeed)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.fetchedAt)
      ..writeByte(11)
      ..write(obj.validUntil)
      ..writeByte(12)
      ..write(obj.precipitationProbability)
      ..writeByte(13)
      ..write(obj.iconCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeatherTriggerAdapter extends TypeAdapter<WeatherTrigger> {
  @override
  final int typeId = 74;

  @override
  WeatherTrigger read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherTrigger(
      id: fields[0] as String,
      taskId: fields[1] as String,
      conditions: (fields[2] as List).cast<WeatherCondition>(),
      enabled: fields[3] as bool,
      createdAt: fields[4] as DateTime,
      lastTriggeredAt: fields[5] as DateTime?,
      minTemperature: fields[6] as double?,
      maxTemperature: fields[7] as double?,
      minPrecipitationProbability: fields[8] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherTrigger obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.conditions)
      ..writeByte(3)
      ..write(obj.enabled)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastTriggeredAt)
      ..writeByte(6)
      ..write(obj.minTemperature)
      ..writeByte(7)
      ..write(obj.maxTemperature)
      ..writeByte(8)
      ..write(obj.minPrecipitationProbability);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherTriggerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeatherConditionAdapter extends TypeAdapter<WeatherCondition> {
  @override
  final int typeId = 73;

  @override
  WeatherCondition read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WeatherCondition.clear;
      case 1:
        return WeatherCondition.clouds;
      case 2:
        return WeatherCondition.rain;
      case 3:
        return WeatherCondition.drizzle;
      case 4:
        return WeatherCondition.thunderstorm;
      case 5:
        return WeatherCondition.snow;
      case 6:
        return WeatherCondition.mist;
      case 7:
        return WeatherCondition.fog;
      case 8:
        return WeatherCondition.tornado;
      case 9:
        return WeatherCondition.unknown;
      default:
        return WeatherCondition.clear;
    }
  }

  @override
  void write(BinaryWriter writer, WeatherCondition obj) {
    switch (obj) {
      case WeatherCondition.clear:
        writer.writeByte(0);
        break;
      case WeatherCondition.clouds:
        writer.writeByte(1);
        break;
      case WeatherCondition.rain:
        writer.writeByte(2);
        break;
      case WeatherCondition.drizzle:
        writer.writeByte(3);
        break;
      case WeatherCondition.thunderstorm:
        writer.writeByte(4);
        break;
      case WeatherCondition.snow:
        writer.writeByte(5);
        break;
      case WeatherCondition.mist:
        writer.writeByte(6);
        break;
      case WeatherCondition.fog:
        writer.writeByte(7);
        break;
      case WeatherCondition.tornado:
        writer.writeByte(8);
        break;
      case WeatherCondition.unknown:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherInfoImpl _$$WeatherInfoImplFromJson(Map<String, dynamic> json) =>
    _$WeatherInfoImpl(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      locationName: json['locationName'] as String,
      condition: $enumDecode(_$WeatherConditionEnumMap, json['condition']),
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      description: json['description'] as String,
      fetchedAt: DateTime.parse(json['fetchedAt'] as String),
      validUntil: DateTime.parse(json['validUntil'] as String),
      precipitationProbability:
          (json['precipitationProbability'] as num?)?.toDouble(),
      iconCode: json['iconCode'] as String?,
    );

Map<String, dynamic> _$$WeatherInfoImplToJson(_$WeatherInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'locationName': instance.locationName,
      'condition': _$WeatherConditionEnumMap[instance.condition]!,
      'temperature': instance.temperature,
      'feelsLike': instance.feelsLike,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'description': instance.description,
      'fetchedAt': instance.fetchedAt.toIso8601String(),
      'validUntil': instance.validUntil.toIso8601String(),
      'precipitationProbability': instance.precipitationProbability,
      'iconCode': instance.iconCode,
    };

const _$WeatherConditionEnumMap = {
  WeatherCondition.clear: 'clear',
  WeatherCondition.clouds: 'clouds',
  WeatherCondition.rain: 'rain',
  WeatherCondition.drizzle: 'drizzle',
  WeatherCondition.thunderstorm: 'thunderstorm',
  WeatherCondition.snow: 'snow',
  WeatherCondition.mist: 'mist',
  WeatherCondition.fog: 'fog',
  WeatherCondition.tornado: 'tornado',
  WeatherCondition.unknown: 'unknown',
};

_$WeatherTriggerImpl _$$WeatherTriggerImplFromJson(Map<String, dynamic> json) =>
    _$WeatherTriggerImpl(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      conditions: (json['conditions'] as List<dynamic>)
          .map((e) => $enumDecode(_$WeatherConditionEnumMap, e))
          .toList(),
      enabled: json['enabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastTriggeredAt: json['lastTriggeredAt'] == null
          ? null
          : DateTime.parse(json['lastTriggeredAt'] as String),
      minTemperature: (json['minTemperature'] as num?)?.toDouble(),
      maxTemperature: (json['maxTemperature'] as num?)?.toDouble(),
      minPrecipitationProbability:
          (json['minPrecipitationProbability'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$WeatherTriggerImplToJson(
        _$WeatherTriggerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'conditions': instance.conditions
          .map((e) => _$WeatherConditionEnumMap[e]!)
          .toList(),
      'enabled': instance.enabled,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastTriggeredAt': instance.lastTriggeredAt?.toIso8601String(),
      'minTemperature': instance.minTemperature,
      'maxTemperature': instance.maxTemperature,
      'minPrecipitationProbability': instance.minPrecipitationProbability,
    };
