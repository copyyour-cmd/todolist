import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

final recurrenceServiceProvider = Provider<RecurrenceService>((ref) {
  return RecurrenceService(ref);
});

class RecurrenceService {
  RecurrenceService(this._ref);

  final Ref _ref;

  /// Handle task completion for recurring tasks
  /// If task is recurring, create next occurrence
  Future<void> handleRecurringTaskCompletion(Task task) async {
    if (!task.isRecurring || task.recurrenceRule == null) {
      return;
    }

    final rule = task.recurrenceRule!;
    final clock = _ref.read(clockProvider);
    final now = clock.now();

    // Check if recurrence should end
    final newCount = task.recurrenceCount + 1;
    if (rule.shouldEnd(now, newCount)) {
      return; // Don't create next occurrence
    }

    // Calculate next occurrence date
    final nextDueDate = task.dueAt != null
        ? rule.nextOccurrence(task.dueAt!)
        : rule.nextOccurrence(now);

    // Calculate next reminder date if exists
    DateTime? nextRemindAt;
    if (task.remindAt != null && task.dueAt != null) {
      final reminderOffset = task.dueAt!.difference(task.remindAt!);
      nextRemindAt = nextDueDate.subtract(reminderOffset);
    }

    // Create next occurrence
    final nextTask = task.copyWith(
      id: _ref.read(idGeneratorProvider).generate(),
      status: TaskStatus.pending,
      completedAt: null,
      dueAt: nextDueDate,
      remindAt: nextRemindAt,
      createdAt: now,
      updatedAt: now,
      parentRecurringTaskId: task.parentRecurringTaskId ?? task.id,
      recurrenceCount: newCount,
      // Keep recurrence rule for continuous recurrence
      recurrenceRule: rule,
    );

    // Save next occurrence
    final repository = _ref.read(taskRepositoryProvider);
    await repository.save(nextTask);
  }

  /// Create a recurring task series
  Future<void> createRecurringTask(Task task) async {
    if (!task.isRecurring) {
      // Just save as regular task
      final repository = _ref.read(taskRepositoryProvider);
      await repository.save(task);
      return;
    }

    // Save the initial task with parentRecurringTaskId set to its own ID
    final taskWithParent = task.copyWith(
      parentRecurringTaskId: task.id,
    );

    final repository = _ref.read(taskRepositoryProvider);
    await repository.save(taskWithParent);
  }

  /// Delete all future occurrences of a recurring task
  Future<void> deleteRecurringSeries(String parentTaskId) async {
    final repository = _ref.read(taskRepositoryProvider);
    final allTasks = await repository.watchAll().first;

    // Find all tasks in this series that are not completed
    final seriesTasks = allTasks.where((t) {
      return t.parentRecurringTaskId == parentTaskId &&
             t.status != TaskStatus.completed;
    }).toList();

    // Delete all future occurrences
    for (final task in seriesTasks) {
      await repository.delete(task.id);
    }
  }

  /// Update recurring task - applies to current and future occurrences
  Future<void> updateRecurringSeries({
    required Task task,
    bool updateFutureOccurrences = true,
  }) async {
    final repository = _ref.read(taskRepositoryProvider);

    if (!updateFutureOccurrences || task.parentRecurringTaskId == null) {
      // Just update this task
      await repository.save(task);
      return;
    }

    // Update all future occurrences
    final allTasks = await repository.watchAll().first;
    final futureTasks = allTasks.where((t) {
      return t.parentRecurringTaskId == task.parentRecurringTaskId &&
             t.status != TaskStatus.completed &&
             t.id != task.id;
    }).toList();

    // Update current task
    await repository.save(task);

    // Update future tasks with same properties (except dates)
    for (final futureTask in futureTasks) {
      final updated = futureTask.copyWith(
        title: task.title,
        notes: task.notes,
        listId: task.listId,
        tagIds: task.tagIds,
        priority: task.priority,
        recurrenceRule: task.recurrenceRule,
        updatedAt: DateTime.now(),
      );
      await repository.save(updated);
    }
  }
}
