// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) {
  return _DashboardStats.fromJson(json);
}

/// @nodoc
mixin _$DashboardStats {
// Today's tasks
  int get todayCompletedCount => throw _privateConstructorUsedError;
  int get todayTotalCount =>
      throw _privateConstructorUsedError; // This week's focus
  int get weekFocusMinutes => throw _privateConstructorUsedError;
  int get weekFocusSessions => throw _privateConstructorUsedError; // Streak
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  DateTime? get lastCheckInDate =>
      throw _privateConstructorUsedError; // Urgent tasks
  int get urgentTasksCount => throw _privateConstructorUsedError;
  int get overdueTasksCount =>
      throw _privateConstructorUsedError; // Additional insights
  double get todayCompletionRate => throw _privateConstructorUsedError;
  int get weekFocusHours => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardStatsCopyWith<DashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsCopyWith<$Res> {
  factory $DashboardStatsCopyWith(
          DashboardStats value, $Res Function(DashboardStats) then) =
      _$DashboardStatsCopyWithImpl<$Res, DashboardStats>;
  @useResult
  $Res call(
      {int todayCompletedCount,
      int todayTotalCount,
      int weekFocusMinutes,
      int weekFocusSessions,
      int currentStreak,
      int longestStreak,
      DateTime? lastCheckInDate,
      int urgentTasksCount,
      int overdueTasksCount,
      double todayCompletionRate,
      int weekFocusHours});
}

/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res, $Val extends DashboardStats>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todayCompletedCount = null,
    Object? todayTotalCount = null,
    Object? weekFocusMinutes = null,
    Object? weekFocusSessions = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastCheckInDate = freezed,
    Object? urgentTasksCount = null,
    Object? overdueTasksCount = null,
    Object? todayCompletionRate = null,
    Object? weekFocusHours = null,
  }) {
    return _then(_value.copyWith(
      todayCompletedCount: null == todayCompletedCount
          ? _value.todayCompletedCount
          : todayCompletedCount // ignore: cast_nullable_to_non_nullable
              as int,
      todayTotalCount: null == todayTotalCount
          ? _value.todayTotalCount
          : todayTotalCount // ignore: cast_nullable_to_non_nullable
              as int,
      weekFocusMinutes: null == weekFocusMinutes
          ? _value.weekFocusMinutes
          : weekFocusMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      weekFocusSessions: null == weekFocusSessions
          ? _value.weekFocusSessions
          : weekFocusSessions // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastCheckInDate: freezed == lastCheckInDate
          ? _value.lastCheckInDate
          : lastCheckInDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      urgentTasksCount: null == urgentTasksCount
          ? _value.urgentTasksCount
          : urgentTasksCount // ignore: cast_nullable_to_non_nullable
              as int,
      overdueTasksCount: null == overdueTasksCount
          ? _value.overdueTasksCount
          : overdueTasksCount // ignore: cast_nullable_to_non_nullable
              as int,
      todayCompletionRate: null == todayCompletionRate
          ? _value.todayCompletionRate
          : todayCompletionRate // ignore: cast_nullable_to_non_nullable
              as double,
      weekFocusHours: null == weekFocusHours
          ? _value.weekFocusHours
          : weekFocusHours // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardStatsImplCopyWith<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  factory _$$DashboardStatsImplCopyWith(_$DashboardStatsImpl value,
          $Res Function(_$DashboardStatsImpl) then) =
      __$$DashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int todayCompletedCount,
      int todayTotalCount,
      int weekFocusMinutes,
      int weekFocusSessions,
      int currentStreak,
      int longestStreak,
      DateTime? lastCheckInDate,
      int urgentTasksCount,
      int overdueTasksCount,
      double todayCompletionRate,
      int weekFocusHours});
}

/// @nodoc
class __$$DashboardStatsImplCopyWithImpl<$Res>
    extends _$DashboardStatsCopyWithImpl<$Res, _$DashboardStatsImpl>
    implements _$$DashboardStatsImplCopyWith<$Res> {
  __$$DashboardStatsImplCopyWithImpl(
      _$DashboardStatsImpl _value, $Res Function(_$DashboardStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todayCompletedCount = null,
    Object? todayTotalCount = null,
    Object? weekFocusMinutes = null,
    Object? weekFocusSessions = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastCheckInDate = freezed,
    Object? urgentTasksCount = null,
    Object? overdueTasksCount = null,
    Object? todayCompletionRate = null,
    Object? weekFocusHours = null,
  }) {
    return _then(_$DashboardStatsImpl(
      todayCompletedCount: null == todayCompletedCount
          ? _value.todayCompletedCount
          : todayCompletedCount // ignore: cast_nullable_to_non_nullable
              as int,
      todayTotalCount: null == todayTotalCount
          ? _value.todayTotalCount
          : todayTotalCount // ignore: cast_nullable_to_non_nullable
              as int,
      weekFocusMinutes: null == weekFocusMinutes
          ? _value.weekFocusMinutes
          : weekFocusMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      weekFocusSessions: null == weekFocusSessions
          ? _value.weekFocusSessions
          : weekFocusSessions // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastCheckInDate: freezed == lastCheckInDate
          ? _value.lastCheckInDate
          : lastCheckInDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      urgentTasksCount: null == urgentTasksCount
          ? _value.urgentTasksCount
          : urgentTasksCount // ignore: cast_nullable_to_non_nullable
              as int,
      overdueTasksCount: null == overdueTasksCount
          ? _value.overdueTasksCount
          : overdueTasksCount // ignore: cast_nullable_to_non_nullable
              as int,
      todayCompletionRate: null == todayCompletionRate
          ? _value.todayCompletionRate
          : todayCompletionRate // ignore: cast_nullable_to_non_nullable
              as double,
      weekFocusHours: null == weekFocusHours
          ? _value.weekFocusHours
          : weekFocusHours // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatsImpl extends _DashboardStats {
  const _$DashboardStatsImpl(
      {required this.todayCompletedCount,
      required this.todayTotalCount,
      required this.weekFocusMinutes,
      required this.weekFocusSessions,
      required this.currentStreak,
      required this.longestStreak,
      required this.lastCheckInDate,
      required this.urgentTasksCount,
      required this.overdueTasksCount,
      required this.todayCompletionRate,
      required this.weekFocusHours})
      : super._();

  factory _$DashboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatsImplFromJson(json);

// Today's tasks
  @override
  final int todayCompletedCount;
  @override
  final int todayTotalCount;
// This week's focus
  @override
  final int weekFocusMinutes;
  @override
  final int weekFocusSessions;
// Streak
  @override
  final int currentStreak;
  @override
  final int longestStreak;
  @override
  final DateTime? lastCheckInDate;
// Urgent tasks
  @override
  final int urgentTasksCount;
  @override
  final int overdueTasksCount;
// Additional insights
  @override
  final double todayCompletionRate;
  @override
  final int weekFocusHours;

  @override
  String toString() {
    return 'DashboardStats(todayCompletedCount: $todayCompletedCount, todayTotalCount: $todayTotalCount, weekFocusMinutes: $weekFocusMinutes, weekFocusSessions: $weekFocusSessions, currentStreak: $currentStreak, longestStreak: $longestStreak, lastCheckInDate: $lastCheckInDate, urgentTasksCount: $urgentTasksCount, overdueTasksCount: $overdueTasksCount, todayCompletionRate: $todayCompletionRate, weekFocusHours: $weekFocusHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsImpl &&
            (identical(other.todayCompletedCount, todayCompletedCount) ||
                other.todayCompletedCount == todayCompletedCount) &&
            (identical(other.todayTotalCount, todayTotalCount) ||
                other.todayTotalCount == todayTotalCount) &&
            (identical(other.weekFocusMinutes, weekFocusMinutes) ||
                other.weekFocusMinutes == weekFocusMinutes) &&
            (identical(other.weekFocusSessions, weekFocusSessions) ||
                other.weekFocusSessions == weekFocusSessions) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastCheckInDate, lastCheckInDate) ||
                other.lastCheckInDate == lastCheckInDate) &&
            (identical(other.urgentTasksCount, urgentTasksCount) ||
                other.urgentTasksCount == urgentTasksCount) &&
            (identical(other.overdueTasksCount, overdueTasksCount) ||
                other.overdueTasksCount == overdueTasksCount) &&
            (identical(other.todayCompletionRate, todayCompletionRate) ||
                other.todayCompletionRate == todayCompletionRate) &&
            (identical(other.weekFocusHours, weekFocusHours) ||
                other.weekFocusHours == weekFocusHours));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      todayCompletedCount,
      todayTotalCount,
      weekFocusMinutes,
      weekFocusSessions,
      currentStreak,
      longestStreak,
      lastCheckInDate,
      urgentTasksCount,
      overdueTasksCount,
      todayCompletionRate,
      weekFocusHours);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      __$$DashboardStatsImplCopyWithImpl<_$DashboardStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatsImplToJson(
      this,
    );
  }
}

abstract class _DashboardStats extends DashboardStats {
  const factory _DashboardStats(
      {required final int todayCompletedCount,
      required final int todayTotalCount,
      required final int weekFocusMinutes,
      required final int weekFocusSessions,
      required final int currentStreak,
      required final int longestStreak,
      required final DateTime? lastCheckInDate,
      required final int urgentTasksCount,
      required final int overdueTasksCount,
      required final double todayCompletionRate,
      required final int weekFocusHours}) = _$DashboardStatsImpl;
  const _DashboardStats._() : super._();

  factory _DashboardStats.fromJson(Map<String, dynamic> json) =
      _$DashboardStatsImpl.fromJson;

  @override // Today's tasks
  int get todayCompletedCount;
  @override
  int get todayTotalCount;
  @override // This week's focus
  int get weekFocusMinutes;
  @override
  int get weekFocusSessions;
  @override // Streak
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  DateTime? get lastCheckInDate;
  @override // Urgent tasks
  int get urgentTasksCount;
  @override
  int get overdueTasksCount;
  @override // Additional insights
  double get todayCompletionRate;
  @override
  int get weekFocusHours;
  @override
  @JsonKey(ignore: true)
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
