// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompletionTrendPointImpl _$$CompletionTrendPointImplFromJson(
        Map<String, dynamic> json) =>
    _$CompletionTrendPointImpl(
      date: DateTime.parse(json['date'] as String),
      completedCount: (json['completedCount'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
    );

Map<String, dynamic> _$$CompletionTrendPointImplToJson(
        _$CompletionTrendPointImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'completedCount': instance.completedCount,
      'totalCount': instance.totalCount,
    };

_$CompletionRateByCategoryImpl _$$CompletionRateByCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$CompletionRateByCategoryImpl(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      completedCount: (json['completedCount'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      color: (json['color'] as num).toInt(),
    );

Map<String, dynamic> _$$CompletionRateByCategoryImplToJson(
        _$CompletionRateByCategoryImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'completedCount': instance.completedCount,
      'totalCount': instance.totalCount,
      'color': instance.color,
    };

_$ProcrastinationStatImpl _$$ProcrastinationStatImplFromJson(
        Map<String, dynamic> json) =>
    _$ProcrastinationStatImpl(
      taskId: json['taskId'] as String,
      taskTitle: json['taskTitle'] as String,
      postponeCount: (json['postponeCount'] as num).toInt(),
      overdueDays: (json['overdueDays'] as num).toInt(),
      dueAt: json['dueAt'] == null
          ? null
          : DateTime.parse(json['dueAt'] as String),
    );

Map<String, dynamic> _$$ProcrastinationStatImplToJson(
        _$ProcrastinationStatImpl instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'taskTitle': instance.taskTitle,
      'postponeCount': instance.postponeCount,
      'overdueDays': instance.overdueDays,
      'dueAt': instance.dueAt?.toIso8601String(),
    };

_$ProductivityByTimeSlotImpl _$$ProductivityByTimeSlotImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductivityByTimeSlotImpl(
      hour: (json['hour'] as num).toInt(),
      completedCount: (json['completedCount'] as num).toInt(),
      totalMinutesSpent: (json['totalMinutesSpent'] as num).toInt(),
    );

Map<String, dynamic> _$$ProductivityByTimeSlotImplToJson(
        _$ProductivityByTimeSlotImpl instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'completedCount': instance.completedCount,
      'totalMinutesSpent': instance.totalMinutesSpent,
    };

_$HeatmapDataPointImpl _$$HeatmapDataPointImplFromJson(
        Map<String, dynamic> json) =>
    _$HeatmapDataPointImpl(
      date: DateTime.parse(json['date'] as String),
      completedCount: (json['completedCount'] as num).toInt(),
      intensity: (json['intensity'] as num).toInt(),
    );

Map<String, dynamic> _$$HeatmapDataPointImplToJson(
        _$HeatmapDataPointImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'completedCount': instance.completedCount,
      'intensity': instance.intensity,
    };

_$TaskStatisticsImpl _$$TaskStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$TaskStatisticsImpl(
      last7Days: (json['last7Days'] as List<dynamic>)
          .map((e) => CompletionTrendPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      last30Days: (json['last30Days'] as List<dynamic>)
          .map((e) => CompletionTrendPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      last90Days: (json['last90Days'] as List<dynamic>)
          .map((e) => CompletionTrendPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      byList: (json['byList'] as List<dynamic>)
          .map((e) =>
              CompletionRateByCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      byTag: (json['byTag'] as List<dynamic>)
          .map((e) =>
              CompletionRateByCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      byPriority: (json['byPriority'] as List<dynamic>)
          .map((e) =>
              CompletionRateByCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      topProcrastinated: (json['topProcrastinated'] as List<dynamic>)
          .map((e) => ProcrastinationStat.fromJson(e as Map<String, dynamic>))
          .toList(),
      productivityByHour: (json['productivityByHour'] as List<dynamic>)
          .map(
              (e) => ProductivityByTimeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
      heatmapData: (json['heatmapData'] as List<dynamic>)
          .map((e) => HeatmapDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalTasksCompleted: (json['totalTasksCompleted'] as num).toInt(),
      totalTasksCreated: (json['totalTasksCreated'] as num).toInt(),
      overallCompletionRate: (json['overallCompletionRate'] as num).toDouble(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      lastCompletionDate: json['lastCompletionDate'] == null
          ? null
          : DateTime.parse(json['lastCompletionDate'] as String),
    );

Map<String, dynamic> _$$TaskStatisticsImplToJson(
        _$TaskStatisticsImpl instance) =>
    <String, dynamic>{
      'last7Days': instance.last7Days,
      'last30Days': instance.last30Days,
      'last90Days': instance.last90Days,
      'byList': instance.byList,
      'byTag': instance.byTag,
      'byPriority': instance.byPriority,
      'topProcrastinated': instance.topProcrastinated,
      'productivityByHour': instance.productivityByHour,
      'heatmapData': instance.heatmapData,
      'totalTasksCompleted': instance.totalTasksCompleted,
      'totalTasksCreated': instance.totalTasksCreated,
      'overallCompletionRate': instance.overallCompletionRate,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastCompletionDate': instance.lastCompletionDate?.toIso8601String(),
    };
