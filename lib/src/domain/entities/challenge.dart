import 'package:freezed_annotation/freezed_annotation.dart';
import '../../infrastructure/hive/type_ids.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'challenge.freezed.dart';
part 'challenge.g.dart';

/// 挑战任务
/// Hive TypeId: 44 (使用FreezedHiveAdapter存储)
@freezed
class Challenge with _$Challenge {
  const factory Challenge({
    required String id,
    required String title,
    required String description,
    required ChallengeType type,
    required ChallengePeriod period, // 周期（每日/每周）
    required int targetValue, // 目标值
    required int pointsReward, // 积分奖励
    required DateTime startDate, // 开始日期
    required DateTime endDate, // 结束日期
    required DateTime createdAt,
    @Default(0) int currentValue, // 当前进度
    @Default(false) bool isCompleted, // 是否完成
    DateTime? completedAt, // 完成时间
  }) = _Challenge;

  const Challenge._();

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);

  /// 是否进行中
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate) && !isCompleted;
  }

  /// 是否已过期
  bool get isExpired => DateTime.now().isAfter(endDate) && !isCompleted;

  /// 进度百分比
  double get progress => targetValue > 0 ? currentValue / targetValue : 0.0;

  /// 进度文本
  String get progressText => '$currentValue / $targetValue';

  /// 剩余时间（天）
  int get daysRemaining {
    if (isExpired || isCompleted) return 0;
    final now = DateTime.now();
    return endDate.difference(now).inDays + 1;
  }

  /// 周期名称
  String get periodName {
    switch (period) {
      case ChallengePeriod.daily:
        return '每日';
      case ChallengePeriod.weekly:
        return '每周';
    }
  }
}

/// 挑战类型
@HiveType(typeId: HiveTypeIds.challengeType, adapterName: 'ChallengeTypeAdapter')
@JsonEnum()
enum ChallengeType {
  @HiveField(0)
  completeTasks, // 完成任务
  @HiveField(1)
  focusTime, // 专注时长
  @HiveField(2)
  completeAllDailyTasks, // 完成所有每日任务
  @HiveField(3)
  addIdeas, // 添加灵感
  @HiveField(4)
  maintainStreak, // 保持连续打卡
}

/// 挑战周期
@HiveType(typeId: HiveTypeIds.challengePeriod, adapterName: 'ChallengePeriodAdapter')
@JsonEnum()
enum ChallengePeriod {
  @HiveField(0)
  daily, // 每日
  @HiveField(1)
  weekly, // 每周
}
