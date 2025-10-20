// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskSuggestionImpl _$$TaskSuggestionImplFromJson(Map<String, dynamic> json) =>
    _$TaskSuggestionImpl(
      task: Task.fromJson(json['task'] as Map<String, dynamic>),
      priorityScore: (json['priorityScore'] as num).toDouble(),
      bestTimeSlot: json['bestTimeSlot'] == null
          ? null
          : SuggestedTimeSlot.fromJson(
              json['bestTimeSlot'] as Map<String, dynamic>),
      predictedMinutes: (json['predictedMinutes'] as num).toInt(),
      completionProbability: (json['completionProbability'] as num).toDouble(),
      reasons:
          (json['reasons'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$TaskSuggestionImplToJson(
        _$TaskSuggestionImpl instance) =>
    <String, dynamic>{
      'task': instance.task,
      'priorityScore': instance.priorityScore,
      'bestTimeSlot': instance.bestTimeSlot,
      'predictedMinutes': instance.predictedMinutes,
      'completionProbability': instance.completionProbability,
      'reasons': instance.reasons,
    };

_$SuggestedTimeSlotImpl _$$SuggestedTimeSlotImplFromJson(
        Map<String, dynamic> json) =>
    _$SuggestedTimeSlotImpl(
      hourOfDay: (json['hourOfDay'] as num).toInt(),
      timeLabel: json['timeLabel'] as String,
      successRate: (json['successRate'] as num).toDouble(),
    );

Map<String, dynamic> _$$SuggestedTimeSlotImplToJson(
        _$SuggestedTimeSlotImpl instance) =>
    <String, dynamic>{
      'hourOfDay': instance.hourOfDay,
      'timeLabel': instance.timeLabel,
      'successRate': instance.successRate,
    };
