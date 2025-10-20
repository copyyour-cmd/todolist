// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(Map<String, dynamic> json) =>
    _$DashboardStatsImpl(
      todayCompletedCount: (json['todayCompletedCount'] as num).toInt(),
      todayTotalCount: (json['todayTotalCount'] as num).toInt(),
      weekFocusMinutes: (json['weekFocusMinutes'] as num).toInt(),
      weekFocusSessions: (json['weekFocusSessions'] as num).toInt(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      lastCheckInDate: json['lastCheckInDate'] == null
          ? null
          : DateTime.parse(json['lastCheckInDate'] as String),
      urgentTasksCount: (json['urgentTasksCount'] as num).toInt(),
      overdueTasksCount: (json['overdueTasksCount'] as num).toInt(),
      todayCompletionRate: (json['todayCompletionRate'] as num).toDouble(),
      weekFocusHours: (json['weekFocusHours'] as num).toInt(),
    );

Map<String, dynamic> _$$DashboardStatsImplToJson(
        _$DashboardStatsImpl instance) =>
    <String, dynamic>{
      'todayCompletedCount': instance.todayCompletedCount,
      'todayTotalCount': instance.todayTotalCount,
      'weekFocusMinutes': instance.weekFocusMinutes,
      'weekFocusSessions': instance.weekFocusSessions,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastCheckInDate': instance.lastCheckInDate?.toIso8601String(),
      'urgentTasksCount': instance.urgentTasksCount,
      'overdueTasksCount': instance.overdueTasksCount,
      'todayCompletionRate': instance.todayCompletionRate,
      'weekFocusHours': instance.weekFocusHours,
    };
