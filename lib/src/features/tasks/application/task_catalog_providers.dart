import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

part 'task_catalog_providers.g.dart';

@riverpod
Stream<List<TaskList>> taskLists(TaskListsRef ref) {
  return ref.watch(taskListRepositoryProvider).watchAll();
}

@riverpod
Stream<List<Tag>> tags(TagsRef ref) {
  return ref.watch(tagRepositoryProvider).watchAll();
}

@riverpod
Stream<List<Task>> allTasks(AllTasksRef ref) {
  return ref.watch(taskRepositoryProvider).watchAll();
}
