import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_statistics.dart';
import 'package:todolist/src/domain/repositories/statistics_repository.dart';
import 'package:todolist/src/domain/repositories/tag_repository.dart';
import 'package:todolist/src/domain/repositories/task_list_repository.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';

class HiveStatisticsRepository implements StatisticsRepository {
  HiveStatisticsRepository({
    required TaskRepository taskRepository,
    required TaskListRepository listRepository,
    required TagRepository tagRepository,
    required Clock clock,
  })  : _taskRepository = taskRepository,
        _listRepository = listRepository,
        _tagRepository = tagRepository,
        _clock = clock;

  final TaskRepository _taskRepository;
  final TaskListRepository _listRepository;
  final TagRepository _tagRepository;
  final Clock _clock;

  @override
  Future<TaskStatistics> getStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final now = _clock.now();
    final end = endDate ?? now;
    final start = startDate ?? end.subtract(const Duration(days: 90));

    final tasks = await _taskRepository.getAll();

    // Get all components
    final last7Days = await getCompletionTrend(
      startDate: now.subtract(const Duration(days: 6)),
      endDate: now,
    );
    final last30Days = await getCompletionTrend(
      startDate: now.subtract(const Duration(days: 29)),
      endDate: now,
    );
    final last90Days = await getCompletionTrend(
      startDate: now.subtract(const Duration(days: 89)),
      endDate: now,
    );

    final byList = await getCompletionRateByList();
    final byTag = await getCompletionRateByTag();
    final byPriority = await getCompletionRateByPriority();
    final topProcrastinated = await getTopProcrastinatedTasks();
    final productivityByHour = await getProductivityByTimeSlot();
    final heatmapData = await getHeatmapData(
      startDate: now.subtract(const Duration(days: 364)),
      endDate: now,
    );

    // Calculate summary stats
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final totalTasks = tasks.length;
    final overallRate = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    final streaks = _calculateStreaks(tasks);

    return TaskStatistics(
      last7Days: last7Days,
      last30Days: last30Days,
      last90Days: last90Days,
      byList: byList,
      byTag: byTag,
      byPriority: byPriority,
      topProcrastinated: topProcrastinated,
      productivityByHour: productivityByHour,
      heatmapData: heatmapData,
      totalTasksCompleted: completedTasks,
      totalTasksCreated: totalTasks,
      overallCompletionRate: overallRate,
      currentStreak: streaks['current'] ?? 0,
      longestStreak: streaks['longest'] ?? 0,
      lastCompletionDate: streaks['lastDate'],
    );
  }

  @override
  Future<List<CompletionTrendPoint>> getCompletionTrend({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final tasks = await _taskRepository.getAll();
    final points = <CompletionTrendPoint>[];

    var currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      final nextDay = currentDate.add(const Duration(days: 1));

      // Count tasks completed on this day
      final completedOnDay = tasks.where((task) {
        if (!task.isCompleted || task.completedAt == null) return false;
        final completedDate = task.completedAt!;
        return completedDate.isAfter(currentDate.subtract(const Duration(microseconds: 1))) &&
            completedDate.isBefore(nextDay);
      }).length;

      // Count tasks that were due on this day
      final dueOnDay = tasks.where((task) {
        if (task.dueAt == null) return false;
        final dueDate = task.dueAt!;
        return dueDate.isAfter(currentDate.subtract(const Duration(microseconds: 1))) &&
            dueDate.isBefore(nextDay);
      }).length;

      points.add(CompletionTrendPoint(
        date: currentDate,
        completedCount: completedOnDay,
        totalCount: dueOnDay,
      ));

      currentDate = nextDay;
    }

    return points;
  }

  @override
  Future<List<CompletionRateByCategory>> getCompletionRateByList() async {
    final tasks = await _taskRepository.getAll();
    final lists = await _listRepository.findAll();

    final stats = <CompletionRateByCategory>[];

    for (final list in lists) {
      final listTasks = tasks.where((t) => t.listId == list.id).toList();
      if (listTasks.isEmpty) continue;

      final completed = listTasks.where((t) => t.isCompleted).length;

      stats.add(CompletionRateByCategory(
        categoryId: list.id,
        categoryName: list.name,
        completedCount: completed,
        totalCount: listTasks.length,
        color: int.parse(list.colorHex.replaceFirst('#', ''), radix: 16) | 0xFF000000,
      ));
    }

    return stats..sort((a, b) => b.totalCount.compareTo(a.totalCount));
  }

  @override
  Future<List<CompletionRateByCategory>> getCompletionRateByTag() async {
    final tasks = await _taskRepository.getAll();
    final tags = await _tagRepository.findAll();

    final stats = <CompletionRateByCategory>[];

    for (final tag in tags) {
      final tagTasks = tasks.where((t) => t.tagIds.contains(tag.id)).toList();
      if (tagTasks.isEmpty) continue;

      final completed = tagTasks.where((t) => t.isCompleted).length;

      stats.add(CompletionRateByCategory(
        categoryId: tag.id,
        categoryName: tag.name,
        completedCount: completed,
        totalCount: tagTasks.length,
        color: int.parse(tag.colorHex.replaceFirst('#', ''), radix: 16) | 0xFF000000,
      ));
    }

    return stats..sort((a, b) => b.totalCount.compareTo(a.totalCount));
  }

  @override
  Future<List<CompletionRateByCategory>> getCompletionRateByPriority() async {
    final tasks = await _taskRepository.getAll();
    final stats = <CompletionRateByCategory>[];

    for (final priority in TaskPriority.values) {
      final priorityTasks = tasks.where((t) => t.priority == priority).toList();
      if (priorityTasks.isEmpty) continue;

      final completed = priorityTasks.where((t) => t.isCompleted).length;

      final color = switch (priority) {
        TaskPriority.critical => 0xFFD32F2F,
        TaskPriority.high => 0xFFF57C00,
        TaskPriority.medium => 0xFF1976D2,
        TaskPriority.low => 0xFF388E3C,
        TaskPriority.none => 0xFF757575,
      };

      stats.add(CompletionRateByCategory(
        categoryId: priority.name,
        categoryName: _priorityLabel(priority),
        completedCount: completed,
        totalCount: priorityTasks.length,
        color: color,
      ));
    }

    return stats;
  }

  @override
  Future<List<ProcrastinationStat>> getTopProcrastinatedTasks({
    int limit = 10,
  }) async {
    final tasks = await _taskRepository.getAll();
    final now = _clock.now();

    final procrastinated = <ProcrastinationStat>[];

    for (final task in tasks) {
      if (task.isCompleted || task.dueAt == null) continue;

      final overdueDays = now.difference(task.dueAt!).inDays;
      if (overdueDays <= 0) continue;

      // Use version as proxy for postpone count
      // (In real implementation, you'd track this separately)
      final postponeCount = task.version;

      procrastinated.add(ProcrastinationStat(
        taskId: task.id,
        taskTitle: task.title,
        postponeCount: postponeCount,
        overdueDays: overdueDays,
        dueAt: task.dueAt,
      ));
    }

    procrastinated.sort((a, b) {
      final daysCompare = b.overdueDays.compareTo(a.overdueDays);
      if (daysCompare != 0) return daysCompare;
      return b.postponeCount.compareTo(a.postponeCount);
    });

    return procrastinated.take(limit).toList();
  }

  @override
  Future<List<ProductivityByTimeSlot>> getProductivityByTimeSlot() async {
    final tasks = await _taskRepository.getAll();
    final completedTasks = tasks.where((t) => t.isCompleted && t.completedAt != null);

    final hourlyStats = <int, Map<String, int>>{};

    for (var i = 0; i < 24; i++) {
      hourlyStats[i] = {'count': 0, 'minutes': 0};
    }

    for (final task in completedTasks) {
      final hour = task.completedAt!.hour;
      hourlyStats[hour]!['count'] = hourlyStats[hour]!['count']! + 1;

      if (task.estimatedMinutes != null) {
        hourlyStats[hour]!['minutes'] =
            hourlyStats[hour]!['minutes']! + task.estimatedMinutes!;
      }
    }

    final result = <ProductivityByTimeSlot>[];
    for (var i = 0; i < 24; i++) {
      final stats = hourlyStats[i]!;
      if (stats['count']! > 0) {
        result.add(ProductivityByTimeSlot(
          hour: i,
          completedCount: stats['count']!,
          totalMinutesSpent: stats['minutes']!,
        ));
      }
    }

    return result..sort((a, b) => b.completedCount.compareTo(a.completedCount));
  }

  @override
  Future<List<HeatmapDataPoint>> getHeatmapData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final tasks = await _taskRepository.getAll();
    final completedTasks = tasks.where((t) => t.isCompleted && t.completedAt != null);

    final dailyCompletions = <String, int>{};

    for (final task in completedTasks) {
      final date = task.completedAt!;
      final dateKey = '${date.year}-${date.month}-${date.day}';
      dailyCompletions[dateKey] = (dailyCompletions[dateKey] ?? 0) + 1;
    }

    // Find max for intensity calculation
    final maxCompletions = dailyCompletions.values.isEmpty
        ? 1
        : dailyCompletions.values.reduce((a, b) => a > b ? a : b);

    final points = <HeatmapDataPoint>[];
    var currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      final dateKey = '${currentDate.year}-${currentDate.month}-${currentDate.day}';
      final count = dailyCompletions[dateKey] ?? 0;

      // Calculate intensity (0-4, GitHub style)
      final intensity = count == 0
          ? 0
          : ((count / maxCompletions) * 4).ceil().clamp(1, 4);

      points.add(HeatmapDataPoint(
        date: currentDate,
        completedCount: count,
        intensity: intensity,
      ));

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return points;
  }

  @override
  Future<Map<String, dynamic>> getSummaryStats() async {
    final tasks = await _taskRepository.getAll();
    final completed = tasks.where((t) => t.isCompleted).length;

    return {
      'total': tasks.length,
      'completed': completed,
      'pending': tasks.length - completed,
      'completion_rate': tasks.isEmpty ? 0.0 : completed / tasks.length,
    };
  }

  Map<String, dynamic> _calculateStreaks(List<Task> tasks) {
    final completedDates = tasks
        .where((t) => t.isCompleted && t.completedAt != null)
        .map((t) {
          final date = t.completedAt!;
          return DateTime(date.year, date.month, date.day);
        })
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Sort descending

    if (completedDates.isEmpty) {
      return {'current': 0, 'longest': 0, 'lastDate': null};
    }

    final now = _clock.now();
    final today = DateTime(now.year, now.month, now.day);

    var currentStreak = 0;
    var longestStreak = 0;
    var tempStreak = 1;
    var expectedDate = completedDates.first;

    // Calculate current streak
    if (expectedDate.isAtSameMomentAs(today) ||
        expectedDate.isAtSameMomentAs(today.subtract(const Duration(days: 1)))) {
      currentStreak = 1;
      for (var i = 1; i < completedDates.length; i++) {
        expectedDate = expectedDate.subtract(const Duration(days: 1));
        if (completedDates[i].isAtSameMomentAs(expectedDate)) {
          currentStreak++;
        } else {
          break;
        }
      }
    }

    // Calculate longest streak
    for (var i = 1; i < completedDates.length; i++) {
      final diff = completedDates[i - 1].difference(completedDates[i]).inDays;
      if (diff == 1) {
        tempStreak++;
        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
      } else {
        tempStreak = 1;
      }
    }

    longestStreak = longestStreak > currentStreak ? longestStreak : currentStreak;

    return {
      'current': currentStreak,
      'longest': longestStreak,
      'lastDate': completedDates.first,
    };
  }

  String _priorityLabel(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.critical => '紧急',
      TaskPriority.high => '高',
      TaskPriority.medium => '中',
      TaskPriority.low => '低',
      TaskPriority.none => '无',
    };
  }
}
