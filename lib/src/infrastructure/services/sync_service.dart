import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/core/config/api_config.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/infrastructure/http/dio_client.dart';

/// 同步结果
class SyncResult {

  SyncResult({
    required this.uploadedTasks,
    required this.downloadedTasks,
    required this.conflicts,
    required this.uploadedLists,
    required this.downloadedLists,
    required this.uploadedTags,
    required this.downloadedTags,
    required this.syncAt,
    this.conflictDetails = const [],
  });

  factory SyncResult.fromJson(Map<String, dynamic> json) {
    return SyncResult(
      uploadedTasks: json['uploaded_tasks'] ?? 0,
      downloadedTasks: (json['downloaded_tasks'] as List?)?.length ?? 0,
      conflicts: (json['conflicts'] as List?)?.length ?? 0,
      uploadedLists: json['uploaded_lists'] ?? 0,
      downloadedLists: (json['downloaded_lists'] as List?)?.length ?? 0,
      uploadedTags: json['uploaded_tags'] ?? 0,
      downloadedTags: (json['downloaded_tags'] as List?)?.length ?? 0,
      syncAt: DateTime.parse(json['sync_at']),
      conflictDetails: json['conflicts'] ?? [],
    );
  }
  final int uploadedTasks;
  final int downloadedTasks;
  final int conflicts;
  final int uploadedLists;
  final int downloadedLists;
  final int uploadedTags;
  final int downloadedTags;
  final DateTime syncAt;
  final List<dynamic> conflictDetails;
}

/// 云同步服务
class SyncService {

  SyncService(this._client);
  final DioClient _client;
  static const String _lastSyncKey = 'last_sync_at';

  /// 批量同步任务、列表、标签
  Future<SyncResult> syncData({
    required List<Task> tasks,
    required List<String> deletedTaskIds,
    required List<TaskList> lists,
    required List<String> deletedListIds,
    required List<Tag> tags,
    required List<String> deletedTagIds,
    String? deviceId,
  }) async {
    // 获取最后同步时间
    final prefs = await SharedPreferences.getInstance();
    final lastSyncAt = prefs.getString(_lastSyncKey);

    final response = await _client.post(
      '/api/sync',
      data: {
        'device_id': deviceId,
        'last_sync_at': lastSyncAt,
        'tasks': tasks.map(_taskToJson).toList(),
        'deleted_task_ids': deletedTaskIds,
        'lists': lists.map(_listToJson).toList(),
        'deleted_list_ids': deletedListIds,
        'tags': tags.map(_tagToJson).toList(),
        'deleted_tag_ids': deletedTagIds,
      },
      options: Options(
        sendTimeout: Duration(seconds: ApiConfig.backupUploadTimeout),
        receiveTimeout: Duration(seconds: ApiConfig.backupUploadTimeout),
      ),
    );

    final result = SyncResult.fromJson(response.data['data']);

    // 保存同步时间
    await prefs.setString(_lastSyncKey, result.syncAt.toIso8601String());

    return result;
  }

  /// 获取服务器任务
  Future<List<Map<String, dynamic>>> getServerTasks(SyncResult result) async {
    // 从同步结果中提取任务数据
    return [];
  }

  /// 获取同步状态
  Future<Map<String, dynamic>> getSyncStatus() async {
    final response = await _client.get('/api/sync/status');
    return response.data['data'];
  }

  /// 强制全量同步
  Future<Map<String, dynamic>> forceFullSync() async {
    final response = await _client.get('/api/sync/full');
    final data = response.data['data'];

    // 保存同步时间
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, data['sync_at']);

    return data;
  }

  /// 检查网络连接
  Future<bool> isNetworkAvailable() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet);
  }

  /// 获取最后同步时间
  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString(_lastSyncKey);
    if (lastSyncStr != null) {
      return DateTime.parse(lastSyncStr);
    }
    return null;
  }

  /// Task 转 JSON
  Map<String, dynamic> _taskToJson(Task task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'list_id': task.listId,
      'tags': task.tags?.map((t) => t.id).toList() ?? [],
      'priority': task.priority.name,
      'status': task.status.name,
      'due_at': task.dueDate?.toIso8601String(),
      'remind_at': task.reminderTime?.toIso8601String(),
      'repeat_type': task.recurrenceRule?.type.name,
      'repeat_rule': task.recurrenceRule != null
          ? {
              'type': task.recurrenceRule!.type.name,
              'interval': task.recurrenceRule!.interval,
              'end_date': task.recurrenceRule!.endDate?.toIso8601String(),
            }
          : null,
      'sub_tasks': task.subTasks
          ?.map((s) => {
                'id': s.id,
                'title': s.title,
                'is_completed': s.isCompleted,
              })
          .toList(),
      'attachments': task.attachments
          .map((a) => {
                'id': a.id,
                'type': a.type.name,
                'path': a.filePath,
                'name': a.fileName,
              })
          .toList(),
      'estimated_minutes': task.estimatedMinutes,
      'actual_minutes': task.actualMinutes,
      'sort_order': 0,
      'is_pinned': false,
      'color': null,
      'completed_at': task.completedAt?.toIso8601String(),
      'deleted_at': task.deletedAt?.toIso8601String(),
      'created_at': task.createdAt.toIso8601String(),
      'updated_at': task.updatedAt.toIso8601String(),
      'version': 1,
    };
  }

  /// TaskList 转 JSON
  Map<String, dynamic> _listToJson(TaskList list) {
    return {
      'id': list.id,
      'name': list.name,
      'icon': list.icon,
      'color': list.color != null ? '#${list.color!.value.toRadixString(16)}' : null,
      'sort_order': list.sortOrder,
      'is_default': list.isDefault,
      'created_at': list.createdAt.toIso8601String(),
      'updated_at': list.updatedAt.toIso8601String(),
    };
  }

  /// Tag 转 JSON
  Map<String, dynamic> _tagToJson(Tag tag) {
    return {
      'id': tag.id,
      'name': tag.name,
      'color': tag.color != null ? '#${tag.color!.value.toRadixString(16)}' : null,
      'created_at': tag.createdAt.toIso8601String(),
      'updated_at': tag.updatedAt.toIso8601String(),
    };
  }
}
