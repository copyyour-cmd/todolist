import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/repositories/tag_repository.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

class TagCreationInput {
  TagCreationInput({
    required this.name,
    this.colorHex = '#8896AB',
  });

  final String name;
  final String colorHex;
}

class TagUpdateInput extends TagCreationInput {
  TagUpdateInput({
    required super.name,
    super.colorHex,
  });
}

class TagService {
  TagService({
    required TagRepository tagRepository,
    required TaskRepository taskRepository,
    required Clock clock,
    required IdGenerator idGenerator,
    required AppLogger logger,
  })  : _tagRepository = tagRepository,
        _taskRepository = taskRepository,
        _clock = clock,
        _idGenerator = idGenerator,
        _logger = logger;

  final TagRepository _tagRepository;
  final TaskRepository _taskRepository;
  final Clock _clock;
  final IdGenerator _idGenerator;
  final AppLogger _logger;

  Future<Tag> createTag(TagCreationInput input) async {
    final now = _clock.now();
    final tag = Tag(
      id: _idGenerator.generate(),
      name: input.name,
      colorHex: input.colorHex,
      createdAt: now,
      updatedAt: now,
    );

    await _tagRepository.save(tag);
    _logger.info('Tag created', tag.id);
    return tag;
  }

  Future<Tag> updateTag(Tag existing, TagUpdateInput input) async {
    final now = _clock.now();
    final updated = existing.copyWith(
      name: input.name,
      colorHex: input.colorHex,
      updatedAt: now,
    );

    await _tagRepository.save(updated);
    _logger.info('Tag updated', updated.id);
    return updated;
  }

  Future<void> deleteTag(String tagId) async {
    // Get all tasks with this tag
    final allTasks = await _taskRepository.watchAll().first;
    final tasksWithTag = allTasks.where(
      (task) => task.tagIds.contains(tagId),
    );

    // Remove tag from all tasks
    for (final task in tasksWithTag) {
      final updatedTagIds = task.tagIds.where((id) => id != tagId).toList();
      await _taskRepository.save(
        task.copyWith(tagIds: updatedTagIds),
      );
    }

    await _tagRepository.delete(tagId);
    _logger.info('Tag deleted', {'tagId': tagId, 'tasksUpdated': tasksWithTag.length});
  }

  Future<int> getTaskCount(String tagId) async {
    final allTasks = await _taskRepository.watchAll().first;
    return allTasks.where((task) => task.tagIds.contains(tagId)).length;
  }

  Future<Map<String, int>> getTaskCountsForAllTags() async {
    final allTasks = await _taskRepository.watchAll().first;
    final counts = <String, int>{};

    for (final task in allTasks) {
      for (final tagId in task.tagIds) {
        counts[tagId] = (counts[tagId] ?? 0) + 1;
      }
    }

    return counts;
  }
}

final tagServiceProvider = Provider<TagService>((ref) {
  return TagService(
    tagRepository: ref.watch(tagRepositoryProvider),
    taskRepository: ref.watch(taskRepositoryProvider),
    clock: ref.watch(clockProvider),
    idGenerator: IdGenerator(),
    logger: ref.watch(appLoggerProvider),
  );
});
