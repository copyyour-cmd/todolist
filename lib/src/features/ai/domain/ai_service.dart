import 'package:todolist/src/features/ai/domain/ai_message.dart';

/// AI服务抽象接口
/// 定义所有AI服务必须实现的方法
abstract class AIService {
  /// 发送聊天消息
  ///
  /// [messages] 对话消息列表
  /// [temperature] 温度参数(0-2),控制随机性,默认0.7
  /// [maxTokens] 最大生成token数,默认1000
  Future<AIResponse> chat({
    required List<AIMessage> messages,
    double temperature = 0.7,
    int maxTokens = 1000,
  });

  /// 生成文本摘要
  ///
  /// [text] 要摘要的文本
  /// [maxLength] 摘要最大长度(字数)
  Future<String> generateSummary({
    required String text,
    int maxLength = 100,
  });

  /// 提取关键词/标签
  ///
  /// [text] 要分析的文本
  /// [count] 返回的标签数量
  Future<List<String>> extractKeywords({
    required String text,
    int count = 5,
  });

  /// 检查服务是否可用
  Future<bool> isAvailable();

  /// 获取当前使用的模型名称
  String get modelName;
}
