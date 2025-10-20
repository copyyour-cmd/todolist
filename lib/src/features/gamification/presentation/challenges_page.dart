import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/gamification/application/gamification_providers.dart';

/// 挑战页面
class ChallengesPage extends ConsumerStatefulWidget {
  const ChallengesPage({super.key});

  static const routePath = '/gamification/challenges';
  static const routeName = 'challenges';

  @override
  ConsumerState<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends ConsumerState<ChallengesPage> {
  String _filter = 'active'; // active, completed, all

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final challengesAsync = _filter == 'active'
        ? ref.watch(activeChallengesProvider)
        : _filter == 'completed'
            ? ref.watch(completedChallengesProvider)
            : ref.watch(allChallengesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('挑战'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => _filter = value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'active',
                child: Text('进行中'),
              ),
              PopupMenuItem(
                value: 'completed',
                child: Text('已完成'),
              ),
              PopupMenuItem(
                value: 'all',
                child: Text('全部'),
              ),
            ],
          ),
        ],
      ),
      body: challengesAsync.when(
        data: (challenges) {
          if (challenges.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 80,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _filter == 'active' ? '暂无活跃挑战' : '暂无挑战',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          // 按周期分组
          final dailyChallenges = challenges.where((c) => c.period.name == 'daily').toList();
          final weeklyChallenges = challenges.where((c) => c.period.name == 'weekly').toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (dailyChallenges.isNotEmpty) ...[
                Text(
                  '每日挑战',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...dailyChallenges.map(
                  (challenge) => _ChallengeCard(challenge: challenge),
                ),
                const SizedBox(height: 24),
              ],
              if (weeklyChallenges.isNotEmpty) ...[
                Text(
                  '每周挑战',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...weeklyChallenges.map(
                  (challenge) => _ChallengeCard(challenge: challenge),
                ),
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

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.challenge});

  final dynamic challenge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = (challenge as dynamic).isCompleted as bool;
    final isExpired = challenge.isExpired as bool;
    final title = challenge.title as String;
    final description = challenge.description as String;
    final periodName = challenge.periodName as String;
    final daysRemaining = challenge.daysRemaining as int;
    final pointsReward = challenge.pointsReward as int;
    final progress = challenge.progress as double;
    final progressText = challenge.progressText as String;
    final completedAt = challenge.completedAt as DateTime?;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isCompleted
          ? theme.colorScheme.primaryContainer.withOpacity(0.3)
          : isExpired
              ? theme.colorScheme.errorContainer.withOpacity(0.3)
              : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                else if (isExpired)
                  Icon(
                    Icons.cancel,
                    color: theme.colorScheme.error,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  periodName,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                if (!isCompleted && !isExpired) ...[
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${daysRemaining}天剩余',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const Spacer(),
                Icon(
                  Icons.stars,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '+$pointsReward',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (!isCompleted && !isExpired) ...[
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        progressText,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(progress * 100).toInt()}% 完成',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
            if (isCompleted && completedAt != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '已于 ${completedAt.toString().split('.')[0]} 完成',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
