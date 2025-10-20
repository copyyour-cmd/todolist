// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_battery_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocationBatteryConfig _$LocationBatteryConfigFromJson(
    Map<String, dynamic> json) {
  return _LocationBatteryConfig.fromJson(json);
}

/// @nodoc
mixin _$LocationBatteryConfig {
  /// 优化模式
  BatteryOptimizationMode get mode => throw _privateConstructorUsedError;

  /// 是否启用地理围栏（推荐，可大幅降低电池消耗）
  bool get useGeofencing => throw _privateConstructorUsedError;

  /// 位置更新最小距离间隔（米）
  int get distanceFilterMeters => throw _privateConstructorUsedError;

  /// 定位精度
  LocationAccuracy get accuracy => throw _privateConstructorUsedError;

  /// 智能模式下的距离阈值配置
  SmartDistanceThresholds get smartThresholds =>
      throw _privateConstructorUsedError;

  /// 后台更新间隔（秒）
  int get backgroundUpdateIntervalSeconds => throw _privateConstructorUsedError;

  /// 是否在应用进入后台时降低更新频率
  bool get reduceFrequencyInBackground => throw _privateConstructorUsedError;

  /// 是否在电池低于某个百分比时自动切换到省电模式
  bool get autoSwitchOnLowBattery => throw _privateConstructorUsedError;

  /// 自动切换的电池百分比阈值
  int get lowBatteryThresholdPercent => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocationBatteryConfigCopyWith<LocationBatteryConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationBatteryConfigCopyWith<$Res> {
  factory $LocationBatteryConfigCopyWith(LocationBatteryConfig value,
          $Res Function(LocationBatteryConfig) then) =
      _$LocationBatteryConfigCopyWithImpl<$Res, LocationBatteryConfig>;
  @useResult
  $Res call(
      {BatteryOptimizationMode mode,
      bool useGeofencing,
      int distanceFilterMeters,
      LocationAccuracy accuracy,
      SmartDistanceThresholds smartThresholds,
      int backgroundUpdateIntervalSeconds,
      bool reduceFrequencyInBackground,
      bool autoSwitchOnLowBattery,
      int lowBatteryThresholdPercent});

  $SmartDistanceThresholdsCopyWith<$Res> get smartThresholds;
}

/// @nodoc
class _$LocationBatteryConfigCopyWithImpl<$Res,
        $Val extends LocationBatteryConfig>
    implements $LocationBatteryConfigCopyWith<$Res> {
  _$LocationBatteryConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? useGeofencing = null,
    Object? distanceFilterMeters = null,
    Object? accuracy = null,
    Object? smartThresholds = null,
    Object? backgroundUpdateIntervalSeconds = null,
    Object? reduceFrequencyInBackground = null,
    Object? autoSwitchOnLowBattery = null,
    Object? lowBatteryThresholdPercent = null,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as BatteryOptimizationMode,
      useGeofencing: null == useGeofencing
          ? _value.useGeofencing
          : useGeofencing // ignore: cast_nullable_to_non_nullable
              as bool,
      distanceFilterMeters: null == distanceFilterMeters
          ? _value.distanceFilterMeters
          : distanceFilterMeters // ignore: cast_nullable_to_non_nullable
              as int,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as LocationAccuracy,
      smartThresholds: null == smartThresholds
          ? _value.smartThresholds
          : smartThresholds // ignore: cast_nullable_to_non_nullable
              as SmartDistanceThresholds,
      backgroundUpdateIntervalSeconds: null == backgroundUpdateIntervalSeconds
          ? _value.backgroundUpdateIntervalSeconds
          : backgroundUpdateIntervalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      reduceFrequencyInBackground: null == reduceFrequencyInBackground
          ? _value.reduceFrequencyInBackground
          : reduceFrequencyInBackground // ignore: cast_nullable_to_non_nullable
              as bool,
      autoSwitchOnLowBattery: null == autoSwitchOnLowBattery
          ? _value.autoSwitchOnLowBattery
          : autoSwitchOnLowBattery // ignore: cast_nullable_to_non_nullable
              as bool,
      lowBatteryThresholdPercent: null == lowBatteryThresholdPercent
          ? _value.lowBatteryThresholdPercent
          : lowBatteryThresholdPercent // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SmartDistanceThresholdsCopyWith<$Res> get smartThresholds {
    return $SmartDistanceThresholdsCopyWith<$Res>(_value.smartThresholds,
        (value) {
      return _then(_value.copyWith(smartThresholds: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LocationBatteryConfigImplCopyWith<$Res>
    implements $LocationBatteryConfigCopyWith<$Res> {
  factory _$$LocationBatteryConfigImplCopyWith(
          _$LocationBatteryConfigImpl value,
          $Res Function(_$LocationBatteryConfigImpl) then) =
      __$$LocationBatteryConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BatteryOptimizationMode mode,
      bool useGeofencing,
      int distanceFilterMeters,
      LocationAccuracy accuracy,
      SmartDistanceThresholds smartThresholds,
      int backgroundUpdateIntervalSeconds,
      bool reduceFrequencyInBackground,
      bool autoSwitchOnLowBattery,
      int lowBatteryThresholdPercent});

  @override
  $SmartDistanceThresholdsCopyWith<$Res> get smartThresholds;
}

/// @nodoc
class __$$LocationBatteryConfigImplCopyWithImpl<$Res>
    extends _$LocationBatteryConfigCopyWithImpl<$Res,
        _$LocationBatteryConfigImpl>
    implements _$$LocationBatteryConfigImplCopyWith<$Res> {
  __$$LocationBatteryConfigImplCopyWithImpl(_$LocationBatteryConfigImpl _value,
      $Res Function(_$LocationBatteryConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? useGeofencing = null,
    Object? distanceFilterMeters = null,
    Object? accuracy = null,
    Object? smartThresholds = null,
    Object? backgroundUpdateIntervalSeconds = null,
    Object? reduceFrequencyInBackground = null,
    Object? autoSwitchOnLowBattery = null,
    Object? lowBatteryThresholdPercent = null,
  }) {
    return _then(_$LocationBatteryConfigImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as BatteryOptimizationMode,
      useGeofencing: null == useGeofencing
          ? _value.useGeofencing
          : useGeofencing // ignore: cast_nullable_to_non_nullable
              as bool,
      distanceFilterMeters: null == distanceFilterMeters
          ? _value.distanceFilterMeters
          : distanceFilterMeters // ignore: cast_nullable_to_non_nullable
              as int,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as LocationAccuracy,
      smartThresholds: null == smartThresholds
          ? _value.smartThresholds
          : smartThresholds // ignore: cast_nullable_to_non_nullable
              as SmartDistanceThresholds,
      backgroundUpdateIntervalSeconds: null == backgroundUpdateIntervalSeconds
          ? _value.backgroundUpdateIntervalSeconds
          : backgroundUpdateIntervalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      reduceFrequencyInBackground: null == reduceFrequencyInBackground
          ? _value.reduceFrequencyInBackground
          : reduceFrequencyInBackground // ignore: cast_nullable_to_non_nullable
              as bool,
      autoSwitchOnLowBattery: null == autoSwitchOnLowBattery
          ? _value.autoSwitchOnLowBattery
          : autoSwitchOnLowBattery // ignore: cast_nullable_to_non_nullable
              as bool,
      lowBatteryThresholdPercent: null == lowBatteryThresholdPercent
          ? _value.lowBatteryThresholdPercent
          : lowBatteryThresholdPercent // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationBatteryConfigImpl extends _LocationBatteryConfig {
  const _$LocationBatteryConfigImpl(
      {this.mode = BatteryOptimizationMode.balanced,
      this.useGeofencing = true,
      this.distanceFilterMeters = 50,
      this.accuracy = LocationAccuracy.medium,
      this.smartThresholds = const SmartDistanceThresholds(),
      this.backgroundUpdateIntervalSeconds = 300,
      this.reduceFrequencyInBackground = true,
      this.autoSwitchOnLowBattery = true,
      this.lowBatteryThresholdPercent = 20})
      : super._();

  factory _$LocationBatteryConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationBatteryConfigImplFromJson(json);

  /// 优化模式
  @override
  @JsonKey()
  final BatteryOptimizationMode mode;

  /// 是否启用地理围栏（推荐，可大幅降低电池消耗）
  @override
  @JsonKey()
  final bool useGeofencing;

  /// 位置更新最小距离间隔（米）
  @override
  @JsonKey()
  final int distanceFilterMeters;

  /// 定位精度
  @override
  @JsonKey()
  final LocationAccuracy accuracy;

  /// 智能模式下的距离阈值配置
  @override
  @JsonKey()
  final SmartDistanceThresholds smartThresholds;

  /// 后台更新间隔（秒）
  @override
  @JsonKey()
  final int backgroundUpdateIntervalSeconds;

  /// 是否在应用进入后台时降低更新频率
  @override
  @JsonKey()
  final bool reduceFrequencyInBackground;

  /// 是否在电池低于某个百分比时自动切换到省电模式
  @override
  @JsonKey()
  final bool autoSwitchOnLowBattery;

  /// 自动切换的电池百分比阈值
  @override
  @JsonKey()
  final int lowBatteryThresholdPercent;

  @override
  String toString() {
    return 'LocationBatteryConfig(mode: $mode, useGeofencing: $useGeofencing, distanceFilterMeters: $distanceFilterMeters, accuracy: $accuracy, smartThresholds: $smartThresholds, backgroundUpdateIntervalSeconds: $backgroundUpdateIntervalSeconds, reduceFrequencyInBackground: $reduceFrequencyInBackground, autoSwitchOnLowBattery: $autoSwitchOnLowBattery, lowBatteryThresholdPercent: $lowBatteryThresholdPercent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationBatteryConfigImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.useGeofencing, useGeofencing) ||
                other.useGeofencing == useGeofencing) &&
            (identical(other.distanceFilterMeters, distanceFilterMeters) ||
                other.distanceFilterMeters == distanceFilterMeters) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.smartThresholds, smartThresholds) ||
                other.smartThresholds == smartThresholds) &&
            (identical(other.backgroundUpdateIntervalSeconds,
                    backgroundUpdateIntervalSeconds) ||
                other.backgroundUpdateIntervalSeconds ==
                    backgroundUpdateIntervalSeconds) &&
            (identical(other.reduceFrequencyInBackground,
                    reduceFrequencyInBackground) ||
                other.reduceFrequencyInBackground ==
                    reduceFrequencyInBackground) &&
            (identical(other.autoSwitchOnLowBattery, autoSwitchOnLowBattery) ||
                other.autoSwitchOnLowBattery == autoSwitchOnLowBattery) &&
            (identical(other.lowBatteryThresholdPercent,
                    lowBatteryThresholdPercent) ||
                other.lowBatteryThresholdPercent ==
                    lowBatteryThresholdPercent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mode,
      useGeofencing,
      distanceFilterMeters,
      accuracy,
      smartThresholds,
      backgroundUpdateIntervalSeconds,
      reduceFrequencyInBackground,
      autoSwitchOnLowBattery,
      lowBatteryThresholdPercent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationBatteryConfigImplCopyWith<_$LocationBatteryConfigImpl>
      get copyWith => __$$LocationBatteryConfigImplCopyWithImpl<
          _$LocationBatteryConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationBatteryConfigImplToJson(
      this,
    );
  }
}

abstract class _LocationBatteryConfig extends LocationBatteryConfig {
  const factory _LocationBatteryConfig(
      {final BatteryOptimizationMode mode,
      final bool useGeofencing,
      final int distanceFilterMeters,
      final LocationAccuracy accuracy,
      final SmartDistanceThresholds smartThresholds,
      final int backgroundUpdateIntervalSeconds,
      final bool reduceFrequencyInBackground,
      final bool autoSwitchOnLowBattery,
      final int lowBatteryThresholdPercent}) = _$LocationBatteryConfigImpl;
  const _LocationBatteryConfig._() : super._();

  factory _LocationBatteryConfig.fromJson(Map<String, dynamic> json) =
      _$LocationBatteryConfigImpl.fromJson;

  @override

  /// 优化模式
  BatteryOptimizationMode get mode;
  @override

  /// 是否启用地理围栏（推荐，可大幅降低电池消耗）
  bool get useGeofencing;
  @override

  /// 位置更新最小距离间隔（米）
  int get distanceFilterMeters;
  @override

  /// 定位精度
  LocationAccuracy get accuracy;
  @override

  /// 智能模式下的距离阈值配置
  SmartDistanceThresholds get smartThresholds;
  @override

  /// 后台更新间隔（秒）
  int get backgroundUpdateIntervalSeconds;
  @override

  /// 是否在应用进入后台时降低更新频率
  bool get reduceFrequencyInBackground;
  @override

  /// 是否在电池低于某个百分比时自动切换到省电模式
  bool get autoSwitchOnLowBattery;
  @override

  /// 自动切换的电池百分比阈值
  int get lowBatteryThresholdPercent;
  @override
  @JsonKey(ignore: true)
  _$$LocationBatteryConfigImplCopyWith<_$LocationBatteryConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SmartDistanceThresholds _$SmartDistanceThresholdsFromJson(
    Map<String, dynamic> json) {
  return _SmartDistanceThresholds.fromJson(json);
}

/// @nodoc
mixin _$SmartDistanceThresholds {
  /// 非常远的距离（米）
  double get veryFarMeters => throw _privateConstructorUsedError;

  /// 远距离（米）
  double get farMeters => throw _privateConstructorUsedError;

  /// 中等距离（米）
  double get nearMeters => throw _privateConstructorUsedError;

  /// 非常近的距离（米）
  double get veryNearMeters => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SmartDistanceThresholdsCopyWith<SmartDistanceThresholds> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartDistanceThresholdsCopyWith<$Res> {
  factory $SmartDistanceThresholdsCopyWith(SmartDistanceThresholds value,
          $Res Function(SmartDistanceThresholds) then) =
      _$SmartDistanceThresholdsCopyWithImpl<$Res, SmartDistanceThresholds>;
  @useResult
  $Res call(
      {double veryFarMeters,
      double farMeters,
      double nearMeters,
      double veryNearMeters});
}

/// @nodoc
class _$SmartDistanceThresholdsCopyWithImpl<$Res,
        $Val extends SmartDistanceThresholds>
    implements $SmartDistanceThresholdsCopyWith<$Res> {
  _$SmartDistanceThresholdsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? veryFarMeters = null,
    Object? farMeters = null,
    Object? nearMeters = null,
    Object? veryNearMeters = null,
  }) {
    return _then(_value.copyWith(
      veryFarMeters: null == veryFarMeters
          ? _value.veryFarMeters
          : veryFarMeters // ignore: cast_nullable_to_non_nullable
              as double,
      farMeters: null == farMeters
          ? _value.farMeters
          : farMeters // ignore: cast_nullable_to_non_nullable
              as double,
      nearMeters: null == nearMeters
          ? _value.nearMeters
          : nearMeters // ignore: cast_nullable_to_non_nullable
              as double,
      veryNearMeters: null == veryNearMeters
          ? _value.veryNearMeters
          : veryNearMeters // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmartDistanceThresholdsImplCopyWith<$Res>
    implements $SmartDistanceThresholdsCopyWith<$Res> {
  factory _$$SmartDistanceThresholdsImplCopyWith(
          _$SmartDistanceThresholdsImpl value,
          $Res Function(_$SmartDistanceThresholdsImpl) then) =
      __$$SmartDistanceThresholdsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double veryFarMeters,
      double farMeters,
      double nearMeters,
      double veryNearMeters});
}

/// @nodoc
class __$$SmartDistanceThresholdsImplCopyWithImpl<$Res>
    extends _$SmartDistanceThresholdsCopyWithImpl<$Res,
        _$SmartDistanceThresholdsImpl>
    implements _$$SmartDistanceThresholdsImplCopyWith<$Res> {
  __$$SmartDistanceThresholdsImplCopyWithImpl(
      _$SmartDistanceThresholdsImpl _value,
      $Res Function(_$SmartDistanceThresholdsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? veryFarMeters = null,
    Object? farMeters = null,
    Object? nearMeters = null,
    Object? veryNearMeters = null,
  }) {
    return _then(_$SmartDistanceThresholdsImpl(
      veryFarMeters: null == veryFarMeters
          ? _value.veryFarMeters
          : veryFarMeters // ignore: cast_nullable_to_non_nullable
              as double,
      farMeters: null == farMeters
          ? _value.farMeters
          : farMeters // ignore: cast_nullable_to_non_nullable
              as double,
      nearMeters: null == nearMeters
          ? _value.nearMeters
          : nearMeters // ignore: cast_nullable_to_non_nullable
              as double,
      veryNearMeters: null == veryNearMeters
          ? _value.veryNearMeters
          : veryNearMeters // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SmartDistanceThresholdsImpl extends _SmartDistanceThresholds {
  const _$SmartDistanceThresholdsImpl(
      {this.veryFarMeters = 5000,
      this.farMeters = 2000,
      this.nearMeters = 500,
      this.veryNearMeters = 100})
      : super._();

  factory _$SmartDistanceThresholdsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartDistanceThresholdsImplFromJson(json);

  /// 非常远的距离（米）
  @override
  @JsonKey()
  final double veryFarMeters;

  /// 远距离（米）
  @override
  @JsonKey()
  final double farMeters;

  /// 中等距离（米）
  @override
  @JsonKey()
  final double nearMeters;

  /// 非常近的距离（米）
  @override
  @JsonKey()
  final double veryNearMeters;

  @override
  String toString() {
    return 'SmartDistanceThresholds(veryFarMeters: $veryFarMeters, farMeters: $farMeters, nearMeters: $nearMeters, veryNearMeters: $veryNearMeters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartDistanceThresholdsImpl &&
            (identical(other.veryFarMeters, veryFarMeters) ||
                other.veryFarMeters == veryFarMeters) &&
            (identical(other.farMeters, farMeters) ||
                other.farMeters == farMeters) &&
            (identical(other.nearMeters, nearMeters) ||
                other.nearMeters == nearMeters) &&
            (identical(other.veryNearMeters, veryNearMeters) ||
                other.veryNearMeters == veryNearMeters));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, veryFarMeters, farMeters, nearMeters, veryNearMeters);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartDistanceThresholdsImplCopyWith<_$SmartDistanceThresholdsImpl>
      get copyWith => __$$SmartDistanceThresholdsImplCopyWithImpl<
          _$SmartDistanceThresholdsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartDistanceThresholdsImplToJson(
      this,
    );
  }
}

abstract class _SmartDistanceThresholds extends SmartDistanceThresholds {
  const factory _SmartDistanceThresholds(
      {final double veryFarMeters,
      final double farMeters,
      final double nearMeters,
      final double veryNearMeters}) = _$SmartDistanceThresholdsImpl;
  const _SmartDistanceThresholds._() : super._();

  factory _SmartDistanceThresholds.fromJson(Map<String, dynamic> json) =
      _$SmartDistanceThresholdsImpl.fromJson;

  @override

  /// 非常远的距离（米）
  double get veryFarMeters;
  @override

  /// 远距离（米）
  double get farMeters;
  @override

  /// 中等距离（米）
  double get nearMeters;
  @override

  /// 非常近的距离（米）
  double get veryNearMeters;
  @override
  @JsonKey(ignore: true)
  _$$SmartDistanceThresholdsImplCopyWith<_$SmartDistanceThresholdsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LocationServiceStatus _$LocationServiceStatusFromJson(
    Map<String, dynamic> json) {
  return _LocationServiceStatus.fromJson(json);
}

/// @nodoc
mixin _$LocationServiceStatus {
  /// 是否正在监控
  bool get isMonitoring => throw _privateConstructorUsedError;

  /// 活跃提醒数量
  int get activeRemindersCount => throw _privateConstructorUsedError;

  /// 当前使用的配置
  LocationBatteryConfig get config => throw _privateConstructorUsedError;

  /// 最后更新时间
  DateTime? get lastUpdateTime => throw _privateConstructorUsedError;

  /// 当前电池优化状态
  BatteryOptimizationMode get currentMode => throw _privateConstructorUsedError;

  /// 预估电池使用情况（每小时百分比）
  double get estimatedBatteryPerHour => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocationServiceStatusCopyWith<LocationServiceStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationServiceStatusCopyWith<$Res> {
  factory $LocationServiceStatusCopyWith(LocationServiceStatus value,
          $Res Function(LocationServiceStatus) then) =
      _$LocationServiceStatusCopyWithImpl<$Res, LocationServiceStatus>;
  @useResult
  $Res call(
      {bool isMonitoring,
      int activeRemindersCount,
      LocationBatteryConfig config,
      DateTime? lastUpdateTime,
      BatteryOptimizationMode currentMode,
      double estimatedBatteryPerHour});

  $LocationBatteryConfigCopyWith<$Res> get config;
}

/// @nodoc
class _$LocationServiceStatusCopyWithImpl<$Res,
        $Val extends LocationServiceStatus>
    implements $LocationServiceStatusCopyWith<$Res> {
  _$LocationServiceStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isMonitoring = null,
    Object? activeRemindersCount = null,
    Object? config = null,
    Object? lastUpdateTime = freezed,
    Object? currentMode = null,
    Object? estimatedBatteryPerHour = null,
  }) {
    return _then(_value.copyWith(
      isMonitoring: null == isMonitoring
          ? _value.isMonitoring
          : isMonitoring // ignore: cast_nullable_to_non_nullable
              as bool,
      activeRemindersCount: null == activeRemindersCount
          ? _value.activeRemindersCount
          : activeRemindersCount // ignore: cast_nullable_to_non_nullable
              as int,
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as LocationBatteryConfig,
      lastUpdateTime: freezed == lastUpdateTime
          ? _value.lastUpdateTime
          : lastUpdateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentMode: null == currentMode
          ? _value.currentMode
          : currentMode // ignore: cast_nullable_to_non_nullable
              as BatteryOptimizationMode,
      estimatedBatteryPerHour: null == estimatedBatteryPerHour
          ? _value.estimatedBatteryPerHour
          : estimatedBatteryPerHour // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LocationBatteryConfigCopyWith<$Res> get config {
    return $LocationBatteryConfigCopyWith<$Res>(_value.config, (value) {
      return _then(_value.copyWith(config: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LocationServiceStatusImplCopyWith<$Res>
    implements $LocationServiceStatusCopyWith<$Res> {
  factory _$$LocationServiceStatusImplCopyWith(
          _$LocationServiceStatusImpl value,
          $Res Function(_$LocationServiceStatusImpl) then) =
      __$$LocationServiceStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isMonitoring,
      int activeRemindersCount,
      LocationBatteryConfig config,
      DateTime? lastUpdateTime,
      BatteryOptimizationMode currentMode,
      double estimatedBatteryPerHour});

  @override
  $LocationBatteryConfigCopyWith<$Res> get config;
}

/// @nodoc
class __$$LocationServiceStatusImplCopyWithImpl<$Res>
    extends _$LocationServiceStatusCopyWithImpl<$Res,
        _$LocationServiceStatusImpl>
    implements _$$LocationServiceStatusImplCopyWith<$Res> {
  __$$LocationServiceStatusImplCopyWithImpl(_$LocationServiceStatusImpl _value,
      $Res Function(_$LocationServiceStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isMonitoring = null,
    Object? activeRemindersCount = null,
    Object? config = null,
    Object? lastUpdateTime = freezed,
    Object? currentMode = null,
    Object? estimatedBatteryPerHour = null,
  }) {
    return _then(_$LocationServiceStatusImpl(
      isMonitoring: null == isMonitoring
          ? _value.isMonitoring
          : isMonitoring // ignore: cast_nullable_to_non_nullable
              as bool,
      activeRemindersCount: null == activeRemindersCount
          ? _value.activeRemindersCount
          : activeRemindersCount // ignore: cast_nullable_to_non_nullable
              as int,
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as LocationBatteryConfig,
      lastUpdateTime: freezed == lastUpdateTime
          ? _value.lastUpdateTime
          : lastUpdateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentMode: null == currentMode
          ? _value.currentMode
          : currentMode // ignore: cast_nullable_to_non_nullable
              as BatteryOptimizationMode,
      estimatedBatteryPerHour: null == estimatedBatteryPerHour
          ? _value.estimatedBatteryPerHour
          : estimatedBatteryPerHour // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationServiceStatusImpl extends _LocationServiceStatus {
  const _$LocationServiceStatusImpl(
      {this.isMonitoring = false,
      this.activeRemindersCount = 0,
      required this.config,
      this.lastUpdateTime,
      this.currentMode = BatteryOptimizationMode.balanced,
      this.estimatedBatteryPerHour = 2.0})
      : super._();

  factory _$LocationServiceStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationServiceStatusImplFromJson(json);

  /// 是否正在监控
  @override
  @JsonKey()
  final bool isMonitoring;

  /// 活跃提醒数量
  @override
  @JsonKey()
  final int activeRemindersCount;

  /// 当前使用的配置
  @override
  final LocationBatteryConfig config;

  /// 最后更新时间
  @override
  final DateTime? lastUpdateTime;

  /// 当前电池优化状态
  @override
  @JsonKey()
  final BatteryOptimizationMode currentMode;

  /// 预估电池使用情况（每小时百分比）
  @override
  @JsonKey()
  final double estimatedBatteryPerHour;

  @override
  String toString() {
    return 'LocationServiceStatus(isMonitoring: $isMonitoring, activeRemindersCount: $activeRemindersCount, config: $config, lastUpdateTime: $lastUpdateTime, currentMode: $currentMode, estimatedBatteryPerHour: $estimatedBatteryPerHour)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationServiceStatusImpl &&
            (identical(other.isMonitoring, isMonitoring) ||
                other.isMonitoring == isMonitoring) &&
            (identical(other.activeRemindersCount, activeRemindersCount) ||
                other.activeRemindersCount == activeRemindersCount) &&
            (identical(other.config, config) || other.config == config) &&
            (identical(other.lastUpdateTime, lastUpdateTime) ||
                other.lastUpdateTime == lastUpdateTime) &&
            (identical(other.currentMode, currentMode) ||
                other.currentMode == currentMode) &&
            (identical(
                    other.estimatedBatteryPerHour, estimatedBatteryPerHour) ||
                other.estimatedBatteryPerHour == estimatedBatteryPerHour));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isMonitoring,
      activeRemindersCount,
      config,
      lastUpdateTime,
      currentMode,
      estimatedBatteryPerHour);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationServiceStatusImplCopyWith<_$LocationServiceStatusImpl>
      get copyWith => __$$LocationServiceStatusImplCopyWithImpl<
          _$LocationServiceStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationServiceStatusImplToJson(
      this,
    );
  }
}

abstract class _LocationServiceStatus extends LocationServiceStatus {
  const factory _LocationServiceStatus(
      {final bool isMonitoring,
      final int activeRemindersCount,
      required final LocationBatteryConfig config,
      final DateTime? lastUpdateTime,
      final BatteryOptimizationMode currentMode,
      final double estimatedBatteryPerHour}) = _$LocationServiceStatusImpl;
  const _LocationServiceStatus._() : super._();

  factory _LocationServiceStatus.fromJson(Map<String, dynamic> json) =
      _$LocationServiceStatusImpl.fromJson;

  @override

  /// 是否正在监控
  bool get isMonitoring;
  @override

  /// 活跃提醒数量
  int get activeRemindersCount;
  @override

  /// 当前使用的配置
  LocationBatteryConfig get config;
  @override

  /// 最后更新时间
  DateTime? get lastUpdateTime;
  @override

  /// 当前电池优化状态
  BatteryOptimizationMode get currentMode;
  @override

  /// 预估电池使用情况（每小时百分比）
  double get estimatedBatteryPerHour;
  @override
  @JsonKey(ignore: true)
  _$$LocationServiceStatusImplCopyWith<_$LocationServiceStatusImpl>
      get copyWith => throw _privateConstructorUsedError;
}
