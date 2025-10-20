// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserStats _$UserStatsFromJson(Map<String, dynamic> json) {
  return _UserStats.fromJson(json);
}

/// @nodoc
mixin _$UserStats {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get totalPoints => throw _privateConstructorUsedError; // 总积分
  int get currentStreak => throw _privateConstructorUsedError; // 当前连续打卡天数
  int get longestStreak => throw _privateConstructorUsedError; // 最长连续打卡天数
  DateTime? get lastCheckInDate => throw _privateConstructorUsedError; // 最后打卡日期
  int get totalTasksCompleted => throw _privateConstructorUsedError; // 总完成任务数
  int get totalFocusMinutes => throw _privateConstructorUsedError; // 总专注时长(分钟)
  List<String> get unlockedBadgeIds =>
      throw _privateConstructorUsedError; // 已解锁徽章ID
  List<String> get unlockedAchievementIds =>
      throw _privateConstructorUsedError; // 已解锁成就ID
  int get totalCheckIns => throw _privateConstructorUsedError; // 总签到天数
  int get makeupCardsCount => throw _privateConstructorUsedError; // 补签卡数量
  DateTime? get lastManualCheckInDate =>
      throw _privateConstructorUsedError; // 最后手动签到日期
  int get totalDraws => throw _privateConstructorUsedError; // 总抽奖次数
  int get freeDrawsUsedToday => throw _privateConstructorUsedError; // 今日已用免费次数
  DateTime? get lastFreeDrawDate =>
      throw _privateConstructorUsedError; // 最后免费抽奖日期
  int get drawPityCounter => throw _privateConstructorUsedError; // 抽奖保底计数器
  String? get equippedTitleId =>
      throw _privateConstructorUsedError; // 当前佩戴的称号ID
  List<String> get unlockedTitleIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      int totalPoints,
      int currentStreak,
      int longestStreak,
      DateTime? lastCheckInDate,
      int totalTasksCompleted,
      int totalFocusMinutes,
      List<String> unlockedBadgeIds,
      List<String> unlockedAchievementIds,
      int totalCheckIns,
      int makeupCardsCount,
      DateTime? lastManualCheckInDate,
      int totalDraws,
      int freeDrawsUsedToday,
      DateTime? lastFreeDrawDate,
      int drawPityCounter,
      String? equippedTitleId,
      List<String> unlockedTitleIds});
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? totalPoints = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastCheckInDate = freezed,
    Object? totalTasksCompleted = null,
    Object? totalFocusMinutes = null,
    Object? unlockedBadgeIds = null,
    Object? unlockedAchievementIds = null,
    Object? totalCheckIns = null,
    Object? makeupCardsCount = null,
    Object? lastManualCheckInDate = freezed,
    Object? totalDraws = null,
    Object? freeDrawsUsedToday = null,
    Object? lastFreeDrawDate = freezed,
    Object? drawPityCounter = null,
    Object? equippedTitleId = freezed,
    Object? unlockedTitleIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
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
      totalTasksCompleted: null == totalTasksCompleted
          ? _value.totalTasksCompleted
          : totalTasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalFocusMinutes: null == totalFocusMinutes
          ? _value.totalFocusMinutes
          : totalFocusMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedBadgeIds: null == unlockedBadgeIds
          ? _value.unlockedBadgeIds
          : unlockedBadgeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      unlockedAchievementIds: null == unlockedAchievementIds
          ? _value.unlockedAchievementIds
          : unlockedAchievementIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalCheckIns: null == totalCheckIns
          ? _value.totalCheckIns
          : totalCheckIns // ignore: cast_nullable_to_non_nullable
              as int,
      makeupCardsCount: null == makeupCardsCount
          ? _value.makeupCardsCount
          : makeupCardsCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastManualCheckInDate: freezed == lastManualCheckInDate
          ? _value.lastManualCheckInDate
          : lastManualCheckInDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalDraws: null == totalDraws
          ? _value.totalDraws
          : totalDraws // ignore: cast_nullable_to_non_nullable
              as int,
      freeDrawsUsedToday: null == freeDrawsUsedToday
          ? _value.freeDrawsUsedToday
          : freeDrawsUsedToday // ignore: cast_nullable_to_non_nullable
              as int,
      lastFreeDrawDate: freezed == lastFreeDrawDate
          ? _value.lastFreeDrawDate
          : lastFreeDrawDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      drawPityCounter: null == drawPityCounter
          ? _value.drawPityCounter
          : drawPityCounter // ignore: cast_nullable_to_non_nullable
              as int,
      equippedTitleId: freezed == equippedTitleId
          ? _value.equippedTitleId
          : equippedTitleId // ignore: cast_nullable_to_non_nullable
              as String?,
      unlockedTitleIds: null == unlockedTitleIds
          ? _value.unlockedTitleIds
          : unlockedTitleIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
          _$UserStatsImpl value, $Res Function(_$UserStatsImpl) then) =
      __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      int totalPoints,
      int currentStreak,
      int longestStreak,
      DateTime? lastCheckInDate,
      int totalTasksCompleted,
      int totalFocusMinutes,
      List<String> unlockedBadgeIds,
      List<String> unlockedAchievementIds,
      int totalCheckIns,
      int makeupCardsCount,
      DateTime? lastManualCheckInDate,
      int totalDraws,
      int freeDrawsUsedToday,
      DateTime? lastFreeDrawDate,
      int drawPityCounter,
      String? equippedTitleId,
      List<String> unlockedTitleIds});
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
      _$UserStatsImpl _value, $Res Function(_$UserStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? totalPoints = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastCheckInDate = freezed,
    Object? totalTasksCompleted = null,
    Object? totalFocusMinutes = null,
    Object? unlockedBadgeIds = null,
    Object? unlockedAchievementIds = null,
    Object? totalCheckIns = null,
    Object? makeupCardsCount = null,
    Object? lastManualCheckInDate = freezed,
    Object? totalDraws = null,
    Object? freeDrawsUsedToday = null,
    Object? lastFreeDrawDate = freezed,
    Object? drawPityCounter = null,
    Object? equippedTitleId = freezed,
    Object? unlockedTitleIds = null,
  }) {
    return _then(_$UserStatsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
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
      totalTasksCompleted: null == totalTasksCompleted
          ? _value.totalTasksCompleted
          : totalTasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalFocusMinutes: null == totalFocusMinutes
          ? _value.totalFocusMinutes
          : totalFocusMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedBadgeIds: null == unlockedBadgeIds
          ? _value._unlockedBadgeIds
          : unlockedBadgeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      unlockedAchievementIds: null == unlockedAchievementIds
          ? _value._unlockedAchievementIds
          : unlockedAchievementIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalCheckIns: null == totalCheckIns
          ? _value.totalCheckIns
          : totalCheckIns // ignore: cast_nullable_to_non_nullable
              as int,
      makeupCardsCount: null == makeupCardsCount
          ? _value.makeupCardsCount
          : makeupCardsCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastManualCheckInDate: freezed == lastManualCheckInDate
          ? _value.lastManualCheckInDate
          : lastManualCheckInDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalDraws: null == totalDraws
          ? _value.totalDraws
          : totalDraws // ignore: cast_nullable_to_non_nullable
              as int,
      freeDrawsUsedToday: null == freeDrawsUsedToday
          ? _value.freeDrawsUsedToday
          : freeDrawsUsedToday // ignore: cast_nullable_to_non_nullable
              as int,
      lastFreeDrawDate: freezed == lastFreeDrawDate
          ? _value.lastFreeDrawDate
          : lastFreeDrawDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      drawPityCounter: null == drawPityCounter
          ? _value.drawPityCounter
          : drawPityCounter // ignore: cast_nullable_to_non_nullable
              as int,
      equippedTitleId: freezed == equippedTitleId
          ? _value.equippedTitleId
          : equippedTitleId // ignore: cast_nullable_to_non_nullable
              as String?,
      unlockedTitleIds: null == unlockedTitleIds
          ? _value._unlockedTitleIds
          : unlockedTitleIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsImpl extends _UserStats {
  const _$UserStatsImpl(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.totalPoints = 0,
      this.currentStreak = 0,
      this.longestStreak = 0,
      this.lastCheckInDate,
      this.totalTasksCompleted = 0,
      this.totalFocusMinutes = 0,
      final List<String> unlockedBadgeIds = const <String>[],
      final List<String> unlockedAchievementIds = const <String>[],
      this.totalCheckIns = 0,
      this.makeupCardsCount = 0,
      this.lastManualCheckInDate,
      this.totalDraws = 0,
      this.freeDrawsUsedToday = 0,
      this.lastFreeDrawDate,
      this.drawPityCounter = 0,
      this.equippedTitleId,
      final List<String> unlockedTitleIds = const <String>[]})
      : _unlockedBadgeIds = unlockedBadgeIds,
        _unlockedAchievementIds = unlockedAchievementIds,
        _unlockedTitleIds = unlockedTitleIds,
        super._();

  factory _$UserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final int totalPoints;
// 总积分
  @override
  @JsonKey()
  final int currentStreak;
// 当前连续打卡天数
  @override
  @JsonKey()
  final int longestStreak;
// 最长连续打卡天数
  @override
  final DateTime? lastCheckInDate;
// 最后打卡日期
  @override
  @JsonKey()
  final int totalTasksCompleted;
// 总完成任务数
  @override
  @JsonKey()
  final int totalFocusMinutes;
// 总专注时长(分钟)
  final List<String> _unlockedBadgeIds;
// 总专注时长(分钟)
  @override
  @JsonKey()
  List<String> get unlockedBadgeIds {
    if (_unlockedBadgeIds is EqualUnmodifiableListView)
      return _unlockedBadgeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockedBadgeIds);
  }

// 已解锁徽章ID
  final List<String> _unlockedAchievementIds;
// 已解锁徽章ID
  @override
  @JsonKey()
  List<String> get unlockedAchievementIds {
    if (_unlockedAchievementIds is EqualUnmodifiableListView)
      return _unlockedAchievementIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockedAchievementIds);
  }

// 已解锁成就ID
  @override
  @JsonKey()
  final int totalCheckIns;
// 总签到天数
  @override
  @JsonKey()
  final int makeupCardsCount;
// 补签卡数量
  @override
  final DateTime? lastManualCheckInDate;
// 最后手动签到日期
  @override
  @JsonKey()
  final int totalDraws;
// 总抽奖次数
  @override
  @JsonKey()
  final int freeDrawsUsedToday;
// 今日已用免费次数
  @override
  final DateTime? lastFreeDrawDate;
// 最后免费抽奖日期
  @override
  @JsonKey()
  final int drawPityCounter;
// 抽奖保底计数器
  @override
  final String? equippedTitleId;
// 当前佩戴的称号ID
  final List<String> _unlockedTitleIds;
// 当前佩戴的称号ID
  @override
  @JsonKey()
  List<String> get unlockedTitleIds {
    if (_unlockedTitleIds is EqualUnmodifiableListView)
      return _unlockedTitleIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockedTitleIds);
  }

  @override
  String toString() {
    return 'UserStats(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, totalPoints: $totalPoints, currentStreak: $currentStreak, longestStreak: $longestStreak, lastCheckInDate: $lastCheckInDate, totalTasksCompleted: $totalTasksCompleted, totalFocusMinutes: $totalFocusMinutes, unlockedBadgeIds: $unlockedBadgeIds, unlockedAchievementIds: $unlockedAchievementIds, totalCheckIns: $totalCheckIns, makeupCardsCount: $makeupCardsCount, lastManualCheckInDate: $lastManualCheckInDate, totalDraws: $totalDraws, freeDrawsUsedToday: $freeDrawsUsedToday, lastFreeDrawDate: $lastFreeDrawDate, drawPityCounter: $drawPityCounter, equippedTitleId: $equippedTitleId, unlockedTitleIds: $unlockedTitleIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastCheckInDate, lastCheckInDate) ||
                other.lastCheckInDate == lastCheckInDate) &&
            (identical(other.totalTasksCompleted, totalTasksCompleted) ||
                other.totalTasksCompleted == totalTasksCompleted) &&
            (identical(other.totalFocusMinutes, totalFocusMinutes) ||
                other.totalFocusMinutes == totalFocusMinutes) &&
            const DeepCollectionEquality()
                .equals(other._unlockedBadgeIds, _unlockedBadgeIds) &&
            const DeepCollectionEquality().equals(
                other._unlockedAchievementIds, _unlockedAchievementIds) &&
            (identical(other.totalCheckIns, totalCheckIns) ||
                other.totalCheckIns == totalCheckIns) &&
            (identical(other.makeupCardsCount, makeupCardsCount) ||
                other.makeupCardsCount == makeupCardsCount) &&
            (identical(other.lastManualCheckInDate, lastManualCheckInDate) ||
                other.lastManualCheckInDate == lastManualCheckInDate) &&
            (identical(other.totalDraws, totalDraws) ||
                other.totalDraws == totalDraws) &&
            (identical(other.freeDrawsUsedToday, freeDrawsUsedToday) ||
                other.freeDrawsUsedToday == freeDrawsUsedToday) &&
            (identical(other.lastFreeDrawDate, lastFreeDrawDate) ||
                other.lastFreeDrawDate == lastFreeDrawDate) &&
            (identical(other.drawPityCounter, drawPityCounter) ||
                other.drawPityCounter == drawPityCounter) &&
            (identical(other.equippedTitleId, equippedTitleId) ||
                other.equippedTitleId == equippedTitleId) &&
            const DeepCollectionEquality()
                .equals(other._unlockedTitleIds, _unlockedTitleIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        createdAt,
        updatedAt,
        totalPoints,
        currentStreak,
        longestStreak,
        lastCheckInDate,
        totalTasksCompleted,
        totalFocusMinutes,
        const DeepCollectionEquality().hash(_unlockedBadgeIds),
        const DeepCollectionEquality().hash(_unlockedAchievementIds),
        totalCheckIns,
        makeupCardsCount,
        lastManualCheckInDate,
        totalDraws,
        freeDrawsUsedToday,
        lastFreeDrawDate,
        drawPityCounter,
        equippedTitleId,
        const DeepCollectionEquality().hash(_unlockedTitleIds)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsImplToJson(
      this,
    );
  }
}

abstract class _UserStats extends UserStats {
  const factory _UserStats(
      {required final String id,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final int totalPoints,
      final int currentStreak,
      final int longestStreak,
      final DateTime? lastCheckInDate,
      final int totalTasksCompleted,
      final int totalFocusMinutes,
      final List<String> unlockedBadgeIds,
      final List<String> unlockedAchievementIds,
      final int totalCheckIns,
      final int makeupCardsCount,
      final DateTime? lastManualCheckInDate,
      final int totalDraws,
      final int freeDrawsUsedToday,
      final DateTime? lastFreeDrawDate,
      final int drawPityCounter,
      final String? equippedTitleId,
      final List<String> unlockedTitleIds}) = _$UserStatsImpl;
  const _UserStats._() : super._();

  factory _UserStats.fromJson(Map<String, dynamic> json) =
      _$UserStatsImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int get totalPoints;
  @override // 总积分
  int get currentStreak;
  @override // 当前连续打卡天数
  int get longestStreak;
  @override // 最长连续打卡天数
  DateTime? get lastCheckInDate;
  @override // 最后打卡日期
  int get totalTasksCompleted;
  @override // 总完成任务数
  int get totalFocusMinutes;
  @override // 总专注时长(分钟)
  List<String> get unlockedBadgeIds;
  @override // 已解锁徽章ID
  List<String> get unlockedAchievementIds;
  @override // 已解锁成就ID
  int get totalCheckIns;
  @override // 总签到天数
  int get makeupCardsCount;
  @override // 补签卡数量
  DateTime? get lastManualCheckInDate;
  @override // 最后手动签到日期
  int get totalDraws;
  @override // 总抽奖次数
  int get freeDrawsUsedToday;
  @override // 今日已用免费次数
  DateTime? get lastFreeDrawDate;
  @override // 最后免费抽奖日期
  int get drawPityCounter;
  @override // 抽奖保底计数器
  String? get equippedTitleId;
  @override // 当前佩戴的称号ID
  List<String> get unlockedTitleIds;
  @override
  @JsonKey(ignore: true)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
