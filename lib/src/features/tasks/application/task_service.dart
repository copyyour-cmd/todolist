import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/attachment.dart';
import 'package:todolist/src/domain/entities/recurrence_rule.dart';
import 'package:todolist/src/domain/entities/sub_task.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';
import 'package:todolist/src/features/reminders/domain/reminder_mode.dart';
import 'package:todolist/src/features/gamification/application/gamification_providers.dart';
import 'package:todolist/src/features/smart_reminders/application/smart_reminder_providers.dart';
import 'package:todolist/src/features/smart_reminders/application/smart_reminder_service.dart';
import 'package:todolist/src/features/tasks/application/recurrence_service.dart';
import 'package:todolist/src/infrastructure/notifications/notification_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

/// Smart reminder configuration for task creation
class SmartReminderConfig {
  SmartReminderConfig.time({
    required this.scheduledAt,
  }) : type = 'time', repeatIntervalMinutes = null, repeatMaxCount = null;

  SmartReminderConfig.repeating({
    required this.scheduledAt,
    required int intervalMinutes,
    required int maxRepeats,
  })  : type = 'repeating',
        repeatIntervalMinutes = intervalMinutes,
        repeatMaxCount = maxRepeats;

  final String type;
  final DateTime scheduledAt;
  final int? repeatIntervalMinutes;
  final int? repeatMaxCount;
}

class TaskCreationInput {
  TaskCreationInput({
    required this.title,
    required this.listId,
    this.notes,
    this.dueAt,
    this.remindAt,
    List<String>? tagIds,
    this.priority = TaskPriority.none,
    List<SubTask>? subtasks,
    List<Attachment>? attachments,
    this.recurrenceRule,
    this.estimatedMinutes,
    List<SmartReminderConfig>? smartReminders,
    this.reminderMode = ReminderMode.notification,
  })  : tagIds = tagIds ?? <String>[],
        subtasks = subtasks ?? <SubTask>[],
        attachments = attachments ?? <Attachment>[],
        smartReminders = smartReminders ?? <SmartReminderConfig>[];

  final String title;
  final String listId;
  final String? notes;
  final DateTime? dueAt;
  final DateTime? remindAt;
  final List<String> tagIds;
  final TaskPriority priority;
  final List<SubTask> subtasks;
  final List<Attachment> attachments;
  final RecurrenceRule? recurrenceRule;
  final int? estimatedMinutes;
  final List<SmartReminderConfig> smartReminders;
  final ReminderMode reminderMode;
}

class TaskUpdateInput extends TaskCreationInput {
  TaskUpdateInput({
    required super.title,
    required super.listId,
    super.notes,
    super.dueAt,
    super.remindAt,
    super.tagIds,
    super.priority,
    super.subtasks,
    super.attachments,
    super.recurrenceRule,
    super.estimatedMinutes,
    super.smartReminders,
    super.reminderMode,
  });
}

class TaskService {
  TaskService({
    required TaskRepository taskRepository,
    required Clock clock,
    required IdGenerator idGenerator,
    required AppLogger logger,
    required NotificationService notificationService,
    required RecurrenceService recurrenceService,
    required SmartReminderService smartReminderService,
  })  : _taskRepository = taskRepository,
        _clock = clock,
        _idGenerator = idGenerator,
        _logger = logger,
        _notificationService = notificationService,
        _recurrenceService = recurrenceService,
        _smartReminderService = smartReminderService;

  final TaskRepository _taskRepository;
  final Clock _clock;
  final IdGenerator _idGenerator;
  final AppLogger _logger;
  final NotificationService _notificationService;
  final RecurrenceService _recurrenceService;
  final SmartReminderService _smartReminderService;

  Future<Task> createTask(TaskCreationInput input) async {
    final now = _clock.now();

    // Create smart reminders first and collect their IDs
    final reminderIds = <String>[];
    final taskId = _idGenerator.generate();

    for (final config in input.smartReminders) {
      try {
        final reminder = config.type == 'repeating'
            ? await _smartReminderService.createRepeatingReminder(
                taskId: taskId,
                firstScheduledAt: config.scheduledAt,
                intervalMinutes: config.repeatIntervalMinutes!,
                maxRepeats: config.repeatMaxCount!,
              )
            : await _smartReminderService.createFromNaturalLanguage(
                taskId: taskId,
                input: config.scheduledAt.toString(),
              );

        if (reminder != null) {
          reminderIds.add(reminder.id);
        }
      } catch (e, stackTrace) {
        _logger.error('Failed to create smart reminder', e, stackTrace);
      }
    }

    final task = Task(
      id: taskId,
      title: input.title,
      notes: input.notes,
      listId: input.listId,
      tagIds: input.tagIds,
      priority: input.priority,
      dueAt: input.dueAt,
      remindAt: input.remindAt,
      subtasks: input.subtasks,
      attachments: input.attachments,
      recurrenceRule: input.recurrenceRule,
      estimatedMinutes: input.estimatedMinutes,
      smartReminderIds: reminderIds,
      reminderMode: input.reminderMode,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );

    // Use recurrence service for recurring tasks
    if (task.isRecurring) {
      await _recurrenceService.createRecurringTask(task);
    } else {
      await _taskRepository.save(task);
    }

    await _notificationService.syncTaskReminder(task);
    _logger.info('Task created', {'taskId': task.id, 'smartReminders': reminderIds.length});
    return task;
  }

  Future<Task> updateTask(Task existing, TaskUpdateInput input) async {
    final now = _clock.now();

    // Handle smart reminder updates
    // Delete old reminders that are not in the new input
    for (final oldReminderId in existing.smartReminderIds) {
      try {
        await _smartReminderService.deleteReminder(oldReminderId);
      } catch (e, stackTrace) {
        _logger.error('Failed to delete old smart reminder', e, stackTrace);
      }
    }

    // Create new smart reminders
    final reminderIds = <String>[];
    for (final config in input.smartReminders) {
      try {
        final reminder = config.type == 'repeating'
            ? await _smartReminderService.createRepeatingReminder(
                taskId: existing.id,
                firstScheduledAt: config.scheduledAt,
                intervalMinutes: config.repeatIntervalMinutes!,
                maxRepeats: config.repeatMaxCount!,
              )
            : await _smartReminderService.createFromNaturalLanguage(
                taskId: existing.id,
                input: config.scheduledAt.toString(),
              );

        if (reminder != null) {
          reminderIds.add(reminder.id);
        }
      } catch (e, stackTrace) {
        _logger.error('Failed to create smart reminder', e, stackTrace);
      }
    }

    final updated = existing.copyWith(
      title: input.title,
      notes: input.notes,
      listId: input.listId,
      tagIds: input.tagIds,
      priority: input.priority,
      dueAt: input.dueAt,
      remindAt: input.remindAt,
      subtasks: input.subtasks,
      attachments: input.attachments,
      recurrenceRule: input.recurrenceRule,
      estimatedMinutes: input.estimatedMinutes,
      smartReminderIds: reminderIds,
      reminderMode: input.reminderMode,
      updatedAt: now,
      version: existing.version + 1,
    );
    await _taskRepository.save(updated);
    await _notificationService.syncTaskReminder(updated);
    _logger.info('Task updated', {'taskId': updated.id, 'smartReminders': reminderIds.length});
    return updated;
  }

  Future<void> toggleCompletion(Task task, {required bool isCompleted, ProviderContainer? container}) async {
    final now = _clock.now();
    final updated = task.copyWith(
      status: isCompleted ? TaskStatus.completed : TaskStatus.pending,
      completedAt: isCompleted ? now : null,
      updatedAt: now,
      version: task.version + 1,
    );
    await _taskRepository.save(updated);
    await _notificationService.syncTaskReminder(updated);

    // 触发游戏化系统（完成任务时）
    if (isCompleted && container != null) {
      try {
        final gamificationService = container.read(
          gamificationServiceProvider,
        );
        await gamificationService.onTaskCompleted();
        _logger.info('Gamification: task completed', {'taskId': task.id});
      } catch (e, stackTrace) {
        _logger.error('Failed to trigger gamification', e, stackTrace);
      }
    }

    // Handle recurring task completion
    if (isCompleted && task.isRecurring) {
      await _recurrenceService.handleRecurringTaskCompletion(updated);
    }

    _logger.info('Task completion toggled', {
      'id': task.id,
      'completed': isCompleted,
    });
  }

  Future<void> toggleSubTask(Task task, SubTask subTask, {required bool isCompleted}) async {
    final now = _clock.now();
    final updatedSubTask = subTask.copyWith(
      isCompleted: isCompleted,
      completedAt: isCompleted ? now : null,
    );
    final updatedTask = task.copyWith(
      subtasks: [
        for (final item in task.subtasks)
          if (item.id == subTask.id) updatedSubTask else item,
      ],
      updatedAt: now,
      version: task.version + 1,
    );
    await _taskRepository.save(updatedTask);
    await _notificationService.syncTaskReminder(updatedTask);
    _logger.info('Subtask toggled', {
      'taskId': task.id,
      'subTaskId': subTask.id,
      'completed': isCompleted,
    });
  }

  /// Clean up smart reminders when task is deleted
  Future<void> deleteTask(Task task) async {
    // Delete all smart reminders for this task
    for (final reminderId in task.smartReminderIds) {
      try {
        await _smartReminderService.deleteReminder(reminderId);
      } catch (e, stackTrace) {
        _logger.error('Failed to delete smart reminder', e, stackTrace);
      }
    }

    // Delete the task
    await _taskRepository.delete(task.id);
    await _notificationService.cancelNotification(task.id.hashCode);
    _logger.info('Task deleted', task.id);
  }

  /// Get all smart reminders for a task
  Future<List<dynamic>> getTaskSmartReminders(String taskId) async {
    return _smartReminderService.getTaskReminders(taskId);
  }
}

final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService(
    taskRepository: ref.watch(taskRepositoryProvider),
    clock: ref.watch(clockProvider),
    idGenerator: ref.watch(idGeneratorProvider),
    logger: ref.watch(appLoggerProvider),
    notificationService: ref.watch(notificationServiceProvider),
    recurrenceService: ref.watch(recurrenceServiceProvider),
    smartReminderService: ref.watch(smartReminderServiceProvider),
  );
});




