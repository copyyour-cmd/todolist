import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'location_battery_config.freezed.dart';
part 'location_battery_config.g.dart';

/// 电池优化模式
enum BatteryOptimizationMode {
  /// 最高精度（高电池消耗）
  highAccuracy,

  /// 平衡模式（推荐）
  balanced,

  /// 省电模式（低电池消耗）
  powerSaver,

  /// 智能模式（根据距离动态调整）
  smart,
}

/// 位置服务电池优化配置
@freezed
class LocationBatteryConfig with _$LocationBatteryConfig {
  const factory LocationBatteryConfig({
    /// 优化模式
    @Default(BatteryOptimizationMode.balanced) BatteryOptimizationMode mode,

    /// 是否启用地理围栏（推荐，可大幅降低电池消耗）
    @Default(true) bool useGeofencing,

    /// 位置更新最小距离间隔（米）
    @Default(50) int distanceFilterMeters,

    /// 定位精度
    @Default(LocationAccuracy.medium) LocationAccuracy accuracy,

    /// 智能模式下的距离阈值配置
    @Default(SmartDistanceThresholds()) SmartDistanceThresholds smartThresholds,

    /// 后台更新间隔（秒）
    @Default(300) int backgroundUpdateIntervalSeconds,

    /// 是否在应用进入后台时降低更新频率
    @Default(true) bool reduceFrequencyInBackground,

    /// 是否在电池低于某个百分比时自动切换到省电模式
    @Default(true) bool autoSwitchOnLowBattery,

    /// 自动切换的电池百分比阈值
    @Default(20) int lowBatteryThresholdPercent,
  }) = _LocationBatteryConfig;

  const LocationBatteryConfig._();

  factory LocationBatteryConfig.fromJson(Map<String, dynamic> json) =>
      _$LocationBatteryConfigFromJson(json);

  /// 根据模式获取推荐配置
  factory LocationBatteryConfig.fromMode(BatteryOptimizationMode mode) {
    switch (mode) {
      case BatteryOptimizationMode.highAccuracy:
        return const LocationBatteryConfig(
          mode: BatteryOptimizationMode.highAccuracy,
          distanceFilterMeters: 10,
          accuracy: LocationAccuracy.best,
          useGeofencing: false,
          backgroundUpdateIntervalSeconds: 60,
          reduceFrequencyInBackground: false,
        );

      case BatteryOptimizationMode.balanced:
        return const LocationBatteryConfig(
          mode: BatteryOptimizationMode.balanced,
          distanceFilterMeters: 50,
          accuracy: LocationAccuracy.medium,
          useGeofencing: true,
          backgroundUpdateIntervalSeconds: 300,
          reduceFrequencyInBackground: true,
        );

      case BatteryOptimizationMode.powerSaver:
        return const LocationBatteryConfig(
          mode: BatteryOptimizationMode.powerSaver,
          distanceFilterMeters: 200,
          accuracy: LocationAccuracy.low,
          useGeofencing: true,
          backgroundUpdateIntervalSeconds: 600,
          reduceFrequencyInBackground: true,
        );

      case BatteryOptimizationMode.smart:
        return const LocationBatteryConfig(
          mode: BatteryOptimizationMode.smart,
          distanceFilterMeters: 100,
          accuracy: LocationAccuracy.medium,
          useGeofencing: true,
          backgroundUpdateIntervalSeconds: 300,
          reduceFrequencyInBackground: true,
          smartThresholds: SmartDistanceThresholds(
            veryFarMeters: 5000,
            farMeters: 2000,
            nearMeters: 500,
            veryNearMeters: 100,
          ),
        );
    }
  }

  /// 获取LocationSettings配置
  LocationSettings toLocationSettings() {
    return LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilterMeters,
    );
  }

  /// 根据距离获取智能更新间隔（仅智能模式）
  int getUpdateIntervalForDistance(double distanceToTarget) {
    if (mode != BatteryOptimizationMode.smart) {
      return backgroundUpdateIntervalSeconds;
    }

    if (distanceToTarget > smartThresholds.veryFarMeters) {
      // 非常远：每10分钟更新一次
      return 600;
    } else if (distanceToTarget > smartThresholds.farMeters) {
      // 远：每5分钟更新一次
      return 300;
    } else if (distanceToTarget > smartThresholds.nearMeters) {
      // 中等距离：每2分钟更新一次
      return 120;
    } else if (distanceToTarget > smartThresholds.veryNearMeters) {
      // 接近：每30秒更新一次
      return 30;
    } else {
      // 非常接近：持续监控
      return 10;
    }
  }

  /// 根据距离获取distanceFilter（仅智能模式）
  int getDistanceFilterForDistance(double distanceToTarget) {
    if (mode != BatteryOptimizationMode.smart) {
      return distanceFilterMeters;
    }

    if (distanceToTarget > smartThresholds.veryFarMeters) {
      return 500; // 非常远：500米才更新
    } else if (distanceToTarget > smartThresholds.farMeters) {
      return 200; // 远：200米更新
    } else if (distanceToTarget > smartThresholds.nearMeters) {
      return 100; // 中等：100米更新
    } else if (distanceToTarget > smartThresholds.veryNearMeters) {
      return 50; // 接近：50米更新
    } else {
      return 10; // 非常接近：10米更新
    }
  }
}

/// 智能模式的距离阈值配置
@freezed
class SmartDistanceThresholds with _$SmartDistanceThresholds {
  const factory SmartDistanceThresholds({
    /// 非常远的距离（米）
    @Default(5000) double veryFarMeters,

    /// 远距离（米）
    @Default(2000) double farMeters,

    /// 中等距离（米）
    @Default(500) double nearMeters,

    /// 非常近的距离（米）
    @Default(100) double veryNearMeters,
  }) = _SmartDistanceThresholds;

  const SmartDistanceThresholds._();

  factory SmartDistanceThresholds.fromJson(Map<String, dynamic> json) =>
      _$SmartDistanceThresholdsFromJson(json);
}

/// 位置服务状态
@freezed
class LocationServiceStatus with _$LocationServiceStatus {
  const factory LocationServiceStatus({
    /// 是否正在监控
    @Default(false) bool isMonitoring,

    /// 活跃提醒数量
    @Default(0) int activeRemindersCount,

    /// 当前使用的配置
    required LocationBatteryConfig config,

    /// 最后更新时间
    DateTime? lastUpdateTime,

    /// 当前电池优化状态
    @Default(BatteryOptimizationMode.balanced) BatteryOptimizationMode currentMode,

    /// 预估电池使用情况（每小时百分比）
    @Default(2.0) double estimatedBatteryPerHour,
  }) = _LocationServiceStatus;

  const LocationServiceStatus._();

  factory LocationServiceStatus.fromJson(Map<String, dynamic> json) =>
      _$LocationServiceStatusFromJson(json);

  /// 获取预估的电池使用情况描述
  String get batteryUsageDescription {
    if (estimatedBatteryPerHour < 1.0) {
      return '极低 (<1%/小时)';
    } else if (estimatedBatteryPerHour < 2.0) {
      return '低 (~${estimatedBatteryPerHour.toStringAsFixed(1)}%/小时)';
    } else if (estimatedBatteryPerHour < 4.0) {
      return '中等 (~${estimatedBatteryPerHour.toStringAsFixed(1)}%/小时)';
    } else {
      return '高 (~${estimatedBatteryPerHour.toStringAsFixed(1)}%/小时)';
    }
  }
}
