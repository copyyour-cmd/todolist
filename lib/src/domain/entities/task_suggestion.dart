import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todolist/src/domain/entities/task.dart';

part 'task_suggestion.freezed.dart';
part 'task_suggestion.g.dart';

/// 智能任务建议
@freezed
class TaskSuggestion with _$TaskSuggestion {
  const factory TaskSuggestion({
    required Task task,
    required double priorityScore,
    required SuggestedTimeSlot? bestTimeSlot,
    required int predictedMinutes,
    required double completionProbability,
    required List<String> reasons,
  }) = _TaskSuggestion;

  const TaskSuggestion._();

  factory TaskSuggestion.fromJson(Map<String, dynamic> json) =>
      _$TaskSuggestionFromJson(json);
}

/// 推荐的时间段
@freezed
class SuggestedTimeSlot with _$SuggestedTimeSlot {
  const factory SuggestedTimeSlot({
    required int hourOfDay,
    required String timeLabel,
    required double successRate,
  }) = _SuggestedTimeSlot;

  const SuggestedTimeSlot._();

  factory SuggestedTimeSlot.fromJson(Map<String, dynamic> json) =>
      _$SuggestedTimeSlotFromJson(json);

  /// 时间段描述
  String get description {
    if (hourOfDay >= 6 && hourOfDay < 9) return '早晨 (6-9点)';
    if (hourOfDay >= 9 && hourOfDay < 12) return '上午 (9-12点)';
    if (hourOfDay >= 12 && hourOfDay < 14) return '中午 (12-14点)';
    if (hourOfDay >= 14 && hourOfDay < 18) return '下午 (14-18点)';
    if (hourOfDay >= 18 && hourOfDay < 22) return '晚上 (18-22点)';
    return '深夜 (22-6点)';
  }
}

/// 任务完成模式分析
class TaskCompletionPattern {
  TaskCompletionPattern({
    required this.averageCompletionHour,
    required this.mostProductiveHours,
    required this.averageDuration,
    required this.completionRate,
    required this.sampleSize,
  });

  final double averageCompletionHour;
  final List<int> mostProductiveHours;
  final double averageDuration;
  final double completionRate;
  final int sampleSize;
}
