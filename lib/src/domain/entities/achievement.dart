import 'package:freezed_annotation/freezed_annotation.dart';
import '../../infrastructure/hive/type_ids.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

/// 成就
// 注意: 使用 JSON adapter (在 hive_initializer.dart 中注册为 typeId: 42)
// 不使用 @HiveType 避免与 Freezed 冲突
@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String id,
    required String name,
    required String description,
    required String icon,
    required AchievementType type,
    required int targetValue,
    required int pointsReward, // 积分奖励
    @Default(0) int currentValue, // 当前进度
    String? badgeReward, // 徽章奖励ID
    DateTime? unlockedAt, // 解锁时间
  }) = _Achievement;

  const Achievement._();

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);

  /// 是否已完成
  bool get isCompleted => currentValue >= targetValue;

  /// 是否已解锁
  bool get isUnlocked => unlockedAt != null;

  /// 进度百分比
  double get progress => targetValue > 0 ? currentValue / targetValue : 0.0;

  /// 进度文本
  String get progressText => '$currentValue / $targetValue';
}

/// 成就类型
@HiveType(typeId: HiveTypeIds.achievementType, adapterName: 'AchievementTypeAdapter')
@JsonEnum()
enum AchievementType {
  @HiveField(0)
  tasksCompleted, // 完成任务总数
  @HiveField(1)
  focusMinutes, // 专注时长
  @HiveField(2)
  streak, // 连续打卡天数
  @HiveField(3)
  dailyGoals, // 每日目标达成次数
  @HiveField(4)
  ideas, // 灵感收集数
  @HiveField(5)
  special, // 特殊成就
}
