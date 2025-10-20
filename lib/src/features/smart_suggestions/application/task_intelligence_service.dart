import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_suggestion.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

final taskIntelligenceServiceProvider = Provider<TaskIntelligenceService>((ref) {
  return TaskIntelligenceService(ref);
});

/// 智能任务建议服务
///
/// 本小姐实现的AI算法包括：
/// 1. 历史数据分析 - 分析用户完成任务的时间模式
/// 2. 最佳时间推荐 - 推荐最高效的任务完成时间
/// 3. 智能排序 - 综合多维度因素排序任务
/// 4. 时长预测 - 基于历史数据预测任务耗时
class TaskIntelligenceService {
  TaskIntelligenceService(this._ref);

  final Ref _ref;

  /// 获取智能任务建议列表
  ///
  /// 哼，这可是本小姐精心设计的智能排序算法！
  Future<List<TaskSuggestion>> getSmartSuggestions({
    int limit = 10,
    bool onlyPending = true,
  }) async {
    final clock = _ref.read(clockProvider);
    final repository = _ref.read(taskRepositoryProvider);
    final allTasks = await repository.watchAll().first;

    // 过滤待办任务
    final tasks = onlyPending
        ? allTasks.where((t) =>
            t.status == TaskStatus.pending || t.status == TaskStatus.inProgress
          ).toList()
        : allTasks;

    if (tasks.isEmpty) {
      return [];
    }

    // 分析历史完成模式
    final pattern = await _analyzeCompletionPattern(allTasks);

    // 为每个任务生成建议
    final suggestions = <TaskSuggestion>[];
    for (final task in tasks) {
      final suggestion = await _generateSuggestion(
        task,
        pattern,
        allTasks,
        clock,
      );
      suggestions.add(suggestion);
    }

    // 按优先级分数排序
    suggestions.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

    return suggestions.take(limit).toList();
  }

  /// 分析用户的任务完成模式
  ///
  /// 分析历史数据，找出用户最高效的工作时间段
  Future<TaskCompletionPattern> _analyzeCompletionPattern(
    List<Task> allTasks,
  ) async {
    final completedTasks = allTasks
        .where((t) => t.isCompleted && t.completedAt != null)
        .toList();

    if (completedTasks.isEmpty) {
      // 没有历史数据时使用默认模式
      return TaskCompletionPattern(
        averageCompletionHour: 14.0,
        mostProductiveHours: [9, 10, 14, 15, 20],
        averageDuration: 30.0,
        completionRate: 0.7,
        sampleSize: 0,
      );
    }

    // 统计完成时间分布（按小时）
    final hourCounts = <int, int>{};
    var totalMinutes = 0;
    var totalHours = 0.0;

    for (final task in completedTasks) {
      final completedAt = task.completedAt!;
      final hour = completedAt.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
      totalHours += hour;

      if (task.actualMinutes > 0) {
        totalMinutes += task.actualMinutes;
      } else if (task.estimatedMinutes != null && task.estimatedMinutes! > 0) {
        totalMinutes += task.estimatedMinutes!;
      }
    }

    // 找出最高产的5个小时
    final sortedHours = hourCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final mostProductiveHours = sortedHours
        .take(5)
        .map((e) => e.key)
        .toList();

    // 计算平均时长
    final averageDuration = completedTasks.isNotEmpty
        ? totalMinutes / completedTasks.length
        : 30.0;

    // 计算完成率
    final totalTasks = allTasks.length;
    final completionRate = totalTasks > 0
        ? completedTasks.length / totalTasks
        : 0.7;

    return TaskCompletionPattern(
      averageCompletionHour: totalHours / completedTasks.length,
      mostProductiveHours: mostProductiveHours,
      averageDuration: averageDuration,
      completionRate: completionRate,
      sampleSize: completedTasks.length,
    );
  }

  /// 为单个任务生成智能建议
  Future<TaskSuggestion> _generateSuggestion(
    Task task,
    TaskCompletionPattern pattern,
    List<Task> allTasks,
    Clock clock,
  ) async {
    // 计算优先级分数（0-100）
    final priorityScore = _calculatePriorityScore(task, clock);

    // 推荐最佳完成时间
    final bestTimeSlot = _recommendBestTimeSlot(task, pattern);

    // 预测任务时长
    final predictedMinutes = _predictDuration(task, allTasks, pattern);

    // 计算完成概率
    final completionProbability = _calculateCompletionProbability(
      task,
      pattern,
      clock,
    );

    // 生成建议原因
    final reasons = _generateReasons(
      task,
      priorityScore,
      bestTimeSlot,
      completionProbability,
      clock,
    );

    return TaskSuggestion(
      task: task,
      priorityScore: priorityScore,
      bestTimeSlot: bestTimeSlot,
      predictedMinutes: predictedMinutes,
      completionProbability: completionProbability,
      reasons: reasons,
    );
  }

  /// 计算任务优先级分数
  ///
  /// 综合考虑：
  /// - 任务优先级 (0-40分)
  /// - 截止日期紧急程度 (0-30分)
  /// - 任务状态 (0-20分)
  /// - 是否有预估时长 (0-10分)
  double _calculatePriorityScore(Task task, Clock clock) {
    var score = 0.0;

    // 1. 任务优先级基础分 (0-40)
    switch (task.priority) {
      case TaskPriority.critical:
        score += 40;
        break;
      case TaskPriority.high:
        score += 30;
        break;
      case TaskPriority.medium:
        score += 20;
        break;
      case TaskPriority.low:
        score += 10;
        break;
      case TaskPriority.none:
        score += 0;
        break;
    }

    // 2. 截止日期紧急度 (0-30)
    if (task.dueAt != null) {
      final now = clock.now();
      final hoursUntilDue = task.dueAt!.difference(now).inHours;

      if (hoursUntilDue < 0) {
        // 已逾期，最高分
        score += 30;
      } else if (hoursUntilDue < 24) {
        // 24小时内
        score += 25;
      } else if (hoursUntilDue < 72) {
        // 3天内
        score += 20;
      } else if (hoursUntilDue < 168) {
        // 1周内
        score += 15;
      } else {
        // 1周以上
        score += 10;
      }
    }

    // 3. 任务状态 (0-20)
    if (task.status == TaskStatus.inProgress) {
      // 进行中的任务优先完成
      score += 20;
    } else if (task.status == TaskStatus.pending) {
      score += 10;
    }

    // 4. 有时间预估的任务更容易规划 (0-10)
    if (task.estimatedMinutes != null && task.estimatedMinutes! > 0) {
      score += 10;
    }

    return score.clamp(0, 100);
  }

  /// 推荐最佳完成时间段
  ///
  /// 基于用户历史完成时间模式推荐
  SuggestedTimeSlot? _recommendBestTimeSlot(
    Task task,
    TaskCompletionPattern pattern,
  ) {
    if (pattern.sampleSize == 0) {
      // 没有足够数据时返回默认推荐
      return const SuggestedTimeSlot(
        hourOfDay: 9,
        timeLabel: '上午 9:00',
        successRate: 0.7,
      );
    }

    // 使用用户最高产的时间段
    final bestHour = pattern.mostProductiveHours.first;
    final successRate = pattern.completionRate;

    return SuggestedTimeSlot(
      hourOfDay: bestHour,
      timeLabel: _formatTimeLabel(bestHour),
      successRate: successRate,
    );
  }

  /// 预测任务时长
  ///
  /// 算法逻辑：
  /// 1. 如果任务有预估时长，使用预估值
  /// 2. 否则基于相同标签/列表的历史任务计算平均时长
  /// 3. 最后使用全局平均时长
  int _predictDuration(
    Task task,
    List<Task> allTasks,
    TaskCompletionPattern pattern,
  ) {
    // 1. 优先使用任务自己的预估
    if (task.estimatedMinutes != null && task.estimatedMinutes! > 0) {
      return task.estimatedMinutes!;
    }

    // 2. 查找相似任务（相同列表或相同标签）
    final similarTasks = allTasks.where((t) {
      if (!t.isCompleted) return false;
      if (t.actualMinutes == 0) return false;

      // 相同列表
      if (t.listId == task.listId) return true;

      // 有相同标签
      if (task.tagIds.isNotEmpty) {
        return task.tagIds.any((tagId) => t.tagIds.contains(tagId));
      }

      return false;
    }).toList();

    if (similarTasks.isNotEmpty) {
      final totalMinutes = similarTasks.fold<int>(
        0,
        (sum, t) => sum + t.actualMinutes,
      );
      return (totalMinutes / similarTasks.length).round();
    }

    // 3. 使用全局平均时长
    return pattern.averageDuration.round();
  }

  /// 计算任务完成概率
  ///
  /// 考虑因素：
  /// - 用户整体完成率
  /// - 任务是否有明确时间规划
  /// - 任务复杂度（子任务数量）
  double _calculateCompletionProbability(
    Task task,
    TaskCompletionPattern pattern,
    Clock clock,
  ) {
    var probability = pattern.completionRate;

    // 有截止日期的任务完成率更高
    if (task.dueAt != null) {
      probability += 0.1;
    }

    // 有时间预估的任务完成率更高
    if (task.estimatedMinutes != null && task.estimatedMinutes! > 0) {
      probability += 0.1;
    }

    // 子任务太多会降低完成率
    if (task.subtasks.length > 5) {
      probability -= 0.1;
    }

    // 已经进行中的任务更可能完成
    if (task.status == TaskStatus.inProgress) {
      probability += 0.15;
    }

    return probability.clamp(0.0, 1.0);
  }

  /// 生成建议原因列表
  List<String> _generateReasons(
    Task task,
    double priorityScore,
    SuggestedTimeSlot? timeSlot,
    double completionProbability,
    Clock clock,
  ) {
    final reasons = <String>[];

    // 优先级原因
    if (task.priority == TaskPriority.critical) {
      reasons.add('⚡ 紧急重要任务，需立即处理');
    } else if (task.priority == TaskPriority.high) {
      reasons.add('🔥 高优先级任务');
    }

    // 截止日期原因
    if (task.dueAt != null) {
      final now = clock.now();
      final hoursUntilDue = task.dueAt!.difference(now).inHours;

      if (hoursUntilDue < 0) {
        reasons.add('❗ 任务已逾期，建议尽快完成');
      } else if (hoursUntilDue < 24) {
        reasons.add('⏰ 即将到期（24小时内）');
      } else if (hoursUntilDue < 72) {
        reasons.add('📅 3天内到期');
      }
    }

    // 时间推荐原因
    if (timeSlot != null && timeSlot.successRate > 0.7) {
      reasons.add('✨ ${timeSlot.description}是您的高效时段');
    }

    // 完成概率原因
    if (completionProbability > 0.8) {
      reasons.add('💪 根据历史数据，完成概率很高');
    } else if (completionProbability < 0.5) {
      reasons.add('⚠️ 任务较复杂，建议分解或预留充足时间');
    }

    // 进行中状态
    if (task.status == TaskStatus.inProgress) {
      reasons.add('🔄 任务进行中，建议优先完成');
    }

    // 时长预估
    if (task.estimatedMinutes != null && task.estimatedMinutes! > 0) {
      final hours = task.estimatedMinutes! ~/ 60;
      final minutes = task.estimatedMinutes! % 60;
      if (hours > 0) {
        reasons.add('⏱️ 预计需要${hours}小时${minutes > 0 ? "$minutes分钟" : ""}');
      } else {
        reasons.add('⏱️ 预计需要${minutes}分钟');
      }
    }

    // 如果没有任何原因，添加默认原因
    if (reasons.isEmpty) {
      reasons.add('📝 建议优先处理此任务');
    }

    return reasons;
  }

  /// 格式化时间标签
  String _formatTimeLabel(int hour) {
    final period = hour >= 12 ? '下午' : '上午';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$period $displayHour:00';
  }
}
