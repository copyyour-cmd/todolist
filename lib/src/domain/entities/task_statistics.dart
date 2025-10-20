import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_statistics.freezed.dart';
part 'task_statistics.g.dart';

/// 任务完成趋势数据点
@freezed
class CompletionTrendPoint with _$CompletionTrendPoint {
  const factory CompletionTrendPoint({
    required DateTime date,
    required int completedCount,
    required int totalCount,
  }) = _CompletionTrendPoint;

  const CompletionTrendPoint._();

  factory CompletionTrendPoint.fromJson(Map<String, dynamic> json) =>
      _$CompletionTrendPointFromJson(json);

  double get completionRate =>
      totalCount > 0 ? completedCount / totalCount : 0.0;
}

/// 按分类的完成率统计
@freezed
class CompletionRateByCategory with _$CompletionRateByCategory {
  const factory CompletionRateByCategory({
    required String categoryId,
    required String categoryName,
    required int completedCount,
    required int totalCount,
    required int color,
  }) = _CompletionRateByCategory;

  const CompletionRateByCategory._();

  factory CompletionRateByCategory.fromJson(Map<String, dynamic> json) =>
      _$CompletionRateByCategoryFromJson(json);

  double get completionRate =>
      totalCount > 0 ? completedCount / totalCount : 0.0;
}

/// 拖延任务统计
@freezed
class ProcrastinationStat with _$ProcrastinationStat {
  const factory ProcrastinationStat({
    required String taskId,
    required String taskTitle,
    required int postponeCount,
    required int overdueDays,
    required DateTime? dueAt,
  }) = _ProcrastinationStat;

  factory ProcrastinationStat.fromJson(Map<String, dynamic> json) =>
      _$ProcrastinationStatFromJson(json);
}

/// 时段生产力统计
@freezed
class ProductivityByTimeSlot with _$ProductivityByTimeSlot {
  const factory ProductivityByTimeSlot({
    required int hour,
    required int completedCount,
    required int totalMinutesSpent,
  }) = _ProductivityByTimeSlot;

  const ProductivityByTimeSlot._();

  factory ProductivityByTimeSlot.fromJson(Map<String, dynamic> json) =>
      _$ProductivityByTimeSlotFromJson(json);

  String get timeSlotLabel {
    if (hour < 6) return '凌晨 (0-6时)';
    if (hour < 12) return '上午 (6-12时)';
    if (hour < 18) return '下午 (12-18时)';
    return '晚上 (18-24时)';
  }

  double get averageMinutesPerTask =>
      completedCount > 0 ? totalMinutesSpent / completedCount : 0.0;
}

/// 日历热力图数据点
@freezed
class HeatmapDataPoint with _$HeatmapDataPoint {
  const factory HeatmapDataPoint({
    required DateTime date,
    required int completedCount,
    required int intensity, // 0-4, GitHub style
  }) = _HeatmapDataPoint;

  factory HeatmapDataPoint.fromJson(Map<String, dynamic> json) =>
      _$HeatmapDataPointFromJson(json);
}

/// 完整的统计数据
@freezed
class TaskStatistics with _$TaskStatistics {
  const factory TaskStatistics({
    // 趋势数据
    required List<CompletionTrendPoint> last7Days,
    required List<CompletionTrendPoint> last30Days,
    required List<CompletionTrendPoint> last90Days,

    // 分类完成率
    required List<CompletionRateByCategory> byList,
    required List<CompletionRateByCategory> byTag,
    required List<CompletionRateByCategory> byPriority,

    // 拖延排行
    required List<ProcrastinationStat> topProcrastinated,

    // 时段分析
    required List<ProductivityByTimeSlot> productivityByHour,

    // 热力图
    required List<HeatmapDataPoint> heatmapData,

    // 汇总指标
    required int totalTasksCompleted,
    required int totalTasksCreated,
    required double overallCompletionRate,
    required int currentStreak,
    required int longestStreak,
    required DateTime? lastCompletionDate,
  }) = _TaskStatistics;

  const TaskStatistics._();

  factory TaskStatistics.fromJson(Map<String, dynamic> json) =>
      _$TaskStatisticsFromJson(json);

  /// 获取最活跃的时间段
  ProductivityByTimeSlot? get peakProductivityTime {
    if (productivityByHour.isEmpty) return null;
    return productivityByHour.reduce(
      (a, b) => a.completedCount > b.completedCount ? a : b,
    );
  }

  /// 获取最常用的标签
  CompletionRateByCategory? get mostUsedTag {
    if (byTag.isEmpty) return null;
    return byTag.reduce(
      (a, b) => a.totalCount > b.totalCount ? a : b,
    );
  }
}
