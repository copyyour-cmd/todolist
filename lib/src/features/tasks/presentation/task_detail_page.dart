import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todolist/l10n/app_localizations.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/features/attachments/presentation/attachment_list.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';
import 'package:todolist/src/features/tasks/application/task_service.dart';
import 'package:todolist/src/features/tasks/presentation/task_composer_sheet.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

class TaskDetailPage extends ConsumerWidget {
  const TaskDetailPage({
    required this.taskId,
    super.key,
  });

  final String taskId;

  static const routePath = '/task/:id';
  static const routeName = 'taskDetail';

  static String buildPath(String taskId) => '/task/$taskId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final tasksAsync = ref.watch(allTasksProvider);
    final listsAsync = ref.watch(taskListsProvider);
    final tagsAsync = ref.watch(tagsProvider);

    return tasksAsync.when(
      data: (tasks) {
        final task = tasks.cast<Task?>().firstWhere(
              (t) => t?.id == taskId,
              orElse: () => null,
            );

        if (task == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(l10n.taskDetailNotFound),
            ),
          );
        }

        final lists = listsAsync.valueOrNull ?? [];
        final tags = tagsAsync.valueOrNull ?? [];
        final taskList = lists.cast<TaskList?>().firstWhere(
              (l) => l?.id == task.listId,
              orElse: () => null,
            );
        final taskTags = tags.where((t) => task.tagIds.contains(t.id)).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.taskDetailTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await TaskComposerSheet.show(context, task: task);
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  switch (value) {
                    case 'delete':
                      await _deleteTask(context, ref, task, l10n);
                    case 'duplicate':
                      await _duplicateTask(context, ref, task);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        const Icon(Icons.content_copy),
                        const SizedBox(width: 12),
                        Text(l10n.taskDetailDuplicate),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: theme.colorScheme.error),
                        const SizedBox(width: 12),
                        Text(
                          l10n.taskDetailDelete,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Title and Status
              _StatusSection(task: task),
              const SizedBox(height: 24),

              // Priority
              _PrioritySection(task: task),
              const SizedBox(height: 16),

              // List
              if (taskList != null) ...[
                _ListSection(taskList: taskList),
                const SizedBox(height: 16),
              ],

              // Tags
              if (taskTags.isNotEmpty) ...[
                _TagsSection(tags: taskTags),
                const SizedBox(height: 16),
              ],

              // Due Date
              if (task.dueAt != null) ...[
                _DateSection(
                  icon: Icons.calendar_today,
                  label: l10n.taskDetailDueDate,
                  date: task.dueAt!,
                ),
                const SizedBox(height: 16),
              ],

              // Reminder
              if (task.remindAt != null) ...[
                _DateSection(
                  icon: Icons.notifications,
                  label: l10n.taskDetailReminder,
                  date: task.remindAt!,
                ),
                const SizedBox(height: 16),
              ],

              // Notes
              if (task.notes != null && task.notes!.isNotEmpty) ...[
                _NotesSection(notes: task.notes!),
                const SizedBox(height: 16),
              ],

              // Subtasks
              if (task.subtasks.isNotEmpty) ...[
                _SubtasksSection(task: task),
                const SizedBox(height: 16),
              ],

              // Attachments
              if (task.attachments.isNotEmpty) ...[
                AttachmentList(
                  attachments: task.attachments,
                  onDelete: (_) {},
                  readOnly: true,
                ),
                const SizedBox(height: 16),
              ],

              const Divider(),
              const SizedBox(height: 16),

              // Timestamps
              _TimestampsSection(task: task),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.taskDetailTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(l10n.taskDetailTitle)),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _deleteTask(
    BuildContext context,
    WidgetRef ref,
    Task task,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.taskDetailDeleteConfirmTitle),
        content: Text(l10n.taskDetailDeleteConfirmMessage(task.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final repository = ref.read(taskRepositoryProvider);
      await repository.delete(task.id);

      if (context.mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.taskDetailDeleted)),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.taskDetailDeleteError}: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _duplicateTask(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) async {
    final service = ref.read(taskServiceProvider);
    final newTask = await service.createTask(
      TaskCreationInput(
        title: '${task.title} (Copy)',
        listId: task.listId,
        notes: task.notes,
        dueAt: task.dueAt,
        remindAt: task.remindAt,
        tagIds: task.tagIds,
        priority: task.priority,
        subtasks: task.subtasks,
      ),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.taskDetailDuplicated)),
      );
    }
  }
}

class _StatusSection extends ConsumerWidget {
  const _StatusSection({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (value) async {
                if (value != null) {
                  final service = ref.read(taskServiceProvider);
                  await service.toggleCompletion(task, isCompleted: value);
                }
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrioritySection extends StatelessWidget {
  const _PrioritySection({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final priorityText = switch (task.priority) {
      TaskPriority.none => l10n.taskPriorityNone,
      TaskPriority.low => l10n.taskPriorityLow,
      TaskPriority.medium => l10n.taskPriorityMedium,
      TaskPriority.high => l10n.taskPriorityHigh,
      TaskPriority.critical => l10n.taskPriorityCritical,
    };

    final priorityColor = switch (task.priority) {
      TaskPriority.none => theme.colorScheme.onSurfaceVariant,
      TaskPriority.low => Colors.blue,
      TaskPriority.medium => Colors.orange,
      TaskPriority.high => Colors.red,
      TaskPriority.critical => Colors.red.shade900,
    };

    return _InfoRow(
      icon: Icons.flag,
      label: l10n.taskDetailPriority,
      value: priorityText,
      valueColor: priorityColor,
    );
  }
}

class _ListSection extends StatelessWidget {
  const _ListSection({required this.taskList});

  final TaskList taskList;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = _colorFromHex(taskList.colorHex ?? '#8896AB');

    return _InfoRow(
      icon: _iconFromString(taskList.iconName ?? 'inbox'),
      label: l10n.taskDetailList,
      value: taskList.name,
      valueColor: color,
    );
  }

  IconData _iconFromString(String name) {
    const iconMap = {
      'inbox': Icons.inbox,
      'work': Icons.work,
      'home': Icons.home,
      'shopping_cart': Icons.shopping_cart,
      'favorite': Icons.favorite,
      'star': Icons.star,
      'calendar_today': Icons.calendar_today,
      'school': Icons.school,
      'fitness_center': Icons.fitness_center,
      'restaurant': Icons.restaurant,
      'flight': Icons.flight,
      'lightbulb': Icons.lightbulb,
      'brush': Icons.brush,
      'music_note': Icons.music_note,
      'sports_soccer': Icons.sports_soccer,
    };
    return iconMap[name] ?? Icons.list;
  }

  Color _colorFromHex(String hex) {
    final sanitized = hex.replaceFirst('#', '');
    final value = int.tryParse(sanitized, radix: 16) ?? 0xFF8896AB;
    return Color(0xFF000000 | value);
  }
}

class _TagsSection extends StatelessWidget {
  const _TagsSection({required this.tags});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.label, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.taskDetailTags,
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) {
                final color = _colorFromHex(tag.colorHex);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.label, size: 14, color: color),
                      const SizedBox(width: 4),
                      Text(
                        tag.name,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFromHex(String hex) {
    final sanitized = hex.replaceFirst('#', '');
    final value = int.tryParse(sanitized, radix: 16) ?? 0xFF8896AB;
    return Color(0xFF000000 | value);
  }
}

class _DateSection extends StatelessWidget {
  const _DateSection({
    required this.icon,
    required this.label,
    required this.date,
  });

  final IconData icon;
  final String label;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMd();
    final timeFormat = DateFormat.jm();
    final dateStr = '${dateFormat.format(date)} ${timeFormat.format(date)}';

    return _InfoRow(
      icon: icon,
      label: label,
      value: dateStr,
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notes, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.taskDetailNotes,
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              notes,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubtasksSection extends ConsumerWidget {
  const _SubtasksSection({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final completedCount =
        task.subtasks.where((s) => s.isCompleted).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.checklist,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.taskDetailSubtasks,
                  style: theme.textTheme.titleSmall,
                ),
                const Spacer(),
                Text(
                  '$completedCount/${task.subtasks.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...task.subtasks.map((subtask) {
              return CheckboxListTile(
                value: subtask.isCompleted,
                onChanged: (value) async {
                  if (value != null) {
                    final service = ref.read(taskServiceProvider);
                    await service.toggleSubTask(
                      task,
                      subtask,
                      isCompleted: value,
                    );
                  }
                },
                title: Text(
                  subtask.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    decoration: subtask.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TimestampsSection extends StatelessWidget {
  const _TimestampsSection({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMMd();
    final timeFormat = DateFormat.jm();

    String formatDateTime(DateTime dt) {
      return '${dateFormat.format(dt)} ${timeFormat.format(dt)}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.taskDetailMetadata,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        _MetadataRow(
          label: l10n.taskDetailCreated,
          value: formatDateTime(task.createdAt),
        ),
        _MetadataRow(
          label: l10n.taskDetailUpdated,
          value: formatDateTime(task.updatedAt),
        ),
        if (task.completedAt != null)
          _MetadataRow(
            label: l10n.taskDetailCompleted,
            value: formatDateTime(task.completedAt!),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
