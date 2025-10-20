/// AI消息实体
/// 用于AI对话的消息结构
class AIMessage {
  const AIMessage({
    required this.role,
    required this.content,
  });

  /// 消息角色: 'system', 'user', 'assistant'
  final String role;

  /// 消息内容
  final String content;

  /// 转换为API请求格式
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }

  /// 从API响应创建
  factory AIMessage.fromJson(Map<String, dynamic> json) {
    return AIMessage(
      role: json['role'] as String,
      content: json['content'] as String,
    );
  }

  /// 创建系统消息
  factory AIMessage.system(String content) {
    return AIMessage(role: 'system', content: content);
  }

  /// 创建用户消息
  factory AIMessage.user(String content) {
    return AIMessage(role: 'user', content: content);
  }

  /// 创建助手消息
  factory AIMessage.assistant(String content) {
    return AIMessage(role: 'assistant', content: content);
  }
}

/// AI响应结果
class AIResponse {
  const AIResponse({
    required this.content,
    this.model,
    this.usage,
  });

  /// 响应内容
  final String content;

  /// 使用的模型名称
  final String? model;

  /// Token使用情况
  final AIUsage? usage;

  factory AIResponse.fromJson(Map<String, dynamic> json) {
    final choices = json['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw const AIException('Invalid response: no choices');
    }

    final firstChoice = choices[0] as Map<String, dynamic>;
    final message = firstChoice['message'] as Map<String, dynamic>?;
    if (message == null) {
      throw const AIException('Invalid response: no message');
    }

    final content = message['content'] as String? ?? '';
    final model = json['model'] as String?;

    final usageJson = json['usage'] as Map<String, dynamic>?;
    final usage = usageJson != null ? AIUsage.fromJson(usageJson) : null;

    return AIResponse(
      content: content,
      model: model,
      usage: usage,
    );
  }
}

/// Token使用统计
class AIUsage {
  const AIUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  /// 提示词Token数
  final int promptTokens;

  /// 生成内容Token数
  final int completionTokens;

  /// 总Token数
  final int totalTokens;

  factory AIUsage.fromJson(Map<String, dynamic> json) {
    return AIUsage(
      promptTokens: json['prompt_tokens'] as int? ?? 0,
      completionTokens: json['completion_tokens'] as int? ?? 0,
      totalTokens: json['total_tokens'] as int? ?? 0,
    );
  }
}

/// AI服务异常
class AIException implements Exception {
  const AIException(this.message);

  final String message;

  @override
  String toString() => 'AIException: $message';
}
