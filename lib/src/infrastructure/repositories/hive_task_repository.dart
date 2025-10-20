import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/repositories/repository_exception.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';
import 'package:todolist/src/infrastructure/hive/hive_boxes.dart';

class HiveTaskRepository implements TaskRepository {
  HiveTaskRepository(Box<Task> box) : _box = box;

  final Box<Task> _box;

  // 性能优化：缓存已排序的任务列表
  List<Task>? _cachedSortedTasks;

  // 性能优化：追踪box版本以检测变化
  int _lastKnownVersion = 0;

  // 性能监控：统计缓存命中
  int _cacheHits = 0;
  int _cacheMisses = 0;
  int _incrementalUpdates = 0;
  int _fullSorts = 0;

  static Future<HiveTaskRepository> create() async {
    final box = Hive.isBoxOpen(HiveBoxes.tasks)
        ? Hive.box<Task>(HiveBoxes.tasks)
        : await Hive.openBox<Task>(HiveBoxes.tasks);
    return HiveTaskRepository(box);
  }

  @override
  Stream<List<Task>> watchAll() async* {
    // 初始加载：使用缓存
    yield _getOrUpdateSortedTasks();

    // 监听变化：仅在数据变化时重新排序
    yield* _box.watch().map((event) {
      return _handleBoxEvent(event);
    });
  }

  /// 处理box变化事件，智能决定是否需要重新排序
  List<Task> _handleBoxEvent(BoxEvent event) {
    final stopwatch = Stopwatch()..start();

    try {
      // 如果事件包含key，说明是单个任务的变化
      if (event.key != null) {
        return _handleSingleTaskChange(event);
      }

      // 批量变化或清空，需要全量重新排序
      return _fullResort();
    } finally {
      stopwatch.stop();
      _logPerformance('handleBoxEvent', stopwatch.elapsedMicroseconds);
    }
  }

  /// 处理单个任务的增删改，使用增量更新
  List<Task> _handleSingleTaskChange(BoxEvent event) {
    final cachedList = _cachedSortedTasks;

    // 如果没有缓存，执行全量排序
    if (cachedList == null) {
      return _fullResort();
    }

    final key = event.key as String;
    final task = event.deleted ? null : _box.get(key);

    // 删除操作：从缓存中移除
    if (event.deleted || task == null) {
      final newList = List<Task>.from(cachedList)
        ..removeWhere((t) => t.id == key);
      _cachedSortedTasks = newList;
      _incrementalUpdates++;
      return newList;
    }

    // 查找任务在缓存中的位置
    final existingIndex = cachedList.indexWhere((t) => t.id == key);

    // 更新操作：移除旧的，插入新的
    if (existingIndex >= 0) {
      final newList = List<Task>.from(cachedList)..removeAt(existingIndex);
      _insertTaskSorted(newList, task);
      _cachedSortedTasks = newList;
      _incrementalUpdates++;
      return newList;
    }

    // 新增操作：直接插入到正确位置
    final newList = List<Task>.from(cachedList);
    _insertTaskSorted(newList, task);
    _cachedSortedTasks = newList;
    _incrementalUpdates++;
    return newList;
  }

  /// 使用二分插入将任务插入到已排序列表的正确位置
  void _insertTaskSorted(List<Task> sortedList, Task task) {
    // 如果列表为空，直接添加
    if (sortedList.isEmpty) {
      sortedList.add(task);
      return;
    }

    // 二分查找插入位置
    int low = 0;
    int high = sortedList.length;

    while (low < high) {
      final mid = (low + high) ~/ 2;
      if (_sortBySchedule(sortedList[mid], task) < 0) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }

    sortedList.insert(low, task);
  }

  @override
  Stream<Task?> watchById(String id) async* {
    yield await findById(id);
    yield* _box.watch(key: id).map((event) {
      return event.deleted ? null : _box.get(id);
    });
  }

  @override
  Future<List<Task>> getAll() {
    return _guardAsync('Failed to get all tasks', () async {
      return _getOrUpdateSortedTasks();
    });
  }

  /// 获取或更新缓存的已排序任务列表
  List<Task> _getOrUpdateSortedTasks() {
    final stopwatch = Stopwatch()..start();

    try {
      // 检查缓存是否有效
      if (_isCacheValid()) {
        _cacheHits++;
        return _cachedSortedTasks!;
      }

      // 缓存失效，执行全量排序
      _cacheMisses++;
      return _fullResort();
    } finally {
      stopwatch.stop();
      _logPerformance('getOrUpdateSortedTasks', stopwatch.elapsedMicroseconds);
    }
  }

  /// 检查缓存是否有效
  bool _isCacheValid() {
    if (_cachedSortedTasks == null) {
      return false;
    }

    // 检查任务数量是否匹配
    if (_cachedSortedTasks!.length != _box.length) {
      return false;
    }

    return true;
  }

  /// 执行全量重新排序
  List<Task> _fullResort() {
    _fullSorts++;
    final sorted = _box.values.toList()..sort(_sortBySchedule);
    _cachedSortedTasks = sorted;
    return sorted;
  }

  @override
  Future<List<Task>> findDueBetween({DateTime? start, DateTime? end}) {
    return _guardAsync('Failed to query tasks due between dates', () async {
      return _box.values
          .where((task) {
            final due = task.dueAt;
            if (due == null) return false;
            if (start != null && due.isBefore(start)) return false;
            if (end != null && due.isAfter(end)) return false;
            return true;
          })
          .toList()
        ..sort(_sortBySchedule);
    });
  }

  @override
  Future<Task?> findById(String id) {
    return _guardAsync('Failed to find task ', () async {
      return _box.get(id);
    });
  }

  @override
  Future<Task?> getById(String id) {
    return _guardAsync('Failed to get task ', () async {
      return _box.get(id);
    });
  }

  @override
  Future<void> save(Task task) {
    return _guardAsync('Failed to save task ', () async {
      await _box.put(task.id, task.copyWith(updatedAt: DateTime.now()));
      // 注意：缓存失效由watchAll的stream自动处理，无需手动清除
    });
  }

  @override
  Future<void> saveAll(Iterable<Task> tasks) {
    return _guardAsync('Failed to save multiple tasks', () async {
      final now = DateTime.now();
      await _box.putAll({
        for (final task in tasks) task.id: task.copyWith(updatedAt: now),
      });
      // 批量操作会触发box.watch()的批量事件，自动重新排序
    });
  }

  @override
  Future<void> delete(String id) {
    return _guardAsync('Failed to delete task ', () async {
      await _box.delete(id);
      // 删除操作会触发box.watch()的删除事件，自动更新缓存
    });
  }

  @override
  Future<void> clear() {
    return _guardAsync('Failed to clear tasks', () async {
      await _box.clear();
      // 清空时立即清除缓存
      _invalidateCache();
    });
  }

  /// 使缓存失效
  void _invalidateCache() {
    _cachedSortedTasks = null;
  }

  int _sortBySchedule(Task a, Task b) {
    final aDue = a.dueAt ?? a.createdAt;
    final bDue = b.dueAt ?? b.createdAt;
    final dueComparison = aDue.compareTo(bDue);
    if (dueComparison != 0) {
      return dueComparison;
    }
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

  /// 性能监控：记录操作耗时
  void _logPerformance(String operation, int microseconds) {
    // 仅在开发模式下记录性能数据
    // 生产环境可以发送到性能监控服务
    if (microseconds > 1000) {
      // 超过1ms的操作记录警告
      print('[Performance] $operation took ${microseconds}μs');
    }
  }

  /// 获取性能统计信息（用于调试和监控）
  Map<String, dynamic> getPerformanceStats() {
    final total = _cacheHits + _cacheMisses;
    final hitRate = total > 0 ? (_cacheHits / total * 100).toStringAsFixed(2) : '0.00';

    return {
      'cacheHits': _cacheHits,
      'cacheMisses': _cacheMisses,
      'cacheHitRate': '$hitRate%',
      'incrementalUpdates': _incrementalUpdates,
      'fullSorts': _fullSorts,
      'cachedTasksCount': _cachedSortedTasks?.length ?? 0,
      'actualTasksCount': _box.length,
    };
  }

  /// 重置性能统计（用于测试）
  void resetPerformanceStats() {
    _cacheHits = 0;
    _cacheMisses = 0;
    _incrementalUpdates = 0;
    _fullSorts = 0;
  }
}
