import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

part 'home_tasks_provider.g.dart';

enum TaskSortOption {
  manual,
  dueDate,
  priority,
  createdDate,
}

Iterable<Task> _filterActiveTasks(Iterable<Task> tasks) {
  return tasks.where((task) {
    return !task.isCompleted &&
        task.status != TaskStatus.cancelled &&
        task.status != TaskStatus.archived;
  });
}

List<Task> _applyFiltersAndSort(
  Iterable<Task> tasks, {
  required TaskSortOption sortBy,
  required bool showCompleted, TaskPriority? priorityFilter,
  String? tagFilter,
  List<String>? tagFilters,
  TagFilterLogic? tagFilterLogic,
  String? listFilter,
}) {
  var filtered = tasks;

  // Filter by completion status
  if (!showCompleted) {
    filtered = _filterActiveTasks(filtered);
  }

  // Filter by priority
  if (priorityFilter != null) {
    filtered = filtered.where((task) => task.priority == priorityFilter);
  }

  // Filter by single tag (legacy support)
  if (tagFilter != null) {
    filtered = filtered.where((task) => task.tagIds.contains(tagFilter));
  }

  // Filter by multiple tags with AND/OR logic
  if (tagFilters != null && tagFilters.isNotEmpty) {
    if (tagFilterLogic == TagFilterLogic.and) {
      // AND logic: task must have all selected tags
      filtered = filtered.where((task) {
        return tagFilters.every((tagId) => task.tagIds.contains(tagId));
      });
    } else {
      // OR logic: task must have at least one selected tag
      filtered = filtered.where((task) {
        return tagFilters.any((tagId) => task.tagIds.contains(tagId));
      });
    }
  }

  // Filter by list
  if (listFilter != null) {
    filtered = filtered.where((task) => task.listId == listFilter);
  }

  // Sort
  final list = filtered.toList();
  switch (sortBy) {
    case TaskSortOption.manual:
      list.sort((a, b) {
        final compare = a.sortOrder.compareTo(b.sortOrder);
        if (compare != 0) return compare;
        return a.createdAt.compareTo(b.createdAt);
      });
    case TaskSortOption.dueDate:
      list.sort((a, b) {
        final dateA = a.dueAt ?? DateTime(9999);
        final dateB = b.dueAt ?? DateTime(9999);
        final compare = dateA.compareTo(dateB);
        if (compare != 0) return compare;
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      });
    case TaskSortOption.priority:
      list.sort((a, b) {
        // Higher priority first (critical -> none)
        final compare = b.priority.index.compareTo(a.priority.index);
        if (compare != 0) return compare;
        // Then by due date
        final dateA = a.dueAt ?? DateTime(9999);
        final dateB = b.dueAt ?? DateTime(9999);
        return dateA.compareTo(dateB);
      });
    case TaskSortOption.createdDate:
      list.sort((a, b) {
        final compare = b.createdAt.compareTo(a.createdAt); // Newest first
        if (compare != 0) return compare;
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      });
  }

  return list;
}

List<Task> _sortBySchedule(Iterable<Task> tasks) {
  return tasks.toList()
    ..sort((a, b) {
      final dateA = a.dueAt ?? a.createdAt;
      final dateB = b.dueAt ?? b.createdAt;
      final compare = dateA.compareTo(dateB);
      if (compare != 0) {
        return compare;
      }
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
}

@riverpod
Stream<List<Task>> todayTasks(TodayTasksRef ref) {
  final clock = ref.watch(clockProvider);
  final repository = ref.watch(taskRepositoryProvider);
  final start = clock.today();
  final end = start.add(const Duration(days: 1));

  final timer = clock.scheduleAt(end, ref.invalidateSelf);
  ref.onDispose(timer.cancel);

  return repository.watchAll().map((tasks) {
    final filtered = _filterActiveTasks(tasks).where((task) {
      final due = task.dueAt;
      if (due == null) return false;
      return !due.isBefore(start) && due.isBefore(end);
    });
    return _sortBySchedule(filtered);
  });
}

@riverpod
Stream<List<Task>> overdueTasks(OverdueTasksRef ref) {
  final clock = ref.watch(clockProvider);
  final repository = ref.watch(taskRepositoryProvider);
  final today = clock.today();

  return repository.watchAll().map((tasks) {
    final filtered = _filterActiveTasks(tasks).where((task) {
      final due = task.dueAt;
      if (due == null) {
        return false;
      }
      return due.isBefore(today);
    });
    return _sortBySchedule(filtered);
  });
}

@riverpod
Stream<List<Task>> upcomingTasks(UpcomingTasksRef ref) {
  final clock = ref.watch(clockProvider);
  final repository = ref.watch(taskRepositoryProvider);
  final start = clock.today().add(const Duration(days: 1));
  final end = start.add(const Duration(days: 7));

  return repository.watchAll().map((tasks) {
    final filtered = _filterActiveTasks(tasks).where((task) {
      final due = task.dueAt;
      if (due == null) {
        return false;
      }
      if (due.isBefore(start)) {
        return false;
      }
      return !due.isAfter(end);
    });
    return _sortBySchedule(filtered);
  });
}

enum HomeTaskFilter { today, thisWeek, important, all, overdue, upcoming }

enum TagFilterLogic { and, or }

final homeTaskFilterProvider =
    StateProvider<HomeTaskFilter>((ref) => HomeTaskFilter.today);

final taskSortOptionProvider =
    StateProvider<TaskSortOption>((ref) => TaskSortOption.manual);

final taskPriorityFilterProvider =
    StateProvider<TaskPriority?>((ref) => null);

// 支持多标签筛选
final taskTagFiltersProvider =
    StateProvider<List<String>>((ref) => []);

// 多标签筛选逻辑（AND/OR）
final tagFilterLogicProvider =
    StateProvider<TagFilterLogic>((ref) => TagFilterLogic.or);

final taskTagFilterProvider =
    StateProvider<String?>((ref) => null);

final taskListFilterProvider =
    StateProvider<String?>((ref) => null);

final showCompletedTasksProvider =
    StateProvider<bool>((ref) => false);

@riverpod
Stream<List<Task>> filteredTasks(FilteredTasksRef ref) {
  final filter = ref.watch(homeTaskFilterProvider);
  final sortBy = ref.watch(taskSortOptionProvider);
  final priorityFilter = ref.watch(taskPriorityFilterProvider);
  final tagFilter = ref.watch(taskTagFilterProvider);
  final tagFilters = ref.watch(taskTagFiltersProvider);
  final tagFilterLogic = ref.watch(tagFilterLogicProvider);
  final listFilter = ref.watch(taskListFilterProvider);
  final showCompleted = ref.watch(showCompletedTasksProvider);

  final repository = ref.watch(taskRepositoryProvider);

  return repository.watchAll().map((tasks) {
    // First apply time-based filter
    Iterable<Task> filtered;
    final clock = ref.watch(clockProvider);

    switch (filter) {
      case HomeTaskFilter.today:
        final start = clock.today();
        final end = start.add(const Duration(days: 1));
        filtered = _filterActiveTasks(tasks).where((task) {
          final due = task.dueAt;
          if (due == null) return false;
          return !due.isBefore(start) && due.isBefore(end);
        });
      case HomeTaskFilter.thisWeek:
        final start = clock.today();
        final end = start.add(const Duration(days: 7));
        filtered = _filterActiveTasks(tasks).where((task) {
          final due = task.dueAt;
          if (due == null) return false;
          return !due.isBefore(start) && due.isBefore(end);
        });
      case HomeTaskFilter.important:
        filtered = _filterActiveTasks(tasks).where((task) {
          return task.priority == TaskPriority.high ||
              task.priority == TaskPriority.critical;
        });
      case HomeTaskFilter.all:
        filtered = _filterActiveTasks(tasks);
      case HomeTaskFilter.overdue:
        final today = clock.today();
        filtered = _filterActiveTasks(tasks).where((task) {
          final due = task.dueAt;
          if (due == null) return false;
          return due.isBefore(today);
        });
      case HomeTaskFilter.upcoming:
        final start = clock.today().add(const Duration(days: 1));
        final end = start.add(const Duration(days: 7));
        filtered = _filterActiveTasks(tasks).where((task) {
          final due = task.dueAt;
          if (due == null) return false;
          if (due.isBefore(start)) return false;
          return !due.isAfter(end);
        });
    }

    // Then apply additional filters and sorting
    return _applyFiltersAndSort(
      filtered,
      sortBy: sortBy,
      priorityFilter: priorityFilter,
      tagFilter: tagFilter,
      tagFilters: tagFilters,
      tagFilterLogic: tagFilterLogic,
      listFilter: listFilter,
      showCompleted: showCompleted,
    );
  });
}
