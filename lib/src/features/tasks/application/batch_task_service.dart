import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

final batchTaskServiceProvider = Provider<BatchTaskService>((ref) {
  return BatchTaskService(ref);
});

class BatchTaskService {
  BatchTaskService(this._ref);

  final Ref _ref;

  /// Batch complete tasks
  Future<void> batchComplete(List<String> taskIds, {required bool isCompleted}) async {
    final repository = _ref.read(taskRepositoryProvider);
    final allTasks = await repository.watchAll().first;

    for (final taskId in taskIds) {
      final task = allTasks.firstWhere((t) => t.id == taskId);
      final updatedTask = task.copyWith(
        status: isCompleted ? TaskStatus.completed : TaskStatus.pending,
        completedAt: isCompleted ? DateTime.now() : null,
      );
      await repository.save(updatedTask);
    }
  }

  /// Batch delete tasks
  Future<void> batchDelete(List<String> taskIds) async {
    final repository = _ref.read(taskRepositoryProvider);

    for (final taskId in taskIds) {
      await repository.delete(taskId);
    }
  }

  /// Batch move tasks to a different list
  Future<void> batchMoveToList(List<String> taskIds, String targetListId) async {
    final repository = _ref.read(taskRepositoryProvider);
    final allTasks = await repository.watchAll().first;

    for (final taskId in taskIds) {
      final task = allTasks.firstWhere((t) => t.id == taskId);
      final updatedTask = task.copyWith(listId: targetListId);
      await repository.save(updatedTask);
    }
  }

  /// Batch add tags to tasks
  Future<void> batchAddTags(List<String> taskIds, List<String> tagIds) async {
    final repository = _ref.read(taskRepositoryProvider);
    final allTasks = await repository.watchAll().first;

    for (final taskId in taskIds) {
      final task = allTasks.firstWhere((t) => t.id == taskId);
      // Combine existing tags with new tags, removing duplicates
      final updatedTagIds = {...task.tagIds, ...tagIds}.toList();
      final updatedTask = task.copyWith(tagIds: updatedTagIds);
      await repository.save(updatedTask);
    }
  }

  /// Batch remove tags from tasks
  Future<void> batchRemoveTags(List<String> taskIds, List<String> tagIds) async {
    final repository = _ref.read(taskRepositoryProvider);
    final allTasks = await repository.watchAll().first;

    for (final taskId in taskIds) {
      final task = allTasks.firstWhere((t) => t.id == taskId);
      // Remove specified tags
      final updatedTagIds =
          task.tagIds.where((id) => !tagIds.contains(id)).toList();
      final updatedTask = task.copyWith(tagIds: updatedTagIds);
      await repository.save(updatedTask);
    }
  }

  /// Batch set priority
  Future<void> batchSetPriority(List<String> taskIds, TaskPriority priority) async {
    final repository = _ref.read(taskRepositoryProvider);
    final allTasks = await repository.watchAll().first;

    for (final taskId in taskIds) {
      final task = allTasks.firstWhere((t) => t.id == taskId);
      final updatedTask = task.copyWith(priority: priority);
      await repository.save(updatedTask);
    }
  }
}
