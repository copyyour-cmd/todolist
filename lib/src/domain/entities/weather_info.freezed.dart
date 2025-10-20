// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeatherInfo _$WeatherInfoFromJson(Map<String, dynamic> json) {
  return _WeatherInfo.fromJson(json);
}

/// @nodoc
mixin _$WeatherInfo {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  double get latitude => throw _privateConstructorUsedError;
  @HiveField(2)
  double get longitude => throw _privateConstructorUsedError;
  @HiveField(3)
  String get locationName => throw _privateConstructorUsedError;
  @HiveField(4)
  WeatherCondition get condition => throw _privateConstructorUsedError;
  @HiveField(5)
  double get temperature => throw _privateConstructorUsedError;
  @HiveField(6)
  double get feelsLike => throw _privateConstructorUsedError;
  @HiveField(7)
  int get humidity => throw _privateConstructorUsedError;
  @HiveField(8)
  double get windSpeed => throw _privateConstructorUsedError;
  @HiveField(9)
  String get description => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime get fetchedAt => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime get validUntil => throw _privateConstructorUsedError;
  @HiveField(12)
  double? get precipitationProbability =>
      throw _privateConstructorUsedError; // 降水概率 0-100
  @HiveField(13)
  String? get iconCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeatherInfoCopyWith<WeatherInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherInfoCopyWith<$Res> {
  factory $WeatherInfoCopyWith(
          WeatherInfo value, $Res Function(WeatherInfo) then) =
      _$WeatherInfoCopyWithImpl<$Res, WeatherInfo>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) double latitude,
      @HiveField(2) double longitude,
      @HiveField(3) String locationName,
      @HiveField(4) WeatherCondition condition,
      @HiveField(5) double temperature,
      @HiveField(6) double feelsLike,
      @HiveField(7) int humidity,
      @HiveField(8) double windSpeed,
      @HiveField(9) String description,
      @HiveField(10) DateTime fetchedAt,
      @HiveField(11) DateTime validUntil,
      @HiveField(12) double? precipitationProbability,
      @HiveField(13) String? iconCode});
}

/// @nodoc
class _$WeatherInfoCopyWithImpl<$Res, $Val extends WeatherInfo>
    implements $WeatherInfoCopyWith<$Res> {
  _$WeatherInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? locationName = null,
    Object? condition = null,
    Object? temperature = null,
    Object? feelsLike = null,
    Object? humidity = null,
    Object? windSpeed = null,
    Object? description = null,
    Object? fetchedAt = null,
    Object? validUntil = null,
    Object? precipitationProbability = freezed,
    Object? iconCode = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as WeatherCondition,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      feelsLike: null == feelsLike
          ? _value.feelsLike
          : feelsLike // ignore: cast_nullable_to_non_nullable
              as double,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as int,
      windSpeed: null == windSpeed
          ? _value.windSpeed
          : windSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      fetchedAt: null == fetchedAt
          ? _value.fetchedAt
          : fetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      validUntil: null == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
      precipitationProbability: freezed == precipitationProbability
          ? _value.precipitationProbability
          : precipitationProbability // ignore: cast_nullable_to_non_nullable
              as double?,
      iconCode: freezed == iconCode
          ? _value.iconCode
          : iconCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeatherInfoImplCopyWith<$Res>
    implements $WeatherInfoCopyWith<$Res> {
  factory _$$WeatherInfoImplCopyWith(
          _$WeatherInfoImpl value, $Res Function(_$WeatherInfoImpl) then) =
      __$$WeatherInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) double latitude,
      @HiveField(2) double longitude,
      @HiveField(3) String locationName,
      @HiveField(4) WeatherCondition condition,
      @HiveField(5) double temperature,
      @HiveField(6) double feelsLike,
      @HiveField(7) int humidity,
      @HiveField(8) double windSpeed,
      @HiveField(9) String description,
      @HiveField(10) DateTime fetchedAt,
      @HiveField(11) DateTime validUntil,
      @HiveField(12) double? precipitationProbability,
      @HiveField(13) String? iconCode});
}

/// @nodoc
class __$$WeatherInfoImplCopyWithImpl<$Res>
    extends _$WeatherInfoCopyWithImpl<$Res, _$WeatherInfoImpl>
    implements _$$WeatherInfoImplCopyWith<$Res> {
  __$$WeatherInfoImplCopyWithImpl(
      _$WeatherInfoImpl _value, $Res Function(_$WeatherInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? locationName = null,
    Object? condition = null,
    Object? temperature = null,
    Object? feelsLike = null,
    Object? humidity = null,
    Object? windSpeed = null,
    Object? description = null,
    Object? fetchedAt = null,
    Object? validUntil = null,
    Object? precipitationProbability = freezed,
    Object? iconCode = freezed,
  }) {
    return _then(_$WeatherInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as WeatherCondition,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      feelsLike: null == feelsLike
          ? _value.feelsLike
          : feelsLike // ignore: cast_nullable_to_non_nullable
              as double,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as int,
      windSpeed: null == windSpeed
          ? _value.windSpeed
          : windSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      fetchedAt: null == fetchedAt
          ? _value.fetchedAt
          : fetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      validUntil: null == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
      precipitationProbability: freezed == precipitationProbability
          ? _value.precipitationProbability
          : precipitationProbability // ignore: cast_nullable_to_non_nullable
              as double?,
      iconCode: freezed == iconCode
          ? _value.iconCode
          : iconCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherInfoImpl extends _WeatherInfo {
  const _$WeatherInfoImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.latitude,
      @HiveField(2) required this.longitude,
      @HiveField(3) required this.locationName,
      @HiveField(4) required this.condition,
      @HiveField(5) required this.temperature,
      @HiveField(6) required this.feelsLike,
      @HiveField(7) required this.humidity,
      @HiveField(8) required this.windSpeed,
      @HiveField(9) required this.description,
      @HiveField(10) required this.fetchedAt,
      @HiveField(11) required this.validUntil,
      @HiveField(12) this.precipitationProbability,
      @HiveField(13) this.iconCode})
      : super._();

  factory _$WeatherInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherInfoImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final double latitude;
  @override
  @HiveField(2)
  final double longitude;
  @override
  @HiveField(3)
  final String locationName;
  @override
  @HiveField(4)
  final WeatherCondition condition;
  @override
  @HiveField(5)
  final double temperature;
  @override
  @HiveField(6)
  final double feelsLike;
  @override
  @HiveField(7)
  final int humidity;
  @override
  @HiveField(8)
  final double windSpeed;
  @override
  @HiveField(9)
  final String description;
  @override
  @HiveField(10)
  final DateTime fetchedAt;
  @override
  @HiveField(11)
  final DateTime validUntil;
  @override
  @HiveField(12)
  final double? precipitationProbability;
// 降水概率 0-100
  @override
  @HiveField(13)
  final String? iconCode;

  @override
  String toString() {
    return 'WeatherInfo(id: $id, latitude: $latitude, longitude: $longitude, locationName: $locationName, condition: $condition, temperature: $temperature, feelsLike: $feelsLike, humidity: $humidity, windSpeed: $windSpeed, description: $description, fetchedAt: $fetchedAt, validUntil: $validUntil, precipitationProbability: $precipitationProbability, iconCode: $iconCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.feelsLike, feelsLike) ||
                other.feelsLike == feelsLike) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.windSpeed, windSpeed) ||
                other.windSpeed == windSpeed) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.fetchedAt, fetchedAt) ||
                other.fetchedAt == fetchedAt) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(
                    other.precipitationProbability, precipitationProbability) ||
                other.precipitationProbability == precipitationProbability) &&
            (identical(other.iconCode, iconCode) ||
                other.iconCode == iconCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      latitude,
      longitude,
      locationName,
      condition,
      temperature,
      feelsLike,
      humidity,
      windSpeed,
      description,
      fetchedAt,
      validUntil,
      precipitationProbability,
      iconCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherInfoImplCopyWith<_$WeatherInfoImpl> get copyWith =>
      __$$WeatherInfoImplCopyWithImpl<_$WeatherInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherInfoImplToJson(
      this,
    );
  }
}

abstract class _WeatherInfo extends WeatherInfo {
  const factory _WeatherInfo(
      {@HiveField(0) required final String id,
      @HiveField(1) required final double latitude,
      @HiveField(2) required final double longitude,
      @HiveField(3) required final String locationName,
      @HiveField(4) required final WeatherCondition condition,
      @HiveField(5) required final double temperature,
      @HiveField(6) required final double feelsLike,
      @HiveField(7) required final int humidity,
      @HiveField(8) required final double windSpeed,
      @HiveField(9) required final String description,
      @HiveField(10) required final DateTime fetchedAt,
      @HiveField(11) required final DateTime validUntil,
      @HiveField(12) final double? precipitationProbability,
      @HiveField(13) final String? iconCode}) = _$WeatherInfoImpl;
  const _WeatherInfo._() : super._();

  factory _WeatherInfo.fromJson(Map<String, dynamic> json) =
      _$WeatherInfoImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  double get latitude;
  @override
  @HiveField(2)
  double get longitude;
  @override
  @HiveField(3)
  String get locationName;
  @override
  @HiveField(4)
  WeatherCondition get condition;
  @override
  @HiveField(5)
  double get temperature;
  @override
  @HiveField(6)
  double get feelsLike;
  @override
  @HiveField(7)
  int get humidity;
  @override
  @HiveField(8)
  double get windSpeed;
  @override
  @HiveField(9)
  String get description;
  @override
  @HiveField(10)
  DateTime get fetchedAt;
  @override
  @HiveField(11)
  DateTime get validUntil;
  @override
  @HiveField(12)
  double? get precipitationProbability;
  @override // 降水概率 0-100
  @HiveField(13)
  String? get iconCode;
  @override
  @JsonKey(ignore: true)
  _$$WeatherInfoImplCopyWith<_$WeatherInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeatherTrigger _$WeatherTriggerFromJson(Map<String, dynamic> json) {
  return _WeatherTrigger.fromJson(json);
}

/// @nodoc
mixin _$WeatherTrigger {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get taskId => throw _privateConstructorUsedError;
  @HiveField(2)
  List<WeatherCondition> get conditions => throw _privateConstructorUsedError;
  @HiveField(3)
  bool get enabled => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime? get lastTriggeredAt =>
      throw _privateConstructorUsedError; // 温度范围触发（可选）
  @HiveField(6)
  double? get minTemperature => throw _privateConstructorUsedError;
  @HiveField(7)
  double? get maxTemperature =>
      throw _privateConstructorUsedError; // 降水概率触发（可选）
  @HiveField(8)
  double? get minPrecipitationProbability => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeatherTriggerCopyWith<WeatherTrigger> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherTriggerCopyWith<$Res> {
  factory $WeatherTriggerCopyWith(
          WeatherTrigger value, $Res Function(WeatherTrigger) then) =
      _$WeatherTriggerCopyWithImpl<$Res, WeatherTrigger>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String taskId,
      @HiveField(2) List<WeatherCondition> conditions,
      @HiveField(3) bool enabled,
      @HiveField(4) DateTime createdAt,
      @HiveField(5) DateTime? lastTriggeredAt,
      @HiveField(6) double? minTemperature,
      @HiveField(7) double? maxTemperature,
      @HiveField(8) double? minPrecipitationProbability});
}

/// @nodoc
class _$WeatherTriggerCopyWithImpl<$Res, $Val extends WeatherTrigger>
    implements $WeatherTriggerCopyWith<$Res> {
  _$WeatherTriggerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? conditions = null,
    Object? enabled = null,
    Object? createdAt = null,
    Object? lastTriggeredAt = freezed,
    Object? minTemperature = freezed,
    Object? maxTemperature = freezed,
    Object? minPrecipitationProbability = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      conditions: null == conditions
          ? _value.conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<WeatherCondition>,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastTriggeredAt: freezed == lastTriggeredAt
          ? _value.lastTriggeredAt
          : lastTriggeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      minTemperature: freezed == minTemperature
          ? _value.minTemperature
          : minTemperature // ignore: cast_nullable_to_non_nullable
              as double?,
      maxTemperature: freezed == maxTemperature
          ? _value.maxTemperature
          : maxTemperature // ignore: cast_nullable_to_non_nullable
              as double?,
      minPrecipitationProbability: freezed == minPrecipitationProbability
          ? _value.minPrecipitationProbability
          : minPrecipitationProbability // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeatherTriggerImplCopyWith<$Res>
    implements $WeatherTriggerCopyWith<$Res> {
  factory _$$WeatherTriggerImplCopyWith(_$WeatherTriggerImpl value,
          $Res Function(_$WeatherTriggerImpl) then) =
      __$$WeatherTriggerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String taskId,
      @HiveField(2) List<WeatherCondition> conditions,
      @HiveField(3) bool enabled,
      @HiveField(4) DateTime createdAt,
      @HiveField(5) DateTime? lastTriggeredAt,
      @HiveField(6) double? minTemperature,
      @HiveField(7) double? maxTemperature,
      @HiveField(8) double? minPrecipitationProbability});
}

/// @nodoc
class __$$WeatherTriggerImplCopyWithImpl<$Res>
    extends _$WeatherTriggerCopyWithImpl<$Res, _$WeatherTriggerImpl>
    implements _$$WeatherTriggerImplCopyWith<$Res> {
  __$$WeatherTriggerImplCopyWithImpl(
      _$WeatherTriggerImpl _value, $Res Function(_$WeatherTriggerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? conditions = null,
    Object? enabled = null,
    Object? createdAt = null,
    Object? lastTriggeredAt = freezed,
    Object? minTemperature = freezed,
    Object? maxTemperature = freezed,
    Object? minPrecipitationProbability = freezed,
  }) {
    return _then(_$WeatherTriggerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      conditions: null == conditions
          ? _value._conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<WeatherCondition>,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastTriggeredAt: freezed == lastTriggeredAt
          ? _value.lastTriggeredAt
          : lastTriggeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      minTemperature: freezed == minTemperature
          ? _value.minTemperature
          : minTemperature // ignore: cast_nullable_to_non_nullable
              as double?,
      maxTemperature: freezed == maxTemperature
          ? _value.maxTemperature
          : maxTemperature // ignore: cast_nullable_to_non_nullable
              as double?,
      minPrecipitationProbability: freezed == minPrecipitationProbability
          ? _value.minPrecipitationProbability
          : minPrecipitationProbability // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherTriggerImpl extends _WeatherTrigger {
  const _$WeatherTriggerImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.taskId,
      @HiveField(2) required final List<WeatherCondition> conditions,
      @HiveField(3) this.enabled = true,
      @HiveField(4) required this.createdAt,
      @HiveField(5) this.lastTriggeredAt,
      @HiveField(6) this.minTemperature,
      @HiveField(7) this.maxTemperature,
      @HiveField(8) this.minPrecipitationProbability})
      : _conditions = conditions,
        super._();

  factory _$WeatherTriggerImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherTriggerImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String taskId;
  final List<WeatherCondition> _conditions;
  @override
  @HiveField(2)
  List<WeatherCondition> get conditions {
    if (_conditions is EqualUnmodifiableListView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conditions);
  }

  @override
  @JsonKey()
  @HiveField(3)
  final bool enabled;
  @override
  @HiveField(4)
  final DateTime createdAt;
  @override
  @HiveField(5)
  final DateTime? lastTriggeredAt;
// 温度范围触发（可选）
  @override
  @HiveField(6)
  final double? minTemperature;
  @override
  @HiveField(7)
  final double? maxTemperature;
// 降水概率触发（可选）
  @override
  @HiveField(8)
  final double? minPrecipitationProbability;

  @override
  String toString() {
    return 'WeatherTrigger(id: $id, taskId: $taskId, conditions: $conditions, enabled: $enabled, createdAt: $createdAt, lastTriggeredAt: $lastTriggeredAt, minTemperature: $minTemperature, maxTemperature: $maxTemperature, minPrecipitationProbability: $minPrecipitationProbability)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherTriggerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            const DeepCollectionEquality()
                .equals(other._conditions, _conditions) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastTriggeredAt, lastTriggeredAt) ||
                other.lastTriggeredAt == lastTriggeredAt) &&
            (identical(other.minTemperature, minTemperature) ||
                other.minTemperature == minTemperature) &&
            (identical(other.maxTemperature, maxTemperature) ||
                other.maxTemperature == maxTemperature) &&
            (identical(other.minPrecipitationProbability,
                    minPrecipitationProbability) ||
                other.minPrecipitationProbability ==
                    minPrecipitationProbability));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      taskId,
      const DeepCollectionEquality().hash(_conditions),
      enabled,
      createdAt,
      lastTriggeredAt,
      minTemperature,
      maxTemperature,
      minPrecipitationProbability);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherTriggerImplCopyWith<_$WeatherTriggerImpl> get copyWith =>
      __$$WeatherTriggerImplCopyWithImpl<_$WeatherTriggerImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherTriggerImplToJson(
      this,
    );
  }
}

abstract class _WeatherTrigger extends WeatherTrigger {
  const factory _WeatherTrigger(
          {@HiveField(0) required final String id,
          @HiveField(1) required final String taskId,
          @HiveField(2) required final List<WeatherCondition> conditions,
          @HiveField(3) final bool enabled,
          @HiveField(4) required final DateTime createdAt,
          @HiveField(5) final DateTime? lastTriggeredAt,
          @HiveField(6) final double? minTemperature,
          @HiveField(7) final double? maxTemperature,
          @HiveField(8) final double? minPrecipitationProbability}) =
      _$WeatherTriggerImpl;
  const _WeatherTrigger._() : super._();

  factory _WeatherTrigger.fromJson(Map<String, dynamic> json) =
      _$WeatherTriggerImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get taskId;
  @override
  @HiveField(2)
  List<WeatherCondition> get conditions;
  @override
  @HiveField(3)
  bool get enabled;
  @override
  @HiveField(4)
  DateTime get createdAt;
  @override
  @HiveField(5)
  DateTime? get lastTriggeredAt;
  @override // 温度范围触发（可选）
  @HiveField(6)
  double? get minTemperature;
  @override
  @HiveField(7)
  double? get maxTemperature;
  @override // 降水概率触发（可选）
  @HiveField(8)
  double? get minPrecipitationProbability;
  @override
  @JsonKey(ignore: true)
  _$$WeatherTriggerImplCopyWith<_$WeatherTriggerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
