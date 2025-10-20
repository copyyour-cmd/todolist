import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/focus/application/focus_providers.dart';
import 'package:todolist/src/features/focus/application/focus_statistics_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

/// Provider for focus statistics service
final focusStatisticsServiceProvider = FutureProvider<FocusStatisticsService>((ref) async {
  final sessionRepo = await ref.watch(focusSessionRepositoryProvider.future);
  final taskRepo = ref.watch(taskRepositoryProvider);
  final taskListRepo = ref.watch(taskListRepositoryProvider);
  final tagRepo = ref.watch(tagRepositoryProvider);
  return FocusStatisticsService(
    sessionRepository: sessionRepo,
    taskRepository: taskRepo,
    taskListRepository: taskListRepo,
    tagRepository: tagRepo,
  );
});

/// Provider for hourly focus data
final hourlyFocusDataProvider = FutureProvider<List<HourlyFocusData>>((ref) async {
  final service = await ref.watch(focusStatisticsServiceProvider.future);
  final now = DateTime.now();
  final startDate = now.subtract(const Duration(days: 30)); // Last 30 days
  return service.getHourlyFocusData(startDate: startDate, endDate: now);
});

class FocusHeatmapPage extends ConsumerWidget {
  const FocusHeatmapPage({super.key});

  static const routeName = 'focus-heatmap';
  static const routePath = '/focus/heatmap';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hourlyDataAsync = ref.watch(hourlyFocusDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('专注时段分析'),
      ),
      body: hourlyDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('加载失败: $error'),
        ),
        data: (hourlyData) {
          if (hourlyData.every((d) => d.sessionCount == 0)) {
            return const Center(
              child: Text('暂无数据\n完成一些专注番茄钟后再来查看'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Insights
                _InsightsCard(hourlyData: hourlyData),
                const SizedBox(height: 24),

                // Heatmap
                Text(
                  '时段热力图',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _HeatmapChart(hourlyData: hourlyData),
                const SizedBox(height: 32),

                // Bar Chart
                Text(
                  '专注时长分布',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _BarChart(hourlyData: hourlyData),
                const SizedBox(height: 32),

                // Quality Score
                Text(
                  '专注质量得分',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _QualityChart(hourlyData: hourlyData),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InsightsCard extends StatelessWidget {
  const _InsightsCard({required this.hourlyData});

  final List<HourlyFocusData> hourlyData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Find best hour
    var bestHour = 0;
    var bestScore = 0.0;
    for (final data in hourlyData) {
      if (data.productivityScore > bestScore) {
        bestScore = data.productivityScore;
        bestHour = data.hour;
      }
    }

    // Calculate total sessions
    final totalSessions = hourlyData.fold<int>(
      0,
      (sum, d) => sum + d.sessionCount,
    );

    // Calculate avg quality
    final qualities = hourlyData
        .where((d) => d.sessionCount > 0)
        .map((d) => d.averageQualityScore)
        .toList();
    final avgQuality = qualities.isEmpty
        ? 0.0
        : qualities.reduce((a, b) => a + b) / qualities.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 数据洞察',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _InsightRow(
              icon: Icons.access_time,
              label: '最佳专注时段',
              value: '$bestHour:00 - ${bestHour + 1}:00',
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            _InsightRow(
              icon: Icons.check_circle,
              label: '总专注次数',
              value: '$totalSessions 次',
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            _InsightRow(
              icon: Icons.star,
              label: '平均质量得分',
              value: '${avgQuality.toInt()}/100',
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _HeatmapChart extends StatelessWidget {
  const _HeatmapChart({required this.hourlyData});

  final List<HourlyFocusData> hourlyData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Find max productivity score
    final maxScore = hourlyData
        .map((d) => d.productivityScore)
        .reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 200,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 24,
        itemBuilder: (context, index) {
          final data = hourlyData[index];
          final intensity = maxScore > 0 ? data.productivityScore / maxScore : 0;

          return Tooltip(
            message: '$index:00\n${data.sessionCount} 次\n${data.totalMinutes} 分钟',
            child: Container(
              decoration: BoxDecoration(
                color: _getHeatColor(intensity.toDouble()),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: intensity > 0.5 ? Colors.white : Colors.black87,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getHeatColor(double intensity) {
    if (intensity == 0) return Colors.grey.shade200;
    if (intensity < 0.25) return Colors.green.shade100;
    if (intensity < 0.5) return Colors.green.shade300;
    if (intensity < 0.75) return Colors.green.shade500;
    return Colors.green.shade700;
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.hourlyData});

  final List<HourlyFocusData> hourlyData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxMinutes() * 1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${group.x}:00\n${rod.toY.toInt()} 分钟',
                  theme.textTheme.bodySmall!.copyWith(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() % 3 == 0) {
                    return Text(
                      '${value.toInt()}',
                      style: theme.textTheme.bodySmall,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}m',
                    style: theme.textTheme.bodySmall,
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
          ),
          borderData: FlBorderData(show: false),
          barGroups: hourlyData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data.totalMinutes.toDouble(),
                  color: theme.colorScheme.primary,
                  width: 8,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  double _getMaxMinutes() {
    return hourlyData
        .map((d) => d.totalMinutes.toDouble())
        .reduce((a, b) => a > b ? a : b);
  }
}

class _QualityChart extends StatelessWidget {
  const _QualityChart({required this.hourlyData});

  final List<HourlyFocusData> hourlyData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final dataWithSessions = hourlyData.where((d) => d.sessionCount > 0).toList();

    if (dataWithSessions.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() % 3 == 0 && value.toInt() < 24) {
                    return Text(
                      '${value.toInt()}',
                      style: theme.textTheme.bodySmall,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: theme.textTheme.bodySmall,
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 23,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: hourlyData.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value.averageQualityScore,
                );
              }).toList(),
              isCurved: true,
              color: theme.colorScheme.secondary,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: theme.colorScheme.secondary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
