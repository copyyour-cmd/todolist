import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/domain/repositories/task_list_repository.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/repositories/tag_repository.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';
import 'package:todolist/src/infrastructure/http/error_handler.dart';
import 'package:todolist/src/infrastructure/services/auth_service.dart';
import 'package:todolist/src/infrastructure/services/sync_service.dart';
import 'package:todolist/src/infrastructure/services/task_cloud_service.dart';

/// 云同步状态
enum SyncStatus {
  idle, // 空闲
  syncing, // 同步中
  success, // 成功
  failed, // 失败
  conflict, // 有冲突
}

/// 云同步管理器
/// 统一管理任务、列表、标签的云同步
class CloudSyncManager extends ChangeNotifier {

  CloudSyncManager({
    required SyncService syncService,
    required TaskCloudService taskCloudService,
    required TaskRepository taskRepository,
    required AuthService authService,
    ListRepository? listRepository,
    TagRepository? tagRepository,
  })  : _syncService = syncService,
        _taskCloudService = taskCloudService,
        _taskRepository = taskRepository,
        _authService = authService,
        _listRepository = listRepository,
        _tagRepository = tagRepository {
    _loadLastSyncTime();
    _startAutoSync();
  }
  final SyncService _syncService;
  final TaskCloudService _taskCloudService;
  final TaskRepository _taskRepository;
  final ListRepository? _listRepository;
  final TagRepository? _tagRepository;
  final AuthService _authService;

  // 同步状态
  SyncStatus _status = SyncStatus.idle;
  String? _errorMessage;
  DateTime? _lastSyncTime;
  List<SyncConflict> _conflicts = [];

  // 自动同步定时器
  Timer? _autoSyncTimer;
  bool _autoSyncEnabled = true;

  SyncStatus get status => _status;
  String? get errorMessage => _errorMessage;
  DateTime? get lastSyncTime => _lastSyncTime;
  List<SyncConflict> get conflicts => _conflicts;
  bool get hasConflicts => _conflicts.isNotEmpty;
  bool get autoSyncEnabled => _autoSyncEnabled;

  /// 加载上次同步时间
  Future<void> _loadLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSync = prefs.getString('last_sync_time');
    if (lastSync != null) {
      _lastSyncTime = DateTime.parse(lastSync);
      notifyListeners();
    }
  }

  /// 保存同步时间
  Future<void> _saveLastSyncTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_sync_time', time.toIso8601String());
    _lastSyncTime = time;
  }

  /// 启动自动同步（每5分钟）
  void _startAutoSync() {
    _autoSyncTimer?.cancel();
    if (_autoSyncEnabled) {
      _autoSyncTimer = Timer.periodic(
        const Duration(minutes: 5),
        (_) => syncAll(),
      );
    }
  }

  /// 设置自动同步
  Future<void> setAutoSync(bool enabled) async {
    _autoSyncEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_sync_enabled', enabled);

    if (enabled) {
      _startAutoSync();
    } else {
      _autoSyncTimer?.cancel();
    }
    notifyListeners();
  }

  /// 执行完整同步
  Future<void> syncAll({bool force = false}) async {
    // 检查是否已登录
    final user = await _authService.getCurrentUser();

    // 检查网络
    final isOnline = await _syncService.isNetworkAvailable();
    if (!isOnline) {
      _status = SyncStatus.failed;
      _errorMessage = '网络不可用';
      notifyListeners();
      return;
    }

    _status = SyncStatus.syncing;
    _errorMessage = null;
    _conflicts.clear();
    notifyListeners();

    try {
      // 1. 获取本地数据
      final localTasks = await _taskRepository.getAll();
      final localLists = await _listRepository?.getAll() ?? [];
      final localTags = await _tagRepository?.getAll() ?? [];

      // 2. 获取需要删除的ID（从本地标记中获取）
      final deletedTaskIds = await _getDeletedTaskIds();

      // 3. 调用同步API
      final result = await _syncService.syncData(
        tasks: localTasks,
        deletedTaskIds: deletedTaskIds,
        lists: localLists,
        deletedListIds: [],
        tags: localTags,
        deletedTagIds: [],
        deviceId: 'device-${user.id}',
      );

      // 4. 处理下载的任务
      for (final serverTask in result.downloadedTasks) {
        final localTask = await _taskRepository.getById(serverTask.id);
        if (localTask == null) {
          // 新任务，直接添加
          await _taskRepository.add(serverTask);
        } else {
          // 检查版本
          if (serverTask.version != null &&
              localTask.version != null &&
              serverTask.version! > localTask.version!) {
            // 服务器版本更新，覆盖本地
            await _taskRepository.update(serverTask);
          }
        }
      }

      // 5. 处理冲突
      if (result.conflicts.isNotEmpty) {
        _conflicts = result.conflicts;
        _status = SyncStatus.conflict;
      } else {
        _status = SyncStatus.success;
      }

      // 6. 保存同步时间
      await _saveLastSyncTime(result.syncAt);
      await _clearDeletedTaskIds();

      notifyListeners();
    } on HttpException catch (e) {
      _status = SyncStatus.failed;
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _status = SyncStatus.failed;
      _errorMessage = '同步失败: $e';
      notifyListeners();
    }
  }

  /// 强制全量同步（下载所有服务器数据）
  Future<void> forceFullSync() async {
    _status = SyncStatus.syncing;
    notifyListeners();

    try {
      final result = await _syncService.forceFullSync();

      // 清空本地数据
      final localTasks = await _taskRepository.getAll();
      for (final task in localTasks) {
        await _taskRepository.delete(task.id);
      }

      // 导入服务器数据
      for (final task in result.tasks) {
        await _taskRepository.add(task);
      }

      _status = SyncStatus.success;
      await _saveLastSyncTime(result.syncAt);
      notifyListeners();
    } on HttpException catch (e) {
      _status = SyncStatus.failed;
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _status = SyncStatus.failed;
      _errorMessage = '全量同步失败: $e';
      notifyListeners();
    }
  }

  /// 解决冲突（使用服务器版本）
  Future<void> resolveConflictWithServer(SyncConflict conflict) async {
    if (conflict.serverData != null) {
      final serverTask = Task.fromJson(conflict.serverData!);
      await _taskRepository.update(serverTask);
      _conflicts.remove(conflict);

      if (_conflicts.isEmpty) {
        _status = SyncStatus.success;
      }
      notifyListeners();
    }
  }

  /// 解决冲突（使用客户端版本）
  Future<void> resolveConflictWithClient(SyncConflict conflict) async {
    if (conflict.clientData != null) {
      final clientTask = Task.fromJson(conflict.clientData!);
      try {
        await _taskCloudService.updateTask(clientTask);
        _conflicts.remove(conflict);

        if (_conflicts.isEmpty) {
          _status = SyncStatus.success;
        }
        notifyListeners();
      } on TaskVersionConflictException catch (e) {
        _errorMessage = '冲突解决失败: $e';
        notifyListeners();
      }
    }
  }

  /// 获取已删除任务ID列表
  Future<List<String>> _getDeletedTaskIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('deleted_task_ids') ?? [];
  }

  /// 标记任务为已删除（用于同步）
  Future<void> markTaskAsDeleted(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final deletedIds = prefs.getStringList('deleted_task_ids') ?? [];
    if (!deletedIds.contains(taskId)) {
      deletedIds.add(taskId);
      await prefs.setStringList('deleted_task_ids', deletedIds);
    }
  }

  /// 清除已删除任务ID列表
  Future<void> _clearDeletedTaskIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('deleted_task_ids');
  }

  /// 获取同步状态
  Future<SyncStatusInfo?> getSyncStatus() async {
    try {
      final status = await _syncService.getSyncStatus();
      return status;
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _autoSyncTimer?.cancel();
    super.dispose();
  }
}
