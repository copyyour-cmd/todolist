import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';
part 'user_stats.g.dart';

/// 用户统计数据
// 注意: 使用 JSON adapter (在 hive_initializer.dart 中注册为 typeId: 40)
// 不使用 @HiveType 避免与 Freezed 冲突
@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int totalPoints, // 总积分
    @Default(0) int currentStreak, // 当前连续打卡天数
    @Default(0) int longestStreak, // 最长连续打卡天数
    DateTime? lastCheckInDate, // 最后打卡日期
    @Default(0) int totalTasksCompleted, // 总完成任务数
    @Default(0) int totalFocusMinutes, // 总专注时长(分钟)
    @Default(<String>[]) List<String> unlockedBadgeIds, // 已解锁徽章ID
    @Default(<String>[]) List<String> unlockedAchievementIds, // 已解锁成就ID
    @Default(0) int totalCheckIns, // 总签到天数
    @Default(0) int makeupCardsCount, // 补签卡数量
    DateTime? lastManualCheckInDate, // 最后手动签到日期
    @Default(0) int totalDraws, // 总抽奖次数
    @Default(0) int freeDrawsUsedToday, // 今日已用免费次数
    DateTime? lastFreeDrawDate, // 最后免费抽奖日期
    @Default(0) int drawPityCounter, // 抽奖保底计数器
    String? equippedTitleId, // 当前佩戴的称号ID
    @Default(<String>[]) List<String> unlockedTitleIds, // 已解锁称号ID
  }) = _UserStats;

  const UserStats._();

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);

  /// 获取等级（基于积分）
  int get level {
    if (totalPoints < 100) return 1;
    if (totalPoints < 300) return 2;
    if (totalPoints < 600) return 3;
    if (totalPoints < 1000) return 4;
    if (totalPoints < 1500) return 5;
    if (totalPoints < 2100) return 6;
    if (totalPoints < 2800) return 7;
    if (totalPoints < 3600) return 8;
    if (totalPoints < 4500) return 9;
    if (totalPoints < 5500) return 10;
    return 10 + (totalPoints - 5500) ~/ 1000;
  }

  /// 当前等级所需积分
  int get currentLevelPoints {
    if (level == 1) return 0;
    if (level == 2) return 100;
    if (level == 3) return 300;
    if (level == 4) return 600;
    if (level == 5) return 1000;
    if (level == 6) return 1500;
    if (level == 7) return 2100;
    if (level == 8) return 2800;
    if (level == 9) return 3600;
    if (level == 10) return 4500;
    return 5500 + (level - 10) * 1000;
  }

  /// 下一等级所需积分
  int get nextLevelPoints {
    if (level == 1) return 100;
    if (level == 2) return 300;
    if (level == 3) return 600;
    if (level == 4) return 1000;
    if (level == 5) return 1500;
    if (level == 6) return 2100;
    if (level == 7) return 2800;
    if (level == 8) return 3600;
    if (level == 9) return 4500;
    if (level == 10) return 5500;
    return 5500 + (level - 9) * 1000;
  }

  /// 距离下一等级的进度 (0.0 - 1.0)
  double get levelProgress {
    final current = totalPoints - currentLevelPoints;
    final total = nextLevelPoints - currentLevelPoints;
    return total > 0 ? current / total : 1.0;
  }
}
