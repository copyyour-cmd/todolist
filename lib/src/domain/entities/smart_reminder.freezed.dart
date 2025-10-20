// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocationTrigger _$LocationTriggerFromJson(Map<String, dynamic> json) {
  return _LocationTrigger.fromJson(json);
}

/// @nodoc
mixin _$LocationTrigger {
  @HiveField(0)
  double get latitude => throw _privateConstructorUsedError;
  @HiveField(1)
  double get longitude => throw _privateConstructorUsedError;
  @HiveField(2)
  double get radiusMeters => throw _privateConstructorUsedError;
  @HiveField(3)
  String get placeName => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get placeAddress => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocationTriggerCopyWith<LocationTrigger> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationTriggerCopyWith<$Res> {
  factory $LocationTriggerCopyWith(
          LocationTrigger value, $Res Function(LocationTrigger) then) =
      _$LocationTriggerCopyWithImpl<$Res, LocationTrigger>;
  @useResult
  $Res call(
      {@HiveField(0) double latitude,
      @HiveField(1) double longitude,
      @HiveField(2) double radiusMeters,
      @HiveField(3) String placeName,
      @HiveField(4) String? placeAddress});
}

/// @nodoc
class _$LocationTriggerCopyWithImpl<$Res, $Val extends LocationTrigger>
    implements $LocationTriggerCopyWith<$Res> {
  _$LocationTriggerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? radiusMeters = null,
    Object? placeName = null,
    Object? placeAddress = freezed,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      radiusMeters: null == radiusMeters
          ? _value.radiusMeters
          : radiusMeters // ignore: cast_nullable_to_non_nullable
              as double,
      placeName: null == placeName
          ? _value.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String,
      placeAddress: freezed == placeAddress
          ? _value.placeAddress
          : placeAddress // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationTriggerImplCopyWith<$Res>
    implements $LocationTriggerCopyWith<$Res> {
  factory _$$LocationTriggerImplCopyWith(_$LocationTriggerImpl value,
          $Res Function(_$LocationTriggerImpl) then) =
      __$$LocationTriggerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) double latitude,
      @HiveField(1) double longitude,
      @HiveField(2) double radiusMeters,
      @HiveField(3) String placeName,
      @HiveField(4) String? placeAddress});
}

/// @nodoc
class __$$LocationTriggerImplCopyWithImpl<$Res>
    extends _$LocationTriggerCopyWithImpl<$Res, _$LocationTriggerImpl>
    implements _$$LocationTriggerImplCopyWith<$Res> {
  __$$LocationTriggerImplCopyWithImpl(
      _$LocationTriggerImpl _value, $Res Function(_$LocationTriggerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? radiusMeters = null,
    Object? placeName = null,
    Object? placeAddress = freezed,
  }) {
    return _then(_$LocationTriggerImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      radiusMeters: null == radiusMeters
          ? _value.radiusMeters
          : radiusMeters // ignore: cast_nullable_to_non_nullable
              as double,
      placeName: null == placeName
          ? _value.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String,
      placeAddress: freezed == placeAddress
          ? _value.placeAddress
          : placeAddress // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationTriggerImpl extends _LocationTrigger {
  const _$LocationTriggerImpl(
      {@HiveField(0) required this.latitude,
      @HiveField(1) required this.longitude,
      @HiveField(2) required this.radiusMeters,
      @HiveField(3) required this.placeName,
      @HiveField(4) this.placeAddress})
      : super._();

  factory _$LocationTriggerImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationTriggerImplFromJson(json);

  @override
  @HiveField(0)
  final double latitude;
  @override
  @HiveField(1)
  final double longitude;
  @override
  @HiveField(2)
  final double radiusMeters;
  @override
  @HiveField(3)
  final String placeName;
  @override
  @HiveField(4)
  final String? placeAddress;

  @override
  String toString() {
    return 'LocationTrigger(latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters, placeName: $placeName, placeAddress: $placeAddress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationTriggerImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.radiusMeters, radiusMeters) ||
                other.radiusMeters == radiusMeters) &&
            (identical(other.placeName, placeName) ||
                other.placeName == placeName) &&
            (identical(other.placeAddress, placeAddress) ||
                other.placeAddress == placeAddress));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, latitude, longitude, radiusMeters, placeName, placeAddress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationTriggerImplCopyWith<_$LocationTriggerImpl> get copyWith =>
      __$$LocationTriggerImplCopyWithImpl<_$LocationTriggerImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationTriggerImplToJson(
      this,
    );
  }
}

abstract class _LocationTrigger extends LocationTrigger {
  const factory _LocationTrigger(
      {@HiveField(0) required final double latitude,
      @HiveField(1) required final double longitude,
      @HiveField(2) required final double radiusMeters,
      @HiveField(3) required final String placeName,
      @HiveField(4) final String? placeAddress}) = _$LocationTriggerImpl;
  const _LocationTrigger._() : super._();

  factory _LocationTrigger.fromJson(Map<String, dynamic> json) =
      _$LocationTriggerImpl.fromJson;

  @override
  @HiveField(0)
  double get latitude;
  @override
  @HiveField(1)
  double get longitude;
  @override
  @HiveField(2)
  double get radiusMeters;
  @override
  @HiveField(3)
  String get placeName;
  @override
  @HiveField(4)
  String? get placeAddress;
  @override
  @JsonKey(ignore: true)
  _$$LocationTriggerImplCopyWith<_$LocationTriggerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RepeatConfig _$RepeatConfigFromJson(Map<String, dynamic> json) {
  return _RepeatConfig.fromJson(json);
}

/// @nodoc
mixin _$RepeatConfig {
  @HiveField(0)
  int get intervalMinutes => throw _privateConstructorUsedError;
  @HiveField(1)
  int get maxRepeats => throw _privateConstructorUsedError;
  @HiveField(2)
  int get currentCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RepeatConfigCopyWith<RepeatConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepeatConfigCopyWith<$Res> {
  factory $RepeatConfigCopyWith(
          RepeatConfig value, $Res Function(RepeatConfig) then) =
      _$RepeatConfigCopyWithImpl<$Res, RepeatConfig>;
  @useResult
  $Res call(
      {@HiveField(0) int intervalMinutes,
      @HiveField(1) int maxRepeats,
      @HiveField(2) int currentCount});
}

/// @nodoc
class _$RepeatConfigCopyWithImpl<$Res, $Val extends RepeatConfig>
    implements $RepeatConfigCopyWith<$Res> {
  _$RepeatConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intervalMinutes = null,
    Object? maxRepeats = null,
    Object? currentCount = null,
  }) {
    return _then(_value.copyWith(
      intervalMinutes: null == intervalMinutes
          ? _value.intervalMinutes
          : intervalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      maxRepeats: null == maxRepeats
          ? _value.maxRepeats
          : maxRepeats // ignore: cast_nullable_to_non_nullable
              as int,
      currentCount: null == currentCount
          ? _value.currentCount
          : currentCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RepeatConfigImplCopyWith<$Res>
    implements $RepeatConfigCopyWith<$Res> {
  factory _$$RepeatConfigImplCopyWith(
          _$RepeatConfigImpl value, $Res Function(_$RepeatConfigImpl) then) =
      __$$RepeatConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int intervalMinutes,
      @HiveField(1) int maxRepeats,
      @HiveField(2) int currentCount});
}

/// @nodoc
class __$$RepeatConfigImplCopyWithImpl<$Res>
    extends _$RepeatConfigCopyWithImpl<$Res, _$RepeatConfigImpl>
    implements _$$RepeatConfigImplCopyWith<$Res> {
  __$$RepeatConfigImplCopyWithImpl(
      _$RepeatConfigImpl _value, $Res Function(_$RepeatConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intervalMinutes = null,
    Object? maxRepeats = null,
    Object? currentCount = null,
  }) {
    return _then(_$RepeatConfigImpl(
      intervalMinutes: null == intervalMinutes
          ? _value.intervalMinutes
          : intervalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      maxRepeats: null == maxRepeats
          ? _value.maxRepeats
          : maxRepeats // ignore: cast_nullable_to_non_nullable
              as int,
      currentCount: null == currentCount
          ? _value.currentCount
          : currentCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RepeatConfigImpl extends _RepeatConfig {
  const _$RepeatConfigImpl(
      {@HiveField(0) required this.intervalMinutes,
      @HiveField(1) required this.maxRepeats,
      @HiveField(2) this.currentCount = 0})
      : super._();

  factory _$RepeatConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$RepeatConfigImplFromJson(json);

  @override
  @HiveField(0)
  final int intervalMinutes;
  @override
  @HiveField(1)
  final int maxRepeats;
  @override
  @JsonKey()
  @HiveField(2)
  final int currentCount;

  @override
  String toString() {
    return 'RepeatConfig(intervalMinutes: $intervalMinutes, maxRepeats: $maxRepeats, currentCount: $currentCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepeatConfigImpl &&
            (identical(other.intervalMinutes, intervalMinutes) ||
                other.intervalMinutes == intervalMinutes) &&
            (identical(other.maxRepeats, maxRepeats) ||
                other.maxRepeats == maxRepeats) &&
            (identical(other.currentCount, currentCount) ||
                other.currentCount == currentCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, intervalMinutes, maxRepeats, currentCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RepeatConfigImplCopyWith<_$RepeatConfigImpl> get copyWith =>
      __$$RepeatConfigImplCopyWithImpl<_$RepeatConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RepeatConfigImplToJson(
      this,
    );
  }
}

abstract class _RepeatConfig extends RepeatConfig {
  const factory _RepeatConfig(
      {@HiveField(0) required final int intervalMinutes,
      @HiveField(1) required final int maxRepeats,
      @HiveField(2) final int currentCount}) = _$RepeatConfigImpl;
  const _RepeatConfig._() : super._();

  factory _RepeatConfig.fromJson(Map<String, dynamic> json) =
      _$RepeatConfigImpl.fromJson;

  @override
  @HiveField(0)
  int get intervalMinutes;
  @override
  @HiveField(1)
  int get maxRepeats;
  @override
  @HiveField(2)
  int get currentCount;
  @override
  @JsonKey(ignore: true)
  _$$RepeatConfigImplCopyWith<_$RepeatConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SmartReminder _$SmartReminderFromJson(Map<String, dynamic> json) {
  return _SmartReminder.fromJson(json);
}

/// @nodoc
mixin _$SmartReminder {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get taskId => throw _privateConstructorUsedError;
  @HiveField(2)
  ReminderType get type => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  @HiveField(4)
  LocationTrigger? get locationTrigger => throw _privateConstructorUsedError;
  @HiveField(5)
  RepeatConfig? get repeatConfig => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime? get lastTriggeredAt => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SmartReminderCopyWith<SmartReminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartReminderCopyWith<$Res> {
  factory $SmartReminderCopyWith(
          SmartReminder value, $Res Function(SmartReminder) then) =
      _$SmartReminderCopyWithImpl<$Res, SmartReminder>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String taskId,
      @HiveField(2) ReminderType type,
      @HiveField(6) DateTime createdAt,
      @HiveField(3) DateTime? scheduledAt,
      @HiveField(4) LocationTrigger? locationTrigger,
      @HiveField(5) RepeatConfig? repeatConfig,
      @HiveField(7) DateTime? lastTriggeredAt,
      @HiveField(8) bool isActive});

  $LocationTriggerCopyWith<$Res>? get locationTrigger;
  $RepeatConfigCopyWith<$Res>? get repeatConfig;
}

/// @nodoc
class _$SmartReminderCopyWithImpl<$Res, $Val extends SmartReminder>
    implements $SmartReminderCopyWith<$Res> {
  _$SmartReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? type = null,
    Object? createdAt = null,
    Object? scheduledAt = freezed,
    Object? locationTrigger = freezed,
    Object? repeatConfig = freezed,
    Object? lastTriggeredAt = freezed,
    Object? isActive = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReminderType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      locationTrigger: freezed == locationTrigger
          ? _value.locationTrigger
          : locationTrigger // ignore: cast_nullable_to_non_nullable
              as LocationTrigger?,
      repeatConfig: freezed == repeatConfig
          ? _value.repeatConfig
          : repeatConfig // ignore: cast_nullable_to_non_nullable
              as RepeatConfig?,
      lastTriggeredAt: freezed == lastTriggeredAt
          ? _value.lastTriggeredAt
          : lastTriggeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LocationTriggerCopyWith<$Res>? get locationTrigger {
    if (_value.locationTrigger == null) {
      return null;
    }

    return $LocationTriggerCopyWith<$Res>(_value.locationTrigger!, (value) {
      return _then(_value.copyWith(locationTrigger: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $RepeatConfigCopyWith<$Res>? get repeatConfig {
    if (_value.repeatConfig == null) {
      return null;
    }

    return $RepeatConfigCopyWith<$Res>(_value.repeatConfig!, (value) {
      return _then(_value.copyWith(repeatConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SmartReminderImplCopyWith<$Res>
    implements $SmartReminderCopyWith<$Res> {
  factory _$$SmartReminderImplCopyWith(
          _$SmartReminderImpl value, $Res Function(_$SmartReminderImpl) then) =
      __$$SmartReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String taskId,
      @HiveField(2) ReminderType type,
      @HiveField(6) DateTime createdAt,
      @HiveField(3) DateTime? scheduledAt,
      @HiveField(4) LocationTrigger? locationTrigger,
      @HiveField(5) RepeatConfig? repeatConfig,
      @HiveField(7) DateTime? lastTriggeredAt,
      @HiveField(8) bool isActive});

  @override
  $LocationTriggerCopyWith<$Res>? get locationTrigger;
  @override
  $RepeatConfigCopyWith<$Res>? get repeatConfig;
}

/// @nodoc
class __$$SmartReminderImplCopyWithImpl<$Res>
    extends _$SmartReminderCopyWithImpl<$Res, _$SmartReminderImpl>
    implements _$$SmartReminderImplCopyWith<$Res> {
  __$$SmartReminderImplCopyWithImpl(
      _$SmartReminderImpl _value, $Res Function(_$SmartReminderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? type = null,
    Object? createdAt = null,
    Object? scheduledAt = freezed,
    Object? locationTrigger = freezed,
    Object? repeatConfig = freezed,
    Object? lastTriggeredAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_$SmartReminderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReminderType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      locationTrigger: freezed == locationTrigger
          ? _value.locationTrigger
          : locationTrigger // ignore: cast_nullable_to_non_nullable
              as LocationTrigger?,
      repeatConfig: freezed == repeatConfig
          ? _value.repeatConfig
          : repeatConfig // ignore: cast_nullable_to_non_nullable
              as RepeatConfig?,
      lastTriggeredAt: freezed == lastTriggeredAt
          ? _value.lastTriggeredAt
          : lastTriggeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SmartReminderImpl extends _SmartReminder {
  const _$SmartReminderImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.taskId,
      @HiveField(2) required this.type,
      @HiveField(6) required this.createdAt,
      @HiveField(3) this.scheduledAt,
      @HiveField(4) this.locationTrigger,
      @HiveField(5) this.repeatConfig,
      @HiveField(7) this.lastTriggeredAt,
      @HiveField(8) this.isActive = true})
      : super._();

  factory _$SmartReminderImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartReminderImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String taskId;
  @override
  @HiveField(2)
  final ReminderType type;
  @override
  @HiveField(6)
  final DateTime createdAt;
  @override
  @HiveField(3)
  final DateTime? scheduledAt;
  @override
  @HiveField(4)
  final LocationTrigger? locationTrigger;
  @override
  @HiveField(5)
  final RepeatConfig? repeatConfig;
  @override
  @HiveField(7)
  final DateTime? lastTriggeredAt;
  @override
  @JsonKey()
  @HiveField(8)
  final bool isActive;

  @override
  String toString() {
    return 'SmartReminder(id: $id, taskId: $taskId, type: $type, createdAt: $createdAt, scheduledAt: $scheduledAt, locationTrigger: $locationTrigger, repeatConfig: $repeatConfig, lastTriggeredAt: $lastTriggeredAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartReminderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.locationTrigger, locationTrigger) ||
                other.locationTrigger == locationTrigger) &&
            (identical(other.repeatConfig, repeatConfig) ||
                other.repeatConfig == repeatConfig) &&
            (identical(other.lastTriggeredAt, lastTriggeredAt) ||
                other.lastTriggeredAt == lastTriggeredAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, taskId, type, createdAt,
      scheduledAt, locationTrigger, repeatConfig, lastTriggeredAt, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartReminderImplCopyWith<_$SmartReminderImpl> get copyWith =>
      __$$SmartReminderImplCopyWithImpl<_$SmartReminderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartReminderImplToJson(
      this,
    );
  }
}

abstract class _SmartReminder extends SmartReminder {
  const factory _SmartReminder(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String taskId,
      @HiveField(2) required final ReminderType type,
      @HiveField(6) required final DateTime createdAt,
      @HiveField(3) final DateTime? scheduledAt,
      @HiveField(4) final LocationTrigger? locationTrigger,
      @HiveField(5) final RepeatConfig? repeatConfig,
      @HiveField(7) final DateTime? lastTriggeredAt,
      @HiveField(8) final bool isActive}) = _$SmartReminderImpl;
  const _SmartReminder._() : super._();

  factory _SmartReminder.fromJson(Map<String, dynamic> json) =
      _$SmartReminderImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get taskId;
  @override
  @HiveField(2)
  ReminderType get type;
  @override
  @HiveField(6)
  DateTime get createdAt;
  @override
  @HiveField(3)
  DateTime? get scheduledAt;
  @override
  @HiveField(4)
  LocationTrigger? get locationTrigger;
  @override
  @HiveField(5)
  RepeatConfig? get repeatConfig;
  @override
  @HiveField(7)
  DateTime? get lastTriggeredAt;
  @override
  @HiveField(8)
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$SmartReminderImplCopyWith<_$SmartReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReminderHistory _$ReminderHistoryFromJson(Map<String, dynamic> json) {
  return _ReminderHistory.fromJson(json);
}

/// @nodoc
mixin _$ReminderHistory {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get reminderId => throw _privateConstructorUsedError;
  @HiveField(2)
  String get taskId => throw _privateConstructorUsedError;
  @HiveField(3)
  String get taskTitle => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get triggeredAt => throw _privateConstructorUsedError;
  @HiveField(5)
  ReminderType get type => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get locationName => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get wasCompleted => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get wasDismissed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReminderHistoryCopyWith<ReminderHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderHistoryCopyWith<$Res> {
  factory $ReminderHistoryCopyWith(
          ReminderHistory value, $Res Function(ReminderHistory) then) =
      _$ReminderHistoryCopyWithImpl<$Res, ReminderHistory>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String reminderId,
      @HiveField(2) String taskId,
      @HiveField(3) String taskTitle,
      @HiveField(4) DateTime triggeredAt,
      @HiveField(5) ReminderType type,
      @HiveField(6) String? locationName,
      @HiveField(7) bool wasCompleted,
      @HiveField(8) bool wasDismissed});
}

/// @nodoc
class _$ReminderHistoryCopyWithImpl<$Res, $Val extends ReminderHistory>
    implements $ReminderHistoryCopyWith<$Res> {
  _$ReminderHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reminderId = null,
    Object? taskId = null,
    Object? taskTitle = null,
    Object? triggeredAt = null,
    Object? type = null,
    Object? locationName = freezed,
    Object? wasCompleted = null,
    Object? wasDismissed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reminderId: null == reminderId
          ? _value.reminderId
          : reminderId // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      taskTitle: null == taskTitle
          ? _value.taskTitle
          : taskTitle // ignore: cast_nullable_to_non_nullable
              as String,
      triggeredAt: null == triggeredAt
          ? _value.triggeredAt
          : triggeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReminderType,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      wasCompleted: null == wasCompleted
          ? _value.wasCompleted
          : wasCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      wasDismissed: null == wasDismissed
          ? _value.wasDismissed
          : wasDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReminderHistoryImplCopyWith<$Res>
    implements $ReminderHistoryCopyWith<$Res> {
  factory _$$ReminderHistoryImplCopyWith(_$ReminderHistoryImpl value,
          $Res Function(_$ReminderHistoryImpl) then) =
      __$$ReminderHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String reminderId,
      @HiveField(2) String taskId,
      @HiveField(3) String taskTitle,
      @HiveField(4) DateTime triggeredAt,
      @HiveField(5) ReminderType type,
      @HiveField(6) String? locationName,
      @HiveField(7) bool wasCompleted,
      @HiveField(8) bool wasDismissed});
}

/// @nodoc
class __$$ReminderHistoryImplCopyWithImpl<$Res>
    extends _$ReminderHistoryCopyWithImpl<$Res, _$ReminderHistoryImpl>
    implements _$$ReminderHistoryImplCopyWith<$Res> {
  __$$ReminderHistoryImplCopyWithImpl(
      _$ReminderHistoryImpl _value, $Res Function(_$ReminderHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reminderId = null,
    Object? taskId = null,
    Object? taskTitle = null,
    Object? triggeredAt = null,
    Object? type = null,
    Object? locationName = freezed,
    Object? wasCompleted = null,
    Object? wasDismissed = null,
  }) {
    return _then(_$ReminderHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reminderId: null == reminderId
          ? _value.reminderId
          : reminderId // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      taskTitle: null == taskTitle
          ? _value.taskTitle
          : taskTitle // ignore: cast_nullable_to_non_nullable
              as String,
      triggeredAt: null == triggeredAt
          ? _value.triggeredAt
          : triggeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReminderType,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      wasCompleted: null == wasCompleted
          ? _value.wasCompleted
          : wasCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      wasDismissed: null == wasDismissed
          ? _value.wasDismissed
          : wasDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReminderHistoryImpl extends _ReminderHistory {
  const _$ReminderHistoryImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.reminderId,
      @HiveField(2) required this.taskId,
      @HiveField(3) required this.taskTitle,
      @HiveField(4) required this.triggeredAt,
      @HiveField(5) required this.type,
      @HiveField(6) this.locationName,
      @HiveField(7) this.wasCompleted = false,
      @HiveField(8) this.wasDismissed = false})
      : super._();

  factory _$ReminderHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReminderHistoryImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String reminderId;
  @override
  @HiveField(2)
  final String taskId;
  @override
  @HiveField(3)
  final String taskTitle;
  @override
  @HiveField(4)
  final DateTime triggeredAt;
  @override
  @HiveField(5)
  final ReminderType type;
  @override
  @HiveField(6)
  final String? locationName;
  @override
  @JsonKey()
  @HiveField(7)
  final bool wasCompleted;
  @override
  @JsonKey()
  @HiveField(8)
  final bool wasDismissed;

  @override
  String toString() {
    return 'ReminderHistory(id: $id, reminderId: $reminderId, taskId: $taskId, taskTitle: $taskTitle, triggeredAt: $triggeredAt, type: $type, locationName: $locationName, wasCompleted: $wasCompleted, wasDismissed: $wasDismissed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reminderId, reminderId) ||
                other.reminderId == reminderId) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.taskTitle, taskTitle) ||
                other.taskTitle == taskTitle) &&
            (identical(other.triggeredAt, triggeredAt) ||
                other.triggeredAt == triggeredAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.wasCompleted, wasCompleted) ||
                other.wasCompleted == wasCompleted) &&
            (identical(other.wasDismissed, wasDismissed) ||
                other.wasDismissed == wasDismissed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, reminderId, taskId,
      taskTitle, triggeredAt, type, locationName, wasCompleted, wasDismissed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderHistoryImplCopyWith<_$ReminderHistoryImpl> get copyWith =>
      __$$ReminderHistoryImplCopyWithImpl<_$ReminderHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderHistoryImplToJson(
      this,
    );
  }
}

abstract class _ReminderHistory extends ReminderHistory {
  const factory _ReminderHistory(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String reminderId,
      @HiveField(2) required final String taskId,
      @HiveField(3) required final String taskTitle,
      @HiveField(4) required final DateTime triggeredAt,
      @HiveField(5) required final ReminderType type,
      @HiveField(6) final String? locationName,
      @HiveField(7) final bool wasCompleted,
      @HiveField(8) final bool wasDismissed}) = _$ReminderHistoryImpl;
  const _ReminderHistory._() : super._();

  factory _ReminderHistory.fromJson(Map<String, dynamic> json) =
      _$ReminderHistoryImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get reminderId;
  @override
  @HiveField(2)
  String get taskId;
  @override
  @HiveField(3)
  String get taskTitle;
  @override
  @HiveField(4)
  DateTime get triggeredAt;
  @override
  @HiveField(5)
  ReminderType get type;
  @override
  @HiveField(6)
  String? get locationName;
  @override
  @HiveField(7)
  bool get wasCompleted;
  @override
  @HiveField(8)
  bool get wasDismissed;
  @override
  @JsonKey(ignore: true)
  _$$ReminderHistoryImplCopyWith<_$ReminderHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
