import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/achievement.dart';
import 'package:todolist/src/domain/entities/badge.dart';
import 'package:todolist/src/domain/entities/challenge.dart';
import 'package:todolist/src/domain/entities/user_stats.dart';
import 'package:todolist/src/domain/entities/title.dart';
import 'package:todolist/src/domain/repositories/gamification_repository.dart';
import 'package:todolist/src/features/gamification/application/gamification_service.dart';
import 'package:todolist/src/infrastructure/repositories/hive_gamification_repository.dart';

part 'gamification_providers.g.dart';

/// 游戏化仓储Provider
@riverpod
GamificationRepository gamificationRepository(GamificationRepositoryRef ref) {
  return HiveGamificationRepository();
}

/// 游戏化服务Provider
@riverpod
GamificationService gamificationService(GamificationServiceRef ref) {
  return GamificationService(
    repository: ref.watch(gamificationRepositoryProvider),
    clock: const SystemClock(),
    idGenerator: IdGenerator(),
  );
}

/// 用户统计Provider
@riverpod
Stream<UserStats?> userStats(UserStatsRef ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.watchUserStats();
}

/// 所有徽章Provider
@riverpod
Stream<List<Badge>> allBadges(AllBadgesRef ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.watchAllBadges();
}

/// 已解锁徽章Provider
@riverpod
Stream<List<Badge>> unlockedBadges(UnlockedBadgesRef ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.watchAllBadges().map(
        (badges) => badges.where((badge) => badge.isUnlocked).toList(),
      );
}

/// 所有成就Provider
@riverpod
Stream<List<Achievement>> allAchievements(AllAchievementsRef ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.watchAllAchievements();
}

/// 已解锁成就Provider
@riverpod
Stream<List<Achievement>> unlockedAchievements(UnlockedAchievementsRef ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.watchAllAchievements().map(
        (achievements) => achievements.where((a) => a.isUnlocked).toList(),
      );
}

/// 进行中的成就Provider
@riverpod
Stream<List<Achievement>> inProgressAchievements(
    InProgressAchievementsRef ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.watchAllAchievements().map(
        (achievements) => achievements
            .where((a) => !a.isUnlocked && a.currentValue > 0)
            .toList(),
      );
}

/// 所有挑战Provider
@riverpod
Stream<List<Challenge>> allChallenges(AllChallengesRef ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.watchAllChallenges();
}

/// 活跃挑战Provider
@riverpod
Stream<List<Challenge>> activeChallenges(ActiveChallengesRef ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.watchAllChallenges().map(
        (challenges) => challenges.where((c) => c.isActive).toList(),
      );
}

/// 已完成挑战Provider
@riverpod
Stream<List<Challenge>> completedChallenges(CompletedChallengesRef ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.watchAllChallenges().map(
        (challenges) => challenges.where((c) => c.isCompleted).toList(),
      );
}

/// 所有称号Provider
@riverpod
Stream<List<UserTitle>> allTitles(AllTitlesRef ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.watchAllTitles();
}

/// 已解锁称号Provider
@riverpod
Stream<List<UserTitle>> unlockedTitles(UnlockedTitlesRef ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.watchAllTitles().map(
        (titles) => titles.where((t) => t.isUnlocked).toList(),
      );
}

/// 当前装备称号Provider
@riverpod
Future<UserTitle?> equippedTitle(EquippedTitleRef ref) async {
  final stats = await ref.watch(userStatsProvider.future);
  if (stats?.equippedTitleId == null) {
    return null;
  }

  final titles = await ref.watch(allTitlesProvider.future);
  return titles.where((t) => t.id == stats!.equippedTitleId).firstOrNull;
}
