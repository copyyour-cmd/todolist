import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/title.dart';
import 'package:todolist/src/features/gamification/application/gamification_providers.dart';

/// 称号页面
class TitlesPage extends ConsumerWidget {
  const TitlesPage({super.key});

  static const routePath = '/gamification/titles';
  static const routeName = 'titles';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final titlesAsync = ref.watch(allTitlesProvider);
    final statsAsync = ref.watch(userStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text('👑'), SizedBox(width: 8), Text('称号系统')],
        ),
      ),
      body: titlesAsync.when(
        data: (titles) {
          if (titles.isEmpty) {
            return const Center(child: Text('暂无称号'));
          }

          return statsAsync.when(
            data: (stats) {
              final equippedTitleId = stats?.equippedTitleId;

              // 按类别分组
              final categoryGroups = <TitleCategory, List<UserTitle>>{};
              for (final title in titles) {
                categoryGroups.putIfAbsent(title.category, () => []).add(title);
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 当前装备的称号
                  if (equippedTitleId != null) ...[
                    Text(
                      '当前称号',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _EquippedTitleCard(
                      title: titles.firstWhere((t) => t.id == equippedTitleId),
                      onUnequip: () async {
                        await ref.read(gamificationServiceProvider).unequipTitle();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已卸下称号')),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // 各类别称号
                  for (final category in TitleCategory.values)
                    if (categoryGroups.containsKey(category)) ...[
                      Text(
                        _getCategoryName(category),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...categoryGroups[category]!.map((title) {
                        final isEquipped = title.id == equippedTitleId;
                        return _TitleCard(
                          title: title,
                          isEquipped: isEquipped,
                          onEquip: title.isUnlocked && !isEquipped
                              ? () async {
                                  await ref
                                      .read(gamificationServiceProvider)
                                      .equipTitle(title.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('已装备「${title.name}」')),
                                    );
                                  }
                                }
                              : null,
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('加载失败')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败: $error')),
      ),
    );
  }

  String _getCategoryName(TitleCategory category) {
    switch (category) {
      case TitleCategory.achievement:
        return '🏆 成就称号';
      case TitleCategory.time:
        return '⏰ 时间称号';
      case TitleCategory.special:
        return '⭐ 特殊称号';
      case TitleCategory.social:
        return '👥 社交称号';
    }
  }
}

class _EquippedTitleCard extends StatelessWidget {
  const _EquippedTitleCard({
    required this.title,
    required this.onUnequip,
  });

  final UserTitle title;
  final VoidCallback onUnequip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getRarityColor(title.rarity).withOpacity(0.2),
              _getRarityColor(title.rarity).withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          _getRarityColor(title.rarity),
                          _getRarityColor(title.rarity).withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        title.icon,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getRarityColor(title.rarity),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getRarityColor(title.rarity),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getRarityName(title.rarity),
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
                          title.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (title.pointsBonus > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.bolt,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '积分加成 +${title.pointsBonus}%',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onUnequip,
                  icon: const Icon(Icons.close),
                  label: const Text('卸下称号'),
                ),
              ),
            ],
          ),
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

class _TitleCard extends StatelessWidget {
  const _TitleCard({
    required this.title,
    required this.isEquipped,
    this.onEquip,
  });

  final UserTitle title;
  final bool isEquipped;
  final VoidCallback? onEquip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlocked = title.isUnlocked;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.5,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 56,
            height: 56,
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
                isUnlocked ? title.icon : '🔒',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          title: Row(
            children: [
              Text(
                isUnlocked ? title.name : '???',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? _getRarityColor(title.rarity) : null,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getRarityColor(title.rarity),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _getRarityName(title.rarity),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isEquipped) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(isUnlocked ? title.description : '未解锁'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.flag, size: 14, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    title.requiredCondition ?? '完成条件未知',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (isUnlocked && title.pointsBonus > 0) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.bolt, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '积分加成 +${title.pointsBonus}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          trailing: onEquip != null
              ? ElevatedButton(
                  onPressed: onEquip,
                  child: const Text('装备'),
                )
              : null,
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
