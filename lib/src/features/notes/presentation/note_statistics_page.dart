import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/features/notes/application/note_statistics_service.dart';
import 'dart:math' as math;

/// 笔记统计分析页面
class NoteStatisticsPage extends ConsumerWidget {
  const NoteStatisticsPage({super.key});

  static const routePath = '/notes/statistics';
  static const routeName = 'note-statistics';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statisticsAsync = ref.watch(noteStatisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('笔记统计分析'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(noteStatisticsProvider),
            tooltip: '刷新数据',
          ),
        ],
      ),
      body: statisticsAsync.when(
        data: (statistics) {
          if (statistics.totalNotes == 0) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.insert_chart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '暂无笔记数据',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '开始创建笔记,查看统计分析',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(noteStatisticsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 概览卡片
                _OverviewCard(statistics: statistics),
                const SizedBox(height: 16),

                // 笔记数量趋势图
                _TrendChartCard(statistics: statistics),
                const SizedBox(height: 16),

                // 分类统计饼图
                _CategoryChartCard(statistics: statistics),
                const SizedBox(height: 16),

                // 标签云
                _TagCloudCard(statistics: statistics),
                const SizedBox(height: 16),

                // 写作热力图
                _HeatmapCard(statistics: statistics),
                const SizedBox(height: 16),

                // 最长笔记和最多浏览
                if (statistics.longestNote != null ||
                    statistics.mostViewedNote != null)
                  _HighlightsCard(statistics: statistics),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('加载失败: $error'),
            ],
          ),
        ),
      ),
    );
  }
}

/// 概览卡片
class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.statistics});

  final NoteStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '数据概览',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.note,
                    label: '总笔记数',
                    value: statistics.totalNotes.toString(),
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.text_fields,
                    label: '总字数',
                    value: _formatNumber(statistics.totalWords),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.bar_chart,
                    label: '平均字数',
                    value: _formatNumber(statistics.averageWordsPerNote),
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.label,
                    label: '标签数',
                    value: statistics.tagFrequency.length.toString(),
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 10000) {
      return '${(number / 10000).toStringAsFixed(1)}万';
    }
    return number.toString();
  }
}

/// 统计项
class _StatItem extends StatelessWidget {
  const _StatItem({
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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
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
    );
  }
}

/// 趋势图表卡片
class _TrendChartCard extends StatelessWidget {
  const _TrendChartCard({required this.statistics});

  final NoteStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 获取最近30天的数据
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day).subtract(
      const Duration(days: 29),
    );
    final trendData = statistics.getTrend(startDate, now);

    // 准备图表数据
    final spots = <FlSpot>[];
    for (var i = 0; i < 30; i++) {
      final date = startDate.add(Duration(days: i));
      final count = trendData[date] ?? 0;
      spots.add(FlSpot(i.toDouble(), count.toDouble()));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '笔记数量趋势 (最近30天)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 7,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < 30) {
                            final date = startDate.add(
                              Duration(days: value.toInt()),
                            );
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                DateFormat('M/d').format(date),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: theme.colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primary.withOpacity(0.1),
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
  }
}

/// 分类统计饼图卡片
class _CategoryChartCard extends StatelessWidget {
  const _CategoryChartCard({required this.statistics});

  final NoteStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sections = statistics.notesByCategory.entries.map((entry) {
      final category = entry.key;
      final count = entry.value;
      final percentage = (count / statistics.totalNotes * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: count.toDouble(),
        title: '$percentage%',
        color: _getCategoryColor(category),
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '笔记分类统计',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (sections.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: statistics.notesByCategory.entries.map((entry) {
                        final note = Note(
                          id: '',
                          title: '',
                          content: '',
                          category: entry.key,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(entry.key),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${note.getCategoryName()} (${entry.value})',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('暂无分类数据'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(NoteCategory category) {
    switch (category) {
      case NoteCategory.general:
        return Colors.grey;
      case NoteCategory.work:
        return Colors.blue;
      case NoteCategory.personal:
        return Colors.green;
      case NoteCategory.study:
        return Colors.orange;
      case NoteCategory.project:
        return Colors.purple;
      case NoteCategory.meeting:
        return Colors.teal;
      case NoteCategory.journal:
        return Colors.pink;
      case NoteCategory.reference:
        return Colors.brown;
    }
  }
}

/// 标签云卡片
class _TagCloudCard extends StatelessWidget {
  const _TagCloudCard({required this.statistics});

  final NoteStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topTags = statistics.getTopTags(20);

    if (topTags.isEmpty) {
      return const SizedBox.shrink();
    }

    // 找出最大频率用于计算相对大小
    final maxFreq = topTags.first.value;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cloud, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '热门标签云',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topTags.map((entry) {
                final fontSize = 12.0 + (entry.value / maxFreq * 16);
                final colors = [
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.purple,
                  Colors.teal,
                  Colors.pink,
                  Colors.amber,
                  Colors.cyan,
                ];
                final color = colors[entry.key.hashCode % colors.length];

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '#${entry.key}',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          entry.value.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// 写作热力图卡片
class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.statistics});

  final NoteStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 获取最近52周的数据
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day).subtract(
      const Duration(days: 364),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.grid_on, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '写作热力图 (最近一年)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _HeatmapGrid(
              startDate: startDate,
              heatmapData: statistics.writingHeatmap,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('少', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 8),
                ...List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getHeatColor(index / 4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 8),
                const Text('多', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getHeatColor(double intensity) {
    if (intensity == 0) return Colors.grey.shade200;
    return Color.lerp(
      Colors.green.shade100,
      Colors.green.shade700,
      intensity,
    )!;
  }
}

/// 热力图网格
class _HeatmapGrid extends StatelessWidget {
  const _HeatmapGrid({
    required this.startDate,
    required this.heatmapData,
  });

  final DateTime startDate;
  final Map<DateTime, int> heatmapData;

  @override
  Widget build(BuildContext context) {
    // 计算最大值用于归一化
    final maxCount = heatmapData.values.isEmpty
        ? 1
        : heatmapData.values.reduce(math.max);

    // 生成52周的网格
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 52,
        itemBuilder: (context, weekIndex) {
          return Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (dayIndex) {
                final date = startDate.add(
                  Duration(days: weekIndex * 7 + dayIndex),
                );
                final count = heatmapData[date] ?? 0;
                final intensity = maxCount == 0 ? 0.0 : count / maxCount;

                return Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getHeatColor(intensity),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }

  Color _getHeatColor(double intensity) {
    if (intensity == 0) return Colors.grey.shade200;
    return Color.lerp(
      Colors.green.shade100,
      Colors.green.shade700,
      intensity,
    )!;
  }
}

/// 亮点卡片
class _HighlightsCard extends StatelessWidget {
  const _HighlightsCard({required this.statistics});

  final NoteStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '笔记亮点',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (statistics.longestNote != null) ...[
              _HighlightItem(
                icon: Icons.article,
                title: '最长笔记',
                note: statistics.longestNote!,
                subtitle:
                    '${statistics.longestNote!.wordCount ?? statistics.longestNote!.content.length} 字',
              ),
              const SizedBox(height: 12),
            ],
            if (statistics.mostViewedNote != null)
              _HighlightItem(
                icon: Icons.visibility,
                title: '最多浏览',
                note: statistics.mostViewedNote!,
                subtitle: '${statistics.mostViewedNote!.viewCount} 次浏览',
              ),
          ],
        ),
      ),
    );
  }
}

/// 亮点项
class _HighlightItem extends StatelessWidget {
  const _HighlightItem({
    required this.icon,
    required this.title,
    required this.note,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final Note note;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.onPrimaryContainer,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
