import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/haptic_feedback_helper.dart';
import 'package:todolist/src/features/gamification/application/gamification_providers.dart';
import 'package:todolist/src/domain/entities/lucky_draw.dart';

/// 幸运抽奖卡片
class LuckyDrawCard extends ConsumerStatefulWidget {
  const LuckyDrawCard({super.key});

  @override
  ConsumerState<LuckyDrawCard> createState() => _LuckyDrawCardState();
}

class _LuckyDrawCardState extends ConsumerState<LuckyDrawCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _wheelController;
  late Animation<double> _wheelRotation;
  bool _isDrawing = false;

  @override
  void initState() {
    super.initState();
    _wheelController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _wheelRotation = Tween<double>(begin: 0, end: 8 * math.pi).animate(
      CurvedAnimation(
        parent: _wheelController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _wheelController.dispose();
    super.dispose();
  }

  Future<void> _performDraw({required bool isFree}) async {
    if (_isDrawing) return;

    setState(() => _isDrawing = true);
    HapticFeedbackHelper.medium();

    try {
      final service = ref.read(gamificationServiceProvider);

      // 开始转盘动画
      _wheelController.reset();
      _wheelController.forward();

      // 执行抽奖
      final prize = isFree
          ? await service.performFreeDraw()
          : await service.performPaidDraw();

      // 等待动画完成
      await _wheelController.forward();

      if (mounted) {
        HapticFeedbackHelper.success();
        _showPrizeDialog(prize);
      }
    } catch (e) {
      if (mounted) {
        HapticFeedbackHelper.error();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDrawing = false);
      }
    }
  }

  void _showPrizeDialog(PrizeConfig prize) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PrizeDialog(prize: prize),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(userStatsProvider);
    final service = ref.watch(gamificationServiceProvider);

    return statsAsync.when(
      data: (stats) {
        if (stats == null) return const SizedBox.shrink();

        return FutureBuilder<List<dynamic>>(
          future: Future.wait([
            service.getLuckyDrawStats(),
            service.getAllPrizes(),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            final drawStats = snapshot.data![0] as Map<String, dynamic>;
            final prizes = snapshot.data![1] as List<PrizeConfig>;

            final hasFreeDrawToday = drawStats['hasFreeDrawToday'] as bool;
            final pityCounter = drawStats['pityCounter'] as int;
            final nextRarePity = drawStats['nextRarePity'] as int;
            final nextLegendaryPity = drawStats['nextLegendaryPity'] as int;
            final hasPrizes = prizes.isNotEmpty;

            return Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 标题行
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.casino,
                            color: Colors.purple,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '幸运抽奖',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.stars,
                                    color: Colors.purple,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '已抽 $pityCounter 次',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.purple,
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

                    const SizedBox(height: 10),

                    // 简化的转盘动画
                    Center(
                      child: AnimatedBuilder(
                        animation: _wheelRotation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _wheelRotation.value,
                            child: child,
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary,
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '🎰',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 紧凑型保底进度
                    _buildCompactPityProgress(nextRarePity, nextLegendaryPity, theme),

                    const SizedBox(height: 12),

                    // 抽奖按钮
                    Row(
                      children: [
                        // 免费抽奖
                        Expanded(
                          child: ElevatedButton(
                            onPressed: hasFreeDrawToday && !_isDrawing && hasPrizes
                                ? () => _performDraw(isFree: true)
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: hasFreeDrawToday && hasPrizes
                                  ? Colors.green
                                  : theme.colorScheme.surfaceContainerHighest,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isDrawing
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.card_giftcard, size: 20),
                                      const SizedBox(height: 4),
                                      Text(
                                        hasFreeDrawToday ? '免费' : '已用',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 付费抽奖
                        Expanded(
                          child: ElevatedButton(
                            onPressed: !_isDrawing && hasPrizes
                                ? () => _performDraw(isFree: false)
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.diamond, size: 20),
                                const SizedBox(height: 4),
                                Text(
                                  '50积分',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// 紧凑型保底进度显示
  Widget _buildCompactPityProgress(int nextRare, int nextLegendary, ThemeData theme) {
    // 显示最近的保底信息
    final closestPity = nextRare < nextLegendary ? nextRare : nextLegendary;
    final isPityRare = nextRare < nextLegendary;
    final pityColor = isPityRare ? Colors.blue : Colors.orange;
    final pityName = isPityRare ? '稀有' : '传说';
    final pityMax = isPityRare ? 10 : 50;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: pityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: pityColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPityRare ? Icons.shield : Icons.auto_awesome,
                    color: pityColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$pityName保底',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: pityColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Text(
                closestPity <= 0 ? '已触发!' : '还需 $closestPity 抽',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: pityColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: closestPity <= 0 ? 1.0 : (pityMax - closestPity) / pityMax,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(pityColor),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPityIndicators(int nextRare, int nextLegendary, ThemeData theme) {
    return Column(
      children: [
        // 稀有保底
        Row(
          children: [
            Icon(
              Icons.shield,
              color: Colors.blue,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '稀有保底',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: nextRare <= 0 ? 1.0 : (10 - nextRare) / 10,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              nextRare <= 0 ? '已触发!' : '$nextRare抽',
              style: TextStyle(
                color: nextRare <= 0 ? Colors.blue : theme.colorScheme.onSurfaceVariant,
                fontWeight: nextRare <= 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 传说保底
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '传说保底',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: nextLegendary <= 0 ? 1.0 : (50 - nextLegendary) / 50,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              nextLegendary <= 0 ? '已触发!' : '$nextLegendary抽',
              style: TextStyle(
                color: nextLegendary <= 0 ? Colors.orange : theme.colorScheme.onSurfaceVariant,
                fontWeight: nextLegendary <= 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrizePool(List<PrizeConfig> prizes, ThemeData theme) {
    // 如果奖品池为空，显示提示信息
    if (prizes.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '奖品池',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '奖品池暂未初始化，抽奖功能暂时不可用',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final rarityGroups = <PrizeRarity, List<PrizeConfig>>{};
    for (final prize in prizes) {
      rarityGroups.putIfAbsent(prize.rarity, () => []).add(prize);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '奖品池',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...PrizeRarity.values.reversed.map((rarity) {
          final rarityPrizes = rarityGroups[rarity] ?? [];
          if (rarityPrizes.isEmpty) return const SizedBox.shrink();

          final color = Color(
            int.parse(rarity.color.substring(1), radix: 16) + 0xFF000000,
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: rarityPrizes.map((prize) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(prize.icon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text(
                        prize.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}

/// 奖品展示对话框
class _PrizeDialog extends StatelessWidget {
  const _PrizeDialog({required this.prize});

  final PrizeConfig prize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rarityColor = Color(
      int.parse(prize.rarity.color.substring(1), radix: 16) + 0xFF000000,
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              rarityColor.withOpacity(0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 稀有度标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: rarityColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                prize.rarity.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 奖品图标
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: rarityColor.withOpacity(0.2),
                border: Border.all(color: rarityColor, width: 3),
              ),
              child: Center(
                child: Text(
                  prize.icon,
                  style: const TextStyle(fontSize: 60),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 奖品名称
            Text(
              prize.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: rarityColor,
              ),
            ),
            const SizedBox(height: 8),

            // 奖品描述
            Text(
              prize.description,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 关闭按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: rarityColor,
                ),
                child: const Text(
                  '太棒了!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
