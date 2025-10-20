import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/domain/entities/achievement.dart';
import 'package:todolist/src/domain/entities/badge.dart';
import 'package:todolist/src/domain/entities/challenge.dart';
import 'package:todolist/src/domain/entities/user_stats.dart';
import 'package:todolist/src/domain/entities/daily_checkin.dart';
import 'package:todolist/src/domain/entities/lucky_draw.dart';
import 'package:todolist/src/domain/entities/title.dart';
import 'package:todolist/src/domain/repositories/gamification_repository.dart';

/// Hive实现的游戏化仓储
class HiveGamificationRepository implements GamificationRepository {
  static const String _userStatsBoxName = 'user_stats';
  static const String _badgesBoxName = 'badges';
  static const String _achievementsBoxName = 'achievements';
  static const String _challengesBoxName = 'challenges';
  static const String _checkInsBoxName = 'daily_checkins';
  static const String _makeupCardsBoxName = 'makeup_cards';
  static const String _prizeConfigsBoxName = 'prize_configs';
  static const String _drawRecordsBoxName = 'draw_records';
  static const String _titlesBoxName = 'titles';

  Box<UserStats>? _userStatsBox;
  Box<Badge>? _badgesBox;
  Box<Achievement>? _achievementsBox;
  Box<Challenge>? _challengesBox;
  Box<DailyCheckIn>? _checkInsBox;
  Box<MakeupCard>? _makeupCardsBox;
  Box<PrizeConfig>? _prizeConfigsBox;
  Box<LuckyDrawRecord>? _drawRecordsBox;
  Box<UserTitle>? _titlesBox;

  Future<void> _ensureInitialized() async {
    _userStatsBox ??= await Hive.openBox<UserStats>(_userStatsBoxName);
    _badgesBox ??= await Hive.openBox<Badge>(_badgesBoxName);
    _achievementsBox ??= await Hive.openBox<Achievement>(_achievementsBoxName);
    _challengesBox ??= await Hive.openBox<Challenge>(_challengesBoxName);
    _checkInsBox ??= await Hive.openBox<DailyCheckIn>(_checkInsBoxName);
    _makeupCardsBox ??= await Hive.openBox<MakeupCard>(_makeupCardsBoxName);
    _prizeConfigsBox ??= await Hive.openBox<PrizeConfig>(_prizeConfigsBoxName);
    _drawRecordsBox ??= await Hive.openBox<LuckyDrawRecord>(_drawRecordsBoxName);
    _titlesBox ??= await Hive.openBox<UserTitle>(_titlesBoxName);
  }

  // 用户统计
  @override
  Future<UserStats?> getUserStats() async {
    await _ensureInitialized();
    return _userStatsBox!.get('user_stats');
  }

  @override
  Future<void> saveUserStats(UserStats stats) async {
    await _ensureInitialized();
    await _userStatsBox!.put('user_stats', stats);
  }

  @override
  Stream<UserStats?> watchUserStats() async* {
    await _ensureInitialized();
    yield _userStatsBox!.get('user_stats');
    yield* _userStatsBox!
        .watch(key: 'user_stats')
        .map((event) => event.value as UserStats?);
  }

  // 徽章
  @override
  Future<Badge?> getBadge(String id) async {
    await _ensureInitialized();
    return _badgesBox!.get(id);
  }

  @override
  Future<List<Badge>> getAllBadges() async {
    await _ensureInitialized();
    return _badgesBox!.values.toList();
  }

  @override
  Future<void> saveBadge(Badge badge) async {
    await _ensureInitialized();
    await _badgesBox!.put(badge.id, badge);
  }

  @override
  Future<void> deleteBadge(String id) async {
    await _ensureInitialized();
    await _badgesBox!.delete(id);
  }

  @override
  Stream<List<Badge>> watchAllBadges() async* {
    await _ensureInitialized();
    yield _badgesBox!.values.toList();
    yield* _badgesBox!.watch().map((_) => _badgesBox!.values.toList());
  }

  // 成就
  @override
  Future<Achievement?> getAchievement(String id) async {
    await _ensureInitialized();
    return _achievementsBox!.get(id);
  }

  @override
  Future<List<Achievement>> getAllAchievements() async {
    await _ensureInitialized();
    return _achievementsBox!.values.toList();
  }

  @override
  Future<void> saveAchievement(Achievement achievement) async {
    await _ensureInitialized();
    await _achievementsBox!.put(achievement.id, achievement);
  }

  @override
  Future<void> deleteAchievement(String id) async {
    await _ensureInitialized();
    await _achievementsBox!.delete(id);
  }

  @override
  Stream<List<Achievement>> watchAllAchievements() async* {
    await _ensureInitialized();
    yield _achievementsBox!.values.toList();
    yield* _achievementsBox!.watch().map((_) => _achievementsBox!.values.toList());
  }

  // 挑战
  @override
  Future<Challenge?> getChallenge(String id) async {
    await _ensureInitialized();
    return _challengesBox!.get(id);
  }

  @override
  Future<List<Challenge>> getAllChallenges() async {
    await _ensureInitialized();
    return _challengesBox!.values.toList();
  }

  @override
  Future<void> saveChallenge(Challenge challenge) async {
    await _ensureInitialized();
    await _challengesBox!.put(challenge.id, challenge);
  }

  @override
  Future<void> deleteChallenge(String id) async {
    await _ensureInitialized();
    await _challengesBox!.delete(id);
  }

  @override
  Stream<List<Challenge>> watchAllChallenges() async* {
    await _ensureInitialized();
    yield _challengesBox!.values.toList();
    yield* _challengesBox!.watch().map((_) => _challengesBox!.values.toList());
  }

  // 每日签到
  @override
  Future<DailyCheckIn?> getCheckIn(String id) async {
    await _ensureInitialized();
    return _checkInsBox!.get(id);
  }

  @override
  Future<List<DailyCheckIn>> getAllCheckIns() async {
    await _ensureInitialized();
    return _checkInsBox!.values.toList();
  }

  @override
  Future<void> saveCheckIn(DailyCheckIn checkIn) async {
    await _ensureInitialized();
    await _checkInsBox!.put(checkIn.id, checkIn);
  }

  @override
  Future<void> deleteCheckIn(String id) async {
    await _ensureInitialized();
    await _checkInsBox!.delete(id);
  }

  @override
  Stream<List<DailyCheckIn>> watchAllCheckIns() async* {
    await _ensureInitialized();
    yield _checkInsBox!.values.toList();
    yield* _checkInsBox!.watch().map((_) => _checkInsBox!.values.toList());
  }

  // 补签卡
  @override
  Future<MakeupCard?> getMakeupCard(String id) async {
    await _ensureInitialized();
    return _makeupCardsBox!.get(id);
  }

  @override
  Future<List<MakeupCard>> getAllMakeupCards() async {
    await _ensureInitialized();
    return _makeupCardsBox!.values.toList();
  }

  @override
  Future<void> saveMakeupCard(MakeupCard card) async {
    await _ensureInitialized();
    await _makeupCardsBox!.put(card.id, card);
  }

  @override
  Future<void> deleteMakeupCard(String id) async {
    await _ensureInitialized();
    await _makeupCardsBox!.delete(id);
  }

  @override
  Stream<List<MakeupCard>> watchAllMakeupCards() async* {
    await _ensureInitialized();
    yield _makeupCardsBox!.values.toList();
    yield* _makeupCardsBox!.watch().map((_) => _makeupCardsBox!.values.toList());
  }

  // 抽奖奖品配置
  @override
  Future<PrizeConfig?> getPrizeConfig(String id) async {
    await _ensureInitialized();
    return _prizeConfigsBox!.get(id);
  }

  @override
  Future<List<PrizeConfig>> getAllPrizeConfigs() async {
    await _ensureInitialized();
    return _prizeConfigsBox!.values.toList();
  }

  @override
  Future<void> savePrizeConfig(PrizeConfig config) async {
    await _ensureInitialized();
    await _prizeConfigsBox!.put(config.id, config);
  }

  @override
  Future<void> deletePrizeConfig(String id) async {
    await _ensureInitialized();
    await _prizeConfigsBox!.delete(id);
  }

  @override
  Stream<List<PrizeConfig>> watchAllPrizeConfigs() async* {
    await _ensureInitialized();
    yield _prizeConfigsBox!.values.toList();
    yield* _prizeConfigsBox!.watch().map((_) => _prizeConfigsBox!.values.toList());
  }

  // 抽奖记录
  @override
  Future<LuckyDrawRecord?> getDrawRecord(String id) async {
    await _ensureInitialized();
    return _drawRecordsBox!.get(id);
  }

  @override
  Future<List<LuckyDrawRecord>> getAllDrawRecords() async {
    await _ensureInitialized();
    return _drawRecordsBox!.values.toList();
  }

  @override
  Future<void> saveDrawRecord(LuckyDrawRecord record) async {
    await _ensureInitialized();
    await _drawRecordsBox!.put(record.id, record);
  }

  @override
  Future<void> deleteDrawRecord(String id) async {
    await _ensureInitialized();
    await _drawRecordsBox!.delete(id);
  }

  @override
  Stream<List<LuckyDrawRecord>> watchAllDrawRecords() async* {
    await _ensureInitialized();
    yield _drawRecordsBox!.values.toList();
    yield* _drawRecordsBox!.watch().map((_) => _drawRecordsBox!.values.toList());
  }

  // 称号
  @override
  Future<UserTitle?> getTitle(String id) async {
    await _ensureInitialized();
    return _titlesBox!.get(id);
  }

  @override
  Future<List<UserTitle>> getAllTitles() async {
    await _ensureInitialized();
    return _titlesBox!.values.toList();
  }

  @override
  Future<void> saveTitle(UserTitle title) async {
    await _ensureInitialized();
    await _titlesBox!.put(title.id, title);
  }

  @override
  Future<void> deleteTitle(String id) async {
    await _ensureInitialized();
    await _titlesBox!.delete(id);
  }

  @override
  Stream<List<UserTitle>> watchAllTitles() async* {
    await _ensureInitialized();
    yield _titlesBox!.values.toList();
    yield* _titlesBox!.watch().map((_) => _titlesBox!.values.toList());
  }
}
