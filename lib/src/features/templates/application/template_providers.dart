import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/recurrence_rule.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_template.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

part 'template_providers.g.dart';

/// Configuration for creating a task from a template
class TemplateConfiguration {
  const TemplateConfiguration({
    this.recurrenceRule,
    this.reminderTime,
    this.dueDate,
  });

  final RecurrenceRule? recurrenceRule;
  final TimeOfDay? reminderTime;
  final DateTime? dueDate;
}

/// Provider for all templates
@riverpod
Future<List<TaskTemplate>> allTemplates(AllTemplatesRef ref) async {
  final repository = ref.watch(taskTemplateRepositoryProvider);
  return repository.getAll();
}

/// Provider for templates by category
@riverpod
Future<List<TaskTemplate>> templatesByCategory(
  TemplatesByCategoryRef ref,
  TemplateCategory category,
) async {
  final repository = ref.watch(taskTemplateRepositoryProvider);
  return repository.getByCategory(category);
}

/// Provider for a specific template
@riverpod
Future<TaskTemplate?> template(TemplateRef ref, String id) async {
  final repository = ref.watch(taskTemplateRepositoryProvider);
  return repository.getById(id);
}

/// Provider for template actions (use, delete, etc.)
@riverpod
class TemplateActions extends _$TemplateActions {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  /// Create a task from a template with custom configuration
  Future<Task> createTaskFromTemplateWithConfig(
    String templateId,
    TemplateConfiguration config,
  ) async {
    final templateRepository = ref.read(taskTemplateRepositoryProvider);
    final taskRepository = ref.read(taskRepositoryProvider);
    final listRepository = ref.read(taskListRepositoryProvider);

    // Get the template
    final template = await templateRepository.getById(templateId);
    if (template == null) {
      throw Exception('Template not found: $templateId');
    }

    // Get default list (inbox or first list)
    final lists = await listRepository.findAll();
    final defaultList = lists.firstWhere(
      (list) => list.isDefault,
      orElse: () => lists.isNotEmpty ? lists.first : throw Exception('No lists available'),
    );

    final now = DateTime.now();

    // Use configured due date or calculate from template
    final dueDate = config.dueDate;

    // Use configured recurrence or template's default
    final recurrenceRule = config.recurrenceRule ?? template.defaultRecurrence;

    final task = Task(
      id: ref.read(idGeneratorProvider).generate(),
      title: template.title,
      notes: template.description,
      listId: defaultList.id,
      priority: template.priority,
      estimatedMinutes: template.estimatedMinutes,
      subtasks: template.defaultSubtasks,
      tagIds: template.tags,
      dueAt: dueDate,
      recurrenceRule: recurrenceRule,
      createdAt: now,
      updatedAt: now,
    );

    await taskRepository.save(task);

    // If this is a recurring task, create future instances for next 7 occurrences
    if (recurrenceRule != null && dueDate != null) {
      final idGen = ref.read(idGeneratorProvider);

      // Create up to 7 future instances
      var currentDue = dueDate;
      for (var i = 1; i <= 7; i++) {
        currentDue = recurrenceRule.nextOccurrence(currentDue);

        final futureTask = Task(
          id: idGen.generate(),
          title: template.title,
          notes: template.description,
          listId: defaultList.id,
          priority: template.priority,
          estimatedMinutes: template.estimatedMinutes,
          subtasks: template.defaultSubtasks,
          tagIds: template.tags,
          dueAt: currentDue,
          recurrenceRule: recurrenceRule,
          parentRecurringTaskId: task.id,
          recurrenceCount: i,
          createdAt: now,
          updatedAt: now,
        );

        await taskRepository.save(futureTask);
      }
    }

    // Increment template usage count
    await templateRepository.incrementUsageCount(templateId);

    // Invalidate to refresh UI
    ref.invalidate(allTemplatesProvider);
    ref.invalidate(taskRepositoryProvider);

    return task;
  }

  /// Create a task from a template
  Future<Task> createTaskFromTemplate(String templateId) async {
    final templateRepository = ref.read(taskTemplateRepositoryProvider);
    final taskRepository = ref.read(taskRepositoryProvider);
    final listRepository = ref.read(taskListRepositoryProvider);

    // Get the template
    final template = await templateRepository.getById(templateId);
    if (template == null) {
      throw Exception('Template not found: $templateId');
    }

    // Get default list (inbox or first list)
    final lists = await listRepository.findAll();
    final defaultList = lists.firstWhere(
      (list) => list.isDefault,
      orElse: () => lists.isNotEmpty ? lists.first : throw Exception('No lists available'),
    );

    // Create task from template
    final now = DateTime.now();

    // Smart due date calculation based on template characteristics
    DateTime? dueDate;
    final estimatedMinutes = template.estimatedMinutes ?? 30;

    if (template.priority == TaskPriority.critical || template.priority == TaskPriority.high) {
      // High priority tasks - due today or tomorrow based on estimated time
      dueDate = estimatedMinutes > 120
          ? now.add(const Duration(days: 1)) // Long tasks get 1 day
          : now; // Short urgent tasks due today
    } else if (estimatedMinutes > 180) {
      // Long tasks (>3 hours) - give 3-7 days
      dueDate = now.add(Duration(days: estimatedMinutes ~/ 60)); // ~1 day per hour
    } else {
      // Normal tasks - due within next few days
      dueDate = now.add(Duration(days: (estimatedMinutes / 60).ceil()));
    }

    final task = Task(
      id: ref.read(idGeneratorProvider).generate(),
      title: template.title,
      notes: template.description,
      listId: defaultList.id,
      priority: template.priority,
      estimatedMinutes: template.estimatedMinutes,
      subtasks: template.defaultSubtasks,
      tagIds: template.tags,
      dueAt: dueDate,
      recurrenceRule: template.defaultRecurrence,
      createdAt: now,
      updatedAt: now,
    );

    await taskRepository.save(task);

    // If this is a recurring task, create future instances for next 7 days
    if (template.defaultRecurrence != null) {
      final rule = template.defaultRecurrence!;
      final idGen = ref.read(idGeneratorProvider);

      // Create up to 7 future instances
      var currentDue = dueDate;
      for (var i = 1; i <= 7; i++) {
        currentDue = rule.nextOccurrence(currentDue);

        final futureTask = Task(
          id: idGen.generate(),
          title: template.title,
          notes: template.description,
          listId: defaultList.id,
          priority: template.priority,
          estimatedMinutes: template.estimatedMinutes,
          subtasks: template.defaultSubtasks,
          tagIds: template.tags,
          dueAt: currentDue,
          recurrenceRule: template.defaultRecurrence,
          parentRecurringTaskId: task.id,
          recurrenceCount: i,
          createdAt: now,
          updatedAt: now,
        );

        await taskRepository.save(futureTask);
      }
    }

    // Increment template usage count
    await templateRepository.incrementUsageCount(templateId);

    // Invalidate to refresh UI
    ref.invalidate(allTemplatesProvider);
    ref.invalidate(taskRepositoryProvider);

    return task;
  }

  /// Delete a custom template
  Future<void> deleteTemplate(String templateId) async {
    final repository = ref.read(taskTemplateRepositoryProvider);
    await repository.delete(templateId);

    // Invalidate templates to refresh UI
    ref.invalidate(allTemplatesProvider);
  }

  /// Save/update a template
  Future<void> saveTemplate(TaskTemplate template) async {
    final repository = ref.read(taskTemplateRepositoryProvider);
    await repository.save(template);

    // Invalidate templates to refresh UI
    ref.invalidate(allTemplatesProvider);
  }
}
