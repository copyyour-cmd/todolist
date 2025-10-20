import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todolist/src/domain/entities/habit.dart';
import 'package:todolist/src/features/habits/application/habit_providers.dart';

class HabitHeatmapPage extends ConsumerStatefulWidget {
  const HabitHeatmapPage({required this.habitId, super.key});

  static const routeName = 'habit_heatmap';
  static const routePath = '/habits/:id/heatmap';

  final String habitId;

  @override
  ConsumerState<HabitHeatmapPage> createState() => _HabitHeatmapPageState();
}

class _HabitHeatmapPageState extends ConsumerState<HabitHeatmapPage> {
  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('习惯热力图'),
      ),
      body: habitsAsync.when(
        data: (habits) {
          final habit = habits.firstWhere(
            (h) => h.id == widget.habitId,
            orElse: () => throw Exception('Habit not found'),
          );

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 习惯信息卡片
                  _HabitInfoCard(habit: habit),
                  const SizedBox(height: 24),

                  // 统计信息
                  _StatisticsSection(habit: habit),
                  const SizedBox(height: 24),

                  // 热力图
                  const Text(
                    '打卡热力图',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _HeatmapGrid(habit: habit),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('错误: $e')),
      ),
    );
  }
}

/// 习惯信息卡片
class _HabitInfoCard extends StatelessWidget {
  const _HabitInfoCard({required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              habit.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (habit.description != null) ...[
              const SizedBox(height: 8),
              Text(
                habit.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 统计信息区域
class _StatisticsSection extends StatelessWidget {
  const _StatisticsSection({required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department,
            iconColor: Colors.orange,
            label: '当前连续',
            value: '${habit.currentStreak}天',
            theme: theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.emoji_events,
            iconColor: Colors.amber,
            label: '最长连续',
            value: '${habit.longestStreak}天',
            theme: theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle,
            iconColor: Colors.green,
            label: '总打卡',
            value: '${habit.totalCompletionCount}次',
            theme: theme,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.theme,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 热力图网格
class _HeatmapGrid extends StatelessWidget {
  const _HeatmapGrid({required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    // 显示过去12周的数据
    const weeks = 12;
    final startDate = now.subtract(Duration(days: weeks * 7));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 月份标签
        _MonthLabels(startDate: startDate, weeks: weeks),
        const SizedBox(height: 8),

        // 热力图主体
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 星期标签
            _WeekdayLabels(),
            const SizedBox(width: 8),

            // 热力图网格
            Expanded(
              child: _HeatmapCells(
                habit: habit,
                startDate: startDate,
                weeks: weeks,
                theme: theme,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 图例
        _HeatmapLegend(theme: theme),
      ],
    );
  }
}

/// 月份标签
class _MonthLabels extends StatelessWidget {
  const _MonthLabels({required this.startDate, required this.weeks});

  final DateTime startDate;
  final int weeks;

  @override
  Widget build(BuildContext context) {
    final months = <String, int>{};

    for (var week = 0; week < weeks; week++) {
      final date = startDate.add(Duration(days: week * 7));
      final monthKey = DateFormat('M月').format(date);
      months[monthKey] = week;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: SizedBox(
        height: 20,
        child: Stack(
          children: months.entries.map((entry) {
            return Positioned(
              left: entry.value * 16.0,
              child: Text(
                entry.key,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// 星期标签
class _WeekdayLabels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: ['一', '三', '五', '日']
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final label = entry.value;
            return Container(
              height: 14,
              margin: EdgeInsets.only(top: index == 0 ? 0 : 14),
              child: Text(
                label,
                style: const TextStyle(fontSize: 10),
              ),
            );
          })
          .toList(),
    );
  }
}

/// 热力图单元格
class _HeatmapCells extends StatelessWidget {
  const _HeatmapCells({
    required this.habit,
    required this.startDate,
    required this.weeks,
    required this.theme,
  });

  final Habit habit;
  final DateTime startDate;
  final int weeks;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final completedDatesSet = habit.completedDates.map((date) {
      return DateTime(date.year, date.month, date.day);
    }).toSet();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(weeks, (weekIndex) {
          return Column(
            children: List.generate(7, (dayIndex) {
              final date = startDate.add(Duration(
                days: weekIndex * 7 + dayIndex,
              ));
              final normalizedDate = DateTime(date.year, date.month, date.day);
              final isCompleted = completedDatesSet.contains(normalizedDate);
              final isFuture = normalizedDate.isAfter(DateTime.now());

              return Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isFuture
                      ? theme.colorScheme.surfaceContainerHighest
                      : isCompleted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}

/// 热力图图例
class _HeatmapLegend extends StatelessWidget {
  const _HeatmapLegend({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('少', style: TextStyle(fontSize: 12)),
        const SizedBox(width: 8),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        const Text('多', style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
