// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'traffic_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrafficInfo _$TrafficInfoFromJson(Map<String, dynamic> json) {
  return _TrafficInfo.fromJson(json);
}

/// @nodoc
mixin _$TrafficInfo {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get routeName => throw _privateConstructorUsedError;
  @HiveField(2)
  double get originLat => throw _privateConstructorUsedError;
  @HiveField(3)
  double get originLng => throw _privateConstructorUsedError;
  @HiveField(4)
  double get destLat => throw _privateConstructorUsedError;
  @HiveField(5)
  double get destLng => throw _privateConstructorUsedError;
  @HiveField(6)
  String get originAddress => throw _privateConstructorUsedError;
  @HiveField(7)
  String get destAddress => throw _privateConstructorUsedError;
  @HiveField(8)
  int get durationSeconds => throw _privateConstructorUsedError; // 预计行程时间（秒）
  @HiveField(9)
  int get durationInTrafficSeconds =>
      throw _privateConstructorUsedError; // 考虑交通的行程时间（秒）
  @HiveField(10)
  int get distanceMeters => throw _privateConstructorUsedError; // 距离（米）
  @HiveField(11)
  TrafficCondition get trafficCondition => throw _privateConstructorUsedError;
  @HiveField(12)
  DateTime get fetchedAt => throw _privateConstructorUsedError;
  @HiveField(13)
  DateTime get validUntil => throw _privateConstructorUsedError;
  @HiveField(14)
  String? get polyline => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TrafficInfoCopyWith<TrafficInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrafficInfoCopyWith<$Res> {
  factory $TrafficInfoCopyWith(
          TrafficInfo value, $Res Function(TrafficInfo) then) =
      _$TrafficInfoCopyWithImpl<$Res, TrafficInfo>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String routeName,
      @HiveField(2) double originLat,
      @HiveField(3) double originLng,
      @HiveField(4) double destLat,
      @HiveField(5) double destLng,
      @HiveField(6) String originAddress,
      @HiveField(7) String destAddress,
      @HiveField(8) int durationSeconds,
      @HiveField(9) int durationInTrafficSeconds,
      @HiveField(10) int distanceMeters,
      @HiveField(11) TrafficCondition trafficCondition,
      @HiveField(12) DateTime fetchedAt,
      @HiveField(13) DateTime validUntil,
      @HiveField(14) String? polyline});
}

/// @nodoc
class _$TrafficInfoCopyWithImpl<$Res, $Val extends TrafficInfo>
    implements $TrafficInfoCopyWith<$Res> {
  _$TrafficInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routeName = null,
    Object? originLat = null,
    Object? originLng = null,
    Object? destLat = null,
    Object? destLng = null,
    Object? originAddress = null,
    Object? destAddress = null,
    Object? durationSeconds = null,
    Object? durationInTrafficSeconds = null,
    Object? distanceMeters = null,
    Object? trafficCondition = null,
    Object? fetchedAt = null,
    Object? validUntil = null,
    Object? polyline = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routeName: null == routeName
          ? _value.routeName
          : routeName // ignore: cast_nullable_to_non_nullable
              as String,
      originLat: null == originLat
          ? _value.originLat
          : originLat // ignore: cast_nullable_to_non_nullable
              as double,
      originLng: null == originLng
          ? _value.originLng
          : originLng // ignore: cast_nullable_to_non_nullable
              as double,
      destLat: null == destLat
          ? _value.destLat
          : destLat // ignore: cast_nullable_to_non_nullable
              as double,
      destLng: null == destLng
          ? _value.destLng
          : destLng // ignore: cast_nullable_to_non_nullable
              as double,
      originAddress: null == originAddress
          ? _value.originAddress
          : originAddress // ignore: cast_nullable_to_non_nullable
              as String,
      destAddress: null == destAddress
          ? _value.destAddress
          : destAddress // ignore: cast_nullable_to_non_nullable
              as String,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      durationInTrafficSeconds: null == durationInTrafficSeconds
          ? _value.durationInTrafficSeconds
          : durationInTrafficSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      distanceMeters: null == distanceMeters
          ? _value.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int,
      trafficCondition: null == trafficCondition
          ? _value.trafficCondition
          : trafficCondition // ignore: cast_nullable_to_non_nullable
              as TrafficCondition,
      fetchedAt: null == fetchedAt
          ? _value.fetchedAt
          : fetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      validUntil: null == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
      polyline: freezed == polyline
          ? _value.polyline
          : polyline // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrafficInfoImplCopyWith<$Res>
    implements $TrafficInfoCopyWith<$Res> {
  factory _$$TrafficInfoImplCopyWith(
          _$TrafficInfoImpl value, $Res Function(_$TrafficInfoImpl) then) =
      __$$TrafficInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String routeName,
      @HiveField(2) double originLat,
      @HiveField(3) double originLng,
      @HiveField(4) double destLat,
      @HiveField(5) double destLng,
      @HiveField(6) String originAddress,
      @HiveField(7) String destAddress,
      @HiveField(8) int durationSeconds,
      @HiveField(9) int durationInTrafficSeconds,
      @HiveField(10) int distanceMeters,
      @HiveField(11) TrafficCondition trafficCondition,
      @HiveField(12) DateTime fetchedAt,
      @HiveField(13) DateTime validUntil,
      @HiveField(14) String? polyline});
}

/// @nodoc
class __$$TrafficInfoImplCopyWithImpl<$Res>
    extends _$TrafficInfoCopyWithImpl<$Res, _$TrafficInfoImpl>
    implements _$$TrafficInfoImplCopyWith<$Res> {
  __$$TrafficInfoImplCopyWithImpl(
      _$TrafficInfoImpl _value, $Res Function(_$TrafficInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routeName = null,
    Object? originLat = null,
    Object? originLng = null,
    Object? destLat = null,
    Object? destLng = null,
    Object? originAddress = null,
    Object? destAddress = null,
    Object? durationSeconds = null,
    Object? durationInTrafficSeconds = null,
    Object? distanceMeters = null,
    Object? trafficCondition = null,
    Object? fetchedAt = null,
    Object? validUntil = null,
    Object? polyline = freezed,
  }) {
    return _then(_$TrafficInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routeName: null == routeName
          ? _value.routeName
          : routeName // ignore: cast_nullable_to_non_nullable
              as String,
      originLat: null == originLat
          ? _value.originLat
          : originLat // ignore: cast_nullable_to_non_nullable
              as double,
      originLng: null == originLng
          ? _value.originLng
          : originLng // ignore: cast_nullable_to_non_nullable
              as double,
      destLat: null == destLat
          ? _value.destLat
          : destLat // ignore: cast_nullable_to_non_nullable
              as double,
      destLng: null == destLng
          ? _value.destLng
          : destLng // ignore: cast_nullable_to_non_nullable
              as double,
      originAddress: null == originAddress
          ? _value.originAddress
          : originAddress // ignore: cast_nullable_to_non_nullable
              as String,
      destAddress: null == destAddress
          ? _value.destAddress
          : destAddress // ignore: cast_nullable_to_non_nullable
              as String,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      durationInTrafficSeconds: null == durationInTrafficSeconds
          ? _value.durationInTrafficSeconds
          : durationInTrafficSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      distanceMeters: null == distanceMeters
          ? _value.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int,
      trafficCondition: null == trafficCondition
          ? _value.trafficCondition
          : trafficCondition // ignore: cast_nullable_to_non_nullable
              as TrafficCondition,
      fetchedAt: null == fetchedAt
          ? _value.fetchedAt
          : fetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      validUntil: null == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
      polyline: freezed == polyline
          ? _value.polyline
          : polyline // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrafficInfoImpl extends _TrafficInfo {
  const _$TrafficInfoImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.routeName,
      @HiveField(2) required this.originLat,
      @HiveField(3) required this.originLng,
      @HiveField(4) required this.destLat,
      @HiveField(5) required this.destLng,
      @HiveField(6) required this.originAddress,
      @HiveField(7) required this.destAddress,
      @HiveField(8) required this.durationSeconds,
      @HiveField(9) required this.durationInTrafficSeconds,
      @HiveField(10) required this.distanceMeters,
      @HiveField(11) required this.trafficCondition,
      @HiveField(12) required this.fetchedAt,
      @HiveField(13) required this.validUntil,
      @HiveField(14) this.polyline})
      : super._();

  factory _$TrafficInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrafficInfoImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String routeName;
  @override
  @HiveField(2)
  final double originLat;
  @override
  @HiveField(3)
  final double originLng;
  @override
  @HiveField(4)
  final double destLat;
  @override
  @HiveField(5)
  final double destLng;
  @override
  @HiveField(6)
  final String originAddress;
  @override
  @HiveField(7)
  final String destAddress;
  @override
  @HiveField(8)
  final int durationSeconds;
// 预计行程时间（秒）
  @override
  @HiveField(9)
  final int durationInTrafficSeconds;
// 考虑交通的行程时间（秒）
  @override
  @HiveField(10)
  final int distanceMeters;
// 距离（米）
  @override
  @HiveField(11)
  final TrafficCondition trafficCondition;
  @override
  @HiveField(12)
  final DateTime fetchedAt;
  @override
  @HiveField(13)
  final DateTime validUntil;
  @override
  @HiveField(14)
  final String? polyline;

  @override
  String toString() {
    return 'TrafficInfo(id: $id, routeName: $routeName, originLat: $originLat, originLng: $originLng, destLat: $destLat, destLng: $destLng, originAddress: $originAddress, destAddress: $destAddress, durationSeconds: $durationSeconds, durationInTrafficSeconds: $durationInTrafficSeconds, distanceMeters: $distanceMeters, trafficCondition: $trafficCondition, fetchedAt: $fetchedAt, validUntil: $validUntil, polyline: $polyline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrafficInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routeName, routeName) ||
                other.routeName == routeName) &&
            (identical(other.originLat, originLat) ||
                other.originLat == originLat) &&
            (identical(other.originLng, originLng) ||
                other.originLng == originLng) &&
            (identical(other.destLat, destLat) || other.destLat == destLat) &&
            (identical(other.destLng, destLng) || other.destLng == destLng) &&
            (identical(other.originAddress, originAddress) ||
                other.originAddress == originAddress) &&
            (identical(other.destAddress, destAddress) ||
                other.destAddress == destAddress) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(
                    other.durationInTrafficSeconds, durationInTrafficSeconds) ||
                other.durationInTrafficSeconds == durationInTrafficSeconds) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.trafficCondition, trafficCondition) ||
                other.trafficCondition == trafficCondition) &&
            (identical(other.fetchedAt, fetchedAt) ||
                other.fetchedAt == fetchedAt) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.polyline, polyline) ||
                other.polyline == polyline));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      routeName,
      originLat,
      originLng,
      destLat,
      destLng,
      originAddress,
      destAddress,
      durationSeconds,
      durationInTrafficSeconds,
      distanceMeters,
      trafficCondition,
      fetchedAt,
      validUntil,
      polyline);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrafficInfoImplCopyWith<_$TrafficInfoImpl> get copyWith =>
      __$$TrafficInfoImplCopyWithImpl<_$TrafficInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrafficInfoImplToJson(
      this,
    );
  }
}

abstract class _TrafficInfo extends TrafficInfo {
  const factory _TrafficInfo(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String routeName,
      @HiveField(2) required final double originLat,
      @HiveField(3) required final double originLng,
      @HiveField(4) required final double destLat,
      @HiveField(5) required final double destLng,
      @HiveField(6) required final String originAddress,
      @HiveField(7) required final String destAddress,
      @HiveField(8) required final int durationSeconds,
      @HiveField(9) required final int durationInTrafficSeconds,
      @HiveField(10) required final int distanceMeters,
      @HiveField(11) required final TrafficCondition trafficCondition,
      @HiveField(12) required final DateTime fetchedAt,
      @HiveField(13) required final DateTime validUntil,
      @HiveField(14) final String? polyline}) = _$TrafficInfoImpl;
  const _TrafficInfo._() : super._();

  factory _TrafficInfo.fromJson(Map<String, dynamic> json) =
      _$TrafficInfoImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get routeName;
  @override
  @HiveField(2)
  double get originLat;
  @override
  @HiveField(3)
  double get originLng;
  @override
  @HiveField(4)
  double get destLat;
  @override
  @HiveField(5)
  double get destLng;
  @override
  @HiveField(6)
  String get originAddress;
  @override
  @HiveField(7)
  String get destAddress;
  @override
  @HiveField(8)
  int get durationSeconds;
  @override // 预计行程时间（秒）
  @HiveField(9)
  int get durationInTrafficSeconds;
  @override // 考虑交通的行程时间（秒）
  @HiveField(10)
  int get distanceMeters;
  @override // 距离（米）
  @HiveField(11)
  TrafficCondition get trafficCondition;
  @override
  @HiveField(12)
  DateTime get fetchedAt;
  @override
  @HiveField(13)
  DateTime get validUntil;
  @override
  @HiveField(14)
  String? get polyline;
  @override
  @JsonKey(ignore: true)
  _$$TrafficInfoImplCopyWith<_$TrafficInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TravelTrigger _$TravelTriggerFromJson(Map<String, dynamic> json) {
  return _TravelTrigger.fromJson(json);
}

/// @nodoc
mixin _$TravelTrigger {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get taskId => throw _privateConstructorUsedError;
  @HiveField(2)
  double get originLat => throw _privateConstructorUsedError;
  @HiveField(3)
  double get originLng => throw _privateConstructorUsedError;
  @HiveField(4)
  double get destLat => throw _privateConstructorUsedError;
  @HiveField(5)
  double get destLng => throw _privateConstructorUsedError;
  @HiveField(6)
  String get originAddress => throw _privateConstructorUsedError;
  @HiveField(7)
  String get destAddress => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime get appointmentTime => throw _privateConstructorUsedError; // 约定到达时间
  @HiveField(9)
  int get bufferMinutes => throw _privateConstructorUsedError; // 缓冲时间（分钟）
  @HiveField(10)
  bool get enabled => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(12)
  DateTime? get lastCheckedAt => throw _privateConstructorUsedError;
  @HiveField(13)
  DateTime? get reminderScheduledFor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TravelTriggerCopyWith<TravelTrigger> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TravelTriggerCopyWith<$Res> {
  factory $TravelTriggerCopyWith(
          TravelTrigger value, $Res Function(TravelTrigger) then) =
      _$TravelTriggerCopyWithImpl<$Res, TravelTrigger>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String taskId,
      @HiveField(2) double originLat,
      @HiveField(3) double originLng,
      @HiveField(4) double destLat,
      @HiveField(5) double destLng,
      @HiveField(6) String originAddress,
      @HiveField(7) String destAddress,
      @HiveField(8) DateTime appointmentTime,
      @HiveField(9) int bufferMinutes,
      @HiveField(10) bool enabled,
      @HiveField(11) DateTime createdAt,
      @HiveField(12) DateTime? lastCheckedAt,
      @HiveField(13) DateTime? reminderScheduledFor});
}

/// @nodoc
class _$TravelTriggerCopyWithImpl<$Res, $Val extends TravelTrigger>
    implements $TravelTriggerCopyWith<$Res> {
  _$TravelTriggerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? originLat = null,
    Object? originLng = null,
    Object? destLat = null,
    Object? destLng = null,
    Object? originAddress = null,
    Object? destAddress = null,
    Object? appointmentTime = null,
    Object? bufferMinutes = null,
    Object? enabled = null,
    Object? createdAt = null,
    Object? lastCheckedAt = freezed,
    Object? reminderScheduledFor = freezed,
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
      originLat: null == originLat
          ? _value.originLat
          : originLat // ignore: cast_nullable_to_non_nullable
              as double,
      originLng: null == originLng
          ? _value.originLng
          : originLng // ignore: cast_nullable_to_non_nullable
              as double,
      destLat: null == destLat
          ? _value.destLat
          : destLat // ignore: cast_nullable_to_non_nullable
              as double,
      destLng: null == destLng
          ? _value.destLng
          : destLng // ignore: cast_nullable_to_non_nullable
              as double,
      originAddress: null == originAddress
          ? _value.originAddress
          : originAddress // ignore: cast_nullable_to_non_nullable
              as String,
      destAddress: null == destAddress
          ? _value.destAddress
          : destAddress // ignore: cast_nullable_to_non_nullable
              as String,
      appointmentTime: null == appointmentTime
          ? _value.appointmentTime
          : appointmentTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bufferMinutes: null == bufferMinutes
          ? _value.bufferMinutes
          : bufferMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastCheckedAt: freezed == lastCheckedAt
          ? _value.lastCheckedAt
          : lastCheckedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reminderScheduledFor: freezed == reminderScheduledFor
          ? _value.reminderScheduledFor
          : reminderScheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TravelTriggerImplCopyWith<$Res>
    implements $TravelTriggerCopyWith<$Res> {
  factory _$$TravelTriggerImplCopyWith(
          _$TravelTriggerImpl value, $Res Function(_$TravelTriggerImpl) then) =
      __$$TravelTriggerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String taskId,
      @HiveField(2) double originLat,
      @HiveField(3) double originLng,
      @HiveField(4) double destLat,
      @HiveField(5) double destLng,
      @HiveField(6) String originAddress,
      @HiveField(7) String destAddress,
      @HiveField(8) DateTime appointmentTime,
      @HiveField(9) int bufferMinutes,
      @HiveField(10) bool enabled,
      @HiveField(11) DateTime createdAt,
      @HiveField(12) DateTime? lastCheckedAt,
      @HiveField(13) DateTime? reminderScheduledFor});
}

/// @nodoc
class __$$TravelTriggerImplCopyWithImpl<$Res>
    extends _$TravelTriggerCopyWithImpl<$Res, _$TravelTriggerImpl>
    implements _$$TravelTriggerImplCopyWith<$Res> {
  __$$TravelTriggerImplCopyWithImpl(
      _$TravelTriggerImpl _value, $Res Function(_$TravelTriggerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? originLat = null,
    Object? originLng = null,
    Object? destLat = null,
    Object? destLng = null,
    Object? originAddress = null,
    Object? destAddress = null,
    Object? appointmentTime = null,
    Object? bufferMinutes = null,
    Object? enabled = null,
    Object? createdAt = null,
    Object? lastCheckedAt = freezed,
    Object? reminderScheduledFor = freezed,
  }) {
    return _then(_$TravelTriggerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      originLat: null == originLat
          ? _value.originLat
          : originLat // ignore: cast_nullable_to_non_nullable
              as double,
      originLng: null == originLng
          ? _value.originLng
          : originLng // ignore: cast_nullable_to_non_nullable
              as double,
      destLat: null == destLat
          ? _value.destLat
          : destLat // ignore: cast_nullable_to_non_nullable
              as double,
      destLng: null == destLng
          ? _value.destLng
          : destLng // ignore: cast_nullable_to_non_nullable
              as double,
      originAddress: null == originAddress
          ? _value.originAddress
          : originAddress // ignore: cast_nullable_to_non_nullable
              as String,
      destAddress: null == destAddress
          ? _value.destAddress
          : destAddress // ignore: cast_nullable_to_non_nullable
              as String,
      appointmentTime: null == appointmentTime
          ? _value.appointmentTime
          : appointmentTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bufferMinutes: null == bufferMinutes
          ? _value.bufferMinutes
          : bufferMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastCheckedAt: freezed == lastCheckedAt
          ? _value.lastCheckedAt
          : lastCheckedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reminderScheduledFor: freezed == reminderScheduledFor
          ? _value.reminderScheduledFor
          : reminderScheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TravelTriggerImpl extends _TravelTrigger {
  const _$TravelTriggerImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.taskId,
      @HiveField(2) required this.originLat,
      @HiveField(3) required this.originLng,
      @HiveField(4) required this.destLat,
      @HiveField(5) required this.destLng,
      @HiveField(6) required this.originAddress,
      @HiveField(7) required this.destAddress,
      @HiveField(8) required this.appointmentTime,
      @HiveField(9) this.bufferMinutes = 15,
      @HiveField(10) this.enabled = true,
      @HiveField(11) required this.createdAt,
      @HiveField(12) this.lastCheckedAt,
      @HiveField(13) this.reminderScheduledFor})
      : super._();

  factory _$TravelTriggerImpl.fromJson(Map<String, dynamic> json) =>
      _$$TravelTriggerImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String taskId;
  @override
  @HiveField(2)
  final double originLat;
  @override
  @HiveField(3)
  final double originLng;
  @override
  @HiveField(4)
  final double destLat;
  @override
  @HiveField(5)
  final double destLng;
  @override
  @HiveField(6)
  final String originAddress;
  @override
  @HiveField(7)
  final String destAddress;
  @override
  @HiveField(8)
  final DateTime appointmentTime;
// 约定到达时间
  @override
  @JsonKey()
  @HiveField(9)
  final int bufferMinutes;
// 缓冲时间（分钟）
  @override
  @JsonKey()
  @HiveField(10)
  final bool enabled;
  @override
  @HiveField(11)
  final DateTime createdAt;
  @override
  @HiveField(12)
  final DateTime? lastCheckedAt;
  @override
  @HiveField(13)
  final DateTime? reminderScheduledFor;

  @override
  String toString() {
    return 'TravelTrigger(id: $id, taskId: $taskId, originLat: $originLat, originLng: $originLng, destLat: $destLat, destLng: $destLng, originAddress: $originAddress, destAddress: $destAddress, appointmentTime: $appointmentTime, bufferMinutes: $bufferMinutes, enabled: $enabled, createdAt: $createdAt, lastCheckedAt: $lastCheckedAt, reminderScheduledFor: $reminderScheduledFor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TravelTriggerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.originLat, originLat) ||
                other.originLat == originLat) &&
            (identical(other.originLng, originLng) ||
                other.originLng == originLng) &&
            (identical(other.destLat, destLat) || other.destLat == destLat) &&
            (identical(other.destLng, destLng) || other.destLng == destLng) &&
            (identical(other.originAddress, originAddress) ||
                other.originAddress == originAddress) &&
            (identical(other.destAddress, destAddress) ||
                other.destAddress == destAddress) &&
            (identical(other.appointmentTime, appointmentTime) ||
                other.appointmentTime == appointmentTime) &&
            (identical(other.bufferMinutes, bufferMinutes) ||
                other.bufferMinutes == bufferMinutes) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastCheckedAt, lastCheckedAt) ||
                other.lastCheckedAt == lastCheckedAt) &&
            (identical(other.reminderScheduledFor, reminderScheduledFor) ||
                other.reminderScheduledFor == reminderScheduledFor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      taskId,
      originLat,
      originLng,
      destLat,
      destLng,
      originAddress,
      destAddress,
      appointmentTime,
      bufferMinutes,
      enabled,
      createdAt,
      lastCheckedAt,
      reminderScheduledFor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TravelTriggerImplCopyWith<_$TravelTriggerImpl> get copyWith =>
      __$$TravelTriggerImplCopyWithImpl<_$TravelTriggerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TravelTriggerImplToJson(
      this,
    );
  }
}

abstract class _TravelTrigger extends TravelTrigger {
  const factory _TravelTrigger(
          {@HiveField(0) required final String id,
          @HiveField(1) required final String taskId,
          @HiveField(2) required final double originLat,
          @HiveField(3) required final double originLng,
          @HiveField(4) required final double destLat,
          @HiveField(5) required final double destLng,
          @HiveField(6) required final String originAddress,
          @HiveField(7) required final String destAddress,
          @HiveField(8) required final DateTime appointmentTime,
          @HiveField(9) final int bufferMinutes,
          @HiveField(10) final bool enabled,
          @HiveField(11) required final DateTime createdAt,
          @HiveField(12) final DateTime? lastCheckedAt,
          @HiveField(13) final DateTime? reminderScheduledFor}) =
      _$TravelTriggerImpl;
  const _TravelTrigger._() : super._();

  factory _TravelTrigger.fromJson(Map<String, dynamic> json) =
      _$TravelTriggerImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get taskId;
  @override
  @HiveField(2)
  double get originLat;
  @override
  @HiveField(3)
  double get originLng;
  @override
  @HiveField(4)
  double get destLat;
  @override
  @HiveField(5)
  double get destLng;
  @override
  @HiveField(6)
  String get originAddress;
  @override
  @HiveField(7)
  String get destAddress;
  @override
  @HiveField(8)
  DateTime get appointmentTime;
  @override // 约定到达时间
  @HiveField(9)
  int get bufferMinutes;
  @override // 缓冲时间（分钟）
  @HiveField(10)
  bool get enabled;
  @override
  @HiveField(11)
  DateTime get createdAt;
  @override
  @HiveField(12)
  DateTime? get lastCheckedAt;
  @override
  @HiveField(13)
  DateTime? get reminderScheduledFor;
  @override
  @JsonKey(ignore: true)
  _$$TravelTriggerImplCopyWith<_$TravelTriggerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
