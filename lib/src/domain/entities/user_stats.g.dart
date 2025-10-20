// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastCheckInDate: json['lastCheckInDate'] == null
          ? null
          : DateTime.parse(json['lastCheckInDate'] as String),
      totalTasksCompleted: (json['totalTasksCompleted'] as num?)?.toInt() ?? 0,
      totalFocusMinutes: (json['totalFocusMinutes'] as num?)?.toInt() ?? 0,
      unlockedBadgeIds: (json['unlockedBadgeIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      unlockedAchievementIds: (json['unlockedAchievementIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      totalCheckIns: (json['totalCheckIns'] as num?)?.toInt() ?? 0,
      makeupCardsCount: (json['makeupCardsCount'] as num?)?.toInt() ?? 0,
      lastManualCheckInDate: json['lastManualCheckInDate'] == null
          ? null
          : DateTime.parse(json['lastManualCheckInDate'] as String),
      totalDraws: (json['totalDraws'] as num?)?.toInt() ?? 0,
      freeDrawsUsedToday: (json['freeDrawsUsedToday'] as num?)?.toInt() ?? 0,
      lastFreeDrawDate: json['lastFreeDrawDate'] == null
          ? null
          : DateTime.parse(json['lastFreeDrawDate'] as String),
      drawPityCounter: (json['drawPityCounter'] as num?)?.toInt() ?? 0,
      equippedTitleId: json['equippedTitleId'] as String?,
      unlockedTitleIds: (json['unlockedTitleIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'totalPoints': instance.totalPoints,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastCheckInDate': instance.lastCheckInDate?.toIso8601String(),
      'totalTasksCompleted': instance.totalTasksCompleted,
      'totalFocusMinutes': instance.totalFocusMinutes,
      'unlockedBadgeIds': instance.unlockedBadgeIds,
      'unlockedAchievementIds': instance.unlockedAchievementIds,
      'totalCheckIns': instance.totalCheckIns,
      'makeupCardsCount': instance.makeupCardsCount,
      'lastManualCheckInDate':
          instance.lastManualCheckInDate?.toIso8601String(),
      'totalDraws': instance.totalDraws,
      'freeDrawsUsedToday': instance.freeDrawsUsedToday,
      'lastFreeDrawDate': instance.lastFreeDrawDate?.toIso8601String(),
      'drawPityCounter': instance.drawPityCounter,
      'equippedTitleId': instance.equippedTitleId,
      'unlockedTitleIds': instance.unlockedTitleIds,
    };
