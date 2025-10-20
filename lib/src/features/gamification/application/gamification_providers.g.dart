// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gamificationRepositoryHash() =>
    r'6fbfce8d3b8e56fcddefbb78a4ae19f1a97738d4';

/// 游戏化仓储Provider
///
/// Copied from [gamificationRepository].
@ProviderFor(gamificationRepository)
final gamificationRepositoryProvider =
    AutoDisposeProvider<GamificationRepository>.internal(
  gamificationRepository,
  name: r'gamificationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gamificationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GamificationRepositoryRef
    = AutoDisposeProviderRef<GamificationRepository>;
String _$gamificationServiceHash() =>
    r'017cfe5e89e64e7ed1685adc744b77bfab37d9eb';

/// 游戏化服务Provider
///
/// Copied from [gamificationService].
@ProviderFor(gamificationService)
final gamificationServiceProvider =
    AutoDisposeProvider<GamificationService>.internal(
  gamificationService,
  name: r'gamificationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gamificationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GamificationServiceRef = AutoDisposeProviderRef<GamificationService>;
String _$userStatsHash() => r'4925dd4f434c1575d26fcf4da89c1bfafce9431c';

/// 用户统计Provider
///
/// Copied from [userStats].
@ProviderFor(userStats)
final userStatsProvider = AutoDisposeStreamProvider<UserStats?>.internal(
  userStats,
  name: r'userStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserStatsRef = AutoDisposeStreamProviderRef<UserStats?>;
String _$allBadgesHash() => r'fcc9e2ac999fcae698d417cbcd116d5adb46b142';

/// 所有徽章Provider
///
/// Copied from [allBadges].
@ProviderFor(allBadges)
final allBadgesProvider = AutoDisposeStreamProvider<List<Badge>>.internal(
  allBadges,
  name: r'allBadgesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allBadgesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllBadgesRef = AutoDisposeStreamProviderRef<List<Badge>>;
String _$unlockedBadgesHash() => r'4786d48afb9260fe8726b44fa2f8e41e6f0963d6';

/// 已解锁徽章Provider
///
/// Copied from [unlockedBadges].
@ProviderFor(unlockedBadges)
final unlockedBadgesProvider = AutoDisposeStreamProvider<List<Badge>>.internal(
  unlockedBadges,
  name: r'unlockedBadgesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unlockedBadgesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UnlockedBadgesRef = AutoDisposeStreamProviderRef<List<Badge>>;
String _$allAchievementsHash() => r'27b4d306413f685ebdb3be156d83927398eb598f';

/// 所有成就Provider
///
/// Copied from [allAchievements].
@ProviderFor(allAchievements)
final allAchievementsProvider =
    AutoDisposeStreamProvider<List<Achievement>>.internal(
  allAchievements,
  name: r'allAchievementsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allAchievementsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllAchievementsRef = AutoDisposeStreamProviderRef<List<Achievement>>;
String _$unlockedAchievementsHash() =>
    r'227c29ed2eeff4e74ee91031858aaf33745d43de';

/// 已解锁成就Provider
///
/// Copied from [unlockedAchievements].
@ProviderFor(unlockedAchievements)
final unlockedAchievementsProvider =
    AutoDisposeStreamProvider<List<Achievement>>.internal(
  unlockedAchievements,
  name: r'unlockedAchievementsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unlockedAchievementsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UnlockedAchievementsRef
    = AutoDisposeStreamProviderRef<List<Achievement>>;
String _$inProgressAchievementsHash() =>
    r'f501cfc43d06ac7a90abf196d608e873d2e0b37b';

/// 进行中的成就Provider
///
/// Copied from [inProgressAchievements].
@ProviderFor(inProgressAchievements)
final inProgressAchievementsProvider =
    AutoDisposeStreamProvider<List<Achievement>>.internal(
  inProgressAchievements,
  name: r'inProgressAchievementsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inProgressAchievementsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InProgressAchievementsRef
    = AutoDisposeStreamProviderRef<List<Achievement>>;
String _$allChallengesHash() => r'055766fe8ac50ea141b4ccf9aedf9e5727fede35';

/// 所有挑战Provider
///
/// Copied from [allChallenges].
@ProviderFor(allChallenges)
final allChallengesProvider =
    AutoDisposeStreamProvider<List<Challenge>>.internal(
  allChallenges,
  name: r'allChallengesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allChallengesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllChallengesRef = AutoDisposeStreamProviderRef<List<Challenge>>;
String _$activeChallengesHash() => r'5659c3b4ab7dc21f7fcd899f0eb667895276ad3b';

/// 活跃挑战Provider
///
/// Copied from [activeChallenges].
@ProviderFor(activeChallenges)
final activeChallengesProvider =
    AutoDisposeStreamProvider<List<Challenge>>.internal(
  activeChallenges,
  name: r'activeChallengesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeChallengesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActiveChallengesRef = AutoDisposeStreamProviderRef<List<Challenge>>;
String _$completedChallengesHash() =>
    r'a461fdeba54f675abd95040ea4234408b97e338a';

/// 已完成挑战Provider
///
/// Copied from [completedChallenges].
@ProviderFor(completedChallenges)
final completedChallengesProvider =
    AutoDisposeStreamProvider<List<Challenge>>.internal(
  completedChallenges,
  name: r'completedChallengesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedChallengesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CompletedChallengesRef = AutoDisposeStreamProviderRef<List<Challenge>>;
String _$allTitlesHash() => r'ebd7842bb4efa20558fd2d28d2e70fe27298fc97';

/// 所有称号Provider
///
/// Copied from [allTitles].
@ProviderFor(allTitles)
final allTitlesProvider = AutoDisposeStreamProvider<List<UserTitle>>.internal(
  allTitles,
  name: r'allTitlesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTitlesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllTitlesRef = AutoDisposeStreamProviderRef<List<UserTitle>>;
String _$unlockedTitlesHash() => r'4b96e5631831444fb370fac796ef135df925ed5c';

/// 已解锁称号Provider
///
/// Copied from [unlockedTitles].
@ProviderFor(unlockedTitles)
final unlockedTitlesProvider =
    AutoDisposeStreamProvider<List<UserTitle>>.internal(
  unlockedTitles,
  name: r'unlockedTitlesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unlockedTitlesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UnlockedTitlesRef = AutoDisposeStreamProviderRef<List<UserTitle>>;
String _$equippedTitleHash() => r'724f0a8bb1fe1d1f09bed819c97bbe0085a4d968';

/// 当前装备称号Provider
///
/// Copied from [equippedTitle].
@ProviderFor(equippedTitle)
final equippedTitleProvider = AutoDisposeFutureProvider<UserTitle?>.internal(
  equippedTitle,
  name: r'equippedTitleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$equippedTitleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EquippedTitleRef = AutoDisposeFutureProviderRef<UserTitle?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
