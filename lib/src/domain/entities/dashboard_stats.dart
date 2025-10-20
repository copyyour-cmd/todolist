import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';
part 'dashboard_stats.g.dart';

/// Dashboard overview statistics
@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    // Today's tasks
    required int todayCompletedCount,
    required int todayTotalCount,

    // This week's focus
    required int weekFocusMinutes,
    required int weekFocusSessions,

    // Streak
    required int currentStreak,
    required int longestStreak,
    required DateTime? lastCheckInDate,

    // Urgent tasks
    required int urgentTasksCount,
    required int overdueTasksCount,

    // Additional insights
    required double todayCompletionRate,
    required int weekFocusHours,
  }) = _DashboardStats;

  const DashboardStats._();

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);

  /// Default empty state
  factory DashboardStats.empty() => DashboardStats(
        todayCompletedCount: 0,
        todayTotalCount: 0,
        weekFocusMinutes: 0,
        weekFocusSessions: 0,
        currentStreak: 0,
        longestStreak: 0,
        lastCheckInDate: null,
        urgentTasksCount: 0,
        overdueTasksCount: 0,
        todayCompletionRate: 0,
        weekFocusHours: 0,
      );

  /// Get today's pending tasks
  int get todayPendingCount => todayTotalCount - todayCompletedCount;

  /// Get week focus hours as formatted string
  String get weekFocusTimeFormatted {
    final hours = weekFocusMinutes ~/ 60;
    final minutes = weekFocusMinutes % 60;
    if (hours == 0) return '$minutes分钟';
    if (minutes == 0) return '$hours小时';
    return '${hours}h ${minutes}m';
  }

  /// Check if streak is active (checked in today or yesterday)
  bool get isStreakActive {
    if (lastCheckInDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final lastDate = DateTime(
      lastCheckInDate!.year,
      lastCheckInDate!.month,
      lastCheckInDate!.day,
    );
    return lastDate.isAtSameMomentAs(today) ||
        lastDate.isAtSameMomentAs(yesterday);
  }
}
