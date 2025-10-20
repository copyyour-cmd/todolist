import 'package:todolist/src/core/config/api_config.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/infrastructure/http/dio_client.dart';
import 'package:todolist/src/infrastructure/http/error_handler.dart';

/// 列表云端服务
/// 注意: 后端暂时只有同步接口，独立的列表CRUD API待开发
class ListCloudService {

  ListCloudService(this._client);
  final DioClient _client;

  /// 通过同步接口获取所有列表
  Future<List<TaskList>> getAllLists() async {
    try {
      final response = await _client.get(ApiConfig.fullSyncEndpoint);
      final data = response.data['data'];

      if (data['lists'] != null) {
        return (data['lists'] as List)
            .map(TaskList.fromJson)
            .toList();
      }
      return [];
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(message: '获取列表失败: $e');
    }
  }

  /// 将TaskList转换为API所需的JSON格式
  Map<String, dynamic> listToJson(TaskList list) {
    return {
      'id': list.id,
      'name': list.name,
      'color': list.color.value.toRadixString(16).padLeft(8, '0'),
      if (list.icon != null) 'icon': list.icon,
      'sort_order': list.sortOrder,
      'is_default': list.isDefault,
    };
  }
}
