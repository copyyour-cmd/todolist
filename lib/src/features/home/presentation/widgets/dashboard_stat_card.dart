import 'package:flutter/material.dart';

class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    this.color,
    this.onTap,
    this.trend,
    this.isWarning = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color? color;
  final VoidCallback? onTap;
  final String? trend;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveColor = isWarning
        ? colorScheme.errorContainer
        : (color ?? colorScheme.primaryContainer);

    final textColor = isWarning
        ? colorScheme.onErrorContainer
        : (color != null
            ? _getTextColorForBackground(color!)
            : colorScheme.onPrimaryContainer);

    return Card(
      color: effectiveColor,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // 左侧图标
              Icon(
                icon,
                color: textColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              // 中间内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            value,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,  // 从18进一步减小到16
                              height: 1.1,  // 减小行高
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // 右侧趋势标签移到这里,与value在同一行
                        if (trend != null) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: textColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              trend!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 8,  // 从9进一步减小到8
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColor.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        fontSize: 10,  // 从11减小到10
                        height: 1.1,  // 减小行高
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: textColor.withOpacity(0.7),
                          fontSize: 8,  // 从9减小到8
                          height: 1.1,  // 减小行高
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTextColorForBackground(Color background) {
    // 使用更严格的标准，让文字更深更清晰
    final luminance = background.computeLuminance();
    // 降低阈值，让更多情况使用深色文字
    return luminance > 0.4 ? Colors.black87 : Colors.white;
  }
}

class DashboardStatsGrid extends StatelessWidget {
  const DashboardStatsGrid({
    required this.todayCompleted,
    required this.todayTotal,
    required this.weekFocusTime,
    required this.currentStreak,
    required this.urgentTasks,
    this.onTodayTap,
    this.onFocusTap,
    this.onStreakTap,
    this.onUrgentTap,
    super.key,
  });

  final int todayCompleted;
  final int todayTotal;
  final String weekFocusTime;
  final int currentStreak;
  final int urgentTasks;
  final VoidCallback? onTodayTap;
  final VoidCallback? onFocusTap;
  final VoidCallback? onStreakTap;
  final VoidCallback? onUrgentTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final todayRate = todayTotal > 0 ? (todayCompleted / todayTotal * 100) : 0;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      childAspectRatio: 2.2,
      children: [
        // Today's tasks
        DashboardStatCard(
          icon: Icons.task_alt,
          title: '今日任务',
          value: '$todayCompleted/$todayTotal',
          subtitle: '${todayRate.toStringAsFixed(0)}% 已完成',
          color: colorScheme.primaryContainer,
          onTap: onTodayTap,
          trend: todayCompleted == todayTotal && todayTotal > 0 ? '✓ 全部完成' : null,
        ),

        // Week focus time
        DashboardStatCard(
          icon: Icons.timer,
          title: '本周专注',
          value: weekFocusTime,
          subtitle: '累计专注时长',
          color: colorScheme.secondaryContainer,
          onTap: onFocusTap,
        ),

        // Streak
        DashboardStatCard(
          icon: Icons.local_fire_department,
          title: '连续打卡',
          value: '$currentStreak天',
          subtitle: currentStreak > 0 ? '保持优秀!' : '开始你的第一天',
          color: colorScheme.tertiaryContainer,
          onTap: onStreakTap,
          trend: currentStreak >= 7
              ? '🔥 $currentStreak'
              : (currentStreak >= 3 ? '⚡ $currentStreak' : null),
        ),

        // Urgent tasks
        DashboardStatCard(
          icon: urgentTasks > 0 ? Icons.warning_amber : Icons.check_circle,
          title: urgentTasks > 0 ? '紧急任务' : '无紧急任务',
          value: urgentTasks > 0 ? '$urgentTasks个' : '✓',
          subtitle: urgentTasks > 0 ? '需要优先处理' : '一切尽在掌握',
          isWarning: urgentTasks > 0,
          color: urgentTasks > 0 ? null : colorScheme.surfaceContainerHighest,
          onTap: onUrgentTap,
        ),
      ],
    );
  }
}
