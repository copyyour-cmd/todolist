import 'package:todolist/src/domain/entities/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> watchAll();

  Stream<Task?> watchById(String id);

  Future<List<Task>> getAll();

  Future<List<Task>> findDueBetween({DateTime? start, DateTime? end});

  Future<Task?> findById(String id);

  Future<Task?> getById(String id);

  Future<void> save(Task task);

  Future<void> saveAll(Iterable<Task> tasks);

  Future<void> delete(String id);

  Future<void> clear();
}
