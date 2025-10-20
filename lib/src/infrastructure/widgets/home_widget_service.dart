import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';

class HomeWidgetService {

  HomeWidgetService([this._taskRepository]);
  static const String _widgetName = 'TodoListWidget';
  static const String _keyTasks = 'widget_tasks';
  static const String _keyTaskCount = 'widget_task_count';
  static const String _keyLastUpdate = 'widget_last_update';
  static const String _pendingActionsKey = 'widget_pending_actions';

  final TaskRepository? _taskRepository;

  /// 初始化小组件
  Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId('group.todolist');
      await _setupInteractivity();
    } catch (e) {
      debugPrint('Failed to initialize home widget: $e');
    }
  }

  /// 设置交互性（处理小组件点击）
  Future<void> _setupInteractivity() async {
    await HomeWidget.registerInteractivityCallback(
      _handleWidgetInteraction,
    );
  }

  /// 处理小组件交互
  @pragma('vm:entry-point')
  static Future<void> _handleWidgetInteraction(Uri? uri) async {
    if (uri == null) return;

    final action = uri.host;
    debugPrint('Widget interaction: $action - $uri');

    // 保存待处理的操作，等待应用启动后处理
    final prefs = await SharedPreferences.getInstance();
    final actions = prefs.getStringList(_pendingActionsKey) ?? [];

    switch (action) {
      case 'open_app':
        // 打开应用主界面
        actions.add(jsonEncode({'action': 'open_app'}));
      case 'add_task':
        // 打开添加任务界面
        actions.add(jsonEncode({'action': 'add_task'}));
      case 'complete_task':
        // 完成任务
        final taskId = uri.queryParameters['id'];
        if (taskId != null) {
          actions.add(jsonEncode({
            'action': 'complete_task',
            'task_id': taskId,
          }));
        }
      case 'refresh':
        // 刷新小组件
        actions.add(jsonEncode({'action': 'refresh'}));
    }

    await prefs.setStringList(_pendingActionsKey, actions);
  }

  /// 处理待处理的操作
  Future<List<Map<String, dynamic>>> getPendingActions() async {
    final prefs = await SharedPreferences.getInstance();
    final actions = prefs.getStringList(_pendingActionsKey) ?? [];
    await prefs.remove(_pendingActionsKey);

    return actions
        .map((a) => jsonDecode(a) as Map<String, dynamic>)
        .toList();
  }

  /// 执行完成任务操作
  Future<void> completeTask(String taskId) async {
    if (_taskRepository == null) return;

    try {
      final task = await _taskRepository.getById(taskId);
      if (task != null) {
        final updatedTask = task.copyWith(
          status: TaskStatus.completed,
          completedAt: DateTime.now(),
        );
        await _taskRepository.update(updatedTask);
      }
    } catch (e) {
      debugPrint('Failed to complete task from widget: $e');
    }
  }

  /// 更新小组件数据
  Future<void> updateWidget({
    required List<Task> todayTasks,
  }) async {
    try {
      // 只显示未完成的任务
      final incompleteTasks = todayTasks
          .where((task) => task.status != TaskStatus.completed)
          .take(5) // 最多显示5个任务
          .toList();

      // 转换任务数据为 JSON
      final tasksJson = incompleteTasks.map((task) {
        return {
          'id': task.id,
          'title': task.title,
          'priority': task.priority.name,
          'dueTime': task.dueDate?.toIso8601String(),
        };
      }).toList();

      // 保存数据到小组件
      await HomeWidget.saveWidgetData<String>(
        _keyTasks,
        jsonEncode(tasksJson),
      );
      await HomeWidget.saveWidgetData<int>(
        _keyTaskCount,
        incompleteTasks.length,
      );
      await HomeWidget.saveWidgetData<String>(
        _keyLastUpdate,
        DateTime.now().toIso8601String(),
      );

      // 更新小组件UI
      await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: _widgetName,
        iOSName: _widgetName,
      );
    } catch (e) {
      debugPrint('Failed to update widget: $e');
    }
  }

  /// 清除小组件数据
  Future<void> clearWidget() async {
    try {
      await HomeWidget.saveWidgetData<String>(_keyTasks, '[]');
      await HomeWidget.saveWidgetData<int>(_keyTaskCount, 0);
      await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: _widgetName,
        iOSName: _widgetName,
      );
    } catch (e) {
      debugPrint('Failed to clear widget: $e');
    }
  }

  /// 检查是否支持小组件
  Future<bool> isWidgetSupported() async {
    try {
      // home_widget 在 Android 和 iOS 上都支持
      return true;
    } catch (e) {
      return false;
    }
  }
}
