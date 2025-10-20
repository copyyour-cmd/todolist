import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/domain/repositories/tag_repository.dart';
import 'package:todolist/src/domain/repositories/task_list_repository.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';
import 'package:todolist/src/infrastructure/http/http_client.dart';

/// 云同步服务
class CloudSyncService {
  CloudSyncService({
    required AppLogger logger,
    required HttpClient httpClient,
    required TaskRepository taskRepository,
    required TaskListRepository listRepository,
    required TagRepository tagRepository,
  })  : _logger = logger,
        _httpClient = httpClient,
        _taskRepository = taskRepository,
        _listRepository = listRepository,
        _tagRepository = tagRepository;

  final AppLogger _logger;
  final HttpClient _httpClient;
  final TaskRepository _taskRepository;
  final TaskListRepository _listRepository;
  final TagRepository _tagRepository;

  /// 上传所有数据到云端
  Future<Map<String, int>> uploadAll({String? deviceId}) async {
    try {
      _logger.info('开始上传所有数据到云端');

      // 获取本地所有数据
      final tasks = await _taskRepository.getAll();
      final lists = await _listRepository.findAll();
      final tags = await _tagRepository.findAll();

      // 构建上传数据
      final data = {
        'tasks': tasks.map(_taskToJson).toList(),
        'lists': lists.map(_listToJson).toList(),
        'tags': tags.map(_tagToJson).toList(),
        if (deviceId != null) 'deviceId': deviceId,
      };

      // 上传到服务器
      final response = await _httpClient.dio.post(
        '/cloud-sync/upload',
        data: data,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final summary = response.data['data']['summary'] as Map<String, dynamic>;
        _logger.info('数据上传成功', summary);

        return {
          'tasks': summary['tasks'] as int,
          'lists': summary['lists'] as int,
          'tags': summary['tags'] as int,
        };
      }

      throw Exception(response.data['message'] ?? '上传失败');
    } catch (e) {
      _logger.error('上传数据失败', e, StackTrace.current);
      rethrow;
    }
  }

  /// 从云端下载所有数据并恢复到本地
  Future<Map<String, int>> downloadAll({
    String? deviceId,
    bool clearLocal = false,
  }) async {
    try {
      _logger.info('开始从云端下载数据');

      // 下载数据
      final response = await _httpClient.dio.get(
        '/cloud-sync/download',
        queryParameters: {
          if (deviceId != null) 'deviceId': deviceId,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];

        // 清空本地数据（如果需要）
        if (clearLocal) {
          await _clearLocalData();
        }

        // 恢复列表
        final lists = (data['lists'] as List)
            .map((json) => _listFromJson(json as Map<String, dynamic>))
            .toList();
        for (final list in lists) {
          await _listRepository.save(list);
        }

        // 恢复标签
        final tags = (data['tags'] as List)
            .map((json) => _tagFromJson(json as Map<String, dynamic>))
            .toList();
        for (final tag in tags) {
          await _tagRepository.save(tag);
        }

        // 恢复任务
        final tasks = (data['tasks'] as List)
            .map((json) => _taskFromJson(json as Map<String, dynamic>))
            .toList();
        for (final task in tasks) {
          await _taskRepository.save(task);
        }

        final summary = response.data['summary'] as Map<String, dynamic>;
        _logger.info('数据下载成功', summary);

        return {
          'tasks': summary['tasks'] as int,
          'lists': summary['lists'] as int,
          'tags': summary['tags'] as int,
        };
      }

      throw Exception(response.data['message'] ?? '下载失败');
    } catch (e) {
      _logger.error('下载数据失败', e, StackTrace.current);
      rethrow;
    }
  }

  /// 创建云端快照
  Future<void> createSnapshot({
    String? name,
    String? description,
  }) async {
    try {
      final response = await _httpClient.dio.post(
        '/cloud-sync/snapshots',
        data: {
          if (name != null) 'name': name,
          if (description != null) 'description': description,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        _logger.info('快照创建成功');
        return;
      }

      throw Exception(response.data['message'] ?? '创建快照失败');
    } catch (e) {
      _logger.error('创建快照失败', e, StackTrace.current);
      rethrow;
    }
  }

  /// 从快照恢复
  Future<void> restoreFromSnapshot(int snapshotId) async {
    try {
      final response = await _httpClient.dio.post(
        '/cloud-sync/snapshots/$snapshotId/restore',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        _logger.info('快照恢复成功');
        // 然后需要下载数据到本地
        await downloadAll(clearLocal: true);
        return;
      }

      throw Exception(response.data['message'] ?? '恢复失败');
    } catch (e) {
      _logger.error('恢复失败', e, StackTrace.current);
      rethrow;
    }
  }

  /// 获取快照列表
  Future<List<Map<String, dynamic>>> getSnapshots() async {
    try {
      final response = await _httpClient.dio.get('/cloud-sync/snapshots');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }

      throw Exception(response.data['message'] ?? '获取快照列表失败');
    } catch (e) {
      _logger.error('获取快照列表失败', e, StackTrace.current);
      rethrow;
    }
  }

  /// 清空本地数据
  Future<void> _clearLocalData() async {
    // 这里可以选择性清空或全部清空
    _logger.info('清空本地数据以准备恢复');
    // TODO: 实现清空逻辑
  }

  // 数据转换方法
  Map<String, dynamic> _taskToJson(Task task) {
    return {
      'id': task.id,
      'title': task.title,
      'notes': task.notes,
      'listId': task.listId,
      'priority': task.priority.name,
      'status': task.status.name,
      'dueAt': task.dueAt?.toIso8601String(),
      'remindAt': task.remindAt?.toIso8601String(),
      'completedAt': task.completedAt?.toIso8601String(),
      'createdAt': task.createdAt.toIso8601String(),
      'updatedAt': task.updatedAt.toIso8601String(),
    };
  }

  Task _taskFromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      notes: json['notes'],
      listId: json['listId'],
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => TaskPriority.none,
      ),
      status: TaskStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => TaskStatus.pending,
      ),
      dueAt: json['dueAt'] != null ? DateTime.parse(json['dueAt']) : null,
      remindAt: json['remindAt'] != null ? DateTime.parse(json['remindAt']) : null,
      completedAt:
          json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> _listToJson(TaskList list) {
    return {
      'id': list.id,
      'name': list.name,
      'colorHex': list.colorHex,
      'sortOrder': list.sortOrder,
      'isDefault': list.isDefault,
      'createdAt': list.createdAt.toIso8601String(),
      'updatedAt': list.updatedAt.toIso8601String(),
    };
  }

  TaskList _listFromJson(Map<String, dynamic> json) {
    return TaskList(
      id: json['id'],
      name: json['name'],
      colorHex: json['colorHex'],
      sortOrder: json['sortOrder'] ?? 0,
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> _tagToJson(Tag tag) {
    return {
      'id': tag.id,
      'name': tag.name,
      'colorHex': tag.colorHex,
      'createdAt': tag.createdAt.toIso8601String(),
      'updatedAt': tag.updatedAt.toIso8601String(),
    };
  }

  Tag _tagFromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      colorHex: json['colorHex'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

