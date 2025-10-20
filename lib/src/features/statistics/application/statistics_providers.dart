import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/domain/entities/task_statistics.dart';
import 'package:todolist/src/domain/repositories/statistics_repository.dart';
import 'package:todolist/src/infrastructure/repositories/hive_statistics_repository.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

part 'statistics_providers.g.dart';

@riverpod
StatisticsRepository statisticsRepository(StatisticsRepositoryRef ref) {
  return HiveStatisticsRepository(
    taskRepository: ref.watch(taskRepositoryProvider),
    listRepository: ref.watch(taskListRepositoryProvider),
    tagRepository: ref.watch(tagRepositoryProvider),
    clock: ref.watch(clockProvider),
  );
}

@riverpod
Future<TaskStatistics> taskStatistics(TaskStatisticsRef ref) async {
  final repository = ref.watch(statisticsRepositoryProvider);
  return repository.getStatistics();
}

@riverpod
Future<List<CompletionTrendPoint>> completionTrend7Days(
  CompletionTrend7DaysRef ref,
) async {
  final repository = ref.watch(statisticsRepositoryProvider);
  final now = DateTime.now();
  return repository.getCompletionTrend(
    startDate: now.subtract(const Duration(days: 6)),
    endDate: now,
  );
}

@riverpod
Future<List<CompletionTrendPoint>> completionTrend30Days(
  CompletionTrend30DaysRef ref,
) async {
  final repository = ref.watch(statisticsRepositoryProvider);
  final now = DateTime.now();
  return repository.getCompletionTrend(
    startDate: now.subtract(const Duration(days: 29)),
    endDate: now,
  );
}

@riverpod
Future<List<CompletionTrendPoint>> completionTrend90Days(
  CompletionTrend90DaysRef ref,
) async {
  final repository = ref.watch(statisticsRepositoryProvider);
  final now = DateTime.now();
  return repository.getCompletionTrend(
    startDate: now.subtract(const Duration(days: 89)),
    endDate: now,
  );
}

@riverpod
Future<List<HeatmapDataPoint>> heatmapData(HeatmapDataRef ref) async {
  final repository = ref.watch(statisticsRepositoryProvider);
  final now = DateTime.now();
  return repository.getHeatmapData(
    startDate: now.subtract(const Duration(days: 364)),
    endDate: now,
  );
}

@riverpod
Future<List<ProcrastinationStat>> topProcrastinatedTasks(
  TopProcrastinatedTasksRef ref,
) async {
  final repository = ref.watch(statisticsRepositoryProvider);
  return repository.getTopProcrastinatedTasks(limit: 10);
}

@riverpod
Future<List<ProductivityByTimeSlot>> productivityByTimeSlot(
  ProductivityByTimeSlotRef ref,
) async {
  final repository = ref.watch(statisticsRepositoryProvider);
  return repository.getProductivityByTimeSlot();
}
