import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../infrastructure/hive/type_ids.dart';

part 'focus_session.freezed.dart';
part 'focus_session.g.dart';

/// Interruption reason during focus session
@HiveType(typeId: HiveTypeIds.interruption, adapterName: 'InterruptionAdapter')
@freezed
class Interruption with _$Interruption {
  const factory Interruption({
    @HiveField(0) required DateTime timestamp,
    @HiveField(1) required String reason,
    @HiveField(2) int? resumedAfterSeconds,
  }) = _Interruption;

  const Interruption._();

  factory Interruption.fromJson(Map<String, dynamic> json) =>
      _$InterruptionFromJson(json);
}

@HiveType(typeId: HiveTypeIds.focusSession, adapterName: 'FocusSessionAdapter')
@freezed
class FocusSession with _$FocusSession {
  const factory FocusSession({
    @HiveField(0) required String id,
    @HiveField(2) required int durationMinutes, @HiveField(3) required DateTime startedAt, @HiveField(1) String? taskId,
    @HiveField(4) DateTime? completedAt,
    @HiveField(5) @Default(false) bool isCompleted,
    @HiveField(6) @Default(false) bool wasCancelled,
    @HiveField(7) String? notes,
    @HiveField(8)
    @JsonKey(fromJson: _interruptionsFromJson, toJson: _interruptionsToJson)
    @Default(<Interruption>[]) List<Interruption> interruptions,
    @HiveField(9) int? pausedSeconds,
  }) = _FocusSession;

  const FocusSession._();

  factory FocusSession.fromJson(Map<String, dynamic> json) =>
      _$FocusSessionFromJson(json);

  int get actualDurationSeconds {
    if (completedAt == null) return 0;
    return completedAt!.difference(startedAt).inSeconds;
  }

  /// Total time spent in focus (excluding pauses)
  int get effectiveFocusSeconds {
    final total = actualDurationSeconds;
    final paused = pausedSeconds ?? 0;
    return total - paused;
  }

  /// Focus quality score (0-100)
  /// Based on: completion, interruptions, pause time
  int get qualityScore {
    if (!isCompleted && !wasCancelled) return 0;

    var score = 100;

    // Penalty for cancellation
    if (wasCancelled) score -= 50;

    // Penalty for interruptions (5 points each, max 30)
    final interruptionPenalty = (interruptions.length * 5).clamp(0, 30);
    score -= interruptionPenalty;

    // Penalty for excessive pause time (over 10% of session)
    final expectedSeconds = durationMinutes * 60;
    final pauseRatio = (pausedSeconds ?? 0) / expectedSeconds;
    if (pauseRatio > 0.1) {
      score -= ((pauseRatio - 0.1) * 100).round().clamp(0, 20);
    }

    return score.clamp(0, 100);
  }

  /// Hour of day when session started (0-23)
  int get hourOfDay => startedAt.hour;
}

List<Interruption> _interruptionsFromJson(List<dynamic>? json) {
  if (json == null) return [];
  return json.map((e) => Interruption.fromJson(e as Map<String, dynamic>)).toList();
}

List<Map<String, dynamic>> _interruptionsToJson(List<Interruption> interruptions) {
  return interruptions.map((e) => e.toJson()).toList();
}

enum FocusDuration {
  short(5),
  standard(25),
  long(45);

  const FocusDuration(this.minutes);
  final int minutes;
}
