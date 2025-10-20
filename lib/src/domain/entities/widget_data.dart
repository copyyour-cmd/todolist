import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_data.freezed.dart';
part 'widget_data.g.dart';

/// 小组件类型
enum WidgetType {
  todayTasks, // 今日任务
  focusStats, // 专注统计
  quickIdea, // 快速灵感
}

/// 小组件数据
@freezed
class WidgetData with _$WidgetData {
  const factory WidgetData({
    required WidgetType type,
    required String widgetId,
    required Map<String, dynamic> data,
    required DateTime lastUpdated,
  }) = _WidgetData;

  factory WidgetData.fromJson(Map<String, dynamic> json) =>
      _$WidgetDataFromJson(json);
}

/// 今日任务小组件数据
@freezed
class TodayTasksWidgetData with _$TodayTasksWidgetData {
  const factory TodayTasksWidgetData({
    required int totalTasks,
    required int completedTasks,
    required List<TaskWidgetItem> tasks,
  }) = _TodayTasksWidgetData;

  const TodayTasksWidgetData._();

  factory TodayTasksWidgetData.fromJson(Map<String, dynamic> json) =>
      _$TodayTasksWidgetDataFromJson(json);

  int get pendingTasks => totalTasks - completedTasks;
  double get completionRate =>
      totalTasks > 0 ? completedTasks / totalTasks : 0.0;
}

/// 任务小组件项目
@freezed
class TaskWidgetItem with _$TaskWidgetItem {
  const factory TaskWidgetItem({
    required String id,
    required String title,
    required bool isCompleted,
    String? priority,
    DateTime? dueAt,
  }) = _TaskWidgetItem;

  factory TaskWidgetItem.fromJson(Map<String, dynamic> json) =>
      _$TaskWidgetItemFromJson(json);
}

/// 专注统计小组件数据
@freezed
class FocusStatsWidgetData with _$FocusStatsWidgetData {
  const factory FocusStatsWidgetData({
    required int todayMinutes,
    required int todaySessions,
    required int weekMinutes,
    required int totalMinutes,
    required int currentStreak,
  }) = _FocusStatsWidgetData;

  const FocusStatsWidgetData._();

  factory FocusStatsWidgetData.fromJson(Map<String, dynamic> json) =>
      _$FocusStatsWidgetDataFromJson(json);

  String get todayHours => '${todayMinutes ~/ 60}h ${todayMinutes % 60}m';
  String get weekHours => '${weekMinutes ~/ 60}h ${weekMinutes % 60}m';
}

/// 快速灵感小组件数据
@freezed
class QuickIdeaWidgetData with _$QuickIdeaWidgetData {
  const factory QuickIdeaWidgetData({
    required int totalIdeas,
    required int todayIdeas,
    required List<String> recentIdeas,
  }) = _QuickIdeaWidgetData;

  factory QuickIdeaWidgetData.fromJson(Map<String, dynamic> json) =>
      _$QuickIdeaWidgetDataFromJson(json);
}
