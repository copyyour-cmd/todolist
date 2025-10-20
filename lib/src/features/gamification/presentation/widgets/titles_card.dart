import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/domain/entities/title.dart';
import 'package:todolist/src/features/gamification/application/gamification_providers.dart';
import 'package:todolist/src/features/gamification/presentation/titles_page.dart';

/// 称号预览卡片
class TitlesCard extends ConsumerWidget {
  const TitlesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final titlesAsync = ref.watch(allTitlesProvider);
    final statsAsync = ref.watch(userStatsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('👑', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      '称号系统',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.push(TitlesPage.routePath),
                  child: const Text('查看全部'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            statsAsync.when(
              data: (stats) {
                if (stats == null) {
                  return const Text('加载中...');
                }

                return titlesAsync.when(
                  data: (titles) {
                    final unlockedCount = titles.where((t) => t.isUnlocked).length;
                    final totalCount = titles.length;
                    final equippedTitle = stats.equippedTitleId != null
                        ? titles.where((t) => t.id == stats.equippedTitleId).firstOrNull
                        : null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 当前装备的称号
                        if (equippedTitle != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getRarityColor(equippedTitle.rarity).withOpacity(0.2),
                                  _getRarityColor(equippedTitle.rarity).withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getRarityColor(equippedTitle.rarity),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  equippedTitle.icon,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            equippedTitle.name,
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: _getRarityColor(equippedTitle.rarity),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getRarityColor(equippedTitle.rarity),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              _getRarityName(equippedTitle.rarity),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        equippedTitle.description,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ] else ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.outline.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text('❓', style: TextStyle(fontSize: 32)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '暂未装备称号',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // 解锁进度
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '已解锁称号',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '$unlockedCount / $totalCount',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: totalCount > 0 ? unlockedCount / totalCount : 0,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 16),

                        // 最近解锁的称号
                        if (unlockedCount > 0) ...[
                          Text(
                            '最近解锁',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: titles.where((t) => t.isUnlocked).take(5).length,
                              itemBuilder: (context, index) {
                                final unlockedTitles =
                                    titles.where((t) => t.isUnlocked).toList()
                                      ..sort((a, b) =>
                                          (b.unlockedAt ?? DateTime(0))
                                              .compareTo(a.unlockedAt ?? DateTime(0)));
                                final title = unlockedTitles[index];

                                return Container(
                                  width: 60,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getRarityColor(title.rarity).withOpacity(0.2),
                                    border: Border.all(
                                      color: _getRarityColor(title.rarity),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      title.icon,
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('加载失败'),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('加载失败'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(TitleRarity rarity) {
    switch (rarity) {
      case TitleRarity.common:
        return Colors.grey;
      case TitleRarity.rare:
        return Colors.blue;
      case TitleRarity.epic:
        return Colors.purple;
      case TitleRarity.legendary:
        return Colors.amber;
    }
  }

  String _getRarityName(TitleRarity rarity) {
    switch (rarity) {
      case TitleRarity.common:
        return '普通';
      case TitleRarity.rare:
        return '稀有';
      case TitleRarity.epic:
        return '史诗';
      case TitleRarity.legendary:
        return '传说';
    }
  }
}
