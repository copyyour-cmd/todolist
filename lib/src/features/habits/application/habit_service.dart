import 'package:todolist/src/domain/entities/habit.dart';
import 'package:todolist/src/domain/repositories/habit_repository.dart';
import 'package:uuid/uuid.dart';

class HabitService {
  const HabitService(this._repository);

  final HabitRepository _repository;
  final _uuid = const Uuid();

  /// 创建习惯
  Future<Habit> createHabit({
    required String name,
    String? description,
    HabitFrequency frequency = HabitFrequency.daily,
  }) async {
    final habit = Habit(
      id: _uuid.v4(),
      name: name,
      description: description,
      frequency: frequency,
      createdAt: DateTime.now(),
    );
    await _repository.save(habit);
    return habit;
  }

  /// 更新习惯
  Future<Habit> updateHabit(Habit habit) async {
    final updated = habit.copyWith(updatedAt: DateTime.now());
    await _repository.save(updated);
    return updated;
  }

  /// 打卡(完成今天的习惯)
  Future<Habit> checkIn(Habit habit) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 检查今天是否已打卡
    if (habit.isCompletedToday) {
      return habit;
    }

    final newCompletedDates = [...habit.completedDates, today];

    // 计算连续天数
    final sortedDates = newCompletedDates.toSet().toList()..sort();
    var currentStreak = 1;
    for (var i = sortedDates.length - 1; i > 0; i--) {
      final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
      if (diff == 1) {
        currentStreak++;
      } else {
        break;
      }
    }

    final updated = habit.copyWith(
      completedDates: newCompletedDates,
      currentStreak: currentStreak,
      longestStreak: currentStreak > habit.longestStreak ? currentStreak : habit.longestStreak,
      updatedAt: now,
    );

    await _repository.save(updated);
    return updated;
  }

  /// 取消打卡
  Future<Habit> uncheckIn(Habit habit) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final newCompletedDates = habit.completedDates
        .where((date) {
          final completedDate = DateTime(date.year, date.month, date.day);
          return completedDate != today;
        })
        .toList();

    // 重新计算连续天数
    var currentStreak = 0;
    if (newCompletedDates.isNotEmpty) {
      final sortedDates = newCompletedDates.toSet().toList()..sort();
      currentStreak = 1;
      for (var i = sortedDates.length - 1; i > 0; i--) {
        final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
        if (diff == 1) {
          currentStreak++;
        } else {
          break;
        }
      }
    }

    final updated = habit.copyWith(
      completedDates: newCompletedDates,
      currentStreak: currentStreak,
      updatedAt: now,
    );

    await _repository.save(updated);
    return updated;
  }

  /// 删除习惯
  Future<void> deleteHabit(String id) async {
    await _repository.delete(id);
  }
}
