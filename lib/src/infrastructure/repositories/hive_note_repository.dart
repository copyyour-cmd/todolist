import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/domain/repositories/repository_exception.dart';
import 'package:todolist/src/infrastructure/hive/hive_boxes.dart';

class HiveNoteRepository implements NoteRepository {
  HiveNoteRepository(Box<Note> box) : _box = box;

  final Box<Note> _box;

  static Future<HiveNoteRepository> create() async {
    final box = Hive.isBoxOpen(HiveBoxes.notes)
        ? Hive.box<Note>(HiveBoxes.notes)
        : await Hive.openBox<Note>(HiveBoxes.notes);
    return HiveNoteRepository(box);
  }

  @override
  Stream<List<Note>> watchAll() async* {
    yield _sortedNotes();
    yield* _box.watch().map((_) => _sortedNotes());
  }

  @override
  Stream<Note?> watchById(String id) async* {
    yield await getById(id);
    yield* _box.watch(key: id).map((event) {
      return event.deleted ? null : _box.get(id);
    });
  }

  @override
  Future<List<Note>> getAll() {
    return _guardAsync('Failed to get all notes', () async {
      return _sortedNotes();
    });
  }

  @override
  Future<Note?> getById(String id) {
    return _guardAsync('Failed to find note', () async {
      return _box.get(id);
    });
  }

  @override
  Future<void> save(Note note) {
    return _guardAsync('Failed to save note', () async {
      await _box.put(note.id, note.copyWith(updatedAt: DateTime.now()));
    });
  }

  @override
  Future<void> saveAll(Iterable<Note> notes) {
    return _guardAsync('Failed to save multiple notes', () async {
      final now = DateTime.now();
      await _box.putAll({
        for (final note in notes) note.id: note.copyWith(updatedAt: now),
      });
    });
  }

  @override
  Future<void> delete(String id) {
    return _guardAsync('Failed to delete note', () async {
      await _box.delete(id);
    });
  }

  @override
  Future<void> deleteAll(Iterable<String> ids) {
    return _guardAsync('Failed to delete multiple notes', () async {
      await _box.deleteAll(ids);
    });
  }

  @override
  Future<void> clear() {
    return _guardAsync('Failed to clear notes', () async {
      await _box.clear();
    });
  }

  @override
  Future<List<Note>> getByCategory(NoteCategory category) {
    return _guardAsync('Failed to get notes by category', () async {
      return _box.values
          .where((note) => note.category == category && !note.isArchived)
          .toList()
        ..sort(_sortByUpdatedAt);
    });
  }

  @override
  Future<List<Note>> getByTag(String tag) {
    return _guardAsync('Failed to get notes by tag', () async {
      return _box.values
          .where((note) => note.tags.contains(tag) && !note.isArchived)
          .toList()
        ..sort(_sortByUpdatedAt);
    });
  }

  @override
  Future<List<Note>> getFavorites() {
    return _guardAsync('Failed to get favorite notes', () async {
      return _box.values
          .where((note) => note.isFavorite && !note.isArchived)
          .toList()
        ..sort(_sortByUpdatedAt);
    });
  }

  @override
  Future<List<Note>> getPinned() {
    return _guardAsync('Failed to get pinned notes', () async {
      return _box.values
          .where((note) => note.isPinned && !note.isArchived)
          .toList()
        ..sort(_sortByUpdatedAt);
    });
  }

  @override
  Future<List<Note>> getArchived() {
    return _guardAsync('Failed to get archived notes', () async {
      return _box.values.where((note) => note.isArchived).toList()
        ..sort(_sortByUpdatedAt);
    });
  }

  @override
  Future<List<Note>> getByFolder(String? folderPath) {
    return _guardAsync('Failed to get notes by folder', () async {
      return _box.values
          .where((note) => note.folderPath == folderPath && !note.isArchived)
          .toList()
        ..sort(_sortByUpdatedAt);
    });
  }

  @override
  Future<List<Note>> search(String query) {
    return _guardAsync('Failed to search notes', () async {
      if (query.trim().isEmpty) {
        return [];
      }

      final lowerQuery = query.toLowerCase();
      return _box.values.where((note) {
        if (note.isArchived) return false;

        final titleMatch = note.title.toLowerCase().contains(lowerQuery);
        final contentMatch = note.content.toLowerCase().contains(lowerQuery);
        final tagMatch = note.tags.any(
          (tag) => tag.toLowerCase().contains(lowerQuery),
        );

        return titleMatch || contentMatch || tagMatch;
      }).toList()
        ..sort(_sortByUpdatedAt);
    });
  }

  @override
  Future<List<Note>> getRecentlyViewed({int limit = 10}) {
    return _guardAsync('Failed to get recently viewed notes', () async {
      final notes = _box.values
          .where((note) => note.lastViewedAt != null && !note.isArchived)
          .toList();

      notes.sort((a, b) {
        final aViewed = a.lastViewedAt ?? a.createdAt;
        final bViewed = b.lastViewedAt ?? b.createdAt;
        return bViewed.compareTo(aViewed);
      });

      return notes.take(limit).toList();
    });
  }

  @override
  Future<List<Note>> getRecentlyUpdated({int limit = 10}) {
    return _guardAsync('Failed to get recently updated notes', () async {
      final notes = _box.values.where((note) => !note.isArchived).toList()
        ..sort(_sortByUpdatedAt);

      return notes.take(limit).toList();
    });
  }

  /// 排序：置顶 > 更新时间
  List<Note> _sortedNotes() {
    final notes = _box.values.where((note) => !note.isArchived).toList();

    notes.sort((a, b) {
      // 置顶的笔记排在前面
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;

      // 按更新时间倒序
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return notes;
  }

  /// 按更新时间倒序
  int _sortByUpdatedAt(Note a, Note b) {
    return b.updatedAt.compareTo(a.updatedAt);
  }

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
