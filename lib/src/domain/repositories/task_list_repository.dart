import 'package:todolist/src/domain/entities/task_list.dart';

abstract class TaskListRepository {
  Stream<List<TaskList>> watchAll();

  Future<List<TaskList>> findAll();

  Future<TaskList?> findById(String id);

  Future<void> save(TaskList list);

  Future<void> delete(String id);

  Future<void> reindex(List<TaskList> lists);

  Future<void> clear();
}
