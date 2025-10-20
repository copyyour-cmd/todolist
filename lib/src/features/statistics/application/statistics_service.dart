import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

final statisticsServiceProvider = Provider<StatisticsService>((ref) {
  return StatisticsService(ref);
});

class StatisticsService {
  StatisticsService(this._ref);

  final Ref _ref;

  /// 获取完成率统计
  Future<CompletionRateStats> getCompletionRateStats() async {
    final clock = _ref.read(clockProvider);
    final repository = _ref.read(taskRepositoryProvider);
    final allTasks = await repository.watchAll().first;

    final now = clock.now();
    final today = clock.today();
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    return CompletionRateStats(
      today: _calculateCompletionRate(allTasks, today, today.add(const Duration(days: 1))),
      thisWeek: _calculateCompletionRate(allTasks, weekStart, weekStart.add(const Duration(days: 7))),
      thisMonth: _calculateCompletionRate(allTasks, monthStart, DateTime(now.year, now.month + 1, 1)),
    );
  }

  CompletionRate _calculateCompletionRate(List<Task> tasks, DateTime start, DateTime end) {
    final relevantTasks = tasks.where((task) {
      if (task.createdAt.isBefore(start)) return false;
      if (task.createdAt.isAfter(end)) return false;
      return true;
    }).toList();

    final completed = relevantTasks.where((t) => t.isCompleted).length;
    final total = relevantTasks.length;
    final rate = total > 0 ? (completed / total * 100).round() : 0;

    return CompletionRate(
      completed: completed,
      total: total,
      rate: rate,
    );
  }

  /// 获取每日趋势数据（最近7天）
  Future<List<DailyTaskCount>> getDailyTrend() async {
    final clock = _ref.read(clockProvider);
    final repository = _ref.read(taskRepositoryProvider);
    final allTasks = await repository.watchAll().first;

    final today = clock.today();
    final result = <DailyTaskCount>[];

    for (var i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final nextDate = date.add(const Duration(days: 1));

      final created = allTasks.where((task) {
        return task.createdAt.isAfter(date) && task.createdAt.isBefore(nextDate);
      }).length;

      final completed = allTasks.where((task) {
        final completedAt = task.completedAt;
        if (completedAt == null) return false;
        return completedAt.isAfter(date) && completedAt.isBefore(nextDate);
      }).length;

      result.add(DailyTaskCount(
        date: date,
        created: created,
        completed: completed,
      ));
    }

    return result;
  }

  /// 按列表统计
  Future<List<ListStatistics>> getStatisticsByList() async {
    final repository = _ref.read(taskRepositoryProvider);
    final listRepository = _ref.read(taskListRepositoryProvider);

    final allTasks = await repository.watchAll().first;
    final allLists = await listRepository.watchAll().first;

    return allLists.map((list) {
      final listTasks = allTasks.where((t) => t.listId == list.id).toList();
      final completed = listTasks.where((t) => t.isCompleted).length;

      return ListStatistics(
        list: list,
        total: listTasks.length,
        completed: completed,
        pending: listTasks.length - completed,
      );
    }).toList();
  }

  /// 按标签统计
  Future<List<TagStatistics>> getStatisticsByTag() async {
    final repository = _ref.read(taskRepositoryProvider);
    final tagRepository = _ref.read(tagRepositoryProvider);

    final allTasks = await repository.watchAll().first;
    final allTags = await tagRepository.watchAll().first;

    return allTags.map((tag) {
      final tagTasks = allTasks.where((t) => t.tagIds.contains(tag.id)).toList();
      final completed = tagTasks.where((t) => t.isCompleted).length;

      return TagStatistics(
        tag: tag,
        total: tagTasks.length,
        completed: completed,
        pending: tagTasks.length - completed,
      );
    }).toList();
  }

  /// 获取生产力热力图数据（最近30天）
  Future<List<ProductivityHeatmapData>> getProductivityHeatmap() async {
    final clock = _ref.read(clockProvider);
    final repository = _ref.read(taskRepositoryProvider);
    final allTasks = await repository.watchAll().first;

    final today = clock.today();
    final result = <ProductivityHeatmapData>[];

    for (var i = 29; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final nextDate = date.add(const Duration(days: 1));

      final completedCount = allTasks.where((task) {
        final completedAt = task.completedAt;
        if (completedAt == null) return false;
        return completedAt.isAfter(date) && completedAt.isBefore(nextDate);
      }).length;

      result.add(ProductivityHeatmapData(
        date: date,
        count: completedCount,
      ));
    }

    return result;
  }
}

class CompletionRateStats {
  const CompletionRateStats({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
  });

  final CompletionRate today;
  final CompletionRate thisWeek;
  final CompletionRate thisMonth;
}

class CompletionRate {
  const CompletionRate({
    required this.completed,
    required this.total,
    required this.rate,
  });

  final int completed;
  final int total;
  final int rate;
}

class DailyTaskCount {
  const DailyTaskCount({
    required this.date,
    required this.created,
    required this.completed,
  });

  final DateTime date;
  final int created;
  final int completed;
}

class ListStatistics {
  const ListStatistics({
    required this.list,
    required this.total,
    required this.completed,
    required this.pending,
  });

  final TaskList list;
  final int total;
  final int completed;
  final int pending;
}

class TagStatistics {
  const TagStatistics({
    required this.tag,
    required this.total,
    required this.completed,
    required this.pending,
  });

  final Tag tag;
  final int total;
  final int completed;
  final int pending;
}

class ProductivityHeatmapData {
  const ProductivityHeatmapData({
    required this.date,
    required this.count,
  });

  final DateTime date;
  final int count;
}
