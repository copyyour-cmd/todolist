import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/domain/repositories/task_list_repository.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

class ListCreationInput {
  ListCreationInput({
    required this.name,
    this.iconName,
    this.colorHex = '#4C83FB',
    this.isDefault = false,
  });

  final String name;
  final String? iconName;
  final String colorHex;
  final bool isDefault;
}

class ListUpdateInput extends ListCreationInput {
  ListUpdateInput({
    required super.name,
    super.iconName,
    super.colorHex,
    super.isDefault,
  });
}

class ListService {
  ListService({
    required TaskListRepository taskListRepository,
    required TaskRepository taskRepository,
    required Clock clock,
    required IdGenerator idGenerator,
    required AppLogger logger,
  })  : _taskListRepository = taskListRepository,
        _taskRepository = taskRepository,
        _clock = clock,
        _idGenerator = idGenerator,
        _logger = logger;

  final TaskListRepository _taskListRepository;
  final TaskRepository _taskRepository;
  final Clock _clock;
  final IdGenerator _idGenerator;
  final AppLogger _logger;

  Future<TaskList> createList(ListCreationInput input) async {
    final now = _clock.now();
    final allLists = await _taskListRepository.findAll();
    final maxSortOrder = allLists.isEmpty
        ? 0
        : allLists.map((l) => l.sortOrder).reduce((a, b) => a > b ? a : b);

    final list = TaskList(
      id: _idGenerator.generate(),
      name: input.name,
      iconName: input.iconName,
      colorHex: input.colorHex,
      sortOrder: maxSortOrder + 1,
      isDefault: input.isDefault,
      createdAt: now,
      updatedAt: now,
    );

    await _taskListRepository.save(list);
    _logger.info('List created', list.id);
    return list;
  }

  Future<TaskList> updateList(TaskList existing, ListUpdateInput input) async {
    final now = _clock.now();
    final updated = existing.copyWith(
      name: input.name,
      iconName: input.iconName,
      colorHex: input.colorHex,
      isDefault: input.isDefault,
      updatedAt: now,
    );

    await _taskListRepository.save(updated);
    _logger.info('List updated', updated.id);
    return updated;
  }

  Future<void> deleteList(String listId) async {
    // Check if list has tasks
    final tasks = await _taskRepository.watchAll().first;
    final hasTasksInList = tasks.any((task) => task.listId == listId);

    if (hasTasksInList) {
      throw ListHasTasksException(
        'Cannot delete list with existing tasks',
      );
    }

    await _taskListRepository.delete(listId);
    _logger.info('List deleted', listId);
  }

  Future<void> reorderLists(List<TaskList> lists) async {
    await _taskListRepository.reindex(lists);
    _logger.info('Lists reordered', lists.length);
  }
}

class ListHasTasksException implements Exception {
  ListHasTasksException(this.message);
  final String message;

  @override
  String toString() => message;
}

final listServiceProvider = Provider<ListService>((ref) {
  return ListService(
    taskListRepository: ref.watch(taskListRepositoryProvider),
    taskRepository: ref.watch(taskRepositoryProvider),
    clock: ref.watch(clockProvider),
    idGenerator: IdGenerator(),
    logger: ref.watch(appLoggerProvider),
  );
});
