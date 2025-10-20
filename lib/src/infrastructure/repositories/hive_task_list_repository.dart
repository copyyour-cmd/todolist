import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/domain/repositories/repository_exception.dart';
import 'package:todolist/src/domain/repositories/task_list_repository.dart';
import 'package:todolist/src/infrastructure/hive/hive_boxes.dart';

class HiveTaskListRepository implements TaskListRepository {
  HiveTaskListRepository(Box<TaskList> box) : _box = box;

  final Box<TaskList> _box;

  static Future<HiveTaskListRepository> create() async {
    final box = Hive.isBoxOpen(HiveBoxes.taskLists)
        ? Hive.box<TaskList>(HiveBoxes.taskLists)
        : await Hive.openBox<TaskList>(HiveBoxes.taskLists);
    return HiveTaskListRepository(box);
  }

  @override
  Stream<List<TaskList>> watchAll() async* {
    yield _orderedLists();
    yield* _box.watch().map((_) => _orderedLists());
  }

  @override
  Future<List<TaskList>> findAll() {
    return _guardAsync('Failed to fetch task lists', () async => _orderedLists());
  }

  @override
  Future<TaskList?> findById(String id) {
    return _guardAsync('Failed to find task list ', () async => _box.get(id));
  }

  @override
  Future<void> save(TaskList list) {
    return _guardAsync('Failed to save task list ', () async {
      await _box.put(list.id, list.copyWith(updatedAt: DateTime.now()));
    });
  }

  @override
  Future<void> delete(String id) {
    return _guardAsync('Failed to delete task list ', () async {
      await _box.delete(id);
    });
  }

  @override
  Future<void> reindex(List<TaskList> lists) {
    return _guardAsync('Failed to reindex task lists', () async {
      final now = DateTime.now();
      await _box.putAll({
        for (var index = 0; index < lists.length; index++)
          lists[index].id: lists[index].copyWith(
                sortOrder: index,
                updatedAt: now,
              ),
      });
    });
  }

  @override
  Future<void> clear() {
    return _guardAsync('Failed to clear task lists', () async {
      await _box.clear();
    });
  }

  List<TaskList> _orderedLists() => _box.values.toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  Future<T> _guardAsync<T>(String context, Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      throw RepositoryException(
        context,
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}
