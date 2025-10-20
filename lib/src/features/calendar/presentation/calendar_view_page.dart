import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/core/utils/lunar_utils.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';
import 'package:todolist/src/features/tasks/application/task_service.dart';
import 'package:todolist/src/features/tasks/presentation/task_composer_sheet.dart';

/// 日历视图页面 - 作为首页
class CalendarViewPage extends ConsumerStatefulWidget {
  const CalendarViewPage({super.key});

  static const routeName = 'calendar';
  static const routePath = '/calendar';

  @override
  ConsumerState<CalendarViewPage> createState() => _CalendarViewPageState();
}

enum CalendarViewMode { day, week, month }

class _CalendarViewPageState extends ConsumerState<CalendarViewPage> {
  late DateTime _selectedDate;
  late DateTime _focusedWeek;
  late DateTime _focusedMonth;
  CalendarViewMode _viewMode = CalendarViewMode.week;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    // 获取本周的第一天（周日）
    _focusedWeek = _getWeekStart(now);
    _focusedMonth = DateTime(now.year, now.month, 1);
  }

  /// 获取某日期所在周的第一天（周日）
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday % 7; // 0=周日, 1=周一, ...
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: weekday));
  }

  /// 获取月份的天数
  int _getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  /// 获取月份第一天是星期几（0=周日）
  int _getMonthStartWeekday(DateTime date) {
    return DateTime(date.year, date.month, 1).weekday % 7;
  }

  /// 根据视图模式获取标题
  String _getTitle() {
    switch (_viewMode) {
      case CalendarViewMode.day:
        return DateFormat('M月d日 EEEE', 'zh_CN').format(_selectedDate);
      case CalendarViewMode.week:
        return '${DateFormat('M月d日').format(_focusedWeek)} - ${DateFormat('M月d日').format(_focusedWeek.add(const Duration(days: 6)))}';
      case CalendarViewMode.month:
        return DateFormat('yyyy年M月').format(_focusedMonth);
    }
  }

  /// 根据视图模式获取图标
  IconData _getViewIcon() {
    switch (_viewMode) {
      case CalendarViewMode.day:
        return Icons.today;
      case CalendarViewMode.week:
        return Icons.view_week;
      case CalendarViewMode.month:
        return Icons.calendar_month;
    }
  }

  /// 根据视图模式构建不同的内容
  Widget _buildViewContent(
    ThemeData theme,
    Map<DateTime, List<Task>> tasksByDate,
  ) {
    final selectedTasks = tasksByDate[_selectedDate] ?? [];

    switch (_viewMode) {
      case CalendarViewMode.day:
        // 今天视图 - 只显示任务列表
        return _DayTasksList(selectedDate: _selectedDate, tasks: selectedTasks);

      case CalendarViewMode.week:
        // 周视图 - 显示周网格 + 选中日期任务
        return Column(
          children: [
            _buildNavigationBar(theme),
            _buildWeekdayHeader(theme),
            SizedBox(
              height: 70, // 周视图：紧凑的单行网格（优化后更小）
              child: _WeekGrid(
                focusedWeek: _focusedWeek,
                selectedDate: _selectedDate,
                tasksByDate: tasksByDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _DayTasksList(
                selectedDate: _selectedDate,
                tasks: selectedTasks,
              ),
            ),
          ],
        );

      case CalendarViewMode.month:
        // 月视图 - 显示月网格 + 选中日期任务
        // 动态计算月视图需要的行数（4-6周）
        final daysInMonth = _getDaysInMonth(_focusedMonth);
        final startWeekday = _getMonthStartWeekday(_focusedMonth);
        final weeksInMonth = ((daysInMonth + startWeekday) / 7).ceil();
        final monthGridHeight = weeksInMonth * 50.0 + 8; // 每行50px（更紧凑）+ padding

        return Column(
          children: [
            _buildNavigationBar(theme, isMonthView: true),
            _buildWeekdayHeader(theme),
            SizedBox(
              height: monthGridHeight, // 月视图：根据周数动态调整高度
              child: _MonthGrid(
                focusedMonth: _focusedMonth,
                selectedDate: _selectedDate,
                tasksByDate: tasksByDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                getDaysInMonth: _getDaysInMonth,
                getMonthStartWeekday: _getMonthStartWeekday,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _DayTasksList(
                selectedDate: _selectedDate,
                tasks: selectedTasks,
              ),
            ),
          ],
        );
    }
  }

  /// 导航栏
  Widget _buildNavigationBar(ThemeData theme, {bool isMonthView = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainerHighest,
            theme.colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              setState(() {
                if (isMonthView) {
                  _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month - 1,
                    1,
                  );
                } else {
                  _focusedWeek = _focusedWeek.subtract(const Duration(days: 7));
                }
              });
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.today, size: 18, color: theme.colorScheme.primary),
            onPressed: () {
              setState(() {
                final now = DateTime.now();
                if (isMonthView) {
                  _focusedMonth = DateTime(now.year, now.month, 1);
                } else {
                  _focusedWeek = _getWeekStart(now);
                }
              });
            },
            label: Text(
              isMonthView
                  ? DateFormat('yyyy年M月').format(_focusedMonth)
                  : '${DateFormat('M月d日').format(_focusedWeek)} - ${DateFormat('M月d日').format(_focusedWeek.add(const Duration(days: 6)))}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              setState(() {
                if (isMonthView) {
                  _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month + 1,
                    1,
                  );
                } else {
                  _focusedWeek = _focusedWeek.add(const Duration(days: 7));
                }
              });
            },
          ),
        ],
      ),
    );
  }

  /// 星期标题
  Widget _buildWeekdayHeader(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withOpacity(0.15),
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: ['日', '一', '二', '三', '四', '五', '六'].asMap().entries.map((
          entry,
        ) {
          final isWeekend = entry.key == 0 || entry.key == 6;
          return Expanded(
            child: Center(
              child: Text(
                entry.value,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isWeekend
                      ? theme.colorScheme.primary.withOpacity(0.7)
                      : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final tasksAsync = ref.watch(allTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          // 视图模式切换
          PopupMenuButton<CalendarViewMode>(
            icon: Icon(_getViewIcon()),
            tooltip: '切换视图',
            onSelected: (mode) {
              setState(() {
                _viewMode = mode;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: CalendarViewMode.day,
                child: Row(
                  children: [
                    Icon(Icons.today),
                    SizedBox(width: 12),
                    Text('今天'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: CalendarViewMode.week,
                child: Row(
                  children: [
                    Icon(Icons.view_week),
                    SizedBox(width: 12),
                    Text('周视图'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: CalendarViewMode.month,
                child: Row(
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(width: 12),
                    Text('月视图'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          // 按日期分组任务
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

          return _buildViewContent(theme, tasksByDate);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateMenu(context),
        icon: const Icon(Icons.add),
        label: const Text('新建'),
      ),
    );
  }

  /// 显示创建选项菜单
  void _showCreateMenu(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}

/// 周视图网格
class _WeekGrid extends StatelessWidget {
  const _WeekGrid({
    required this.focusedWeek,
    required this.selectedDate,
    required this.tasksByDate,
    required this.onDateSelected,
  });

  final DateTime focusedWeek;
  final DateTime selectedDate;
  final Map<DateTime, List<Task>> tasksByDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: 7, // 显示一周7天
      itemBuilder: (context, index) {
        final date = focusedWeek.add(Duration(days: index));
        final isSelected = date == selectedDate;
        final isToday =
            date ==
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );
        final tasksForDate = tasksByDate[date] ?? [];
        final hasTask = tasksForDate.isNotEmpty;

        // 获取农历信息
        final festivalOrTerm = LunarUtils.getFestivalOrTerm(date);
        final lunarDay = festivalOrTerm ?? LunarUtils.getSimpleLunarDay(date);

        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: Container(
            decoration: BoxDecoration(
              color: isToday
                  ? theme.colorScheme.primary
                  : isSelected
                  ? theme.colorScheme.primaryContainer
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 日期数字
                Text(
                  '${date.day}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isToday
                        ? Colors.white
                        : isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface,
                    fontWeight: isToday || isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
                // 农历/节日
                Text(
                  lunarDay,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: festivalOrTerm != null
                        ? (isToday ? Colors.white : theme.colorScheme.error)
                        : (isToday
                            ? Colors.white.withOpacity(0.8)
                            : isSelected
                            ? theme.colorScheme.onPrimaryContainer.withOpacity(0.7)
                            : theme.colorScheme.onSurfaceVariant.withOpacity(0.6)),
                    fontSize: 9,
                    fontWeight: festivalOrTerm != null ? FontWeight.w600 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // 任务指示器 - 小圆点（系统设置风格）
                const SizedBox(height: 1),
                if (hasTask)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      tasksForDate.length > 3 ? 3 : tasksForDate.length,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0.5),
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: isToday
                              ? Colors.white.withOpacity(0.8)
                              : theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 3),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 月视图网格
class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.focusedMonth,
    required this.selectedDate,
    required this.tasksByDate,
    required this.onDateSelected,
    required this.getDaysInMonth,
    required this.getMonthStartWeekday,
  });

  final DateTime focusedMonth;
  final DateTime selectedDate;
  final Map<DateTime, List<Task>> tasksByDate;
  final ValueChanged<DateTime> onDateSelected;
  final int Function(DateTime) getDaysInMonth;
  final int Function(DateTime) getMonthStartWeekday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final daysInMonth = getDaysInMonth(focusedMonth);
    final startWeekday = getMonthStartWeekday(focusedMonth);
    final totalCells = ((daysInMonth + startWeekday) / 7).ceil() * 7;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - startWeekday + 1;

        // 如果是月份之外的空格，返回空容器
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(focusedMonth.year, focusedMonth.month, dayNumber);
        final isSelected = date == selectedDate;
        final today = DateTime.now();
        final isToday = date == DateTime(today.year, today.month, today.day);
        final tasksForDate = tasksByDate[date] ?? [];
        final hasTask = tasksForDate.isNotEmpty;

        // 获取农历信息
        final festivalOrTerm = LunarUtils.getFestivalOrTerm(date);
        final lunarDay = festivalOrTerm ?? LunarUtils.getSimpleLunarDay(date);

        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: Container(
            decoration: BoxDecoration(
              color: isToday
                  ? theme.colorScheme.primary
                  : isSelected
                  ? theme.colorScheme.primaryContainer
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 日期数字
                Text(
                  '$dayNumber',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isToday
                        ? Colors.white
                        : isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface,
                    fontWeight: isToday || isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                // 农历/节日
                Text(
                  lunarDay,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: festivalOrTerm != null
                        ? (isToday ? Colors.white : theme.colorScheme.error)
                        : (isToday
                            ? Colors.white.withOpacity(0.8)
                            : isSelected
                            ? theme.colorScheme.onPrimaryContainer.withOpacity(0.7)
                            : theme.colorScheme.onSurfaceVariant.withOpacity(0.6)),
                    fontSize: 9,
                    fontWeight: festivalOrTerm != null ? FontWeight.w600 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // 任务指示器 - 小圆点（系统设置风格）
                const SizedBox(height: 1),
                if (hasTask)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      tasksForDate.length > 3 ? 3 : tasksForDate.length,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0.5),
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: isToday
                              ? Colors.white.withOpacity(0.8)
                              : theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 3),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 选中日期的任务列表
class _DayTasksList extends ConsumerWidget {
  const _DayTasksList({required this.selectedDate, required this.tasks});

  final DateTime selectedDate;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isToday =
        selectedDate ==
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    // 获取农历信息
    final lunarInfo = LunarUtils.getLunarInfo(selectedDate);
    final festivalOrTerm = LunarUtils.getFestivalOrTerm(selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('M月d日 EEEE', 'zh_CN').format(selectedDate),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            lunarInfo.shortDate,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                          if (festivalOrTerm != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                festivalOrTerm,
                                style: TextStyle(
                                  color: theme.colorScheme.onErrorContainer,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  if (isToday)
                    Chip(
                      label: const Text('今天'),
                      backgroundColor: theme.colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontSize: 12,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  const Spacer(),
                  Text(
                    '${tasks.length} 个任务',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surface,
            strokeWidth: 3.0,
            displacement: 50.0,
            onRefresh: () async {
              // 刷新任务数据
              await Future.delayed(const Duration(milliseconds: 500));
              // TODO: 这里可以触发任务重新加载
            },
            child: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '这天没有安排任务',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                  itemCount: tasks.length,
                  onReorder: (oldIndex, newIndex) {
                    // 处理拖拽排序
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    // 这里可以调用service更新任务顺序
                    // 暂时只是视觉效果，需要后端支持
                  },
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return _TaskListTile(
                      key: ValueKey(task.id),
                      task: task,
                    );
                  },
                ),
          ),
        ),
      ],
    );
  }
}

/// 任务列表项 - 系统日历风格
class _TaskListTile extends ConsumerWidget {
  const _TaskListTile({
    required this.task,
    super.key,
  });

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            TaskComposerSheet.show(context, task: task);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 复选框
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) async {
                      if (value == null) return;
                      final service = ref.read(taskServiceProvider);
                      await service.toggleCompletion(task, isCompleted: value);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 任务内容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (task.notes != null && task.notes!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            task.notes!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (task.dueAt != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('HH:mm').format(task.dueAt!),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // 优先级指示器
                if (task.priority != TaskPriority.none)
                  _PriorityIndicator(priority: task.priority),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 优先级指示器
class _PriorityIndicator extends StatelessWidget {
  const _PriorityIndicator({required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (priority == TaskPriority.none) {
      return const SizedBox.shrink();
    }

    final (icon, color) = switch (priority) {
      TaskPriority.critical => (Icons.priority_high, Colors.red),
      TaskPriority.high => (Icons.arrow_upward, Colors.orange),
      TaskPriority.medium => (Icons.drag_handle, Colors.blue),
      TaskPriority.low => (Icons.arrow_downward, Colors.grey),
      TaskPriority.none => (Icons.remove, Colors.grey),
    };

    return Icon(icon, color: color, size: 20);
  }
}
