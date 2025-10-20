import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/repositories/repository_exception.dart';
import 'package:todolist/src/domain/repositories/tag_repository.dart';
import 'package:todolist/src/infrastructure/hive/hive_boxes.dart';

class HiveTagRepository implements TagRepository {
  HiveTagRepository(Box<Tag> box) : _box = box;

  final Box<Tag> _box;

  static Future<HiveTagRepository> create() async {
    final box = Hive.isBoxOpen(HiveBoxes.tags)
        ? Hive.box<Tag>(HiveBoxes.tags)
        : await Hive.openBox<Tag>(HiveBoxes.tags);
    return HiveTagRepository(box);
  }

  @override
  Stream<List<Tag>> watchAll() async* {
    yield _sortedTags();
    yield* _box.watch().map((_) => _sortedTags());
  }

  @override
  Future<List<Tag>> findAll() {
    return _guardAsync('Failed to fetch tags', () async => _sortedTags());
  }

  @override
  Future<Tag?> findById(String id) {
    return _guardAsync('Failed to find tag ', () async => _box.get(id));
  }

  @override
  Future<void> save(Tag tag) {
    return _guardAsync('Failed to save tag ', () async {
      await _box.put(tag.id, tag.copyWith(updatedAt: DateTime.now()));
    });
  }

  @override
  Future<void> delete(String id) {
    return _guardAsync('Failed to delete tag ', () async {
      await _box.delete(id);
    });
  }

  @override
  Future<void> clear() {
    return _guardAsync('Failed to clear tags', () async {
      await _box.clear();
    });
  }

  List<Tag> _sortedTags() => _box.values.toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

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
