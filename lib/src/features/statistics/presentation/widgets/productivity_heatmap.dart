import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/src/domain/entities/task_statistics.dart';

class ProductivityHeatmap extends StatelessWidget {
  const ProductivityHeatmap({
    required this.data,
    this.cellSize = 16.0,
    super.key,
  });

  final List<HeatmapDataPoint> data;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('暂无数据'),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Group data by week
    final weeks = _groupByWeek(data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '效率日历',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '过去一年的任务完成情况',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weekday labels
              Row(
                children: [
                  SizedBox(width: 40), // Space for month labels
                  ...List.generate(7, (index) {
                    final weekday = ['日', '一', '二', '三', '四', '五', '六'][index];
                    return SizedBox(
                      width: cellSize + 2,
                      height: 20,
                      child: Center(
                        child: Text(
                          weekday,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 4),
              // Heatmap grid
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month labels
                  SizedBox(
                    width: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _buildMonthLabels(weeks, theme),
                    ),
                  ),
                  // Heatmap cells
                  Column(
                    children: weeks.asMap().entries.map((weekEntry) {
                      return Row(
                        children: weekEntry.value.map((dayData) {
                          return _buildCell(
                            context,
                            dayData,
                            colorScheme,
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Legend
              Row(
                children: [
                  Text(
                    '少',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Container(
                        width: cellSize,
                        height: cellSize,
                        decoration: BoxDecoration(
                          color: _getColorForIntensity(index, colorScheme),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(width: 8),
                  Text(
                    '多',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCell(
    BuildContext context,
    HeatmapDataPoint? data,
    ColorScheme colorScheme,
  ) {
    if (data == null) {
      return SizedBox(width: cellSize + 2, height: cellSize + 2);
    }

    final color = _getColorForIntensity(data.intensity, colorScheme);

    return Padding(
      padding: const EdgeInsets.all(1),
      child: Tooltip(
        message: '${DateFormat('yyyy年M月d日').format(data.date)}\n'
            '完成 ${data.completedCount} 个任务',
        child: Container(
          width: cellSize,
          height: cellSize,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Color _getColorForIntensity(int intensity, ColorScheme colorScheme) {
    // GitHub-style green colors
    return switch (intensity) {
      0 => colorScheme.surfaceContainerHighest,
      1 => colorScheme.primary.withOpacity(0.2),
      2 => colorScheme.primary.withOpacity(0.4),
      3 => colorScheme.primary.withOpacity(0.6),
      4 => colorScheme.primary.withOpacity(0.8),
      _ => colorScheme.primary,
    };
  }

  List<List<HeatmapDataPoint?>> _groupByWeek(List<HeatmapDataPoint> data) {
    final weeks = <List<HeatmapDataPoint?>>[];
    var currentWeek = <HeatmapDataPoint?>[];

    // Find the first Sunday
    var startDate = data.first.date;
    while (startDate.weekday != DateTime.sunday) {
      startDate = startDate.subtract(const Duration(days: 1));
    }

    final dataMap = {for (final d in data) d.date: d};

    for (var i = 0; i < 53; i++) {
      // 53 weeks to cover a year
      currentWeek = [];
      for (var j = 0; j < 7; j++) {
        final date = startDate.add(Duration(days: i * 7 + j));
        currentWeek.add(dataMap[DateTime(date.year, date.month, date.day)]);
      }
      weeks.add(currentWeek);
    }

    return weeks;
  }

  List<Widget> _buildMonthLabels(
    List<List<HeatmapDataPoint?>> weeks,
    ThemeData theme,
  ) {
    final labels = <Widget>[];
    String? lastMonth;

    for (var weekIndex = 0; weekIndex < weeks.length; weekIndex++) {
      final week = weeks[weekIndex];
      final firstValidDay = week.firstWhere(
        (d) => d != null,
        orElse: () => null,
      );

      if (firstValidDay != null) {
        final month = DateFormat('M月').format(firstValidDay.date);
        if (month != lastMonth) {
          labels.add(
            SizedBox(
              height: cellSize + 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    month,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          );
          lastMonth = month;
        } else {
          labels.add(SizedBox(height: cellSize + 2));
        }
      } else {
        labels.add(SizedBox(height: cellSize + 2));
      }
    }

    return labels;
  }
}
