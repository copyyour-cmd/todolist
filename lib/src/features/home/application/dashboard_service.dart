import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/domain/entities/dashboard_stats.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';
import 'package:todolist/src/infrastructure/repositories/focus_session_repository.dart';

class DashboardService {
  DashboardService({
    required TaskRepository taskRepository,
    required FocusSessionRepository focusRepository,
    required Clock clock,
  })  : _taskRepository = taskRepository,
        _focusRepository = focusRepository,
        _clock = clock;

  final TaskRepository _taskRepository;
  final FocusSessionRepository _focusRepository;
  final Clock _clock;

  /// Get dashboard statistics
  Future<DashboardStats> getDashboardStats() async {
    final now = _clock.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final weekStart = today.subtract(Duration(days: now.weekday - 1));

    // Get all tasks
    final allTasks = await _taskRepository.getAll();

    // Today's tasks
    final todayTasks = allTasks.where((task) {
      if (task.dueAt == null) return false;
      return task.dueAt!.isAfter(today.subtract(const Duration(microseconds: 1))) &&
          task.dueAt!.isBefore(tomorrow);
    }).toList();

    final todayCompleted = todayTasks.where((t) => t.isCompleted).length;

    // Urgent tasks (critical or high priority, not completed)
    final urgentTasks = allTasks.where((task) {
      return !task.isCompleted &&
          (task.priority == TaskPriority.critical ||
              task.priority == TaskPriority.high);
    }).length;

    // Overdue tasks
    final overdueTasks = allTasks.where((task) {
      return !task.isCompleted &&
          task.dueAt != null &&
          task.dueAt!.isBefore(now);
    }).length;

    // This week's focus sessions
    final allSessions = _focusRepository.getAll();
    final weekSessions = allSessions.where((session) {
      return session.startedAt.isAfter(weekStart.subtract(const Duration(microseconds: 1))) &&
          session.startedAt.isBefore(now.add(const Duration(microseconds: 1)));
    }).toList();

    final weekFocusMinutes = weekSessions.fold<int>(
      0,
      (sum, session) => sum + session.durationMinutes,
    );

    // Calculate streak
    final streak = await _calculateStreak(allTasks);

    return DashboardStats(
      todayCompletedCount: todayCompleted,
      todayTotalCount: todayTasks.length,
      weekFocusMinutes: weekFocusMinutes,
      weekFocusSessions: weekSessions.length,
      currentStreak: streak['current'] ?? 0,
      longestStreak: streak['longest'] ?? 0,
      lastCheckInDate: streak['lastDate'],
      urgentTasksCount: urgentTasks,
      overdueTasksCount: overdueTasks,
      todayCompletionRate:
          todayTasks.isEmpty ? 0.0 : todayCompleted / todayTasks.length,
      weekFocusHours: weekFocusMinutes ~/ 60,
    );
  }

  Future<Map<String, dynamic>> _calculateStreak(List<Task> tasks) async {
    final completedDates = tasks
        .where((t) => t.isCompleted && t.completedAt != null)
        .map((t) {
          final date = t.completedAt!;
          return DateTime(date.year, date.month, date.day);
        })
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Sort descending

    if (completedDates.isEmpty) {
      return {'current': 0, 'longest': 0, 'lastDate': null};
    }

    final now = _clock.now();
    final today = DateTime(now.year, now.month, now.day);

    var currentStreak = 0;
    var longestStreak = 0;
    var tempStreak = 1;
    var expectedDate = completedDates.first;

    // Calculate current streak
    if (expectedDate.isAtSameMomentAs(today) ||
        expectedDate.isAtSameMomentAs(today.subtract(const Duration(days: 1)))) {
      currentStreak = 1;
      for (var i = 1; i < completedDates.length; i++) {
        expectedDate = expectedDate.subtract(const Duration(days: 1));
        if (completedDates[i].isAtSameMomentAs(expectedDate)) {
          currentStreak++;
        } else {
          break;
        }
      }
    }

    // Calculate longest streak
    for (var i = 1; i < completedDates.length; i++) {
      final diff = completedDates[i - 1].difference(completedDates[i]).inDays;
      if (diff == 1) {
        tempStreak++;
        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
      } else {
        tempStreak = 1;
      }
    }

    longestStreak = longestStreak > currentStreak ? longestStreak : currentStreak;

    return {
      'current': currentStreak,
      'longest': longestStreak,
      'lastDate': completedDates.first,
    };
  }
}
