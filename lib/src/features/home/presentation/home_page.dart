import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todolist/l10n/app_localizations.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/haptic_feedback_helper.dart';
import 'package:todolist/src/core/widgets/skeleton_loader.dart';
import 'package:todolist/src/core/widgets/enhanced_snackbar.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/features/home/application/dashboard_providers.dart';
import 'package:todolist/src/features/home/application/home_tasks_provider.dart';
import 'package:todolist/src/features/home/application/task_selection_provider.dart';
import 'package:todolist/src/features/home/presentation/widgets/dashboard_stat_card.dart';
import 'package:todolist/src/features/notes/presentation/notes_list_page.dart';
import 'package:todolist/src/features/settings/presentation/settings_page.dart';
import 'package:todolist/src/features/settings/presentation/widgets/background_container.dart';
import 'package:todolist/src/features/tasks/application/batch_task_service.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';
import 'package:todolist/src/features/tasks/application/task_service.dart';
import 'package:todolist/src/features/tasks/presentation/task_composer_sheet.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';
import 'package:todolist/src/features/animations/widgets/animated_task_wrapper.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const routeName = 'home';
  static const routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final clock = ref.watch(clockProvider);
    final now = clock.now();
    final locale = Localizations.localeOf(context).toString();
    final weekday = DateFormat.EEEE(locale).format(now);
    final longDate = DateFormat.yMMMMd(locale).format(now);

    final filter = ref.watch(homeTaskFilterProvider);
    final tasksAsync = ref.watch(filteredTasksProvider);

    final listsAsync = ref.watch(taskListsProvider);
    final tagsAsync = ref.watch(tagsProvider);

    final listMap = {
      for (final list in listsAsync.valueOrNull ?? <TaskList>[]) list.id: list,
    };
    final tagMap = {
      for (final tag in tagsAsync.valueOrNull ?? <Tag>[]) tag.id: tag,
    };

    final isSelectionMode = ref.watch(taskSelectionModeProvider);
    final selectedCount = ref.watch(selectedTaskIdsProvider).length;
    final l10n = context.l10n;

    return BackgroundContainer(
      backgroundType: BackgroundType.home,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: isSelectionMode
            ? _buildSelectionAppBar(context, ref, selectedCount)
            : _buildNormalAppBar(context, weekday, longDate, theme),
      body: Column(
        children: [
          // 快速筛选栏 - 今天、本周、重要、全部（优化：减小padding）
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _QuickFilterChip(
                    label: '今天',
                    icon: Icons.today,
                    isSelected: filter == HomeTaskFilter.today,
                    onTap: () {
                      HapticFeedbackHelper.selection();
                      ref.read(homeTaskFilterProvider.notifier).state =
                          HomeTaskFilter.today;
                    },
                  ),
                  const SizedBox(width: 4),
                  _QuickFilterChip(
                    label: '本周',
                    icon: Icons.date_range,
                    isSelected: filter == HomeTaskFilter.thisWeek,
                    onTap: () {
                      HapticFeedbackHelper.selection();
                      ref.read(homeTaskFilterProvider.notifier).state =
                          HomeTaskFilter.thisWeek;
                    },
                  ),
                  const SizedBox(width: 4),
                  _QuickFilterChip(
                    label: '重要',
                    icon: Icons.priority_high,
                    isSelected: filter == HomeTaskFilter.important,
                    onTap: () {
                      HapticFeedbackHelper.selection();
                      ref.read(homeTaskFilterProvider.notifier).state =
                          HomeTaskFilter.important;
                    },
                  ),
                  const SizedBox(width: 4),
                  _QuickFilterChip(
                    label: '全部',
                    icon: Icons.list,
                    isSelected: filter == HomeTaskFilter.all,
                    onTap: () {
                      HapticFeedbackHelper.selection();
                      ref.read(homeTaskFilterProvider.notifier).state =
                          HomeTaskFilter.all;
                    },
                  ),
                ],
              ),
            ),
          ),
          if (!isSelectionMode) ...[
            _FilterBar(
              lists: listsAsync.valueOrNull ?? [],
              tags: tagsAsync.valueOrNull ?? [],
            ),
            // Dashboard stats cards
            Consumer(
              builder: (context, ref, child) {
                final statsAsync = ref.watch(dashboardStatsProvider);
                return statsAsync.when(
                  data: (stats) => Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                    child: DashboardStatsGrid(
                      todayCompleted: stats.todayCompletedCount,
                      todayTotal: stats.todayTotalCount,
                      weekFocusTime: stats.weekFocusTimeFormatted,
                      currentStreak: stats.currentStreak,
                      urgentTasks: stats.urgentTasksCount,
                      onTodayTap: () {
                        ref.read(homeTaskFilterProvider.notifier).state =
                            HomeTaskFilter.today;
                      },
                      onUrgentTap: () {
                        ref.read(homeTaskFilterProvider.notifier).state =
                            HomeTaskFilter.important;
                      },
                    ),
                  ),
                  loading: () => const SizedBox(height: 160),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
            ),
          ],
          Expanded(
            child: tasksAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      HapticFeedbackHelper.refresh(); // 刷新触觉反馈
                      ref.invalidate(taskListsProvider);
                      ref.invalidate(tagsProvider);
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    displacement: 60,
                    edgeOffset: 0,
                    color: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.surface,
                    child: const _EmptyState(),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    HapticFeedbackHelper.refresh(); // 刷新触觉反馈
                    ref.invalidate(taskListsProvider);
                    ref.invalidate(tagsProvider);
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  displacement: 60,
                  edgeOffset: 0,
                  color: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.surface,
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    itemCount: items.length,
                    onReorder: (oldIndex, newIndex) async {
                      HapticFeedbackHelper.selection(); // 拖拽反馈
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final taskToMove = items[oldIndex];
                      final reorderedTasks = List<Task>.from(items);
                      reorderedTasks.removeAt(oldIndex);
                      reorderedTasks.insert(newIndex, taskToMove);

                      // Update sortOrder for all affected tasks
                      final repository = ref.read(taskRepositoryProvider);
                      for (var i = 0; i < reorderedTasks.length; i++) {
                        final updatedTask = reorderedTasks[i].copyWith(
                          sortOrder: i,
                        );
                        await repository.save(updatedTask);
                      }

                      HapticFeedbackHelper.light(); // 完成反馈
                      // Refresh the task list
                      // ref.invalidate(homeTasksProvider);
                    },
                    itemBuilder: (context, index) {
                      final task = items[index];
                      final list = listMap[task.listId];
                      final tags = [
                        for (final tagId in task.tagIds)
                          if (tagMap[tagId] != null) tagMap[tagId]!,
                      ];
                      return Padding(
                        key: ValueKey(task.id),
                        padding: EdgeInsets.only(
                          bottom: index < items.length - 1 ? 16 : 0,
                        ),
                        child: AnimatedTaskWrapper(
                          task: task,
                          child: _TaskCard(task: task, list: list, tags: tags),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                itemCount: 5,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: const SkeletonTaskCard(),
                ),
              ),
              error: (error, stackTrace) => _ErrorState(error: error),
            ),
          ),
        ],
      ),
        floatingActionButton: isSelectionMode
            ? null
            : FloatingActionButton.extended(
                onPressed: () => _showCreateMenu(context),
                icon: const Icon(Icons.add),
                label: const Text('新建'),
              ),
        bottomNavigationBar: isSelectionMode
            ? _BatchActionBar(
                selectedCount: selectedCount,
                lists: listsAsync.valueOrNull ?? [],
                tags: tagsAsync.valueOrNull ?? [],
              )
            : null,
      ),
    );
  }

  AppBar _buildNormalAppBar(
    BuildContext context,
    String weekday,
    String longDate,
    ThemeData theme,
  ) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weekday,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          Text(
            longDate,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => context.push('/enhanced-search'),
          icon: const Icon(Icons.search),
          tooltip: '全局搜索',
        ),
        IconButton(
          onPressed: () => context.push('/calendar'),
          icon: const Icon(Icons.calendar_month_outlined),
          tooltip: '日历视图',
        ),
        IconButton(
          onPressed: () => context.push(NotesListPage.routePath),
          icon: const Icon(Icons.note_outlined),
          tooltip: '笔记',
        ),
        IconButton(
          onPressed: () => context.push(SettingsPage.routePath),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }

  AppBar _buildSelectionAppBar(
    BuildContext context,
    WidgetRef ref,
    int selectedCount,
  ) {
    final l10n = context.l10n;
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => ref.exitSelectionMode(),
      ),
      title: Text(l10n.homeSelectionTitle(selectedCount)),
      actions: [
        IconButton(
          icon: const Icon(Icons.select_all),
          onPressed: () {
            final tasksAsync = ref.read(filteredTasksProvider);
            tasksAsync.whenData((tasks) {
              ref.selectAllTasks(tasks.map((t) => t.id).toList());
            });
          },
        ),
      ],
    );
  }

  /// 显示创建选项菜单
  static void _showCreateMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.task_alt, color: Colors.blue),
              title: const Text('新建任务'),
              subtitle: const Text('创建待办事项或安排'),
              onTap: () {
                Navigator.pop(context);
                TaskComposerSheet.show(context);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.note, color: Colors.green),
              title: const Text('新建笔记'),
              subtitle: const Text('记录学习笔记和文档'),
              onTap: () {
                Navigator.pop(context);
                context.push('/notes/new');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  const _TaskCard({required this.task, this.list, this.tags = const []});

  final Task task;
  final TaskList? list;
  final List<Tag> tags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dueAt = task.dueAt;
    final formatter = DateFormat('HH:mm');
    final service = ref.read(taskServiceProvider);
    final completedSubTasks = task.subtasks
        .where((sub) => sub.isCompleted)
        .length;

    final isSelectionMode = ref.watch(taskSelectionModeProvider);
    final isSelected = ref.watch(selectedTaskIdsProvider).contains(task.id);
    final l10n = context.l10n;

    // 判断任务状态
    final now = DateTime.now();
    final isOverdue = dueAt != null &&
        dueAt.isBefore(now) &&
        !task.isCompleted;
    final isDueToday = dueAt != null &&
        !task.isCompleted &&
        dueAt.year == now.year &&
        dueAt.month == now.month &&
        dueAt.day == now.day;

    final cardWidget = Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isOverdue
            ? BorderSide(color: Colors.red, width: 2)
            : isDueToday
                ? BorderSide(color: Colors.orange, width: 2)
                : BorderSide.none,
      ),
      color: isSelected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          HapticFeedbackHelper.light(); // 点击反馈
          if (isSelectionMode) {
            ref.toggleTaskSelection(task.id);
          } else {
            TaskComposerSheet.show(context, task: task);
          }
        },
        onLongPress: () {
          if (!isSelectionMode) {
            HapticFeedbackHelper.longPress(); // 长按反馈
            _showQuickActionMenu(context, ref, task, service, list);
          }
        },
        child: Opacity(
          opacity: task.isCompleted ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSelectionMode)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (_) => ref.toggleTaskSelection(task.id),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  )
                else
                  _PriorityDot(priority: task.priority),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (task.notes != null && task.notes!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          task.notes!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (dueAt != null)
                            _Chip(
                              icon: Icons.timer_outlined,
                              label: formatter.format(dueAt),
                              backgroundColor: Colors.orange.withValues(alpha: 0.12),
                              foregroundColor: Colors.orange.shade700,
                            ),
                          if (list != null)
                            _Chip(
                              icon: Icons.list_alt_outlined,
                              label: list!.name,
                              backgroundColor: _colorFromHex(
                                list!.colorHex,
                              ).withValues(alpha: 0.12),
                              foregroundColor: _colorFromHex(list!.colorHex),
                            ),
                          for (final tag in tags)
                            _Chip(
                              icon: Icons.label_outline,
                              label: tag.name,
                              backgroundColor: _colorFromHex(
                                tag.colorHex,
                              ).withValues(alpha: 0.12),
                              foregroundColor: _colorFromHex(tag.colorHex),
                            ),
                        ],
                      ),
                      if (task.subtasks.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.homeSubtaskSummary(
                                      completedSubTasks,
                                      task.subtasks.length,
                                    ),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: LinearProgressIndicator(
                                      value: task.subtasks.isEmpty
                                          ? 0.0
                                          : completedSubTasks / task.subtasks.length,
                                      backgroundColor: Colors.grey.shade300,
                                      valueColor: AlwaysStoppedAnimation(
                                        theme.colorScheme.primary,
                                      ),
                                      minHeight: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      // Time estimation progress
                      if (task.estimatedMinutes != null) ...[
                        const SizedBox(height: 8),
                        _TimeEstimationProgress(task: task),
                      ],
                    ],
                  ),
                ),
                if (!isSelectionMode) ...[
                  // 快速专注按钮
                  IconButton(
                    icon: Icon(Icons.timer, size: 20, color: Colors.blue.shade600),
                    tooltip: '专注模式',
                    onPressed: () {
                      Navigator.of(context).pushNamed('/focus', arguments: task);
                    },
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 4),
                  // 完成复选框
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) async {
                      if (value == null) return;
                      // 添加触觉反馈 - 完成任务时用成功反馈,取消完成用轻触
                      if (value) {
                        HapticFeedbackHelper.success();
                      } else {
                        HapticFeedbackHelper.light();
                      }
                      await service.toggleCompletion(task, isCompleted: value);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    // Don't use slidable in selection mode
    if (isSelectionMode) {
      return cardWidget;
    }

    return Slidable(
      key: ValueKey(task.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              HapticFeedbackHelper.light(); // 滑动操作反馈
              await service.toggleCompletion(
                task,
                isCompleted: !task.isCompleted,
              );
            },
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            icon: task.isCompleted ? Icons.undo : Icons.check,
            label: task.isCompleted ? l10n.commonReset : '完成',
          ),
          // 稍后提醒（1小时后）
          SlidableAction(
            onPressed: (_) async {
              HapticFeedbackHelper.light(); // 滑动操作反馈
              final oneHourLater = DateTime.now().add(const Duration(hours: 1));
              await ref.read(taskRepositoryProvider).save(
                task.copyWith(remindAt: oneHourLater),
              );
              if (context.mounted) {
                EnhancedSnackBar.showSuccess(
                  context,
                  '已设置1小时后提醒',
                  duration: const Duration(seconds: 2),
                );
              }
            },
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.access_time,
            label: '1小时后',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          // 明天提醒
          SlidableAction(
            onPressed: (_) async {
              HapticFeedbackHelper.light(); // 滑动操作反馈
              final tomorrow = DateTime.now().add(const Duration(days: 1));
              final tomorrowMorning = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0);
              await ref.read(taskRepositoryProvider).save(
                task.copyWith(remindAt: tomorrowMorning),
              );
              if (context.mounted) {
                EnhancedSnackBar.showSuccess(
                  context,
                  '已设置明天早上9点提醒',
                  duration: const Duration(seconds: 2),
                );
              }
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.wb_sunny,
            label: '明天',
          ),
          SlidableAction(
            onPressed: (_) async {
              HapticFeedbackHelper.warning(); // 删除警告反馈
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.taskDetailDeleteConfirmTitle),
                  content: Text(
                    l10n.taskDetailDeleteConfirmMessage(task.title),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(l10n.commonCancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(l10n.commonDelete),
                    ),
                  ],
                ),
              );

              if (confirmed ?? false) {
                final repository = ref.read(taskRepositoryProvider);
                await repository.delete(task.id);
              }
            },
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.delete,
            label: l10n.commonDelete,
          ),
        ],
      ),
      child: cardWidget,
    );
  }

  // 显示快捷操作菜单
  static void _showQuickActionMenu(
    BuildContext context,
    WidgetRef ref,
    Task task,
    dynamic service,
    TaskList? list,
  ) {
    final l10n = context.l10n;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('编辑任务'),
              onTap: () {
                Navigator.pop(context);
                TaskComposerSheet.show(context, task: task);
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer, color: Colors.orange),
              title: const Text('专注模式'),
              subtitle: const Text('开始番茄钟计时'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/focus', arguments: task);
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move, color: Colors.purple),
              title: const Text('移动到...'),
              subtitle: list != null ? Text('当前: ${list.name}') : null,
              onTap: () async {
                Navigator.pop(context);
                final lists = await ref.read(taskListsProvider.future);
                if (!context.mounted) return;

                final selected = await showDialog<TaskList>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('选择列表'),
                    children: lists.map((l) {
                      return SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, l),
                        child: Text(l.name),
                      );
                    }).toList(),
                  ),
                );

                if (selected != null) {
                  await ref.read(taskRepositoryProvider).save(
                    task.copyWith(listId: selected.id),
                  );
                }
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('删除任务'),
              onTap: () async {
                Navigator.pop(context);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.taskDetailDeleteConfirmTitle),
                    content: Text(
                      l10n.taskDetailDeleteConfirmMessage(task.title),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(l10n.commonCancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(l10n.commonDelete),
                      ),
                    ],
                  ),
                );

                if (confirmed ?? false) {
                  final repository = ref.read(taskRepositoryProvider);
                  await repository.delete(task.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityDot extends StatelessWidget {
  const _PriorityDot({required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      TaskPriority.none => Colors.grey.shade500,
      TaskPriority.low => Colors.blue.shade600,
      TaskPriority.medium => Colors.teal.shade600,
      TaskPriority.high => Colors.orange.shade600,
      TaskPriority.critical => Colors.red.shade700,
    };

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background =
        backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final foreground = foregroundColor ?? theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 3),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: foreground,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatefulWidget {
  const _EmptyState();

  @override
  State<_EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<_EmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 动画图标
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.inbox_outlined,
                          size: 72,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 渐显文字
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            l10n.homeEmptyTitle,
                            style: theme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.homeEmptySubtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          // 添加引导按钮
                          FilledButton.icon(
                            onPressed: () => TaskComposerSheet.show(context),
                            icon: const Icon(Icons.add),
                            label: const Text('创建第一个任务'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(l10n.homeErrorTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              l10n.homeErrorDetails(error.toString()),
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends ConsumerStatefulWidget {
  const _FilterBar({required this.lists, required this.tags});

  final List<TaskList> lists;
  final List<Tag> tags;

  @override
  ConsumerState<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends ConsumerState<_FilterBar> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final sortBy = ref.watch(taskSortOptionProvider);
    final priorityFilter = ref.watch(taskPriorityFilterProvider);
    final tagFilters = ref.watch(taskTagFiltersProvider);
    final tagFilterLogic = ref.watch(tagFilterLogicProvider);
    final listFilter = ref.watch(taskListFilterProvider);
    final showCompleted = ref.watch(showCompletedTasksProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<TaskSortOption>(
                  initialValue: sortBy,
                  decoration: InputDecoration(
                    labelText: l10n.homeSortByLabel,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    isDense: true,
                  ),
                  isDense: true,
                  dropdownColor: theme.colorScheme.surfaceContainerHighest,
                  style: theme.textTheme.bodySmall,
                  items: [
                    DropdownMenuItem(
                      value: TaskSortOption.manual,
                      child: Text(l10n.homeSortByManual, style: theme.textTheme.bodySmall),
                    ),
                    DropdownMenuItem(
                      value: TaskSortOption.dueDate,
                      child: Text(l10n.homeSortByDueDate, style: theme.textTheme.bodySmall),
                    ),
                    DropdownMenuItem(
                      value: TaskSortOption.priority,
                      child: Text(l10n.homeSortByPriority, style: theme.textTheme.bodySmall),
                    ),
                    DropdownMenuItem(
                      value: TaskSortOption.createdDate,
                      child: Text(l10n.homeSortByCreatedDate, style: theme.textTheme.bodySmall),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(taskSortOptionProvider.notifier).state = value;
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(l10n.homeShowCompletedLabel, style: theme.textTheme.bodySmall),
                selected: showCompleted,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                selectedColor: theme.colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: showCompleted
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                visualDensity: VisualDensity.compact,
                onSelected: (value) {
                  ref.read(showCompletedTasksProvider.notifier).state = value;
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.homeFilterBarTitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: theme.colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Priority filters
                ...TaskPriority.values.map((priority) {
                  final isSelected = priorityFilter == priority;
                  return FilterChip(
                    label: Text(_getPriorityLabel(priority, l10n)),
                    selected: isSelected,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    selectedColor: _getPriorityColor(priority).withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                      color: isSelected
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                    ),
                    onSelected: (selected) {
                      ref.read(taskPriorityFilterProvider.notifier).state =
                          selected ? priority : null;
                    },
                    avatar: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
                // List filters
                ...widget.lists.map((list) {
                  final isSelected = listFilter == list.id;
                  final listColor = _colorFromHex(list.colorHex);
                  return FilterChip(
                    label: Text(list.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      ref.read(taskListFilterProvider.notifier).state = selected
                          ? list.id
                          : null;
                    },
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    selectedColor: listColor.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                      color: isSelected
                        ? _getTextColorForChip(listColor)
                        : theme.colorScheme.onSurfaceVariant,
                    ),
                    side: BorderSide(
                      color: listColor.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  );
                }),
                // Tag filters with AND/OR logic toggle
                if (widget.tags.isNotEmpty) ...[
                  const SizedBox(width: 8, height: 8),
                  // AND/OR Toggle
                  ChoiceChip(
                    label: Text(tagFilterLogic == TagFilterLogic.or ? 'OR' : 'AND'),
                    selected: true,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) {
                      ref.read(tagFilterLogicProvider.notifier).state =
                          tagFilterLogic == TagFilterLogic.or
                              ? TagFilterLogic.and
                              : TagFilterLogic.or;
                    },
                    avatar: Icon(
                      tagFilterLogic == TagFilterLogic.or
                          ? Icons.join_inner
                          : Icons.join_full,
                      size: 18,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8, height: 8),
                ],
                // Tag filter chips (multi-select)
                ...widget.tags.map((tag) {
                  final isSelected = tagFilters.contains(tag.id);
                  final tagColor = _colorFromHex(tag.colorHex);
                  return FilterChip(
                    label: Text(tag.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      final newFilters = List<String>.from(tagFilters);
                      if (selected) {
                        newFilters.add(tag.id);
                      } else {
                        newFilters.remove(tag.id);
                      }
                      ref.read(taskTagFiltersProvider.notifier).state = newFilters;
                    },
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    selectedColor: tagColor.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                      color: isSelected
                        ? _getTextColorForChip(tagColor)
                        : theme.colorScheme.onSurfaceVariant,
                    ),
                    side: BorderSide(
                      color: tagColor.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  );
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getPriorityLabel(TaskPriority priority, AppLocalizations l10n) {
    return switch (priority) {
      TaskPriority.none => l10n.taskPriorityNone,
      TaskPriority.low => l10n.taskPriorityLow,
      TaskPriority.medium => l10n.taskPriorityMedium,
      TaskPriority.high => l10n.taskPriorityHigh,
      TaskPriority.critical => l10n.taskPriorityCritical,
    };
  }

  Color _getPriorityColor(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.none => Colors.grey.shade400,
      TaskPriority.low => Colors.blue.shade300,
      TaskPriority.medium => Colors.teal.shade400,
      TaskPriority.high => Colors.orange.shade400,
      TaskPriority.critical => Colors.redAccent,
    };
  }
}

// 快速筛选Chip
class _QuickFilterChip extends StatelessWidget {
  const _QuickFilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 3),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BatchActionBar extends ConsumerWidget {
  const _BatchActionBar({
    required this.selectedCount,
    required this.lists,
    required this.tags,
  });

  final int selectedCount;
  final List<TaskList> lists;
  final List<Tag> tags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: l10n.homeBatchComplete,
            onPressed: () => _batchComplete(context, ref, true),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.homeBatchDelete,
            onPressed: () => _batchDelete(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.list_alt_outlined),
            tooltip: l10n.homeBatchMove,
            onPressed: () => _batchMoveToList(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.label_outline),
            tooltip: l10n.homeBatchTag,
            onPressed: () => _batchAddTags(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _batchComplete(
    BuildContext context,
    WidgetRef ref,
    bool isCompleted,
  ) async {
    final selectedIds = ref.read(selectedTaskIdsProvider).toList();
    final service = ref.read(batchTaskServiceProvider);
    final l10n = context.l10n;

    try {
      await service.batchComplete(selectedIds, isCompleted: isCompleted);
      ref.exitSelectionMode();
      if (context.mounted) {
        final message = isCompleted
            ? l10n.homeBatchCompleteSuccess(selectedCount)
            : l10n.homeBatchUncompleteSuccess(selectedCount);
        EnhancedSnackBar.showSuccess(context, message);
      }
    } catch (e) {
      if (context.mounted) {
        EnhancedSnackBar.showError(context, l10n.homeBatchActionFailure(e.toString()));
      }
    }
  }

  Future<void> _batchDelete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.homeBatchDeleteTitle),
        content: Text(l10n.homeBatchDeleteMessage(selectedCount)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final selectedIds = ref.read(selectedTaskIdsProvider).toList();
    final service = ref.read(batchTaskServiceProvider);

    try {
      await service.batchDelete(selectedIds);
      ref.exitSelectionMode();
      if (context.mounted) {
        EnhancedSnackBar.showSuccess(context, l10n.homeBatchDeleteSuccess(selectedCount));
      }
    } catch (e) {
      if (context.mounted) {
        EnhancedSnackBar.showError(context, l10n.homeBatchActionFailure(e.toString()));
      }
    }
  }

  Future<void> _batchMoveToList(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final selectedListId = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.homeBatchMoveTitle),
        children: lists.map((list) {
          return SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(list.id),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 16,
                  color: _colorFromHex(list.colorHex),
                ),
                const SizedBox(width: 12),
                Text(list.name),
              ],
            ),
          );
        }).toList(),
      ),
    );

    if (selectedListId == null) return;

    final selectedIds = ref.read(selectedTaskIdsProvider).toList();
    final service = ref.read(batchTaskServiceProvider);

    try {
      await service.batchMoveToList(selectedIds, selectedListId);
      ref.exitSelectionMode();
      if (context.mounted) {
        EnhancedSnackBar.showSuccess(context, l10n.homeBatchMoveSuccess(selectedCount));
      }
    } catch (e) {
      if (context.mounted) {
        EnhancedSnackBar.showError(context, l10n.homeBatchActionFailure(e.toString()));
      }
    }
  }

  Future<void> _batchAddTags(BuildContext context, WidgetRef ref) async {
    final selectedTagIds = await showDialog<List<String>>(
      context: context,
      builder: (context) => _TagSelectionDialog(tags: tags),
    );

    if (selectedTagIds == null || selectedTagIds.isEmpty) return;

    final selectedIds = ref.read(selectedTaskIdsProvider).toList();
    final service = ref.read(batchTaskServiceProvider);
    final l10n = context.l10n;

    try {
      await service.batchAddTags(selectedIds, selectedTagIds);
      ref.exitSelectionMode();
      if (context.mounted) {
        EnhancedSnackBar.showSuccess(context, l10n.homeBatchTagSuccess(selectedCount));
      }
    } catch (e) {
      if (context.mounted) {
        EnhancedSnackBar.showError(context, l10n.homeBatchActionFailure(e.toString()));
      }
    }
  }
}

class _TagSelectionDialog extends StatefulWidget {
  const _TagSelectionDialog({required this.tags});

  final List<Tag> tags;

  @override
  State<_TagSelectionDialog> createState() => _TagSelectionDialogState();
}

class _TagSelectionDialogState extends State<_TagSelectionDialog> {
  final Set<String> _selectedTagIds = {};

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.homeTagDialogTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.tags.length,
          itemBuilder: (context, index) {
            final tag = widget.tags[index];
            final isSelected = _selectedTagIds.contains(tag.id);

            return CheckboxListTile(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value ?? false) {
                    _selectedTagIds.add(tag.id);
                  } else {
                    _selectedTagIds.remove(tag.id);
                  }
                });
              },
              title: Row(
                children: [
                  Icon(
                    Icons.label,
                    size: 16,
                    color: _colorFromHex(tag.colorHex),
                  ),
                  const SizedBox(width: 8),
                  Text(tag.name),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(context.l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_selectedTagIds.toList()),
          child: Text(context.l10n.commonConfirm),
        ),
      ],
    );
  }
}

class _TimeEstimationProgress extends StatelessWidget {
  const _TimeEstimationProgress({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final estimated = task.estimatedMinutes!;
    final actual = task.actualMinutes;
    final progress = actual / estimated;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              '预估$estimated分 ',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (actual > 0) ...[
              Text(
                '• 已用$actual分',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _getProgressColor(progress),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(_getProgressColor(progress)),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress <= 0.5) return Colors.green;
    if (progress <= 0.8) return Colors.orange;
    if (progress <= 1.0) return Colors.amber;
    return Colors.red;
  }
}

Color _colorFromHex(String hex) {
  final sanitized = hex.replaceFirst('#', '');
  final value = int.tryParse(sanitized, radix: 16) ?? 0xFF000000;
  if (sanitized.length == 6) {
    return Color(0xFF000000 | value);
  }
  return Color(value);
}

Color _getTextColorForChip(Color background) {
  final luminance = background.computeLuminance();
  return luminance > 0.4 ? Colors.black87 : Colors.white;
}
