import 'package:dio/dio.dart';
import 'package:todolist/src/core/config/api_config.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/infrastructure/http/dio_client.dart';
import 'package:todolist/src/infrastructure/http/error_handler.dart';

/// 任务云端服务
class TaskCloudService {

  TaskCloudService(this._client);
  final DioClient _client;

  /// 获取云端任务列表
  ///
  /// [page] 页码，默认1
  /// [limit] 每页数量，默认100
  /// [listId] 按列表ID过滤
  /// [status] 按状态过滤
  /// [priority] 按优先级过滤
  /// [updatedAfter] 增量同步时间点
  Future<List<Task>> getTasks({
    int page = 1,
    int limit = 100,
    String? listId,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? updatedAfter,
    bool includeDeleted = false,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (listId != null) 'listId': listId,
        if (status != null) 'status': status.name,
        if (priority != null) 'priority': priority.name,
        if (updatedAfter != null) 'updatedAfter': updatedAfter.toIso8601String(),
        'includeDeleted': includeDeleted,
      };

      final response = await _client.get(
        ApiConfig.getTasksEndpoint,
        queryParameters: queryParams,
      );

      final data = response.data['data'];
      final tasks = (data['tasks'] as List)
          .map(Task.fromJson)
          .toList();

      return tasks;
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(message: '获取任务列表失败: $e');
    }
  }

  /// 获取单个任务详情
  Future<Task> getTask(String taskId) async {
    try {
      final response = await _client.get('${ApiConfig.tasksPath}/$taskId');
      return Task.fromJson(response.data['data']);
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(message: '获取任务详情失败: $e');
    }
  }

  /// 创建云端任务
  Future<Task> createTask(Task task) async {
    try {
      final response = await _client.post(
        ApiConfig.createTaskEndpoint,
        data: _taskToJson(task),
      );

      return Task.fromJson(response.data['data']);
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(message: '创建任务失败: $e');
    }
  }

  /// 更新云端任务
  Future<Task> updateTask(Task task) async {
    try {
      final response = await _client.put(
        '${ApiConfig.tasksPath}/${task.id}',
        data: _taskToJson(task),
      );

      return Task.fromJson(response.data['data']);
    } on DioException catch (e) {
      // 检查是否是版本冲突
      if (e.response?.statusCode == 409) {
        final errorData = e.response?.data;
        if (errorData['error'] == 'VERSION_CONFLICT') {
          throw TaskVersionConflictException(
            clientVersion: errorData['data']['client_version'],
            serverVersion: errorData['data']['server_version'],
            serverTask: Task.fromJson(errorData['data']['server_task']),
          );
        }
      }
      throw HttpException.fromDioException(e);
    } catch (e) {
      throw HttpException(message: '更新任务失败: $e');
    }
  }

  /// 删除任务
  ///
  /// [permanent] 是否永久删除，默认false（软删除）
  Future<void> deleteTask(String taskId, {bool permanent = false}) async {
    try {
      await _client.delete(
        '${ApiConfig.tasksPath}/$taskId',
        queryParameters: {'permanent': permanent},
      );
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(message: '删除任务失败: $e');
    }
  }

  /// 恢复已删除的任务
  Future<Task> restoreTask(String taskId) async {
    try {
      final response = await _client.post(
        '${ApiConfig.tasksPath}/$taskId/restore',
      );
      return Task.fromJson(response.data['data']);
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(message: '恢复任务失败: $e');
    }
  }

  /// 批量更新任务
  Future<int> batchUpdateTasks(
    List<String> taskIds,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _client.post(
        ApiConfig.batchUpdateTasksEndpoint,
        data: {
          'task_ids': taskIds,
          'updates': updates,
        },
      );

      return response.data['data']['updated_count'] as int;
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(message: '批量更新任务失败: $e');
    }
  }

  /// 将Task转换为API所需的JSON格式
  Map<String, dynamic> _taskToJson(Task task) {
    return {
      'client_id': task.id,
      'title': task.title,
      if (task.description != null) 'description': task.description,
      if (task.listId != null) 'list_id': task.listId,
      if (task.tags.isNotEmpty) 'tags': task.tags,
      'priority': task.priority.name,
      'status': task.status.name,
      if (task.dueDate != null) 'due_at': task.dueDate!.toIso8601String(),
      if (task.remindAt != null) 'remind_at': task.remindAt!.toIso8601String(),
      if (task.repeatType != RepeatType.none) ...{
        'repeat_type': task.repeatType.name,
        if (task.repeatRule != null) 'repeat_rule': task.repeatRule!.toJson(),
      },
      if (task.subTasks.isNotEmpty)
        'sub_tasks': task.subTasks.map((st) => st.toJson()).toList(),
      if (task.estimatedMinutes != null)
        'estimated_minutes': task.estimatedMinutes,
      'is_pinned': task.isPinned,
      if (task.version != null) 'version': task.version,
    };
  }
}

/// 任务版本冲突异常
class TaskVersionConflictException implements Exception {

  TaskVersionConflictException({
    required this.clientVersion,
    required this.serverVersion,
    required this.serverTask,
  });
  final int clientVersion;
  final int serverVersion;
  final Task serverTask;

  @override
  String toString() =>
      'TaskVersionConflictException: 客户端版本($clientVersion) vs 服务器版本($serverVersion)';
}
