import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/features/focus/application/focus_providers.dart';
import 'package:todolist/src/features/focus/application/focus_statistics_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

/// Provider for time estimation analysis
final timeEstimationAnalysisProvider = FutureProvider<TimeEstimationAnalysis>((ref) async {
  final sessionRepo = await ref.watch(focusSessionRepositoryProvider.future);
  final taskRepo = ref.watch(taskRepositoryProvider);
  final taskListRepo = ref.watch(taskListRepositoryProvider);
  final tagRepo = ref.watch(tagRepositoryProvider);
  final service = FocusStatisticsService(
    sessionRepository: sessionRepo,
    taskRepository: taskRepo,
    taskListRepository: taskListRepo,
    tagRepository: tagRepo,
  );
  return service.getTimeEstimationAnalysis();
});

/// Provider for completed tasks with estimates
final tasksWithEstimatesProvider = FutureProvider<List<Task>>((ref) async {
  final tasks = await ref.watch(taskRepositoryProvider).getAll();
  return tasks.where((task) {
    return task.isCompleted &&
        task.estimatedMinutes != null &&
        task.actualMinutes > 0;
  }).toList();
});

class TimeEstimationPage extends ConsumerWidget {
  const TimeEstimationPage({super.key});

  static const routeName = 'time-estimation';
  static const routePath = '/focus/time-estimation';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final analysisAsync = ref.watch(timeEstimationAnalysisProvider);
    final tasksAsync = ref.watch(tasksWithEstimatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('时间预估分析'),
      ),
      body: analysisAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败: $error')),
        data: (analysis) {
          if (analysis.totalTasksWithEstimates == 0) {
            return const Center(
              child: Text('暂无数据\n完成一些带预估时间的任务后再来查看'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Card
                _SummaryCard(analysis: analysis),
                const SizedBox(height: 24),

                // Tendency Analysis
                Text(
                  '预估倾向分析',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _TendencyChart(analysis: analysis),
                const SizedBox(height: 32),

                // Task List
                Text(
                  '任务详情',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                tasksAsync.when(
                  data: (tasks) => _TaskComparisonList(tasks: tasks),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.analysis});

  final TimeEstimationAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final accuracyPercent = (analysis.averageAccuracy * 100).toInt();
    final overestimatePercent = (analysis.tendencyToOverestimate * 100).toInt();
    final underestimatePercent = (analysis.tendencyToUnderestimate * 100).toInt();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 总体评估',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _MetricRow(
              label: '分析任务数',
              value: '${analysis.totalTasksWithEstimates} 个',
              icon: Icons.task_alt,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _MetricRow(
              label: '平均准确度',
              value: '$accuracyPercent%',
              icon: Icons.center_focus_strong,
              color: _getAccuracyColor(analysis.averageAccuracy),
            ),
            const SizedBox(height: 12),
            _MetricRow(
              label: '预估倾向',
              value: analysis.isOverestimating ? '偏高估' : '偏低估',
              icon: analysis.isOverestimating
                  ? Icons.trending_up
                  : Icons.trending_down,
              color: analysis.isOverestimating ? Colors.orange : Colors.purple,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              '建议',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _getRecommendation(analysis),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String _getRecommendation(TimeEstimationAnalysis analysis) {
    if (analysis.averageAccuracy >= 0.8) {
      return '👍 预估能力很好!继续保持。';
    } else if (analysis.isOverestimating) {
      if (analysis.tendencyToOverestimate > 0.5) {
        return '建议:你倾向于高估任务时间。可以尝试将预估时间减少15-20%。';
      }
      return '建议:适当降低预估时间,更贴近实际完成时间。';
    } else {
      if (analysis.tendencyToUnderestimate > 0.5) {
        return '建议:你倾向于低估任务时间。预估时可以增加20-30%的缓冲时间。';
      }
      return '建议:适当增加预估时间,为意外情况留出空间。';
    }
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _TendencyChart extends StatelessWidget {
  const _TendencyChart({required this.analysis});

  final TimeEstimationAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final overPercent = analysis.tendencyToOverestimate * 100;
    final underPercent = analysis.tendencyToUnderestimate * 100;
    final accuratePercent = 100 - overPercent - underPercent;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: overPercent,
                      title: '高估\n${overPercent.toInt()}%',
                      color: Colors.orange,
                      radius: 80,
                      titleStyle: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: accuratePercent,
                      title: '准确\n${accuratePercent.toInt()}%',
                      color: Colors.green,
                      radius: 80,
                      titleStyle: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: underPercent,
                      title: '低估\n${underPercent.toInt()}%',
                      color: Colors.purple,
                      radius: 80,
                      titleStyle: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              children: const [
                _LegendItem(color: Colors.green, label: '准确 (±20%)'),
                _LegendItem(color: Colors.orange, label: '高估'),
                _LegendItem(color: Colors.purple, label: '低估'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}

class _TaskComparisonList extends StatelessWidget {
  const _TaskComparisonList({required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (final task in tasks.take(20)) ...[
          Card(
            child: ListTile(
              title: Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: _buildProgressBar(context, task),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _getDifferenceText(task),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getDifferenceColor(task),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${(task.estimationAccuracy * 100).toInt()}% 准确',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context, Task task) {
    final theme = Theme.of(context);
    final estimated = task.estimatedMinutes!;
    final actual = task.actualMinutes;
    final ratio = actual / estimated;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '预估: $estimated分钟',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 16),
            Text(
              '实际: $actual分钟',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            FractionallySizedBox(
              widthFactor: ratio.clamp(0.0, 1.0),
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: _getDifferenceColor(task),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getDifferenceText(Task task) {
    final diff = task.actualMinutes - task.estimatedMinutes!;
    if (diff > 0) {
      return '+$diff分钟';
    } else if (diff < 0) {
      return '$diff分钟';
    }
    return '准确';
  }

  Color _getDifferenceColor(Task task) {
    final ratio = task.actualMinutes / task.estimatedMinutes!;
    if (ratio >= 0.8 && ratio <= 1.2) {
      return Colors.green;
    } else if (ratio > 1.2) {
      return Colors.purple; // Underestimated
    } else {
      return Colors.orange; // Overestimated
    }
  }
}
