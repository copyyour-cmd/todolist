import 'package:todolist/src/core/config/api_config.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/infrastructure/http/dio_client.dart';
import 'package:todolist/src/infrastructure/http/error_handler.dart';

/// 标签云端服务
/// 注意: 后端暂时只有同步接口，独立的标签CRUD API待开发
class TagCloudService {

  TagCloudService(this._client);
  final DioClient _client;

  /// 通过同步接口获取所有标签
  Future<List<Tag>> getAllTags() async {
    try {
      final response = await _client.get(ApiConfig.fullSyncEndpoint);
      final data = response.data['data'];

      if (data['tags'] != null) {
        return (data['tags'] as List)
            .map(Tag.fromJson)
            .toList();
      }
      return [];
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(message: '获取标签失败: $e');
    }
  }

  /// 将Tag转换为API所需的JSON格式
  Map<String, dynamic> tagToJson(Tag tag) {
    return {
      'id': tag.id,
      'name': tag.name,
      'color': tag.color.value.toRadixString(16).padLeft(8, '0'),
    };
  }
}
