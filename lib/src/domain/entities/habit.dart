import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit.freezed.dart';
part 'habit.g.dart';

/// 习惯频率
enum HabitFrequency {
  daily,    // 每日
  weekly,   // 每周
  monthly,  // 每月
}

/// 习惯实体
@freezed
class Habit with _$Habit {
  const factory Habit({
    required String id,
    required String name,
    required DateTime createdAt, String? description,
    @Default(HabitFrequency.daily) HabitFrequency frequency,
    DateTime? updatedAt,
    @Default([]) List<DateTime> completedDates, // 完成日期列表
    @Default(0) int currentStreak, // 当前连续天数
    @Default(0) int longestStreak, // 最长连续天数
  }) = _Habit;

  const Habit._();

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  /// 获取今天是否已完成
  bool get isCompletedToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return completedDates.any((date) {
      final completedDate = DateTime(date.year, date.month, date.day);
      return completedDate == today;
    });
  }

  /// 获取本周完成次数
  int get weekCompletionCount {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday % 7));
    final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);

    return completedDates.where((date) {
      final completedDate = DateTime(date.year, date.month, date.day);
      return completedDate.isAfter(weekStartDate.subtract(const Duration(days: 1))) &&
          completedDate.isBefore(weekStartDate.add(const Duration(days: 7)));
    }).length;
  }

  /// 获取本月完成次数
  int get monthCompletionCount {
    final now = DateTime.now();
    return completedDates.where((date) {
      return date.year == now.year && date.month == now.month;
    }).length;
  }

  /// 获取总完成次数
  int get totalCompletionCount => completedDates.length;
}
