// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_checkin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyCheckIn _$DailyCheckInFromJson(Map<String, dynamic> json) {
  return _DailyCheckIn.fromJson(json);
}

/// @nodoc
mixin _$DailyCheckIn {
  String get id => throw _privateConstructorUsedError;
  DateTime get checkInDate => throw _privateConstructorUsedError; // 签到日期(年月日)
  DateTime get createdAt => throw _privateConstructorUsedError; // 签到时间
  int get pointsEarned => throw _privateConstructorUsedError; // 获得积分
  int get consecutiveDays => throw _privateConstructorUsedError; // 当时的连续天数
  bool get isMakeup => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyCheckInCopyWith<DailyCheckIn> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyCheckInCopyWith<$Res> {
  factory $DailyCheckInCopyWith(
          DailyCheckIn value, $Res Function(DailyCheckIn) then) =
      _$DailyCheckInCopyWithImpl<$Res, DailyCheckIn>;
  @useResult
  $Res call(
      {String id,
      DateTime checkInDate,
      DateTime createdAt,
      int pointsEarned,
      int consecutiveDays,
      bool isMakeup});
}

/// @nodoc
class _$DailyCheckInCopyWithImpl<$Res, $Val extends DailyCheckIn>
    implements $DailyCheckInCopyWith<$Res> {
  _$DailyCheckInCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? checkInDate = null,
    Object? createdAt = null,
    Object? pointsEarned = null,
    Object? consecutiveDays = null,
    Object? isMakeup = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      checkInDate: null == checkInDate
          ? _value.checkInDate
          : checkInDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      consecutiveDays: null == consecutiveDays
          ? _value.consecutiveDays
          : consecutiveDays // ignore: cast_nullable_to_non_nullable
              as int,
      isMakeup: null == isMakeup
          ? _value.isMakeup
          : isMakeup // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyCheckInImplCopyWith<$Res>
    implements $DailyCheckInCopyWith<$Res> {
  factory _$$DailyCheckInImplCopyWith(
          _$DailyCheckInImpl value, $Res Function(_$DailyCheckInImpl) then) =
      __$$DailyCheckInImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime checkInDate,
      DateTime createdAt,
      int pointsEarned,
      int consecutiveDays,
      bool isMakeup});
}

/// @nodoc
class __$$DailyCheckInImplCopyWithImpl<$Res>
    extends _$DailyCheckInCopyWithImpl<$Res, _$DailyCheckInImpl>
    implements _$$DailyCheckInImplCopyWith<$Res> {
  __$$DailyCheckInImplCopyWithImpl(
      _$DailyCheckInImpl _value, $Res Function(_$DailyCheckInImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? checkInDate = null,
    Object? createdAt = null,
    Object? pointsEarned = null,
    Object? consecutiveDays = null,
    Object? isMakeup = null,
  }) {
    return _then(_$DailyCheckInImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      checkInDate: null == checkInDate
          ? _value.checkInDate
          : checkInDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      consecutiveDays: null == consecutiveDays
          ? _value.consecutiveDays
          : consecutiveDays // ignore: cast_nullable_to_non_nullable
              as int,
      isMakeup: null == isMakeup
          ? _value.isMakeup
          : isMakeup // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyCheckInImpl extends _DailyCheckIn {
  const _$DailyCheckInImpl(
      {required this.id,
      required this.checkInDate,
      required this.createdAt,
      this.pointsEarned = 10,
      this.consecutiveDays = 1,
      this.isMakeup = false})
      : super._();

  factory _$DailyCheckInImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyCheckInImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime checkInDate;
// 签到日期(年月日)
  @override
  final DateTime createdAt;
// 签到时间
  @override
  @JsonKey()
  final int pointsEarned;
// 获得积分
  @override
  @JsonKey()
  final int consecutiveDays;
// 当时的连续天数
  @override
  @JsonKey()
  final bool isMakeup;

  @override
  String toString() {
    return 'DailyCheckIn(id: $id, checkInDate: $checkInDate, createdAt: $createdAt, pointsEarned: $pointsEarned, consecutiveDays: $consecutiveDays, isMakeup: $isMakeup)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyCheckInImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.checkInDate, checkInDate) ||
                other.checkInDate == checkInDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.pointsEarned, pointsEarned) ||
                other.pointsEarned == pointsEarned) &&
            (identical(other.consecutiveDays, consecutiveDays) ||
                other.consecutiveDays == consecutiveDays) &&
            (identical(other.isMakeup, isMakeup) ||
                other.isMakeup == isMakeup));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, checkInDate, createdAt,
      pointsEarned, consecutiveDays, isMakeup);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyCheckInImplCopyWith<_$DailyCheckInImpl> get copyWith =>
      __$$DailyCheckInImplCopyWithImpl<_$DailyCheckInImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyCheckInImplToJson(
      this,
    );
  }
}

abstract class _DailyCheckIn extends DailyCheckIn {
  const factory _DailyCheckIn(
      {required final String id,
      required final DateTime checkInDate,
      required final DateTime createdAt,
      final int pointsEarned,
      final int consecutiveDays,
      final bool isMakeup}) = _$DailyCheckInImpl;
  const _DailyCheckIn._() : super._();

  factory _DailyCheckIn.fromJson(Map<String, dynamic> json) =
      _$DailyCheckInImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get checkInDate;
  @override // 签到日期(年月日)
  DateTime get createdAt;
  @override // 签到时间
  int get pointsEarned;
  @override // 获得积分
  int get consecutiveDays;
  @override // 当时的连续天数
  bool get isMakeup;
  @override
  @JsonKey(ignore: true)
  _$$DailyCheckInImplCopyWith<_$DailyCheckInImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MakeupCard _$MakeupCardFromJson(Map<String, dynamic> json) {
  return _MakeupCard.fromJson(json);
}

/// @nodoc
mixin _$MakeupCard {
  String get id => throw _privateConstructorUsedError;
  DateTime get obtainedAt => throw _privateConstructorUsedError; // 获得时间
  DateTime? get usedAt => throw _privateConstructorUsedError; // 使用时间
  bool get isUsed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MakeupCardCopyWith<MakeupCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MakeupCardCopyWith<$Res> {
  factory $MakeupCardCopyWith(
          MakeupCard value, $Res Function(MakeupCard) then) =
      _$MakeupCardCopyWithImpl<$Res, MakeupCard>;
  @useResult
  $Res call({String id, DateTime obtainedAt, DateTime? usedAt, bool isUsed});
}

/// @nodoc
class _$MakeupCardCopyWithImpl<$Res, $Val extends MakeupCard>
    implements $MakeupCardCopyWith<$Res> {
  _$MakeupCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? obtainedAt = null,
    Object? usedAt = freezed,
    Object? isUsed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      obtainedAt: null == obtainedAt
          ? _value.obtainedAt
          : obtainedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isUsed: null == isUsed
          ? _value.isUsed
          : isUsed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MakeupCardImplCopyWith<$Res>
    implements $MakeupCardCopyWith<$Res> {
  factory _$$MakeupCardImplCopyWith(
          _$MakeupCardImpl value, $Res Function(_$MakeupCardImpl) then) =
      __$$MakeupCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime obtainedAt, DateTime? usedAt, bool isUsed});
}

/// @nodoc
class __$$MakeupCardImplCopyWithImpl<$Res>
    extends _$MakeupCardCopyWithImpl<$Res, _$MakeupCardImpl>
    implements _$$MakeupCardImplCopyWith<$Res> {
  __$$MakeupCardImplCopyWithImpl(
      _$MakeupCardImpl _value, $Res Function(_$MakeupCardImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? obtainedAt = null,
    Object? usedAt = freezed,
    Object? isUsed = null,
  }) {
    return _then(_$MakeupCardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      obtainedAt: null == obtainedAt
          ? _value.obtainedAt
          : obtainedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isUsed: null == isUsed
          ? _value.isUsed
          : isUsed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MakeupCardImpl extends _MakeupCard {
  const _$MakeupCardImpl(
      {required this.id,
      required this.obtainedAt,
      this.usedAt,
      this.isUsed = false})
      : super._();

  factory _$MakeupCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$MakeupCardImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime obtainedAt;
// 获得时间
  @override
  final DateTime? usedAt;
// 使用时间
  @override
  @JsonKey()
  final bool isUsed;

  @override
  String toString() {
    return 'MakeupCard(id: $id, obtainedAt: $obtainedAt, usedAt: $usedAt, isUsed: $isUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MakeupCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.obtainedAt, obtainedAt) ||
                other.obtainedAt == obtainedAt) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt) &&
            (identical(other.isUsed, isUsed) || other.isUsed == isUsed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, obtainedAt, usedAt, isUsed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MakeupCardImplCopyWith<_$MakeupCardImpl> get copyWith =>
      __$$MakeupCardImplCopyWithImpl<_$MakeupCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MakeupCardImplToJson(
      this,
    );
  }
}

abstract class _MakeupCard extends MakeupCard {
  const factory _MakeupCard(
      {required final String id,
      required final DateTime obtainedAt,
      final DateTime? usedAt,
      final bool isUsed}) = _$MakeupCardImpl;
  const _MakeupCard._() : super._();

  factory _MakeupCard.fromJson(Map<String, dynamic> json) =
      _$MakeupCardImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get obtainedAt;
  @override // 获得时间
  DateTime? get usedAt;
  @override // 使用时间
  bool get isUsed;
  @override
  @JsonKey(ignore: true)
  _$$MakeupCardImplCopyWith<_$MakeupCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
