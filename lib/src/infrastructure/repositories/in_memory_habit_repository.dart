import 'dart:async';
import 'package:todolist/src/domain/entities/habit.dart';
import 'package:todolist/src/domain/repositories/habit_repository.dart';

class InMemoryHabitRepository implements HabitRepository {

  InMemoryHabitRepository() {
    _controller.add(_habits);
  }
  final _habits = <String, Habit>{};
  final _controller = StreamController<Map<String, Habit>>.broadcast();

  @override
  Stream<List<Habit>> watchAll() {
    return _controller.stream.map((habits) => habits.values.toList());
  }

  @override
  Stream<Habit?> watchById(String id) {
    return _controller.stream.map((habits) => habits[id]);
  }

  @override
  Future<List<Habit>> getAll() async {
    return _habits.values.toList();
  }

  @override
  Future<Habit?> findById(String id) async {
    return _habits[id];
  }

  @override
  Future<void> save(Habit habit) async {
    _habits[habit.id] = habit;
    _controller.add(_habits);
  }

  @override
  Future<void> delete(String id) async {
    _habits.remove(id);
    _controller.add(_habits);
  }

  @override
  Future<void> clear() async {
    _habits.clear();
    _controller.add(_habits);
  }

  void dispose() {
    _controller.close();
  }
}
