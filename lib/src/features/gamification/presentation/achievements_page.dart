import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/gamification/application/gamification_providers.dart';

/// 成就页面
class AchievementsPage extends ConsumerStatefulWidget {
  const AchievementsPage({super.key});

  static const routePath = '/gamification/achievements';
  static const routeName = 'achievements';

  @override
  ConsumerState<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends ConsumerState<AchievementsPage> {
  String _filter = 'all'; // all, unlocked, inProgress

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final achievementsAsync = _filter == 'unlocked'
        ? ref.watch(unlockedAchievementsProvider)
        : _filter == 'inProgress'
            ? ref.watch(inProgressAchievementsProvider)
            : ref.watch(allAchievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('成就'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => _filter = value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'all',
                child: Text('全部'),
              ),
              PopupMenuItem(
                value: 'unlocked',
                child: Text('已解锁'),
              ),
              PopupMenuItem(
                value: 'inProgress',
                child: Text('进行中'),
              ),
            ],
          ),
        ],
      ),
      body: achievementsAsync.when(
        data: (achievements) {
          if (achievements.isEmpty) {
            return const Center(child: Text('暂无成就'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: achievement.isUnlocked
                    ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                    : null,
                child: ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: achievement.isUnlocked
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Opacity(
                        opacity: achievement.isUnlocked ? 1.0 : 0.3,
                        child: Text(
                          achievement.icon,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(child: Text(achievement.name)),
                      if (achievement.isUnlocked)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(achievement.description),
                      const SizedBox(height: 8),
                      if (!achievement.isUnlocked) ...[
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: achievement.progress,
                                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              achievement.progressText,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.stars,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+${achievement.pointsReward} 积分',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (achievement.badgeReward != null) ...[
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.military_tech,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '徽章',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                      if (achievement.isUnlocked && achievement.unlockedAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '已于 ${achievement.unlockedAt!.toString().split('.')[0]} 解锁',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败: $error')),
      ),
    );
  }
}
