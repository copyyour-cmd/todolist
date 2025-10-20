// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WidgetDataImpl _$$WidgetDataImplFromJson(Map<String, dynamic> json) =>
    _$WidgetDataImpl(
      type: $enumDecode(_$WidgetTypeEnumMap, json['type']),
      widgetId: json['widgetId'] as String,
      data: json['data'] as Map<String, dynamic>,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$WidgetDataImplToJson(_$WidgetDataImpl instance) =>
    <String, dynamic>{
      'type': _$WidgetTypeEnumMap[instance.type]!,
      'widgetId': instance.widgetId,
      'data': instance.data,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

const _$WidgetTypeEnumMap = {
  WidgetType.todayTasks: 'todayTasks',
  WidgetType.focusStats: 'focusStats',
  WidgetType.quickIdea: 'quickIdea',
};

_$TodayTasksWidgetDataImpl _$$TodayTasksWidgetDataImplFromJson(
        Map<String, dynamic> json) =>
    _$TodayTasksWidgetDataImpl(
      totalTasks: (json['totalTasks'] as num).toInt(),
      completedTasks: (json['completedTasks'] as num).toInt(),
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => TaskWidgetItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TodayTasksWidgetDataImplToJson(
        _$TodayTasksWidgetDataImpl instance) =>
    <String, dynamic>{
      'totalTasks': instance.totalTasks,
      'completedTasks': instance.completedTasks,
      'tasks': instance.tasks,
    };

_$TaskWidgetItemImpl _$$TaskWidgetItemImplFromJson(Map<String, dynamic> json) =>
    _$TaskWidgetItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      priority: json['priority'] as String?,
      dueAt: json['dueAt'] == null
          ? null
          : DateTime.parse(json['dueAt'] as String),
    );

Map<String, dynamic> _$$TaskWidgetItemImplToJson(
        _$TaskWidgetItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
      'priority': instance.priority,
      'dueAt': instance.dueAt?.toIso8601String(),
    };

_$FocusStatsWidgetDataImpl _$$FocusStatsWidgetDataImplFromJson(
        Map<String, dynamic> json) =>
    _$FocusStatsWidgetDataImpl(
      todayMinutes: (json['todayMinutes'] as num).toInt(),
      todaySessions: (json['todaySessions'] as num).toInt(),
      weekMinutes: (json['weekMinutes'] as num).toInt(),
      totalMinutes: (json['totalMinutes'] as num).toInt(),
      currentStreak: (json['currentStreak'] as num).toInt(),
    );

Map<String, dynamic> _$$FocusStatsWidgetDataImplToJson(
        _$FocusStatsWidgetDataImpl instance) =>
    <String, dynamic>{
      'todayMinutes': instance.todayMinutes,
      'todaySessions': instance.todaySessions,
      'weekMinutes': instance.weekMinutes,
      'totalMinutes': instance.totalMinutes,
      'currentStreak': instance.currentStreak,
    };

_$QuickIdeaWidgetDataImpl _$$QuickIdeaWidgetDataImplFromJson(
        Map<String, dynamic> json) =>
    _$QuickIdeaWidgetDataImpl(
      totalIdeas: (json['totalIdeas'] as num).toInt(),
      todayIdeas: (json['todayIdeas'] as num).toInt(),
      recentIdeas: (json['recentIdeas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$QuickIdeaWidgetDataImplToJson(
        _$QuickIdeaWidgetDataImpl instance) =>
    <String, dynamic>{
      'totalIdeas': instance.totalIdeas,
      'todayIdeas': instance.todayIdeas,
      'recentIdeas': instance.recentIdeas,
    };
