import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/gamification/application/gamification_providers.dart';

/// 徽章页面
class BadgesPage extends ConsumerWidget {
  const BadgesPage({super.key});

  static const routePath = '/gamification/badges';
  static const routeName = 'badges';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final badgesAsync = ref.watch(allBadgesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('徽章'),
      ),
      body: badgesAsync.when(
        data: (badges) {
          if (badges.isEmpty) {
            return const Center(child: Text('暂无徽章'));
          }

          // 按类别分组
          final taskBadges = badges.where((b) => b.category.name == 'tasks').toList();
          final focusBadges = badges.where((b) => b.category.name == 'focus').toList();
          final streakBadges = badges.where((b) => b.category.name == 'streak').toList();
          final specialBadges = badges.where((b) => b.category.name == 'special').toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (taskBadges.isNotEmpty) ...[
                Text(
                  '任务相关',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _BadgeGrid(badges: taskBadges),
                const SizedBox(height: 24),
              ],
              if (focusBadges.isNotEmpty) ...[
                Text(
                  '专注相关',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _BadgeGrid(badges: focusBadges),
                const SizedBox(height: 24),
              ],
              if (streakBadges.isNotEmpty) ...[
                Text(
                  '连续打卡',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _BadgeGrid(badges: streakBadges),
                const SizedBox(height: 24),
              ],
              if (specialBadges.isNotEmpty) ...[
                Text(
                  '特殊成就',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _BadgeGrid(badges: specialBadges),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败: $error')),
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  const _BadgeGrid({required this.badges});

  final List<dynamic> badges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        final rarityColor = (badge as dynamic).rarityColor as String;
        final color = Color(
          int.parse(rarityColor.substring(1), radix: 16) + 0xFF000000,
        );
        final isUnlocked = badge.isUnlocked as bool;
        final icon = badge.icon as String;
        final name = badge.name as String;
        final rarityName = badge.rarityName as String;

        return GestureDetector(
          onTap: () => _showBadgeDetail(context, badge),
          child: Card(
            color: color.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: isUnlocked ? 1.0 : 0.3,
                    child: Text(
                      icon,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      rarityName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBadgeDetail(BuildContext context, dynamic badge) {
    final icon = (badge as dynamic).icon as String;
    final name = badge.name as String;
    final description = badge.description as String;
    final rarityName = badge.rarityName as String;
    final rarityColor = badge.rarityColor as String;
    final isUnlocked = badge.isUnlocked as bool;
    final unlockedAt = badge.unlockedAt as DateTime?;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '稀有度: $rarityName',
                  style: TextStyle(
                    color: Color(
                      int.parse(rarityColor.substring(1), radix: 16) + 0xFF000000,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (isUnlocked) ...[
              const SizedBox(height: 12),
              Text(
                '已于 ${unlockedAt.toString().split('.')[0]} 解锁',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ] else ...[
              const SizedBox(height: 12),
              const Text('🔒 尚未解锁'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
