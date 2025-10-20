import 'package:freezed_annotation/freezed_annotation.dart';
import '../../infrastructure/hive/type_ids.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'weather_info.freezed.dart';
part 'weather_info.g.dart';

/// 天气信息
@HiveType(typeId: HiveTypeIds.weatherInfo, adapterName: 'WeatherInfoAdapter')
@freezed
class WeatherInfo with _$WeatherInfo {
  const factory WeatherInfo({
    @HiveField(0) required String id,
    @HiveField(1) required double latitude,
    @HiveField(2) required double longitude,
    @HiveField(3) required String locationName,
    @HiveField(4) required WeatherCondition condition,
    @HiveField(5) required double temperature,
    @HiveField(6) required double feelsLike,
    @HiveField(7) required int humidity,
    @HiveField(8) required double windSpeed,
    @HiveField(9) required String description,
    @HiveField(10) required DateTime fetchedAt,
    @HiveField(11) required DateTime validUntil,
    @HiveField(12) double? precipitationProbability, // 降水概率 0-100
    @HiveField(13) String? iconCode,
  }) = _WeatherInfo;

  const WeatherInfo._();

  factory WeatherInfo.fromJson(Map<String, dynamic> json) =>
      _$WeatherInfoFromJson(json);

  /// 是否需要下雨提醒
  bool get needsRainReminder =>
      condition == WeatherCondition.rain ||
      condition == WeatherCondition.drizzle ||
      condition == WeatherCondition.thunderstorm ||
      (precipitationProbability != null && precipitationProbability! > 50);

  /// 是否极端天气
  bool get isExtremeWeather =>
      condition == WeatherCondition.thunderstorm ||
      condition == WeatherCondition.snow ||
      condition == WeatherCondition.tornado ||
      temperature < -10 ||
      temperature > 38;

  /// 天气图标emoji
  String get emoji {
    switch (condition) {
      case WeatherCondition.clear:
        return '☀️';
      case WeatherCondition.clouds:
        return '☁️';
      case WeatherCondition.rain:
        return '🌧️';
      case WeatherCondition.drizzle:
        return '🌦️';
      case WeatherCondition.thunderstorm:
        return '⛈️';
      case WeatherCondition.snow:
        return '❄️';
      case WeatherCondition.mist:
      case WeatherCondition.fog:
        return '🌫️';
      case WeatherCondition.tornado:
        return '🌪️';
      case WeatherCondition.unknown:
        return '🌈';
    }
  }

  /// 是否已过期
  bool isExpired(DateTime now) => now.isAfter(validUntil);
}

/// 天气状况枚举
@HiveType(typeId: HiveTypeIds.weatherCondition, adapterName: 'WeatherConditionAdapter')
@JsonEnum()
enum WeatherCondition {
  @HiveField(0)
  clear, // 晴天
  @HiveField(1)
  clouds, // 多云
  @HiveField(2)
  rain, // 雨
  @HiveField(3)
  drizzle, // 毛毛雨
  @HiveField(4)
  thunderstorm, // 雷暴
  @HiveField(5)
  snow, // 雪
  @HiveField(6)
  mist, // 薄雾
  @HiveField(7)
  fog, // 雾
  @HiveField(8)
  tornado, // 龙卷风
  @HiveField(9)
  unknown, // 未知
}

/// 天气触发器配置
@HiveType(typeId: HiveTypeIds.weatherTrigger, adapterName: 'WeatherTriggerAdapter')
@freezed
class WeatherTrigger with _$WeatherTrigger {
  const factory WeatherTrigger({
    @HiveField(0) required String id,
    @HiveField(1) required String taskId,
    @HiveField(2) required List<WeatherCondition> conditions,
    @HiveField(3) @Default(true) bool enabled,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) DateTime? lastTriggeredAt,
    // 温度范围触发（可选）
    @HiveField(6) double? minTemperature,
    @HiveField(7) double? maxTemperature,
    // 降水概率触发（可选）
    @HiveField(8) double? minPrecipitationProbability,
  }) = _WeatherTrigger;

  const WeatherTrigger._();

  factory WeatherTrigger.fromJson(Map<String, dynamic> json) =>
      _$WeatherTriggerFromJson(json);

  /// 检查天气是否匹配触发条件
  bool matches(WeatherInfo weather) {
    if (!enabled) return false;

    // 检查天气状况
    if (conditions.isNotEmpty && !conditions.contains(weather.condition)) {
      return false;
    }

    // 检查温度范围
    if (minTemperature != null && weather.temperature < minTemperature!) {
      return false;
    }
    if (maxTemperature != null && weather.temperature > maxTemperature!) {
      return false;
    }

    // 检查降水概率
    if (minPrecipitationProbability != null &&
        weather.precipitationProbability != null &&
        weather.precipitationProbability! < minPrecipitationProbability!) {
      return false;
    }

    return true;
  }
}
