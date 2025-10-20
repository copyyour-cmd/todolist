import 'package:todolist/src/domain/entities/achievement.dart';
import 'package:todolist/src/domain/entities/badge.dart';
import 'package:todolist/src/domain/entities/challenge.dart';
import 'package:todolist/src/domain/entities/user_stats.dart';
import 'package:todolist/src/domain/entities/daily_checkin.dart';
import 'package:todolist/src/domain/entities/lucky_draw.dart';
import 'package:todolist/src/domain/entities/title.dart';

/// 游戏化仓储接口
abstract class GamificationRepository {
  // 用户统计
  Future<UserStats?> getUserStats();
  Future<void> saveUserStats(UserStats stats);
  Stream<UserStats?> watchUserStats();

  // 徽章
  Future<Badge?> getBadge(String id);
  Future<List<Badge>> getAllBadges();
  Future<void> saveBadge(Badge badge);
  Future<void> deleteBadge(String id);
  Stream<List<Badge>> watchAllBadges();

  // 成就
  Future<Achievement?> getAchievement(String id);
  Future<List<Achievement>> getAllAchievements();
  Future<void> saveAchievement(Achievement achievement);
  Future<void> deleteAchievement(String id);
  Stream<List<Achievement>> watchAllAchievements();

  // 挑战
  Future<Challenge?> getChallenge(String id);
  Future<List<Challenge>> getAllChallenges();
  Future<void> saveChallenge(Challenge challenge);
  Future<void> deleteChallenge(String id);
  Stream<List<Challenge>> watchAllChallenges();

  // 每日签到
  Future<DailyCheckIn?> getCheckIn(String id);
  Future<List<DailyCheckIn>> getAllCheckIns();
  Future<void> saveCheckIn(DailyCheckIn checkIn);
  Future<void> deleteCheckIn(String id);
  Stream<List<DailyCheckIn>> watchAllCheckIns();

  // 补签卡
  Future<MakeupCard?> getMakeupCard(String id);
  Future<List<MakeupCard>> getAllMakeupCards();
  Future<void> saveMakeupCard(MakeupCard card);
  Future<void> deleteMakeupCard(String id);
  Stream<List<MakeupCard>> watchAllMakeupCards();

  // 抽奖奖品配置
  Future<PrizeConfig?> getPrizeConfig(String id);
  Future<List<PrizeConfig>> getAllPrizeConfigs();
  Future<void> savePrizeConfig(PrizeConfig config);
  Future<void> deletePrizeConfig(String id);
  Stream<List<PrizeConfig>> watchAllPrizeConfigs();

  // 抽奖记录
  Future<LuckyDrawRecord?> getDrawRecord(String id);
  Future<List<LuckyDrawRecord>> getAllDrawRecords();
  Future<void> saveDrawRecord(LuckyDrawRecord record);
  Future<void> deleteDrawRecord(String id);
  Stream<List<LuckyDrawRecord>> watchAllDrawRecords();

  // 称号
  Future<UserTitle?> getTitle(String id);
  Future<List<UserTitle>> getAllTitles();
  Future<void> saveTitle(UserTitle title);
  Future<void> deleteTitle(String id);
  Stream<List<UserTitle>> watchAllTitles();
}
