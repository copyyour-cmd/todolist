import 'package:todolist/src/domain/entities/habit.dart';

abstract class HabitRepository {
  Stream<List<Habit>> watchAll();

  Stream<Habit?> watchById(String id);

  Future<List<Habit>> getAll();

  Future<Habit?> findById(String id);

  Future<void> save(Habit habit);

  Future<void> delete(String id);

  Future<void> clear();
}
