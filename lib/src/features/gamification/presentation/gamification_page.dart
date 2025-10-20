import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/core/design/spacing.dart';
import 'package:todolist/src/core/design/gamification_colors.dart';
import 'package:todolist/src/features/gamification/application/gamification_providers.dart';
import 'package:todolist/src/features/gamification/presentation/achievements_page.dart';
import 'package:todolist/src/features/gamification/presentation/badges_page.dart';
import 'package:todolist/src/features/gamification/presentation/challenges_page.dart';
import 'package:todolist/src/features/gamification/presentation/widgets/daily_checkin_card.dart';
import 'package:todolist/src/features/gamification/presentation/widgets/lucky_draw_card.dart';
import 'package:todolist/src/features/gamification/presentation/widgets/titles_card.dart';

/// 游戏化主页 - 采用F-layout和三层视觉层次设计
/// 优化后的视觉设计：统一间距、圆角、阴影系统
class GamificationPage extends ConsumerStatefulWidget {
  const GamificationPage({super.key});

  static const routePath = '/gamification';
  static const routeName = 'gamification';

  @override
  ConsumerState<GamificationPage> createState() => _GamificationPageState();
}

class _GamificationPageState extends ConsumerState<GamificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(userStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text('🏆'), SizedBox(width: 8), Text('游戏化')],
        ),
      ),
      body: statsAsync.when(
        data: (stats) {
          if (stats == null) {
            return const Center(child: Text('正在初始化...'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(GamificationSpacing.pageHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ========== Tier 1: Hero区域 ==========
                _HeroCard(stats: stats),
                SizedBox(height: GamificationSpacing.sectionSpacing),

                // ========== Tier 2: 每日互动区 ==========
                _DailyTasksSection(),
                SizedBox(height: GamificationSpacing.sectionSpacing),

                // ========== Tier 3: 数据总览 ==========
                _CompactStatsGrid(stats: stats),
                SizedBox(height: GamificationSpacing.sectionSpacing),

                // ========== Tier 3: 进度系统Tab ==========
                _ProgressSystemTabs(tabController: _tabController),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败: $error')),
      ),
    );
  }
}

/// Tier 1: Hero卡片 - 用户等级和积分（高视觉权重）带微动画
class _HeroCard extends StatefulWidget {
  const _HeroCard({required this.stats});

  final dynamic stats;

  @override
  State<_HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<_HeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        );
      },
      child: Container(
        height: CardDimensions.heroCardHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.heroGradientStart,
              theme.colorScheme.heroGradientEnd,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(GamificationSpacing.radiusXLarge),
          boxShadow: GamificationElevation.heroShadow(context),
        ),
        padding: EdgeInsets.all(GamificationSpacing.cardPaddingHero),
        child: Row(
          children: [
            // 等级圆环
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  'Lv.${widget.stats.level}',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.heroTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            SizedBox(width: GamificationSpacing.lg),

            // 积分和进度
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 总积分
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '总积分',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.heroTextColor.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: 0, end: widget.stats.totalPoints as int),
                        duration: const Duration(milliseconds: 800),
                        builder: (context, value, child) {
                          return Text(
                            '$value',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.heroTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: GamificationSpacing.xs),

                  // 升级进度
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '升级进度',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.heroTextColor.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${(widget.stats.levelProgress * 100).toInt()}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.heroTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: GamificationSpacing.xxs),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: (widget.stats.levelProgress as num?)?.toDouble() ?? 0.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(GamificationSpacing.radiusSmall),
                            child: LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.heroTextColor,
                              ),
                              minHeight: 6,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: GamificationSpacing.xxs),
                      Text(
                        '距离 Lv.${widget.stats.level + 1} 还需 ${widget.stats.nextLevelPoints - widget.stats.totalPoints} 积分',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.heroTextColor.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tier 2: 每日任务区域 - 签到和抽奖纵向排列
/// 每个卡片占一行，避免拥挤
class _DailyTasksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DailyCheckInCard(),
        SizedBox(height: GamificationSpacing.gridSpacing),
        LuckyDrawCard(),
      ],
    );
  }
}

/// Tier 3: 紧凑型统计网格 - 2x2布局，等高设计
class _CompactStatsGrid extends StatelessWidget {
  const _CompactStatsGrid({required this.stats});

  final dynamic stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _CompactStatCard(
                icon: Icons.check_circle_outline,
                label: '完成任务',
                value: '${stats.totalTasksCompleted}',
                color: StatCardColors.tasksCompleted,
              ),
            ),
            SizedBox(width: GamificationSpacing.gridSpacing),
            Expanded(
              child: _CompactStatCard(
                icon: Icons.local_fire_department_outlined,
                label: '连续打卡',
                value: '${stats.currentStreak}天',
                color: StatCardColors.currentStreak,
              ),
            ),
          ],
        ),
        SizedBox(height: GamificationSpacing.gridSpacing),
        Row(
          children: [
            Expanded(
              child: _CompactStatCard(
                icon: Icons.access_time_outlined,
                label: '专注时长',
                value: '${stats.totalFocusMinutes ~/ 60}h',
                color: StatCardColors.focusTime,
              ),
            ),
            SizedBox(width: GamificationSpacing.gridSpacing),
            Expanded(
              child: _CompactStatCard(
                icon: Icons.emoji_events_outlined,
                label: '最长连续',
                value: '${stats.longestStreak}天',
                color: StatCardColors.longestStreak,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 紧凑型统计卡片 - 带交互和动画，固定高度
class _CompactStatCard extends StatefulWidget {
  const _CompactStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  State<_CompactStatCard> createState() => _CompactStatCardState();
}

class _CompactStatCardState extends State<_CompactStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.label}: ${widget.value}'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: AnimatedScale(
        scale: _scaleAnimation.value,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: CardDimensions.statCardHeight,
          padding: EdgeInsets.all(GamificationSpacing.md),
          decoration: BoxDecoration(
            color: _isPressed
                ? widget.color.withValues(alpha: 0.1)
                : theme.colorScheme.statsBackground,
            borderRadius: BorderRadius.circular(GamificationSpacing.radiusMedium),
            border: Border.all(
              color: _isPressed
                  ? widget.color.withValues(alpha: 0.6)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: _isPressed ? 2 : 1,
            ),
            boxShadow: _isPressed
                ? GamificationElevation.cardShadowMedium(context)
                : GamificationElevation.cardShadowLow(context),
          ),
          child: Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Icon(
                      widget.icon,
                      size: CardDimensions.statCardIconSize,
                      color: widget.color,
                    ),
                  );
                },
              ),
              SizedBox(width: GamificationSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 400),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Text(
                            widget.value,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: widget.color,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: GamificationSpacing.xxs),
                    Text(
                      widget.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.statsIconColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tier 3: 进度系统Tab - 整合成就、徽章、挑战、称号
class _ProgressSystemTabs extends StatelessWidget {
  const _ProgressSystemTabs({required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Tab导航栏
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(GamificationSpacing.radiusMedium),
          ),
          child: TabBar(
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(GamificationSpacing.radiusMedium),
            ),
            labelColor: theme.colorScheme.onPrimary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            tabs: const [
              Tab(text: '成就'),
              Tab(text: '徽章'),
              Tab(text: '挑战'),
              Tab(text: '称号'),
            ],
          ),
        ),
        SizedBox(height: GamificationSpacing.md),

        // Tab内容区域 - 带淡入动画
        SizedBox(
          height: CardDimensions.tabContentHeight,
          child: TabBarView(
            controller: tabController,
            children: [
              _FadeInWrapper(child: _AchievementsTab()),
              _FadeInWrapper(child: _BadgesTab()),
              _FadeInWrapper(child: _ChallengesTab()),
              _FadeInWrapper(child: _TitlesTab()),
            ],
          ),
        ),
      ],
    );
  }
}

/// 成就Tab内容
class _AchievementsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final achievementsAsync = ref.watch(inProgressAchievementsProvider);

    return achievementsAsync.when(
      data: (achievements) {
        if (achievements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                SizedBox(height: GamificationSpacing.md),
                Text(
                  '暂无进行中的成就',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: GamificationSpacing.sm),
                TextButton.icon(
                  onPressed: () => context.push(AchievementsPage.routePath),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('查看全部成就'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return Card(
              margin: EdgeInsets.only(bottom: GamificationSpacing.xs),
              child: ListTile(
                leading: Text(
                  achievement.icon,
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(achievement.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement.progressText,
                      style: theme.textTheme.bodySmall,
                    ),
                    SizedBox(height: GamificationSpacing.xxs),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(GamificationSpacing.xxs),
                      child: LinearProgressIndicator(
                        value: achievement.progress,
                        backgroundColor: theme.colorScheme.progressBackground,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  '+${achievement.pointsReward}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.statsValueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => context.push(AchievementsPage.routePath),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('加载失败')),
    );
  }
}

/// 徽章Tab内容
class _BadgesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final badgesAsync = ref.watch(allBadgesProvider);

    return badgesAsync.when(
      data: (badges) {
        if (badges.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.military_tech_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                SizedBox(height: GamificationSpacing.md),
                Text(
                  '暂无徽章',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: GamificationSpacing.sm),
                TextButton.icon(
                  onPressed: () => context.push(BadgesPage.routePath),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('查看全部徽章'),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: GamificationSpacing.gridSpacing,
            mainAxisSpacing: GamificationSpacing.gridSpacing,
            childAspectRatio: 0.85,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];
            final color = Color(
              int.parse(badge.rarityColor.substring(1), radix: 16) + 0xFF000000,
            );

            return Card(
              color: color.withValues(alpha: 0.1),
              child: InkWell(
                onTap: () => context.push(BadgesPage.routePath),
                borderRadius: BorderRadius.circular(GamificationSpacing.radiusMedium),
                child: Padding(
                  padding: EdgeInsets.all(GamificationSpacing.sm),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: badge.isUnlocked ? 1.0 : 0.3,
                        child: Text(
                          badge.icon,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                      SizedBox(height: GamificationSpacing.xs),
                      Text(
                        badge.name,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('加载失败')),
    );
  }
}

/// 挑战Tab内容
class _ChallengesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final challengesAsync = ref.watch(activeChallengesProvider);

    return challengesAsync.when(
      data: (challenges) {
        if (challenges.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flag_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                SizedBox(height: GamificationSpacing.md),
                Text(
                  '暂无活跃挑战',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: GamificationSpacing.sm),
                TextButton.icon(
                  onPressed: () => context.push(ChallengesPage.routePath),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('查看全部挑战'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final challenge = challenges[index];
            return Card(
              margin: EdgeInsets.only(bottom: GamificationSpacing.xs),
              child: ListTile(
                title: Text(challenge.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${challenge.periodName} • ${challenge.daysRemaining}天剩余',
                      style: theme.textTheme.bodySmall,
                    ),
                    SizedBox(height: GamificationSpacing.xxs),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(GamificationSpacing.xxs),
                            child: LinearProgressIndicator(
                              value: challenge.progress,
                              backgroundColor: theme.colorScheme.progressBackground,
                              minHeight: 6,
                            ),
                          ),
                        ),
                        SizedBox(width: GamificationSpacing.xs),
                        Text(
                          challenge.progressText,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Text(
                  '+${challenge.pointsReward}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.statsValueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => context.push(ChallengesPage.routePath),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('加载失败')),
    );
  }
}

/// 称号Tab内容
class _TitlesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          SizedBox(height: GamificationSpacing.md),
          Text(
            '称号系统',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: GamificationSpacing.sm),
          TitlesCard(),
        ],
      ),
    );
  }
}

/// Tab切换淡入包装器 - 为Tab内容添加平滑的淡入过渡效果
class _FadeInWrapper extends StatefulWidget {
  const _FadeInWrapper({required this.child});

  final Widget child;

  @override
  State<_FadeInWrapper> createState() => _FadeInWrapperState();
}

class _FadeInWrapperState extends State<_FadeInWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}
