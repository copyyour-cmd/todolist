import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/domain/entities/habit.dart';
import 'package:todolist/src/features/habits/application/habit_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

part 'habit_providers.g.dart';

@riverpod
Stream<List<Habit>> habits(HabitsRef ref) {
  return ref.watch(habitRepositoryProvider).watchAll();
}

@riverpod
HabitService habitService(HabitServiceRef ref) {
  return HabitService(ref.watch(habitRepositoryProvider));
}
