import 'package:todolist/src/domain/entities/task_statistics.dart';

/// Repository for task statistics and analytics
abstract class StatisticsRepository {
  /// Get comprehensive task statistics
  Future<TaskStatistics> getStatistics({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get completion trend data for a specific period
  Future<List<CompletionTrendPoint>> getCompletionTrend({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get completion rate breakdown by category (list/tag/priority)
  Future<List<CompletionRateByCategory>> getCompletionRateByList();
  Future<List<CompletionRateByCategory>> getCompletionRateByTag();
  Future<List<CompletionRateByCategory>> getCompletionRateByPriority();

  /// Get most procrastinated tasks
  Future<List<ProcrastinationStat>> getTopProcrastinatedTasks({
    int limit = 10,
  });

  /// Get productivity data by time slot
  Future<List<ProductivityByTimeSlot>> getProductivityByTimeSlot();

  /// Get heatmap data for calendar view
  Future<List<HeatmapDataPoint>> getHeatmapData({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get overall statistics summary
  Future<Map<String, dynamic>> getSummaryStats();
}
