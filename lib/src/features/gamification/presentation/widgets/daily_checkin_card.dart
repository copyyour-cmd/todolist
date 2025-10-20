import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/haptic_feedback_helper.dart';
import 'package:todolist/src/features/gamification/application/gamification_providers.dart';
import 'package:intl/intl.dart';

/// 每日签到卡片
class DailyCheckInCard extends ConsumerStatefulWidget {
  const DailyCheckInCard({super.key});

  @override
  ConsumerState<DailyCheckInCard> createState() => _DailyCheckInCardState();
}

class _DailyCheckInCardState extends ConsumerState<DailyCheckInCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _performCheckIn() async {
    if (_isChecking) return;

    setState(() => _isChecking = true);
    HapticFeedbackHelper.medium();

    try {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      final service = ref.read(gamificationServiceProvider);
      final checkIn = await service.performDailyCheckIn();

      if (mounted) {
        HapticFeedbackHelper.success();
        _showSuccessDialog(checkIn.pointsEarned, checkIn.consecutiveDays);
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
        setState(() => _isChecking = false);
      }
    }
  }

  void _showSuccessDialog(int points, int streak) {
    showDialog(
      context: context,
      builder: (context) => _CheckInSuccessDialog(
        points: points,
        streak: streak,
      ),
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

        return FutureBuilder<Map<String, dynamic>>(
          future: service.getCheckInStats(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            final checkInStats = snapshot.data!;
            final hasCheckedIn = checkInStats['hasCheckedInToday'] as bool;
            final currentStreak = checkInStats['currentStreak'] as int;
            final makeupCards = checkInStats['makeupCardsCount'] as int;

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
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            color: theme.colorScheme.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '每日签到',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    color: Colors.orange,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '连续 $currentStreak 天',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.orange,
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

                    const SizedBox(height: 12),

                    // 奖励进度
                    _buildCompactRewardProgress(currentStreak, theme),

                    const SizedBox(height: 12),

                    // 签到按钮
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: hasCheckedIn || _isChecking
                            ? null
                            : _performCheckIn,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: hasCheckedIn
                              ? theme.colorScheme.surfaceContainerHighest
                              : theme.colorScheme.primary,
                          foregroundColor: hasCheckedIn
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isChecking
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    hasCheckedIn
                                        ? Icons.check_circle
                                        : Icons.touch_app,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    hasCheckedIn ? '今日已签到' : '立即签到',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
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

  Widget _buildCheckInCalendar(Map<String, dynamic> stats) {
    final recentCheckIns = stats['recentCheckIns'] as List;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = today.subtract(Duration(days: 6 - index));
          final hasCheckIn = recentCheckIns.any((checkIn) {
            final checkInDate = DateTime(
              checkIn.checkInDate.year,
              checkIn.checkInDate.month,
              checkIn.checkInDate.day,
            );
            return checkInDate == date;
          });
          final isToday = date == today;

          return Container(
            width: 50,
            margin: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Text(
                  DateFormat('EEE', 'zh_CN').format(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: isToday
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasCheckIn
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    border: isToday
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Icon(
                      hasCheckIn ? Icons.check : Icons.close,
                      size: 20,
                      color: hasCheckIn
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 紧凑型奖励进度显示
  Widget _buildCompactRewardProgress(int currentStreak, ThemeData theme) {
    // 关键里程碑：3天、7天、14天、30天
    final milestones = [3, 7, 14, 30];

    // 找到下一个里程碑
    final nextMilestone = milestones.firstWhere(
      (m) => m > currentStreak,
      orElse: () => 30,
    );

    // 找到前一个里程碑用于计算进度
    final prevMilestone = milestones.lastWhere(
      (m) => m <= currentStreak,
      orElse: () => 0,
    );

    // 计算进度
    final progress = prevMilestone == nextMilestone
        ? 1.0
        : (currentStreak - prevMilestone) / (nextMilestone - prevMilestone);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '下个奖励',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
            Text(
              currentStreak >= 30 ? '已完成' : '还需 ${nextMilestone - currentStreak} 天',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.orange,
            ),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 6),
        // 里程碑标记
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: milestones.map((milestone) {
            final isAchieved = currentStreak >= milestone;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAchieved
                        ? Colors.orange
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$milestone',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isAchieved
                        ? Colors.orange
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isAchieved ? FontWeight.bold : FontWeight.normal,
                    fontSize: 10,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRewardHints(int currentStreak, ThemeData theme) {
    final hints = <MapEntry<int, String>>[
      const MapEntry(3, '3天: +10'),
      const MapEntry(7, '7天: +30'),
      const MapEntry(14, '14天: +50'),
      const MapEntry(21, '21天: +80'),
      const MapEntry(30, '30天: +120'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: hints.map((hint) {
        final isAchieved = currentStreak >= hint.key;
        final isCurrent = currentStreak == hint.key;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isAchieved
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: isCurrent
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Text(
            hint.value,
            style: TextStyle(
              fontSize: 12,
              color: isAchieved
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// 签到成功对话框
class _CheckInSuccessDialog extends StatelessWidget {
  const _CheckInSuccessDialog({
    required this.points,
    required this.streak,
  });

  final int points;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
              ),
              child: const Icon(
                Icons.check_circle,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '签到成功!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '获得 $points 积分',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '连续签到 $streak 天',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('太棒了!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
