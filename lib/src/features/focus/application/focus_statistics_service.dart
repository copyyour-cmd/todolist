import 'package:todolist/src/domain/entities/focus_session.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';
import 'package:todolist/src/infrastructure/repositories/focus_session_repository.dart';

/// Statistics about focus sessions
class FocusStatistics {
  const FocusStatistics({
    required this.totalSessions,
    required this.completedSessions,
    required this.totalMinutes,
    required this.averageQualityScore,
    required this.bestHourOfDay,
    required this.peakProductivityHours,
    required this.totalInterruptions,
    required this.averageInterruptionsPerSession,
    required this.taskCompletionRate,
  });

  final int totalSessions;
  final int completedSessions;
  final int totalMinutes;
  final double averageQualityScore;
  final int? bestHourOfDay;
  final List<int> peakProductivityHours;
  final int totalInterruptions;
  final double averageInterruptionsPerSession;
  final double taskCompletionRate;

  double get completionRate {
    if (totalSessions == 0) return 0;
    return completedSessions / totalSessions;
  }
}

/// Hourly focus statistics
class HourlyFocusData {
  const HourlyFocusData({
    required this.hour,
    required this.sessionCount,
    required this.totalMinutes,
    required this.averageQualityScore,
  });

  final int hour;
  final int sessionCount;
  final int totalMinutes;
  final double averageQualityScore;

  /// Productivity score (combines session count, minutes, and quality)
  double get productivityScore {
    if (sessionCount == 0) return 0;
    return (sessionCount * 10 + totalMinutes * 0.5 + averageQualityScore) / 3;
  }
}

/// Accuracy statistics for a specific task type (list or tag)
class TaskTypeAccuracy {
  const TaskTypeAccuracy({
    required this.typeId,
    required this.typeName,
    required this.taskCount,
    required this.averageAccuracy,
    required this.isListType,
  });

  final String typeId;
  final String typeName;
  final int taskCount;
  final double averageAccuracy; // 0-100, where 100 is perfect
  final bool isListType; // true for list, false for tag

  String get typeLabel => isListType ? '清单: $typeName' : '标签: $typeName';
}

/// Time estimation analysis
class TimeEstimationAnalysis {
  const TimeEstimationAnalysis({
    required this.totalTasksWithEstimates,
    required this.averageAccuracy,
    required this.tendencyToOverestimate,
    required this.tendencyToUnderestimate,
    required this.mostAccurateTaskType,
    required this.taskTypeAccuracies,
  });

  final int totalTasksWithEstimates;
  final double averageAccuracy;
  final double tendencyToOverestimate;
  final double tendencyToUnderestimate;
  final TaskTypeAccuracy? mostAccurateTaskType;
  final List<TaskTypeAccuracy> taskTypeAccuracies;

  bool get isOverestimating => tendencyToOverestimate > tendencyToUnderestimate;

  /// Get top N most accurate task types
  List<TaskTypeAccuracy> getTopAccurate(int count) {
    final sorted = List<TaskTypeAccuracy>.from(taskTypeAccuracies)
      ..sort((a, b) => b.averageAccuracy.compareTo(a.averageAccuracy));
    return sorted.take(count).toList();
  }

  /// Get task types that need improvement (least accurate)
  List<TaskTypeAccuracy> getNeedImprovement(int count) {
    final sorted = List<TaskTypeAccuracy>.from(taskTypeAccuracies)
      ..sort((a, b) => a.averageAccuracy.compareTo(b.averageAccuracy));
    return sorted.take(count).toList();
  }
}

/// Service for analyzing focus session data
class FocusStatisticsService {
  FocusStatisticsService({
    required FocusSessionRepository sessionRepository,
    required TaskRepository taskRepository,
    required this.taskListRepository,
    required this.tagRepository,
  })  : _sessionRepository = sessionRepository,
        _taskRepository = taskRepository;

  final FocusSessionRepository _sessionRepository;
  final TaskRepository _taskRepository;
  final dynamic taskListRepository;
  final dynamic tagRepository;

  /// Get overall focus statistics for a date range
  Future<FocusStatistics> getStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final sessions = _sessionRepository.getAll();
    final filteredSessions = _filterByDateRange(sessions, startDate, endDate);

    if (filteredSessions.isEmpty) {
      return const FocusStatistics(
        totalSessions: 0,
        completedSessions: 0,
        totalMinutes: 0,
        averageQualityScore: 0,
        bestHourOfDay: null,
        peakProductivityHours: [],
        totalInterruptions: 0,
        averageInterruptionsPerSession: 0,
        taskCompletionRate: 0,
      );
    }

    final completed = filteredSessions.where((s) => s.isCompleted).toList();
    final totalMinutes = filteredSessions.fold<int>(
      0,
      (sum, s) => sum + s.durationMinutes,
    );
    final qualityScores = completed.map((s) => s.qualityScore).toList();
    final avgQuality = qualityScores.isEmpty
        ? 0.0
        : qualityScores.reduce((a, b) => a + b) / qualityScores.length;

    final hourlyData = await getHourlyFocusData(
      startDate: startDate,
      endDate: endDate,
    );
    final bestHour = _findBestHour(hourlyData);
    final peakHours = _findPeakHours(hourlyData, threshold: 0.7);

    final totalInterruptions = filteredSessions.fold<int>(
      0,
      (sum, s) => sum + s.interruptions.length,
    );
    final avgInterruptions = filteredSessions.isEmpty
        ? 0.0
        : totalInterruptions / filteredSessions.length;

    final taskCompletionRate = await _calculateTaskCompletionRate(
      filteredSessions,
    );

    return FocusStatistics(
      totalSessions: filteredSessions.length,
      completedSessions: completed.length,
      totalMinutes: totalMinutes,
      averageQualityScore: avgQuality,
      bestHourOfDay: bestHour,
      peakProductivityHours: peakHours,
      totalInterruptions: totalInterruptions,
      averageInterruptionsPerSession: avgInterruptions,
      taskCompletionRate: taskCompletionRate,
    );
  }

  /// Get focus data grouped by hour of day
  Future<List<HourlyFocusData>> getHourlyFocusData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final sessions = _sessionRepository.getAll();
    final filteredSessions = _filterByDateRange(sessions, startDate, endDate);

    final hourlyMap = <int, List<FocusSession>>{};
    for (final session in filteredSessions) {
      final hour = session.hourOfDay;
      hourlyMap.putIfAbsent(hour, () => []).add(session);
    }

    final result = <HourlyFocusData>[];
    for (var hour = 0; hour < 24; hour++) {
      final sessionsInHour = hourlyMap[hour] ?? [];
      if (sessionsInHour.isEmpty) {
        result.add(HourlyFocusData(
          hour: hour,
          sessionCount: 0,
          totalMinutes: 0,
          averageQualityScore: 0,
        ));
        continue;
      }

      final totalMinutes = sessionsInHour.fold<int>(
        0,
        (sum, s) => sum + s.durationMinutes,
      );
      final qualityScores = sessionsInHour
          .where((s) => s.isCompleted)
          .map((s) => s.qualityScore)
          .toList();
      final avgQuality = qualityScores.isEmpty
          ? 0.0
          : qualityScores.reduce((a, b) => a + b) / qualityScores.length;

      result.add(HourlyFocusData(
        hour: hour,
        sessionCount: sessionsInHour.length,
        totalMinutes: totalMinutes,
        averageQualityScore: avgQuality,
      ));
    }

    return result;
  }

  /// Analyze time estimation accuracy
  Future<TimeEstimationAnalysis> getTimeEstimationAnalysis({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final tasks = await _taskRepository.getAll();
    final filteredTasks = tasks.where((task) {
      if (task.estimatedMinutes == null) return false;
      if (task.actualMinutes == 0) return false;
      if (startDate != null && task.createdAt.isBefore(startDate)) return false;
      if (endDate != null && task.createdAt.isAfter(endDate)) return false;
      return true;
    }).toList();

    if (filteredTasks.isEmpty) {
      return const TimeEstimationAnalysis(
        totalTasksWithEstimates: 0,
        averageAccuracy: 0,
        tendencyToOverestimate: 0,
        tendencyToUnderestimate: 0,
        mostAccurateTaskType: null,
        taskTypeAccuracies: [],
      );
    }

    final accuracies = filteredTasks.map((t) => t.estimationAccuracy).toList();
    final avgAccuracy = accuracies.reduce((a, b) => a + b) / accuracies.length;

    var overestimateCount = 0;
    var underestimateCount = 0;
    for (final task in filteredTasks) {
      final ratio = task.actualMinutes / task.estimatedMinutes!;
      if (ratio < 0.8) {
        overestimateCount++;
      } else if (ratio > 1.2) {
        underestimateCount++;
      }
    }

    final tendencyOver = overestimateCount / filteredTasks.length;
    final tendencyUnder = underestimateCount / filteredTasks.length;

    // Calculate accuracy by list and tag
    final taskTypeAccuracies = await _calculateTaskTypeAccuracies(filteredTasks);

    // Find most accurate task type
    TaskTypeAccuracy? mostAccurate;
    if (taskTypeAccuracies.isNotEmpty) {
      mostAccurate = taskTypeAccuracies.reduce(
        (a, b) => a.averageAccuracy > b.averageAccuracy ? a : b,
      );
    }

    return TimeEstimationAnalysis(
      totalTasksWithEstimates: filteredTasks.length,
      averageAccuracy: avgAccuracy,
      tendencyToOverestimate: tendencyOver,
      tendencyToUnderestimate: tendencyUnder,
      mostAccurateTaskType: mostAccurate,
      taskTypeAccuracies: taskTypeAccuracies,
    );
  }

  /// Calculate accuracy statistics grouped by lists and tags
  Future<List<TaskTypeAccuracy>> _calculateTaskTypeAccuracies(List<Task> tasks) async {
    final accuracies = <TaskTypeAccuracy>[];

    // Get all lists and tags
    final lists = await taskListRepository.findAll();
    final tags = await tagRepository.findAll();

    // Group by list
    for (final list in lists) {
      final listTasks = tasks.where((t) => t.listId == list.id).toList();
      if (listTasks.length < 2) continue; // Need at least 2 tasks for meaningful stats

      final listAccuracy = _calculateAccuracyForTasks(listTasks);
      accuracies.add(TaskTypeAccuracy(
        typeId: list.id,
        typeName: list.name,
        taskCount: listTasks.length,
        averageAccuracy: listAccuracy,
        isListType: true,
      ));
    }

    // Group by tag
    for (final tag in tags) {
      final tagTasks = tasks.where((t) => t.tagIds.contains(tag.id)).toList();
      if (tagTasks.length < 2) continue; // Need at least 2 tasks for meaningful stats

      final tagAccuracy = _calculateAccuracyForTasks(tagTasks);
      accuracies.add(TaskTypeAccuracy(
        typeId: tag.id,
        typeName: tag.name,
        taskCount: tagTasks.length,
        averageAccuracy: tagAccuracy,
        isListType: false,
      ));
    }

    return accuracies;
  }

  /// Calculate average accuracy for a list of tasks (0-100)
  double _calculateAccuracyForTasks(List<Task> tasks) {
    if (tasks.isEmpty) return 0;

    final accuracies = tasks.map((task) {
      if (task.estimatedMinutes == null || task.estimatedMinutes == 0) {
        return 0.0;
      }
      final ratio = task.actualMinutes / task.estimatedMinutes!;
      // Perfect is 1.0, calculate accuracy as percentage
      // The closer to 1.0, the better
      if (ratio <= 1.0) {
        return ratio * 100; // Under/on-time tasks
      } else {
        return (2.0 - ratio) * 100; // Over-time tasks (penalized more)
      }
    });

    final avgAccuracy = accuracies.reduce((a, b) => a + b) / tasks.length;
    return avgAccuracy.clamp(0, 100);
  }

  /// Get suggested pomodoros for a task based on historical data
  Future<int> getSuggestedPomodoros({
    required String? listId,
    required List<String> tagIds,
  }) async {
    final tasks = await _taskRepository.getAll();

    // Find similar completed tasks
    final similarTasks = tasks.where((task) {
      if (!task.isCompleted) return false;
      if (task.actualMinutes == 0) return false;

      // Match by list or tags
      if (listId != null && task.listId == listId) return true;
      if (tagIds.any((tagId) => task.tagIds.contains(tagId))) return true;

      return false;
    }).toList();

    if (similarTasks.isEmpty) {
      return 1; // Default to 1 pomodoro
    }

    // Average actual time spent
    final avgMinutes = similarTasks.fold<int>(
          0,
          (sum, task) => sum + task.actualMinutes,
        ) /
        similarTasks.length;

    // Convert to pomodoros (25 min each)
    return (avgMinutes / 25).ceil().clamp(1, 8);
  }

  // Private helpers

  List<FocusSession> _filterByDateRange(
    List<FocusSession> sessions,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return sessions.where((session) {
      if (startDate != null && session.startedAt.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && session.startedAt.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();
  }

  int? _findBestHour(List<HourlyFocusData> hourlyData) {
    if (hourlyData.every((d) => d.sessionCount == 0)) return null;

    var bestHour = 0;
    var bestScore = 0.0;

    for (final data in hourlyData) {
      if (data.productivityScore > bestScore) {
        bestScore = data.productivityScore;
        bestHour = data.hour;
      }
    }

    return bestHour;
  }

  List<int> _findPeakHours(List<HourlyFocusData> hourlyData, {required double threshold}) {
    final maxScore = hourlyData
        .map((d) => d.productivityScore)
        .reduce((a, b) => a > b ? a : b);

    if (maxScore == 0) return [];

    return hourlyData
        .where((d) => d.productivityScore >= maxScore * threshold)
        .map((d) => d.hour)
        .toList();
  }

  Future<double> _calculateTaskCompletionRate(
    List<FocusSession> sessions,
  ) async {
    final sessionsWithTasks = sessions.where((s) => s.taskId != null).toList();
    if (sessionsWithTasks.isEmpty) return 0;

    var completedTasks = 0;
    for (final session in sessionsWithTasks) {
      final task = await _taskRepository.getById(session.taskId!);
      if (task != null && task.isCompleted) {
        completedTasks++;
      }
    }

    return completedTasks / sessionsWithTasks.length;
  }
}
