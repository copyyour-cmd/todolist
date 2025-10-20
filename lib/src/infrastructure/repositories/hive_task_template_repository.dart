import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/domain/entities/task_template.dart';
import 'package:todolist/src/domain/repositories/repository_exception.dart';
import 'package:todolist/src/domain/repositories/task_template_repository.dart';
import 'package:todolist/src/infrastructure/hive/hive_boxes.dart';
import 'package:todolist/src/infrastructure/seed/builtin_templates.dart';

class HiveTaskTemplateRepository implements TaskTemplateRepository {
  HiveTaskTemplateRepository(Box<TaskTemplate> box) : _box = box;

  final Box<TaskTemplate> _box;

  static const String _builtInInitKey = '_builtin_templates_initialized';

  static Future<HiveTaskTemplateRepository> create() async {
    final box = Hive.isBoxOpen(HiveBoxes.taskTemplates)
        ? Hive.box<TaskTemplate>(HiveBoxes.taskTemplates)
        : await Hive.openBox<TaskTemplate>(HiveBoxes.taskTemplates);
    final repo = HiveTaskTemplateRepository(box);

    // Initialize built-in templates on first run
    await repo.initializeBuiltInTemplates();

    return repo;
  }

  @override
  Stream<List<TaskTemplate>> watchAll() async* {
    yield _sortedTemplates();
    yield* _box.watch().map((_) => _sortedTemplates());
  }

  @override
  Stream<TaskTemplate?> watchById(String id) async* {
    yield await getById(id);
    yield* _box.watch(key: id).map((event) {
      return event.deleted ? null : _box.get(id);
    });
  }

  @override
  Future<List<TaskTemplate>> getAll() {
    return _guardAsync('Failed to get all templates', () async {
      return _sortedTemplates();
    });
  }

  @override
  Future<List<TaskTemplate>> getByCategory(TemplateCategory category) {
    return _guardAsync('Failed to get templates by category', () async {
      return _box.values
          .where((template) => template.category == category)
          .toList()
        ..sort(_sortByUsage);
    });
  }

  @override
  Future<TaskTemplate?> getById(String id) {
    return _guardAsync('Failed to find template', () async {
      return _box.get(id);
    });
  }

  @override
  Future<void> save(TaskTemplate template) {
    return _guardAsync('Failed to save template', () async {
      await _box.put(template.id, template);
    });
  }

  @override
  Future<void> saveAll(Iterable<TaskTemplate> templates) {
    return _guardAsync('Failed to save multiple templates', () async {
      await _box.putAll({
        for (final template in templates) template.id: template,
      });
    });
  }

  @override
  Future<void> delete(String id) {
    return _guardAsync('Failed to delete template', () async {
      final template = _box.get(id);
      if (template?.isBuiltIn ?? false) {
        throw RepositoryException('Cannot delete built-in templates');
      }
      await _box.delete(id);
    });
  }

  @override
  Future<void> incrementUsageCount(String id) {
    return _guardAsync('Failed to increment usage count', () async {
      final template = _box.get(id);
      if (template != null) {
        await _box.put(
          id,
          template.copyWith(usageCount: template.usageCount + 1),
        );
      }
    });
  }

  @override
  Future<void> initializeBuiltInTemplates() async {
    return _guardAsync('Failed to initialize built-in templates', () async {
      // Check if already initialized
      final isInitialized = _box.get(_builtInInitKey) != null;
      if (isInitialized) return;

      // Load and save all built-in templates
      final builtInTemplates = BuiltInTemplates.getAll();
      await saveAll(builtInTemplates);

      // Mark as initialized using a dummy template as flag
      await _box.put(
        _builtInInitKey,
        TaskTemplate(
          id: _builtInInitKey,
          title: 'System Flag',
          category: TemplateCategory.custom,
          isBuiltIn: true,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  List<TaskTemplate> _sortedTemplates() {
    return _box.values
        .where((t) => t.id != _builtInInitKey) // Exclude system flag
        .toList()
      ..sort(_sortByUsage);
  }

  int _sortByUsage(TaskTemplate a, TaskTemplate b) {
    // Sort by usage count (descending), then by title
    final usageComparison = b.usageCount.compareTo(a.usageCount);
    if (usageComparison != 0) return usageComparison;
    return a.title.toLowerCase().compareTo(b.title.toLowerCase());
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
