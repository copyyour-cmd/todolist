// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_battery_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationBatteryConfigImpl _$$LocationBatteryConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationBatteryConfigImpl(
      mode:
          $enumDecodeNullable(_$BatteryOptimizationModeEnumMap, json['mode']) ??
              BatteryOptimizationMode.balanced,
      useGeofencing: json['useGeofencing'] as bool? ?? true,
      distanceFilterMeters:
          (json['distanceFilterMeters'] as num?)?.toInt() ?? 50,
      accuracy:
          $enumDecodeNullable(_$LocationAccuracyEnumMap, json['accuracy']) ??
              LocationAccuracy.medium,
      smartThresholds: json['smartThresholds'] == null
          ? const SmartDistanceThresholds()
          : SmartDistanceThresholds.fromJson(
              json['smartThresholds'] as Map<String, dynamic>),
      backgroundUpdateIntervalSeconds:
          (json['backgroundUpdateIntervalSeconds'] as num?)?.toInt() ?? 300,
      reduceFrequencyInBackground:
          json['reduceFrequencyInBackground'] as bool? ?? true,
      autoSwitchOnLowBattery: json['autoSwitchOnLowBattery'] as bool? ?? true,
      lowBatteryThresholdPercent:
          (json['lowBatteryThresholdPercent'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$$LocationBatteryConfigImplToJson(
        _$LocationBatteryConfigImpl instance) =>
    <String, dynamic>{
      'mode': _$BatteryOptimizationModeEnumMap[instance.mode]!,
      'useGeofencing': instance.useGeofencing,
      'distanceFilterMeters': instance.distanceFilterMeters,
      'accuracy': _$LocationAccuracyEnumMap[instance.accuracy]!,
      'smartThresholds': instance.smartThresholds,
      'backgroundUpdateIntervalSeconds':
          instance.backgroundUpdateIntervalSeconds,
      'reduceFrequencyInBackground': instance.reduceFrequencyInBackground,
      'autoSwitchOnLowBattery': instance.autoSwitchOnLowBattery,
      'lowBatteryThresholdPercent': instance.lowBatteryThresholdPercent,
    };

const _$BatteryOptimizationModeEnumMap = {
  BatteryOptimizationMode.highAccuracy: 'highAccuracy',
  BatteryOptimizationMode.balanced: 'balanced',
  BatteryOptimizationMode.powerSaver: 'powerSaver',
  BatteryOptimizationMode.smart: 'smart',
};

const _$LocationAccuracyEnumMap = {
  LocationAccuracy.lowest: 'lowest',
  LocationAccuracy.low: 'low',
  LocationAccuracy.medium: 'medium',
  LocationAccuracy.high: 'high',
  LocationAccuracy.best: 'best',
  LocationAccuracy.bestForNavigation: 'bestForNavigation',
  LocationAccuracy.reduced: 'reduced',
};

_$SmartDistanceThresholdsImpl _$$SmartDistanceThresholdsImplFromJson(
        Map<String, dynamic> json) =>
    _$SmartDistanceThresholdsImpl(
      veryFarMeters: (json['veryFarMeters'] as num?)?.toDouble() ?? 5000,
      farMeters: (json['farMeters'] as num?)?.toDouble() ?? 2000,
      nearMeters: (json['nearMeters'] as num?)?.toDouble() ?? 500,
      veryNearMeters: (json['veryNearMeters'] as num?)?.toDouble() ?? 100,
    );

Map<String, dynamic> _$$SmartDistanceThresholdsImplToJson(
        _$SmartDistanceThresholdsImpl instance) =>
    <String, dynamic>{
      'veryFarMeters': instance.veryFarMeters,
      'farMeters': instance.farMeters,
      'nearMeters': instance.nearMeters,
      'veryNearMeters': instance.veryNearMeters,
    };

_$LocationServiceStatusImpl _$$LocationServiceStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationServiceStatusImpl(
      isMonitoring: json['isMonitoring'] as bool? ?? false,
      activeRemindersCount:
          (json['activeRemindersCount'] as num?)?.toInt() ?? 0,
      config: LocationBatteryConfig.fromJson(
          json['config'] as Map<String, dynamic>),
      lastUpdateTime: json['lastUpdateTime'] == null
          ? null
          : DateTime.parse(json['lastUpdateTime'] as String),
      currentMode: $enumDecodeNullable(
              _$BatteryOptimizationModeEnumMap, json['currentMode']) ??
          BatteryOptimizationMode.balanced,
      estimatedBatteryPerHour:
          (json['estimatedBatteryPerHour'] as num?)?.toDouble() ?? 2.0,
    );

Map<String, dynamic> _$$LocationServiceStatusImplToJson(
        _$LocationServiceStatusImpl instance) =>
    <String, dynamic>{
      'isMonitoring': instance.isMonitoring,
      'activeRemindersCount': instance.activeRemindersCount,
      'config': instance.config,
      'lastUpdateTime': instance.lastUpdateTime?.toIso8601String(),
      'currentMode': _$BatteryOptimizationModeEnumMap[instance.currentMode]!,
      'estimatedBatteryPerHour': instance.estimatedBatteryPerHour,
    };
