import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/widget_config.dart';

/// Service for managing home screen widgets
class WidgetService {
  WidgetService({
    required Clock clock,
  }) : _clock = clock;

  final Clock _clock;

  static const String _widgetGroupId = 'group.todolist.widget';
  static const String _todayTasksKey = 'today_tasks';
  static const String _taskCountKey = 'task_count';
  static const String _completedCountKey = 'completed_count';
  static const String _lastUpdateKey = 'last_update';
  static const String _widgetConfigKey = 'widget_config';

  /// Update widget data with today's tasks
  Future<void> updateTodayTasks(
    List<Task> allTasks, {
    WidgetConfig? config,
  }) async {
    try {
      final widgetConfig = config ?? const WidgetConfig();
      final now = _clock.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      // Filter today's tasks (due today or overdue)
      final todayTasks = allTasks.where((task) {
        if (task.isCompleted && !widgetConfig.showCompleted) return false;
        if (task.dueAt == null) return false;
        if (!widgetConfig.showOverdue && task.dueAt!.isBefore(now)) {
          return false;
        }
        return task.dueAt!.isBefore(tomorrow);
      }).toList();

      // Sort by priority and due time
      todayTasks.sort((a, b) {
        // First by priority
        final priorityCompare = b.priority.index.compareTo(a.priority.index);
        if (priorityCompare != 0) return priorityCompare;

        // Then by due time
        if (a.dueAt == null && b.dueAt == null) return 0;
        if (a.dueAt == null) return 1;
        if (b.dueAt == null) return -1;
        return a.dueAt!.compareTo(b.dueAt!);
      });

      // Take top N tasks based on config
      final topTasks = todayTasks.take(widgetConfig.maxTasks).toList();

      // Convert to JSON
      final tasksData = topTasks.map((task) => {
        'id': task.id,
        'title': task.title,
        'priority': task.priority.name,
        'dueAt': task.dueAt?.toIso8601String(),
        'isOverdue': task.dueAt != null && task.dueAt!.isBefore(now),
      }).toList();

      final completedToday = allTasks.where((task) {
        if (!task.isCompleted || task.completedAt == null) return false;
        final completedDate = task.completedAt!;
        return completedDate.year == now.year &&
            completedDate.month == now.month &&
            completedDate.day == now.day;
      }).length;

      // Save to widget data
      await HomeWidget.saveWidgetData<String>(
        _todayTasksKey,
        jsonEncode(tasksData),
      );
      await HomeWidget.saveWidgetData<int>(
        _taskCountKey,
        todayTasks.length,
      );
      await HomeWidget.saveWidgetData<int>(
        _completedCountKey,
        completedToday,
      );
      await HomeWidget.saveWidgetData<String>(
        _lastUpdateKey,
        now.toIso8601String(),
      );

      // Save widget config
      await HomeWidget.saveWidgetData<String>(
        _widgetConfigKey,
        jsonEncode(widgetConfig.toJson()),
      );

      // Update widgets based on size
      final widgetName = switch (widgetConfig.size) {
        WidgetSize.small => 'TodayTasksWidgetSmall',
        WidgetSize.medium => 'TodayTasksWidgetMedium',
        WidgetSize.large => 'TodayTasksWidgetLarge',
      };

      // Update widgets
      await HomeWidget.updateWidget(
        androidName: widgetName,
        iOSName: 'TodayTasksWidget',
      );
    } catch (e) {
      print('Error updating widget: $e');
    }
  }

  /// Handle widget tap to open task
  static Future<void> handleWidgetTap(Uri? uri) async {
    if (uri == null) return;

    final taskId = uri.queryParameters['taskId'];
    if (taskId != null) {
      // Navigate to task detail
      // This will be handled by the app's deep link handler
      print('Opening task: $taskId');
    }
  }

  /// Initialize widget callbacks
  static Future<void> initializeCallbacks() async {
    HomeWidget.setAppGroupId(_widgetGroupId);

    // Set up background callback for widget interactions
    HomeWidget.registerInteractivityCallback(
      (Uri? uri) async {
        await handleWidgetTap(uri);
      },
    );
  }

  /// Quick add task from widget
  Future<void> quickAddTask(String title) async {
    // This will be implemented to add a task quickly from widget
    await HomeWidget.saveWidgetData<String>('quick_add_task', title);
  }

  /// Update countdown widget with next deadline
  Future<void> updateCountdownWidget(List<Task> allTasks) async {
    try {
      final now = _clock.now();

      // Find next upcoming task with deadline
      final upcomingTasks = allTasks
          .where((task) => !task.isCompleted && task.dueAt != null)
          .toList()
        ..sort((a, b) => a.dueAt!.compareTo(b.dueAt!));

      if (upcomingTasks.isEmpty) {
        await HomeWidget.saveWidgetData<String>('countdown_task_id', '');
        await HomeWidget.saveWidgetData<String>('countdown_task_title', '暂无任务');
        await HomeWidget.saveWidgetData<int>('countdown_seconds', 0);
      } else {
        final nextTask = upcomingTasks.first;
        final secondsUntilDue = nextTask.dueAt!.difference(now).inSeconds;

        await HomeWidget.saveWidgetData<String>(
          'countdown_task_id',
          nextTask.id,
        );
        await HomeWidget.saveWidgetData<String>(
          'countdown_task_title',
          nextTask.title,
        );
        await HomeWidget.saveWidgetData<int>(
          'countdown_seconds',
          secondsUntilDue > 0 ? secondsUntilDue : 0,
        );
        await HomeWidget.saveWidgetData<String>(
          'countdown_priority',
          nextTask.priority.name,
        );
      }

      // Update countdown widget
      await HomeWidget.updateWidget(
        androidName: 'CountdownWidgetProvider',
        iOSName: 'CountdownWidget',
      );
    } catch (e) {
      print('Error updating countdown widget: $e');
    }
  }

  /// Handle quick action from widget
  static Future<void> handleQuickAction(String action, String? taskId) async {
    await HomeWidget.saveWidgetData<String>('quick_action', action);
    if (taskId != null) {
      await HomeWidget.saveWidgetData<String>('quick_action_task_id', taskId);
    }
  }
}
