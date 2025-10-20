import 'dart:math' as math;
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/achievement.dart';
import 'package:todolist/src/domain/entities/badge.dart';
import 'package:todolist/src/domain/entities/challenge.dart';
import 'package:todolist/src/domain/entities/user_stats.dart';
import 'package:todolist/src/domain/entities/daily_checkin.dart';
import 'package:todolist/src/domain/entities/lucky_draw.dart';
import 'package:todolist/src/domain/entities/title.dart';
import 'package:todolist/src/domain/repositories/gamification_repository.dart';

/// 游戏化服务
class GamificationService {
  GamificationService({
    required GamificationRepository repository,
    required Clock clock,
    required IdGenerator idGenerator,
  })  : _repository = repository,
        _clock = clock,
        _idGenerator = idGenerator;

  final GamificationRepository _repository;
  final Clock _clock;
  final IdGenerator _idGenerator;

  // 积分规则
  static const int pointsPerTask = 10; // 完成任务
  static const int pointsPerFocusSession = 20; // 完成专注
  static const int pointsPerStreak = 5; // 每天连续打卡
  static const int pointsPerIdea = 3; // 添加灵感
  static const int pointsPerDailyCheckIn = 10; // 每日签到基础积分
  static const int makeupCardCost = 100; // 补签卡价格
  static const int luckyDrawCost = 50; // 抽奖价格
  static const int rarePityThreshold = 10; // 稀有保底（10抽必出稀有）
  static const int legendaryPityThreshold = 50; // 传说保底（50抽必出传说）

  /// 获取用户统计
  Future<UserStats> getUserStats() async {
    var stats = await _repository.getUserStats();
    if (stats == null) {
      // 创建初始统计
      stats = UserStats(
        id: 'user_stats',
        createdAt: _clock.now(),
        updatedAt: _clock.now(),
      );
      await _repository.saveUserStats(stats);
    }
    return stats;
  }

  /// 添加积分
  Future<UserStats> addPoints(int points, {String? reason}) async {
    final stats = await getUserStats();
    final updated = stats.copyWith(
      totalPoints: stats.totalPoints + points,
      updatedAt: _clock.now(),
    );
    await _repository.saveUserStats(updated);

    // 检查成就解锁
    await _checkAchievements(updated);

    return updated;
  }

  /// 完成任务时调用
  Future<UserStats> onTaskCompleted() async {
    final stats = await getUserStats();
    final updated = stats.copyWith(
      totalPoints: stats.totalPoints + pointsPerTask,
      totalTasksCompleted: stats.totalTasksCompleted + 1,
      updatedAt: _clock.now(),
    );
    await _repository.saveUserStats(updated);

    // 检查打卡
    await _checkDailyCheckIn(updated);

    // 更新挑战进度
    await _updateChallengeProgress(ChallengeType.completeTasks, 1);

    // 检查成就
    await _checkAchievements(updated);

    return updated;
  }

  /// 完成专注会话时调用
  Future<UserStats> onFocusSessionCompleted(int minutes) async {
    final stats = await getUserStats();
    final updated = stats.copyWith(
      totalPoints: stats.totalPoints + pointsPerFocusSession,
      totalFocusMinutes: stats.totalFocusMinutes + minutes,
      updatedAt: _clock.now(),
    );
    await _repository.saveUserStats(updated);

    // 更新挑战进度
    await _updateChallengeProgress(ChallengeType.focusTime, minutes);

    // 检查成就
    await _checkAchievements(updated);

    return updated;
  }

  /// 添加灵感时调用
  Future<UserStats> onIdeaAdded() async {
    final stats = await getUserStats();
    final updated = stats.copyWith(
      totalPoints: stats.totalPoints + pointsPerIdea,
      updatedAt: _clock.now(),
    );
    await _repository.saveUserStats(updated);

    // 更新挑战进度
    await _updateChallengeProgress(ChallengeType.addIdeas, 1);

    return updated;
  }

  /// 检查每日打卡
  Future<void> _checkDailyCheckIn(UserStats stats) async {
    final now = _clock.now();
    final today = DateTime(now.year, now.month, now.day);

    if (stats.lastCheckInDate == null) {
      // 首次打卡
      final updated = stats.copyWith(
        currentStreak: 1,
        longestStreak: 1,
        lastCheckInDate: today,
        totalPoints: stats.totalPoints + pointsPerStreak,
        updatedAt: now,
      );
      await _repository.saveUserStats(updated);
      return;
    }

    final lastCheckIn = DateTime(
      stats.lastCheckInDate!.year,
      stats.lastCheckInDate!.month,
      stats.lastCheckInDate!.day,
    );

    final daysDiff = today.difference(lastCheckIn).inDays;

    if (daysDiff == 0) {
      // 今天已打卡
      return;
    } else if (daysDiff == 1) {
      // 连续打卡
      final newStreak = stats.currentStreak + 1;
      final updated = stats.copyWith(
        currentStreak: newStreak,
        longestStreak: newStreak > stats.longestStreak ? newStreak : stats.longestStreak,
        lastCheckInDate: today,
        totalPoints: stats.totalPoints + pointsPerStreak,
        updatedAt: now,
      );
      await _repository.saveUserStats(updated);

      // 检查连续打卡成就
      await _checkStreakAchievements(newStreak);
    } else {
      // 中断打卡
      final updated = stats.copyWith(
        currentStreak: 1,
        lastCheckInDate: today,
        totalPoints: stats.totalPoints + pointsPerStreak,
        updatedAt: now,
      );
      await _repository.saveUserStats(updated);
    }
  }

  /// 检查连续打卡成就
  Future<void> _checkStreakAchievements(int streak) async {
    final achievements = await _repository.getAllAchievements();
    for (final achievement in achievements) {
      if (achievement.type == AchievementType.streak &&
          !achievement.isUnlocked &&
          streak >= achievement.targetValue) {
        await unlockAchievement(achievement.id);
      }
    }
  }

  /// 检查成就解锁
  Future<void> _checkAchievements(UserStats stats) async {
    final achievements = await _repository.getAllAchievements();

    for (final achievement in achievements) {
      if (achievement.isUnlocked) continue;

      var shouldUnlock = false;
      var currentValue = 0;

      switch (achievement.type) {
        case AchievementType.tasksCompleted:
          currentValue = stats.totalTasksCompleted;
          shouldUnlock = currentValue >= achievement.targetValue;
        case AchievementType.focusMinutes:
          currentValue = stats.totalFocusMinutes;
          shouldUnlock = currentValue >= achievement.targetValue;
        case AchievementType.streak:
          currentValue = stats.currentStreak;
          shouldUnlock = currentValue >= achievement.targetValue;
        default:
          continue;
      }

      // 更新进度
      final updated = achievement.copyWith(currentValue: currentValue);
      await _repository.saveAchievement(updated);

      if (shouldUnlock) {
        await unlockAchievement(achievement.id);
      }
    }
  }

  /// 解锁成就
  Future<void> unlockAchievement(String achievementId) async {
    final achievement = await _repository.getAchievement(achievementId);
    if (achievement == null || achievement.isUnlocked) return;

    final now = _clock.now();
    final updated = achievement.copyWith(unlockedAt: now);
    await _repository.saveAchievement(updated);

    // 添加奖励积分
    await addPoints(achievement.pointsReward, reason: '成就解锁: ${achievement.name}');

    // 解锁徽章
    if (achievement.badgeReward != null) {
      await unlockBadge(achievement.badgeReward!);
    }

    // 更新用户统计
    final stats = await getUserStats();
    final updatedStats = stats.copyWith(
      unlockedAchievementIds: [...stats.unlockedAchievementIds, achievementId],
      updatedAt: now,
    );
    await _repository.saveUserStats(updatedStats);
  }

  /// 解锁徽章
  Future<void> unlockBadge(String badgeId) async {
    final badge = await _repository.getBadge(badgeId);
    if (badge == null || badge.isUnlocked) return;

    final now = _clock.now();
    final updated = badge.copyWith(unlockedAt: now);
    await _repository.saveBadge(updated);

    // 更新用户统计
    final stats = await getUserStats();
    final updatedStats = stats.copyWith(
      unlockedBadgeIds: [...stats.unlockedBadgeIds, badgeId],
      updatedAt: now,
    );
    await _repository.saveUserStats(updatedStats);
  }

  /// 更新挑战进度
  Future<void> _updateChallengeProgress(ChallengeType type, int increment) async {
    final challenges = await getActiveChallenges();

    for (final challenge in challenges) {
      if (challenge.type == type && challenge.isActive) {
        final newValue = challenge.currentValue + increment;
        final updated = challenge.copyWith(currentValue: newValue);

        if (newValue >= challenge.targetValue && !challenge.isCompleted) {
          // 完成挑战
          await completeChallenge(challenge.id);
        } else {
          await _repository.saveChallenge(updated);
        }
      }
    }
  }

  /// 完成挑战
  Future<void> completeChallenge(String challengeId) async {
    final challenge = await _repository.getChallenge(challengeId);
    if (challenge == null || challenge.isCompleted) return;

    final now = _clock.now();
    final updated = challenge.copyWith(
      isCompleted: true,
      completedAt: now,
    );
    await _repository.saveChallenge(updated);

    // 添加奖励积分
    await addPoints(challenge.pointsReward, reason: '挑战完成: ${challenge.title}');
  }

  /// 获取活跃挑战
  Future<List<Challenge>> getActiveChallenges() async {
    final allChallenges = await _repository.getAllChallenges();
    return allChallenges.where((c) => c.isActive).toList();
  }

  /// 生成每日挑战
  Future<List<Challenge>> generateDailyChallenges() async {
    final now = _clock.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final challenges = <Challenge>[];

    // 每日任务挑战
    challenges.add(Challenge(
      id: _idGenerator.generate(),
      title: '完成5个任务',
      description: '今天完成至少5个任务',
      type: ChallengeType.completeTasks,
      period: ChallengePeriod.daily,
      targetValue: 5,
      pointsReward: 50,
      startDate: today,
      endDate: tomorrow,
      createdAt: now,
    ));

    // 专注挑战
    challenges.add(Challenge(
      id: _idGenerator.generate(),
      title: '专注30分钟',
      description: '今天累计专注时长达到30分钟',
      type: ChallengeType.focusTime,
      period: ChallengePeriod.daily,
      targetValue: 30,
      pointsReward: 30,
      startDate: today,
      endDate: tomorrow,
      createdAt: now,
    ));

    for (final challenge in challenges) {
      await _repository.saveChallenge(challenge);
    }

    return challenges;
  }

  /// 生成每周挑战
  Future<List<Challenge>> generateWeeklyChallenges() async {
    final now = _clock.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextWeek = today.add(const Duration(days: 7));

    final challenges = <Challenge>[];

    // 每周任务挑战
    challenges.add(Challenge(
      id: _idGenerator.generate(),
      title: '完成30个任务',
      description: '本周完成至少30个任务',
      type: ChallengeType.completeTasks,
      period: ChallengePeriod.weekly,
      targetValue: 30,
      pointsReward: 200,
      startDate: today,
      endDate: nextWeek,
      createdAt: now,
    ));

    // 连续打卡挑战
    challenges.add(Challenge(
      id: _idGenerator.generate(),
      title: '连续打卡7天',
      description: '保持7天连续打卡记录',
      type: ChallengeType.maintainStreak,
      period: ChallengePeriod.weekly,
      targetValue: 7,
      pointsReward: 150,
      startDate: today,
      endDate: nextWeek,
      createdAt: now,
    ));

    for (final challenge in challenges) {
      await _repository.saveChallenge(challenge);
    }

    return challenges;
  }

  /// 获取所有徽章
  Future<List<Badge>> getAllBadges() => _repository.getAllBadges();

  /// 获取所有成就
  Future<List<Achievement>> getAllAchievements() => _repository.getAllAchievements();

  /// 获取所有挑战
  Future<List<Challenge>> getAllChallenges() => _repository.getAllChallenges();

  /// 初始化预设徽章和成就
  Future<void> initializePresets() async {
    await _initializeBadges();
    await _initializeAchievements();
  }

  Future<void> _initializeBadges() async {
    final badges = [
      const Badge(
        id: 'badge_first_task',
        name: '初来乍到',
        description: '完成第一个任务',
        icon: '🎯',
        category: BadgeCategory.tasks,
        rarity: BadgeRarity.common,
      ),
      const Badge(
        id: 'badge_10_tasks',
        name: '小试牛刀',
        description: '完成10个任务',
        icon: '⭐',
        category: BadgeCategory.tasks,
        rarity: BadgeRarity.common,
      ),
      const Badge(
        id: 'badge_100_tasks',
        name: '任务达人',
        description: '完成100个任务',
        icon: '🏆',
        category: BadgeCategory.tasks,
        rarity: BadgeRarity.rare,
      ),
      const Badge(
        id: 'badge_first_focus',
        name: '专注新手',
        description: '完成第一次专注',
        icon: '🧘',
        category: BadgeCategory.focus,
        rarity: BadgeRarity.common,
      ),
      const Badge(
        id: 'badge_100_focus',
        name: '专注大师',
        description: '累计专注100小时',
        icon: '🎓',
        category: BadgeCategory.focus,
        rarity: BadgeRarity.epic,
      ),
      const Badge(
        id: 'badge_7_streak',
        name: '坚持一周',
        description: '连续打卡7天',
        icon: '🔥',
        category: BadgeCategory.streak,
        rarity: BadgeRarity.rare,
      ),
      const Badge(
        id: 'badge_30_streak',
        name: '月度冠军',
        description: '连续打卡30天',
        icon: '👑',
        category: BadgeCategory.streak,
        rarity: BadgeRarity.epic,
      ),
      const Badge(
        id: 'badge_100_streak',
        name: '百日坚持',
        description: '连续打卡100天',
        icon: '💎',
        category: BadgeCategory.streak,
        rarity: BadgeRarity.legendary,
      ),
    ];

    for (final badge in badges) {
      final existing = await _repository.getBadge(badge.id);
      if (existing == null) {
        await _repository.saveBadge(badge);
      }
    }
  }

  Future<void> _initializeAchievements() async {
    final achievements = [
      const Achievement(
        id: 'achievement_10_tasks',
        name: '勤奋工作者',
        description: '完成10个任务',
        icon: '📝',
        type: AchievementType.tasksCompleted,
        targetValue: 10,
        pointsReward: 100,
        badgeReward: 'badge_10_tasks',
      ),
      const Achievement(
        id: 'achievement_100_tasks',
        name: '任务大师',
        description: '完成100个任务',
        icon: '🎯',
        type: AchievementType.tasksCompleted,
        targetValue: 100,
        pointsReward: 500,
        badgeReward: 'badge_100_tasks',
      ),
      const Achievement(
        id: 'achievement_60_focus',
        name: '专注之星',
        description: '累计专注60分钟',
        icon: '⏰',
        type: AchievementType.focusMinutes,
        targetValue: 60,
        pointsReward: 200,
      ),
      const Achievement(
        id: 'achievement_6000_focus',
        name: '专注传奇',
        description: '累计专注6000分钟（100小时）',
        icon: '🌟',
        type: AchievementType.focusMinutes,
        targetValue: 6000,
        pointsReward: 1000,
        badgeReward: 'badge_100_focus',
      ),
      const Achievement(
        id: 'achievement_7_streak',
        name: '一周坚持',
        description: '连续打卡7天',
        icon: '🔥',
        type: AchievementType.streak,
        targetValue: 7,
        pointsReward: 200,
        badgeReward: 'badge_7_streak',
      ),
      const Achievement(
        id: 'achievement_30_streak',
        name: '月度坚持',
        description: '连续打卡30天',
        icon: '💪',
        type: AchievementType.streak,
        targetValue: 30,
        pointsReward: 500,
        badgeReward: 'badge_30_streak',
      ),
      const Achievement(
        id: 'achievement_100_streak',
        name: '百日坚持',
        description: '连续打卡100天',
        icon: '🏅',
        type: AchievementType.streak,
        targetValue: 100,
        pointsReward: 2000,
        badgeReward: 'badge_100_streak',
      ),
    ];

    for (final achievement in achievements) {
      final existing = await _repository.getAchievement(achievement.id);
      if (existing == null) {
        await _repository.saveAchievement(achievement);
      }
    }
  }

  // ==================== 每日签到功能 ====================

  /// 执行每日签到
  Future<DailyCheckIn> performDailyCheckIn() async {
    final stats = await getUserStats();
    final now = _clock.now();
    final today = DateTime(now.year, now.month, now.day);

    // 检查今天是否已签到
    final todayCheckIn = await getTodayCheckIn();
    if (todayCheckIn != null) {
      throw Exception('今天已经签到过了');
    }

    // 计算连续天数和奖励
    int consecutiveDays = 1;
    int basePoints = pointsPerDailyCheckIn;
    int bonusPoints = 0;

    if (stats.lastManualCheckInDate != null) {
      final lastCheckIn = DateTime(
        stats.lastManualCheckInDate!.year,
        stats.lastManualCheckInDate!.month,
        stats.lastManualCheckInDate!.day,
      );
      final daysDiff = today.difference(lastCheckIn).inDays;

      if (daysDiff == 1) {
        // 连续签到
        consecutiveDays = stats.currentStreak + 1;
      } else if (daysDiff > 1) {
        // 中断了，重新开始
        consecutiveDays = 1;
      }
    }

    // 连续签到奖励
    if (consecutiveDays == 3) {
      bonusPoints = 10; // 3天奖励
    } else if (consecutiveDays == 7) {
      bonusPoints = 30; // 7天奖励
    } else if (consecutiveDays == 14) {
      bonusPoints = 50; // 14天奖励
    } else if (consecutiveDays == 21) {
      bonusPoints = 80; // 21天奖励
    } else if (consecutiveDays == 30) {
      bonusPoints = 120; // 30天奖励
    } else if (consecutiveDays % 30 == 0 && consecutiveDays > 30) {
      bonusPoints = 150; // 每30天奖励
    }

    final totalPoints = basePoints + bonusPoints;

    // 创建签到记录
    final checkIn = DailyCheckIn(
      id: _idGenerator.generate(),
      checkInDate: today,
      createdAt: now,
      pointsEarned: totalPoints,
      consecutiveDays: consecutiveDays,
    );
    await _repository.saveCheckIn(checkIn);

    // 更新用户统计
    final updatedStats = stats.copyWith(
      totalPoints: stats.totalPoints + totalPoints,
      currentStreak: consecutiveDays,
      longestStreak: consecutiveDays > stats.longestStreak ? consecutiveDays : stats.longestStreak,
      lastManualCheckInDate: today,
      totalCheckIns: stats.totalCheckIns + 1,
      updatedAt: now,
    );
    await _repository.saveUserStats(updatedStats);

    // 检查成就
    await _checkAchievements(updatedStats);
    await _checkStreakAchievements(consecutiveDays);

    return checkIn;
  }

  /// 使用补签卡补签
  Future<DailyCheckIn> performMakeupCheckIn(DateTime date) async {
    final stats = await getUserStats();
    final now = _clock.now();
    final targetDate = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);

    // 只能补签过去7天内的
    final daysDiff = today.difference(targetDate).inDays;
    if (daysDiff <= 0 || daysDiff > 7) {
      throw Exception('只能补签过去7天内的记录');
    }

    // 检查是否已经签到过
    final existingCheckIn = await getCheckInByDate(targetDate);
    if (existingCheckIn != null) {
      throw Exception('该日期已经签到过了');
    }

    // 检查补签卡数量
    if (stats.makeupCardsCount <= 0) {
      throw Exception('补签卡不足，需要购买');
    }

    // 使用补签卡
    final checkIn = DailyCheckIn(
      id: _idGenerator.generate(),
      checkInDate: targetDate,
      createdAt: now,
      pointsEarned: pointsPerDailyCheckIn,
      consecutiveDays: 1, // 补签不计入连续天数奖励
      isMakeup: true,
    );
    await _repository.saveCheckIn(checkIn);

    // 扣除补签卡并增加积分
    final updatedStats = stats.copyWith(
      makeupCardsCount: stats.makeupCardsCount - 1,
      totalPoints: stats.totalPoints + pointsPerDailyCheckIn,
      totalCheckIns: stats.totalCheckIns + 1,
      updatedAt: now,
    );
    await _repository.saveUserStats(updatedStats);

    return checkIn;
  }

  /// 购买补签卡
  Future<void> buyMakeupCard() async {
    final stats = await getUserStats();
    final now = _clock.now();

    if (stats.totalPoints < makeupCardCost) {
      throw Exception('积分不足，需要 $makeupCardCost 积分');
    }

    // 扣除积分并增加补签卡
    final updatedStats = stats.copyWith(
      totalPoints: stats.totalPoints - makeupCardCost,
      makeupCardsCount: stats.makeupCardsCount + 1,
      updatedAt: now,
    );
    await _repository.saveUserStats(updatedStats);
  }

  /// 获取今天的签到记录
  Future<DailyCheckIn?> getTodayCheckIn() async {
    final now = _clock.now();
    final today = DateTime(now.year, now.month, now.day);
    return getCheckInByDate(today);
  }

  /// 获取指定日期的签到记录
  Future<DailyCheckIn?> getCheckInByDate(DateTime date) async {
    final allCheckIns = await _repository.getAllCheckIns();
    final targetDate = DateTime(date.year, date.month, date.day);

    for (final checkIn in allCheckIns) {
      final checkInDate = DateTime(
        checkIn.checkInDate.year,
        checkIn.checkInDate.month,
        checkIn.checkInDate.day,
      );
      if (checkInDate == targetDate) {
        return checkIn;
      }
    }
    return null;
  }

  /// 获取最近7天的签到记录
  Future<List<DailyCheckIn>> getRecentCheckIns({int days = 7}) async {
    final now = _clock.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = today.subtract(Duration(days: days - 1));

    final allCheckIns = await _repository.getAllCheckIns();
    return allCheckIns.where((checkIn) {
      final checkInDate = DateTime(
        checkIn.checkInDate.year,
        checkIn.checkInDate.month,
        checkIn.checkInDate.day,
      );
      return !checkInDate.isBefore(startDate) && !checkInDate.isAfter(today);
    }).toList()
      ..sort((a, b) => b.checkInDate.compareTo(a.checkInDate));
  }

  /// 获取签到统计
  Future<Map<String, dynamic>> getCheckInStats() async {
    final stats = await getUserStats();
    final todayCheckIn = await getTodayCheckIn();
    final recentCheckIns = await getRecentCheckIns();

    return {
      'hasCheckedInToday': todayCheckIn != null,
      'currentStreak': stats.currentStreak,
      'longestStreak': stats.longestStreak,
      'totalCheckIns': stats.totalCheckIns,
      'makeupCardsCount': stats.makeupCardsCount,
      'recentCheckIns': recentCheckIns,
    };
  }

  // ==================== 幸运抽奖功能 ====================

  /// 初始化奖品池
  Future<void> initializePrizePool() async {
    final existingPrizes = await _repository.getAllPrizeConfigs();
    if (existingPrizes.isNotEmpty) return; // 已初始化

    final prizes = <PrizeConfig>[
      // 普通奖品 (60%)
      PrizeConfig(
        id: 'prize_points_5',
        name: '5积分',
        description: '获得5点积分',
        type: PrizeType.points,
        rarity: PrizeRarity.common,
        icon: '💰',
        value: 5,
      ),
      PrizeConfig(
        id: 'prize_points_10',
        name: '10积分',
        description: '获得10点积分',
        type: PrizeType.points,
        rarity: PrizeRarity.common,
        icon: '💵',
        value: 10,
      ),
      PrizeConfig(
        id: 'prize_points_15',
        name: '15积分',
        description: '获得15点积分',
        type: PrizeType.points,
        rarity: PrizeRarity.common,
        icon: '💴',
        value: 15,
      ),

      // 稀有奖品 (25%)
      PrizeConfig(
        id: 'prize_points_30',
        name: '30积分',
        description: '获得30点积分',
        type: PrizeType.points,
        rarity: PrizeRarity.rare,
        icon: '💎',
        value: 30,
      ),
      PrizeConfig(
        id: 'prize_points_50',
        name: '50积分',
        description: '获得50点积分',
        type: PrizeType.points,
        rarity: PrizeRarity.rare,
        icon: '💍',
        value: 50,
      ),
      PrizeConfig(
        id: 'prize_makeup_card',
        name: '补签卡',
        description: '获得1张补签卡',
        type: PrizeType.makeupCard,
        rarity: PrizeRarity.rare,
        icon: '🎫',
        value: 1,
      ),

      // 史诗奖品 (10%)
      PrizeConfig(
        id: 'prize_points_80',
        name: '80积分',
        description: '获得80点积分',
        type: PrizeType.points,
        rarity: PrizeRarity.epic,
        icon: '👑',
        value: 80,
      ),
      PrizeConfig(
        id: 'prize_points_100',
        name: '100积分',
        description: '获得100点积分',
        type: PrizeType.points,
        rarity: PrizeRarity.epic,
        icon: '🏆',
        value: 100,
      ),

      // 传说奖品 (5%)
      PrizeConfig(
        id: 'prize_points_200',
        name: '200积分',
        description: '获得200点积分！',
        type: PrizeType.points,
        rarity: PrizeRarity.legendary,
        icon: '⭐',
        value: 200,
      ),
      PrizeConfig(
        id: 'prize_points_500',
        name: '500积分',
        description: '获得500点积分！！',
        type: PrizeType.points,
        rarity: PrizeRarity.legendary,
        icon: '🌟',
        value: 500,
      ),
    ];

    for (final prize in prizes) {
      await _repository.savePrizeConfig(prize);
    }
  }

  /// 执行免费抽奖
  Future<PrizeConfig> performFreeDraw() async {
    final stats = await getUserStats();
    final now = _clock.now();
    final today = DateTime(now.year, now.month, now.day);

    // 检查今天是否还有免费次数
    if (stats.lastFreeDrawDate != null) {
      final lastDrawDay = DateTime(
        stats.lastFreeDrawDate!.year,
        stats.lastFreeDrawDate!.month,
        stats.lastFreeDrawDate!.day,
      );

      if (lastDrawDay == today && stats.freeDrawsUsedToday >= 1) {
        throw Exception('今天已经使用过免费抽奖了');
      }
    }

    // 执行抽奖
    final prize = await _performDraw(stats, isFree: true);

    // 更新统计
    final lastDrawDay = stats.lastFreeDrawDate != null
        ? DateTime(
            stats.lastFreeDrawDate!.year,
            stats.lastFreeDrawDate!.month,
            stats.lastFreeDrawDate!.day,
          )
        : null;

    final updatedStats = stats.copyWith(
      freeDrawsUsedToday: (lastDrawDay != null && lastDrawDay == today)
          ? stats.freeDrawsUsedToday + 1
          : 1,
      lastFreeDrawDate: now,
      totalDraws: stats.totalDraws + 1,
      updatedAt: now,
    );
    await _repository.saveUserStats(updatedStats);

    return prize;
  }

  /// 执行付费抽奖
  Future<PrizeConfig> performPaidDraw() async {
    final stats = await getUserStats();

    // 检查积分
    if (stats.totalPoints < luckyDrawCost) {
      throw Exception('积分不足，需要 $luckyDrawCost 积分');
    }

    // 执行抽奖
    final prize = await _performDraw(stats, isFree: false);

    // 扣除积分并更新统计
    final now = _clock.now();
    final updatedStats = stats.copyWith(
      totalPoints: stats.totalPoints - luckyDrawCost,
      totalDraws: stats.totalDraws + 1,
      updatedAt: now,
    );
    await _repository.saveUserStats(updatedStats);

    return prize;
  }

  /// 执行抽奖逻辑
  Future<PrizeConfig> _performDraw(UserStats stats, {required bool isFree}) async {
    final allPrizes = await _repository.getAllPrizeConfigs();
    final random = math.Random();
    final now = _clock.now();

    PrizeConfig selectedPrize;

    // 保底机制
    if (stats.drawPityCounter >= legendaryPityThreshold) {
      // 传说保底
      final legendaryPrizes = allPrizes
          .where((p) => p.rarity == PrizeRarity.legendary)
          .toList();
      selectedPrize = legendaryPrizes[random.nextInt(legendaryPrizes.length)];
    } else if (stats.drawPityCounter >= rarePityThreshold) {
      // 稀有保底
      final rarePrizes = allPrizes
          .where((p) => p.rarity == PrizeRarity.rare ||
                        p.rarity == PrizeRarity.epic ||
                        p.rarity == PrizeRarity.legendary)
          .toList();
      selectedPrize = rarePrizes[random.nextInt(rarePrizes.length)];
    } else {
      // 正常抽奖
      selectedPrize = _selectPrizeByProbability(allPrizes, random);
    }

    // 更新保底计数器
    int newPityCounter = stats.drawPityCounter + 1;
    if (selectedPrize.rarity == PrizeRarity.legendary) {
      newPityCounter = 0; // 重置保底
    } else if (selectedPrize.rarity == PrizeRarity.rare ||
               selectedPrize.rarity == PrizeRarity.epic) {
      // 出了稀有或史诗，部分重置
      newPityCounter = (newPityCounter / 2).floor();
    }

    // 发放奖励
    final statsAfterPrize = await _grantPrize(stats, selectedPrize);

    // 检查是否抽中传说,解锁"欧皇"称号
    if (selectedPrize.rarity == PrizeRarity.legendary) {
      await unlockTitle('title_lucky_one');
    }

    // 保存抽奖记录
    final record = LuckyDrawRecord(
      id: _idGenerator.generate(),
      createdAt: now,
      prizeId: selectedPrize.id,
      prizeName: selectedPrize.name,
      prizeType: selectedPrize.type,
      prizeRarity: selectedPrize.rarity,
      costPoints: isFree ? 0 : luckyDrawCost,
      isFree: isFree,
    );
    await _repository.saveDrawRecord(record);

    // 更新保底计数器 (使用发放奖励后的统计数据,避免覆盖积分变化)
    await _repository.saveUserStats(
      statsAfterPrize.copyWith(drawPityCounter: newPityCounter),
    );

    return selectedPrize;
  }

  /// 根据概率选择奖品
  PrizeConfig _selectPrizeByProbability(
    List<PrizeConfig> allPrizes,
    math.Random random,
  ) {
    // 按稀有度分组
    final prizesByRarity = <PrizeRarity, List<PrizeConfig>>{};
    for (final rarity in PrizeRarity.values) {
      prizesByRarity[rarity] =
          allPrizes.where((p) => p.rarity == rarity).toList();
    }

    // 随机选择稀有度
    final roll = random.nextDouble();
    var cumulativeProbability = 0.0;

    for (final rarity in PrizeRarity.values.reversed) {
      cumulativeProbability += rarity.probability;
      if (roll <= cumulativeProbability) {
        final prizes = prizesByRarity[rarity]!;
        return prizes[random.nextInt(prizes.length)];
      }
    }

    // 兜底：返回普通奖品
    final commonPrizes = prizesByRarity[PrizeRarity.common]!;
    return commonPrizes[random.nextInt(commonPrizes.length)];
  }

  /// 发放奖品
  Future<UserStats> _grantPrize(UserStats stats, PrizeConfig prize) async {
    final now = _clock.now();

    switch (prize.type) {
      case PrizeType.points:
        // 增加积分
        final updatedStats = stats.copyWith(
          totalPoints: stats.totalPoints + prize.value,
          updatedAt: now,
        );
        await _repository.saveUserStats(updatedStats);
        return updatedStats;

      case PrizeType.makeupCard:
        // 增加补签卡
        final updatedStats = stats.copyWith(
          makeupCardsCount: stats.makeupCardsCount + prize.value,
          updatedAt: now,
        );
        await _repository.saveUserStats(updatedStats);
        return updatedStats;

      case PrizeType.badge:
        // 解锁徽章
        if (prize.itemId != null) {
          await unlockBadge(prize.itemId!);
        }
        return stats;

      case PrizeType.title:
        // TODO: 称号系统待实现
        return stats;
    }
  }

  /// 获取抽奖统计
  Future<Map<String, dynamic>> getLuckyDrawStats() async {
    final stats = await getUserStats();
    final now = _clock.now();
    final today = DateTime(now.year, now.month, now.day);

    bool hasFreeDrawToday = true;
    if (stats.lastFreeDrawDate != null) {
      final lastDrawDay = DateTime(
        stats.lastFreeDrawDate!.year,
        stats.lastFreeDrawDate!.month,
        stats.lastFreeDrawDate!.day,
      );
      hasFreeDrawToday = lastDrawDay.isBefore(today) || stats.freeDrawsUsedToday < 1;
    }

    final records = await _repository.getAllDrawRecords();
    final recentRecords = records.take(10).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return {
      'hasFreeDrawToday': hasFreeDrawToday,
      'totalDraws': stats.totalDraws,
      'pityCounter': stats.drawPityCounter,
      'nextRarePity': rarePityThreshold - stats.drawPityCounter,
      'nextLegendaryPity': legendaryPityThreshold - stats.drawPityCounter,
      'recentRecords': recentRecords,
    };
  }

  /// 获取所有奖品配置
  Future<List<PrizeConfig>> getAllPrizes() => _repository.getAllPrizeConfigs();

  /// 获取抽奖记录
  Future<List<LuckyDrawRecord>> getDrawRecords() => _repository.getAllDrawRecords();

  // ==================== 称号系统 ====================

  /// 初始化称号
  Future<void> initializeTitles() async {
    final existingTitles = await _repository.getAllTitles();
    if (existingTitles.isNotEmpty) return; // 已初始化

    final titles = <UserTitle>[
      // 成就类称号
      const UserTitle(
        id: 'title_task_master',
        name: '任务狂魔',
        description: '完成1000个任务',
        category: TitleCategory.achievement,
        rarity: TitleRarity.epic,
        icon: '🏆',
        requiredValue: 1000,
        requiredCondition: '完成1000个任务',
        pointsBonus: 15,
      ),
      const UserTitle(
        id: 'title_focus_master',
        name: '专注大师',
        description: '累计专注100小时',
        category: TitleCategory.achievement,
        rarity: TitleRarity.epic,
        icon: '🎓',
        requiredValue: 6000,
        requiredCondition: '累计专注6000分钟',
        pointsBonus: 15,
      ),
      const UserTitle(
        id: 'title_achievement_hunter',
        name: '成就猎人',
        description: '解锁所有成就',
        category: TitleCategory.achievement,
        rarity: TitleRarity.legendary,
        icon: '🎯',
        requiredValue: 7,
        requiredCondition: '解锁全部7个成就',
        pointsBonus: 20,
      ),

      // 时间类称号
      const UserTitle(
        id: 'title_week_warrior',
        name: '周战士',
        description: '连续打卡7天',
        category: TitleCategory.time,
        rarity: TitleRarity.rare,
        icon: '⚔️',
        requiredValue: 7,
        requiredCondition: '连续打卡7天',
        pointsBonus: 10,
      ),
      const UserTitle(
        id: 'title_month_champion',
        name: '月度冠军',
        description: '连续打卡30天',
        category: TitleCategory.time,
        rarity: TitleRarity.epic,
        icon: '👑',
        requiredValue: 30,
        requiredCondition: '连续打卡30天',
        pointsBonus: 15,
      ),
      const UserTitle(
        id: 'title_century_legend',
        name: '百日传说',
        description: '连续打卡100天',
        category: TitleCategory.time,
        rarity: TitleRarity.legendary,
        icon: '💎',
        requiredValue: 100,
        requiredCondition: '连续打卡100天',
        pointsBonus: 20,
      ),

      // 特殊类称号
      const UserTitle(
        id: 'title_early_bird',
        name: '晨曦之星',
        description: '首批用户专属',
        category: TitleCategory.special,
        rarity: TitleRarity.legendary,
        icon: '⭐',
        requiredValue: 0,
        requiredCondition: '首批用户',
        pointsBonus: 20,
      ),
      const UserTitle(
        id: 'title_lucky_one',
        name: '欧皇',
        description: '抽到传说奖品',
        category: TitleCategory.special,
        rarity: TitleRarity.rare,
        icon: '🍀',
        requiredValue: 1,
        requiredCondition: '抽中传说级奖品',
        pointsBonus: 10,
      ),

      // 社交类称号
      const UserTitle(
        id: 'title_influencer',
        name: '影响力',
        description: '分享5次成就',
        category: TitleCategory.social,
        rarity: TitleRarity.rare,
        icon: '📢',
        requiredValue: 5,
        requiredCondition: '分享5次成就',
        pointsBonus: 10,
      ),
    ];

    for (final title in titles) {
      await _repository.saveTitle(title);
    }
  }

  /// 解锁称号
  Future<void> unlockTitle(String titleId) async {
    final title = await _repository.getTitle(titleId);
    if (title == null || title.isUnlocked) return;

    final now = _clock.now();
    final updated = title.copyWith(
      isUnlocked: true,
      unlockedAt: now,
    );
    await _repository.saveTitle(updated);

    // 更新用户统计
    final stats = await getUserStats();
    final updatedStats = stats.copyWith(
      unlockedTitleIds: [...stats.unlockedTitleIds, titleId],
      updatedAt: now,
    );
    await _repository.saveUserStats(updatedStats);
  }

  /// 佩戴称号
  Future<void> equipTitle(String titleId) async {
    final title = await _repository.getTitle(titleId);
    if (title == null || !title.isUnlocked) {
      throw Exception('该称号尚未解锁');
    }

    final stats = await getUserStats();
    final updatedStats = stats.copyWith(
      equippedTitleId: titleId,
      updatedAt: _clock.now(),
    );
    await _repository.saveUserStats(updatedStats);
  }

  /// 卸下称号
  Future<void> unequipTitle() async {
    final stats = await getUserStats();
    final updatedStats = stats.copyWith(
      equippedTitleId: null,
      updatedAt: _clock.now(),
    );
    await _repository.saveUserStats(updatedStats);
  }

  /// 检查称号解锁条件
  Future<void> checkTitleUnlocks() async {
    final stats = await getUserStats();
    final titles = await _repository.getAllTitles();

    for (final title in titles) {
      if (title.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (title.category) {
        case TitleCategory.achievement:
          if (title.id == 'title_task_master') {
            shouldUnlock = stats.totalTasksCompleted >= title.requiredValue;
          } else if (title.id == 'title_focus_master') {
            shouldUnlock = stats.totalFocusMinutes >= title.requiredValue;
          } else if (title.id == 'title_achievement_hunter') {
            shouldUnlock = stats.unlockedAchievementIds.length >= title.requiredValue;
          }
          break;

        case TitleCategory.time:
          if (title.id == 'title_week_warrior' ||
              title.id == 'title_month_champion' ||
              title.id == 'title_century_legend') {
            shouldUnlock = stats.currentStreak >= title.requiredValue;
          }
          break;

        case TitleCategory.special:
          // 特殊称号通过其他方式解锁
          break;

        case TitleCategory.social:
          // 社交称号通过分享解锁
          break;
      }

      if (shouldUnlock) {
        await unlockTitle(title.id);
      }
    }
  }

  /// 获取所有称号
  Future<List<UserTitle>> getAllTitles() => _repository.getAllTitles();

  /// 获取已解锁称号
  Future<List<UserTitle>> getUnlockedTitles() async {
    final titles = await _repository.getAllTitles();
    return titles.where((t) => t.isUnlocked).toList();
  }

  /// 获取当前佩戴的称号
  Future<UserTitle?> getEquippedTitle() async {
    final stats = await getUserStats();
    if (stats.equippedTitleId == null) return null;
    return _repository.getTitle(stats.equippedTitleId!);
  }
}
