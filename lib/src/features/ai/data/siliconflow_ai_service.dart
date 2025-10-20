import 'package:dio/dio.dart';
import 'package:todolist/src/features/ai/domain/ai_message.dart';
import 'package:todolist/src/features/ai/domain/ai_service.dart';

/// 硅基流动AI服务实现
/// 兼容OpenAI API格式
class SiliconFlowAIService implements AIService {
  SiliconFlowAIService({
    required String apiKey,
    String? baseUrl,
    String? model,
    Dio? dio,
  })  : _apiKey = apiKey,
        _baseUrl = baseUrl ?? 'https://api.siliconflow.cn/v1',
        _model = model ?? 'Qwen/Qwen2.5-7B-Instruct',
        _dio = dio ?? Dio();

  final String _apiKey;
  final String _baseUrl;
  final String _model;
  final Dio _dio;

  @override
  String get modelName => _model;

  @override
  Future<AIResponse> chat({
    required List<AIMessage> messages,
    double temperature = 0.7,
    int maxTokens = 1000,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/chat/completions',
        data: {
          'model': _model,
          'messages': messages.map((m) => m.toJson()).toList(),
          'temperature': temperature,
          'max_tokens': maxTokens,
          'stream': false,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.json,
        ),
      );

      if (response.data == null) {
        throw const AIException('Empty response from AI service');
      }

      return AIResponse.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          final errorMsg = data['error']?['message'] ?? e.message ?? 'Unknown error';
          throw AIException('AI请求失败: $errorMsg');
        }
      }
      throw AIException('网络请求失败: ${e.message}');
    } catch (e) {
      throw AIException('AI服务异常: $e');
    }
  }

  @override
  Future<String> generateSummary({
    required String text,
    int maxLength = 100,
  }) async {
    final response = await chat(
      messages: [
        AIMessage.user('''
请为以下内容生成一个简洁的摘要，不超过${maxLength}字：

$text

要求：
- 提取核心要点
- 语言简洁明了
- 保持客观中立
- 只返回摘要内容，不要其他说明
'''),
      ],
      temperature: 0.5, // 降低随机性
      maxTokens: (maxLength * 1.5).toInt(), // 预留一些token空间
    );

    return response.content.trim();
  }

  @override
  Future<List<String>> extractKeywords({
    required String text,
    int count = 5,
  }) async {
    final response = await chat(
      messages: [
        AIMessage.user('''
分析以下内容，提取$count个最相关的关键词标签：

$text

要求：
- 每个标签2-4个中文字
- 标签要准确反映内容主题
- 只返回标签列表，用逗号分隔
- 不要编号，不要其他说明
'''),
      ],
      temperature: 0.3, // 进一步降低随机性，保证稳定输出
      maxTokens: 100,
    );

    // 解析返回的标签
    final content = response.content.trim();
    final tags = content
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .take(count)
        .toList();

    return tags;
  }

  @override
  Future<bool> isAvailable() async {
    try {
      // 发送一个简单的测试请求
      await chat(
        messages: [AIMessage.user('你好')],
        maxTokens: 10,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
