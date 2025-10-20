import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/task_statistics.dart';
import 'package:todolist/src/features/statistics/application/statistics_providers.dart';
import 'package:todolist/src/features/statistics/presentation/widgets/completion_rate_pie_chart.dart';
import 'package:todolist/src/features/statistics/presentation/widgets/completion_trend_chart.dart';
import 'package:todolist/src/features/statistics/presentation/widgets/productivity_heatmap.dart';

enum TrendPeriod {
  week7('最近7天'),
  day30('最近30天'),
  day90('最近90天');

  const TrendPeriod(this.label);
  final String label;
}

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  static const routeName = 'statistics';
  static const routePath = '/statistics';

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage>
    with SingleTickerProviderStateMixin {
  TrendPeriod _selectedPeriod = TrendPeriod.week7;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statisticsAsync = ref.watch(taskStatisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('数据统计'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(taskStatisticsProvider);
            },
          ),
        ],
      ),
      body: statisticsAsync.when(
        data: (statistics) => _buildContent(context, statistics),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('加载失败: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(taskStatisticsProvider);
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TaskStatistics statistics) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(taskStatisticsProvider);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary cards
          _buildSummaryCards(context, statistics),
          const SizedBox(height: 24),

          // Completion trend chart
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '完成趋势',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SegmentedButton<TrendPeriod>(
                        segments: TrendPeriod.values
                            .map((period) => ButtonSegment(
                                  value: period,
                                  label: Text(
                                    period.label,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                            .toList(),
                        selected: {_selectedPeriod},
                        onSelectionChanged: (Set<TrendPeriod> newSelection) {
                          setState(() {
                            _selectedPeriod = newSelection.first;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                CompletionTrendChart(
                  data: _getTrendData(statistics),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Completion rate breakdown
          Text(
            '完成率分析',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '按不同维度查看任务完成情况',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Tabs for different breakdowns
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '按列表'),
              Tab(text: '按标签'),
              Tab(text: '按优先级'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 350,
            child: TabBarView(
              controller: _tabController,
              children: [
                Card(
                  child: CompletionRatePieChart(
                    data: statistics.byList,
                    title: '按列表',
                  ),
                ),
                Card(
                  child: CompletionRatePieChart(
                    data: statistics.byTag,
                    title: '按标签',
                  ),
                ),
                Card(
                  child: CompletionRatePieChart(
                    data: statistics.byPriority,
                    title: '按优先级',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Procrastination ranking
          if (statistics.topProcrastinated.isNotEmpty) ...[
            Text(
              '最常拖延的任务',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: statistics.topProcrastinated.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final task = statistics.topProcrastinated[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.errorContainer,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(task.taskTitle),
                    subtitle: Text('已逾期 ${task.overdueDays} 天'),
                    trailing: Icon(
                      Icons.warning_amber,
                      color: colorScheme.error,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Productivity by time slot
          if (statistics.productivityByHour.isNotEmpty) ...[
            Text(
              '黄金时段分析',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '完成任务最多的时间段',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: statistics.productivityByHour.take(5).map((slot) {
                    final isTop = slot == statistics.peakProductivityTime;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isTop
                                  ? colorScheme.primaryContainer
                                  : colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${slot.hour}:00',
                              style: TextStyle(
                                fontWeight:
                                    isTop ? FontWeight.bold : FontWeight.normal,
                                color: isTop
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: slot.completedCount /
                                  statistics.productivityByHour.first
                                      .completedCount,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation(
                                isTop
                                    ? colorScheme.primary
                                    : colorScheme.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${slot.completedCount} 个',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight:
                                  isTop ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          if (isTop) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Productivity heatmap
          Card(
            child: ProductivityHeatmap(
              data: statistics.heatmapData,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, TaskStatistics statistics) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.task_alt,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${statistics.totalTasksCompleted}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '已完成',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            color: colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${statistics.currentStreak}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '连续天数',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            color: colorScheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.trending_up,
                    color: colorScheme.onTertiaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(statistics.overallCompletionRate * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '完成率',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<CompletionTrendPoint> _getTrendData(TaskStatistics statistics) {
    return switch (_selectedPeriod) {
      TrendPeriod.week7 => statistics.last7Days,
      TrendPeriod.day30 => statistics.last30Days,
      TrendPeriod.day90 => statistics.last90Days,
    };
  }
}
