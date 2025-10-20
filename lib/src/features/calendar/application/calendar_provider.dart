import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

part 'calendar_provider.g.dart';

@riverpod
Stream<List<Task>> calendarTasks(CalendarTasksRef ref) {
  final repository = ref.watch(taskRepositoryProvider);

  return repository.watchAll().map((tasks) {
    // Return all tasks that have a due date
    return tasks.where((task) => task.dueAt != null).toList()
      ..sort((a, b) => a.dueAt!.compareTo(b.dueAt!));
  });
}
