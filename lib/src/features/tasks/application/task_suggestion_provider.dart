import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/features/focus/application/focus_providers.dart';
import 'package:todolist/src/features/focus/application/focus_statistics_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

part 'task_suggestion_provider.g.dart';

/// Suggestion for a task based on historical data
class TaskSuggestion {
  const TaskSuggestion({
    required this.suggestedPomodoros,
    required this.suggestedMinutes,
    required this.confidence,
    required this.basedOnTasksCount,
  });

  final int suggestedPomodoros;
  final int suggestedMinutes;
  final double confidence; // 0-1, how confident we are
  final int basedOnTasksCount; // How many similar tasks we analyzed

  String get confidenceLabel {
    if (confidence >= 0.8) return '高';
    if (confidence >= 0.5) return '中';
    return '低';
  }
}

/// Provider for getting task suggestions based on list and tags
@riverpod
Future<TaskSuggestion?> taskSuggestion(
  TaskSuggestionRef ref, {
  required String? listId,
  required List<String> tagIds,
}) async {
  if (listId == null && tagIds.isEmpty) {
    return null;
  }

  final sessionRepo = await ref.watch(focusSessionRepositoryProvider.future);
  final taskRepo = ref.watch(taskRepositoryProvider);
  final taskListRepo = ref.watch(taskListRepositoryProvider);
  final tagRepo = ref.watch(tagRepositoryProvider);
  final statisticsService = FocusStatisticsService(
    sessionRepository: sessionRepo,
    taskRepository: taskRepo,
    taskListRepository: taskListRepo,
    tagRepository: tagRepo,
  );

  final suggestedPomodoros = await statisticsService.getSuggestedPomodoros(
    listId: listId,
    tagIds: tagIds,
  );

  // Get similar tasks to calculate confidence
  final tasks = await ref.watch(taskRepositoryProvider).getAll();
  final similarTasks = tasks.where((task) {
    if (!task.isCompleted) return false;
    if (task.actualMinutes == 0) return false;

    if (listId != null && task.listId == listId) return true;
    if (tagIds.any((tagId) => task.tagIds.contains(tagId))) return true;

    return false;
  }).toList();

  if (similarTasks.isEmpty) {
    return null;
  }

  // Calculate confidence based on sample size and consistency
  final confidence = _calculateConfidence(similarTasks);

  return TaskSuggestion(
    suggestedPomodoros: suggestedPomodoros,
    suggestedMinutes: suggestedPomodoros * 25,
    confidence: confidence,
    basedOnTasksCount: similarTasks.length,
  );
}

double _calculateConfidence(List<dynamic> similarTasks) {
  final count = similarTasks.length;

  // More tasks = higher confidence
  if (count >= 10) return 0.9;
  if (count >= 5) return 0.7;
  if (count >= 3) return 0.5;
  return 0.3;
}
