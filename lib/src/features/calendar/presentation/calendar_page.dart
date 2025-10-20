import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/l10n/app_localizations.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/features/calendar/application/calendar_provider.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';
import 'package:todolist/src/features/tasks/application/task_service.dart';
import 'package:todolist/src/features/tasks/presentation/task_composer_sheet.dart';
import 'package:todolist/src/features/tasks/presentation/task_detail_page.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  static const routeName = 'calendar_old';
  static const routePath = '/calendar_old';

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    final now = ref.read(clockProvider).now();
    _focusedDay = now;
    _selectedDay = now;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final tasksAsync = ref.watch(calendarTasksProvider);
    final listsAsync = ref.watch(taskListsProvider);
    final tagsAsync = ref.watch(tagsProvider);
    final clock = ref.watch(clockProvider);
    final today = DateTime(clock.now().year, clock.now().month, clock.now().day);

    final listMap = {
      for (final list in listsAsync.valueOrNull ?? <TaskList>[]) list.id: list,
    };
    final tagMap = {
      for (final tag in tagsAsync.valueOrNull ?? <Tag>[]) tag.id: tag,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calendarTitle),
        actions: [
          // 周/月视图切换按钮
          SegmentedButton<CalendarFormat>(
            segments: const [
              ButtonSegment<CalendarFormat>(
                value: CalendarFormat.week,
                icon: Icon(Icons.view_week, size: 16),
                label: Text('周'),
              ),
              ButtonSegment<CalendarFormat>(
                value: CalendarFormat.month,
                icon: Icon(Icons.calendar_view_month, size: 16),
                label: Text('月'),
              ),
            ],
            selected: {_calendarFormat},
            onSelectionChanged: (Set<CalendarFormat> newSelection) {
              setState(() {
                _calendarFormat = newSelection.first;
              });
            },
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: l10n.calendarTodayButton,
            onPressed: () {
              final now = ref.read(clockProvider).now();
              setState(() {
                _focusedDay = now;
                _selectedDay = now;
              });
            },
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final tasksByDate = <DateTime, List<Task>>{};
          for (final task in tasks) {
            if (task.dueAt != null) {
              final date = DateTime(
                task.dueAt!.year,
                task.dueAt!.month,
                task.dueAt!.day,
              );
              tasksByDate.putIfAbsent(date, () => []).add(task);
            }
          }

          final selectedDayTasks = tasksByDate[DateTime(
                _selectedDay.year,
                _selectedDay.month,
                _selectedDay.day,
              )] ??
              [];

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(8),
                elevation: 0,
                color: Colors.transparent,
                child: TableCalendar<Task>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  eventLoader: (day) {
                    final normalizedDay = DateTime(day.year, day.month, day.day);
                    return tasksByDate[normalizedDay] ?? [];
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    // 弹出当天任务列表
                    final dayTasks = tasksByDate[DateTime(
                          selectedDay.year,
                          selectedDay.month,
                          selectedDay.day,
                        )] ??
                        [];
                    if (dayTasks.isNotEmpty) {
                      _showDayTasksBottomSheet(
                        context,
                        selectedDay,
                        dayTasks,
                        listMap,
                        tagMap,
                      );
                    }
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarBuilders: CalendarBuilders(
                    // 自定义任务指示器 - 简约小圆点
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return null;

                      // 最多显示3个小圆点
                      return Positioned(
                        bottom: 4,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            events.length > 3 ? 3 : events.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1.5),
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    // 完全模仿系统设置日历样式
                    cellMargin: const EdgeInsets.all(2),
                    cellPadding: const EdgeInsets.all(0),
                    cellAlignment: Alignment.center,
                    // 今天的样式 - 蓝色实心圆
                    todayDecoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    // 选中日期 - 浅色圆圈
                    selectedDecoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    // 普通日期
                    defaultTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: theme.colorScheme.onSurface,
                    ),
                    // 周末
                    weekendTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: theme.colorScheme.onSurface,
                    ),
                    // 其他月份的日期
                    outsideTextStyle: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                    // 不显示默认marker
                    markersMaxCount: 0,
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      DateFormat.yMMMd().format(_selectedDay),
                      style: theme.textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      l10n.calendarTaskCount(selectedDayTasks.length),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: selectedDayTasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_available,
                              size: 64,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.calendarNoTasks,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: selectedDayTasks.length,
                        itemBuilder: (context, index) {
                          final task = selectedDayTasks[index];
                          final list = listMap[task.listId];
                          final tags = [
                            for (final tagId in task.tagIds)
                              if (tagMap[tagId] != null) tagMap[tagId]!,
                          ];
                          return _TaskCard(
                            task: task,
                            list: list,
                            tags: tags,
                            selectedDate: _selectedDay,
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(l10n.homeErrorDetails(error.toString())),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => TaskComposerSheet.show(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.homeFabLabel),
      ),
    );
  }

  // 获取优先级对应的颜色
  Color _getPriorityColor(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.critical => Colors.red,
      TaskPriority.high => Colors.orange,
      TaskPriority.medium => Colors.amber,
      TaskPriority.low => Colors.blue,
      TaskPriority.none => Colors.grey,
    };
  }

  // 显示当天任务列表的底部弹窗
  void _showDayTasksBottomSheet(
    BuildContext context,
    DateTime selectedDay,
    List<Task> tasks,
    Map<String, TaskList> listMap,
    Map<String, Tag> tagMap,
  ) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // 拖拽指示器
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 标题
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.event,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat.yMMMd().format(selectedDay),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${tasks.length} 个任务',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 任务列表
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final list = listMap[task.listId];
                    final tags = [
                      for (final tagId in task.tagIds)
                        if (tagMap[tagId] != null) tagMap[tagId]!,
                    ];
                    return _TaskCard(
                      task: task,
                      list: list,
                      tags: tags,
                      selectedDate: selectedDay,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  const _TaskCard({
    required this.task,
    required this.list,
    required this.tags,
    required this.selectedDate,
  });

  final Task task;
  final TaskList? list;
  final List<Tag> tags;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return LongPressDraggable<Task>(
      data: task,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            task.title,
            style: theme.textTheme.bodyLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildCard(context, theme, l10n, ref),
      ),
      child: _buildCard(context, theme, l10n, ref),
    );
  }

  Widget _buildCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.push(TaskDetailPage.buildPath(task.id));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) async {
                      if (value == null) return;
                      await ref.read(taskServiceProvider).toggleCompletion(
                            task,
                            isCompleted: value,
                          );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  if (task.priority != TaskPriority.none)
                    Icon(
                      Icons.flag,
                      size: 20,
                      color: _getPriorityColor(task.priority, theme),
                    ),
                ],
              ),
              if (task.notes != null && task.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.notes!,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (list != null || tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (list != null)
                      Chip(
                        avatar: const Icon(
                          Icons.list,
                          size: 16,
                        ),
                        label: Text(list!.name),
                        visualDensity: VisualDensity.compact,
                      ),
                    ...tags.map(
                      (tag) => Chip(
                        label: Text(tag.name),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              ],
              if (task.dueAt != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat.Hm().format(task.dueAt!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority, ThemeData theme) {
    return switch (priority) {
      TaskPriority.critical => Colors.red,
      TaskPriority.high => Colors.orange,
      TaskPriority.medium => Colors.yellow.shade700,
      TaskPriority.low => Colors.blue,
      TaskPriority.none => theme.colorScheme.onSurfaceVariant,
    };
  }
}
