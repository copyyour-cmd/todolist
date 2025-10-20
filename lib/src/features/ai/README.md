# AI增强功能模块

## 📋 功能概述

本模块为todolist应用添加了强大的AI增强功能，包括：

- 🤖 **智能摘要**: 自动生成笔记摘要
- 🏷️ **标签推荐**: 智能推荐相关标签
- 🔗 **相关笔记**: 基于TF-IDF和余弦相似度推荐相关笔记
- 💬 **智能问答**: 基于笔记内容回答问题

## 🏗️ 架构设计

### 目录结构

```
lib/src/features/ai/
├── domain/              # 领域层
│   ├── ai_message.dart  # AI消息实体
│   └── ai_service.dart  # AI服务抽象接口
├── data/                # 数据层
│   └── siliconflow_ai_service.dart  # 硅基流动实现
├── application/         # 应用层
│   ├── note_ai_service.dart        # 笔记AI服务
│   └── ai_providers.dart            # Riverpod Providers
└── presentation/        # 表现层
    ├── ai_settings_page.dart        # AI设置页面
    └── widgets/
        └── note_ai_actions.dart     # AI操作组件
```

### 设计原则

✅ **依赖倒置原则 (DIP)**: 抽象接口 `AIService` 定义行为,具体实现可替换

✅ **单一职责原则 (SRP)**:
- `AIService`: 负责AI基础能力
- `NoteAIService`: 负责笔记相关的AI增强
- `SiliconFlowAIService`: 负责与硅基流动API交互

✅ **开闭原则 (OCP)**: 易于扩展新的AI后端(OpenAI, Ollama等)

## 🚀 使用指南

### 1. 配置AI服务

#### 获取API Key

1. 访问 [硅基流动官网](https://siliconflow.cn)
2. 注册并登录账号
3. 进入控制台获取API Key
4. 新用户有免费额度可用

#### 在应用中配置

```dart
// 方式1: 通过UI配置 (推荐)
// 导航到 设置 -> AI设置 -> 输入API Key

// 方式2: 代码配置
final saveApiKey = ref.read(saveAIApiKeyProvider);
await saveApiKey('你的API Key');
```

### 2. 使用AI功能

#### 在笔记详情页添加AI组件

```dart
import 'package:todolist/src/features/ai/presentation/widgets/note_ai_actions.dart';

// 在笔记详情页中
Column(
  children: [
    // ... 笔记内容 ...

    // 添加AI操作组件
    NoteAIActions(note: note),
  ],
)
```

#### 直接调用AI服务

```dart
// 1. 生成摘要
final summary = await ref.read(
  generateNoteSummaryProvider(note).future,
);

// 2. 推荐标签
final tags = await ref.read(
  suggestNoteTagsProvider(note).future,
);

// 3. 相关笔记推荐
final relatedNotes = await ref.read(
  recommendedNotesProvider(note).future,
);

// 4. 智能问答
final answer = await ref.read(
  askAboutNoteProvider((
    note: note,
    question: '这篇笔记的核心观点是什么?',
  )).future,
);
```

## 🎨 UI组件

### AISettingsPage - AI设置页面

完整的AI配置页面,包括:
- API Key配置
- 模型选择
- 连接测试
- 功能介绍

```dart
// 导航到AI设置
context.push('/settings/ai');
```

### NoteAIActions - AI操作组件

集成4个AI功能的操作面板:
- 一键生成摘要
- 一键推荐标签
- 查看相关笔记
- 智能问答

## 📊 可用模型

| 模型 | 参数量 | 特点 | 适用场景 |
|-----|-------|------|---------|
| Qwen/Qwen2.5-7B-Instruct | 7B | 速度快,成本低 | 日常使用 |
| Qwen/Qwen2.5-14B-Instruct | 14B | 平衡性能 | 标准需求 |
| Qwen/Qwen2.5-32B-Instruct | 32B | 高质量 | 专业内容 |
| Qwen/Qwen2.5-72B-Instruct | 72B | 最强性能 | 复杂任务 |
| THUDM/glm-4-9b-chat | 9B | 中文友好 | 中文内容 |
| deepseek-ai/DeepSeek-V3 | - | 代码能力强 | 技术笔记 |

## 🔧 高级用法

### 自定义AI服务

如果需要集成其他AI服务(如OpenAI, Ollama),只需实现 `AIService` 接口:

```dart
class MyCustomAIService implements AIService {
  @override
  Future<AIResponse> chat({
    required List<AIMessage> messages,
    double temperature = 0.7,
    int maxTokens = 1000,
  }) async {
    // 实现你的AI调用逻辑
  }

  @override
  Future<String> generateSummary({
    required String text,
    int maxLength = 100,
  }) async {
    // 实现摘要生成
  }

  // ... 其他方法
}
```

然后替换Provider:

```dart
final aiServiceProvider = Provider<AIService?>((ref) {
  return MyCustomAIService();
});
```

### 批量处理

```dart
// 批量生成摘要
final service = ref.read(noteAIServiceProvider);
final summaries = await service?.batchGenerateSummaries(
  notes,
  maxLength: 100,
);
```

### 调整AI参数

```dart
// 调整温度参数(0-2)
// 0: 确定性输出
// 1: 平衡
// 2: 创造性输出
final response = await aiService.chat(
  messages: [AIMessage.user('...')],
  temperature: 0.3,  // 更确定的输出
  maxTokens: 500,
);
```

## 💰 成本估算

硅基流动的定价(以Qwen2.5-7B为例):
- 输入: ~¥0.0007/1K tokens
- 输出: ~¥0.002/1K tokens

**估算**:
- 一次摘要: ~0.01元
- 一次标签推荐: ~0.005元
- 一次问答: ~0.02元

新用户通常有**免费额度**,足够日常使用!

## 🛡️ 安全性

### API Key存储

- 使用 `flutter_secure_storage` 加密存储
- API Key不会明文保存在SharedPreferences
- 支持随时清除配置

### 数据隐私

- 笔记内容仅在生成请求时发送给AI服务
- 不会自动上传或缓存笔记内容
- 用户完全控制何时使用AI功能

## 🚧 局限性

1. **网络依赖**: 需要网络连接调用AI服务
2. **响应延迟**: 根据模型大小,响应时间1-10秒不等
3. **成本**: 虽然有免费额度,但大量使用需要付费
4. **准确性**: AI生成的内容可能存在错误,需要人工检查

## 🎯 未来扩展

- [ ] 支持本地AI模型(Ollama)
- [ ] 笔记自动分类
- [ ] 写作建议和改进
- [ ] 多轮对话支持
- [ ] 语音转文字增强
- [ ] 笔记知识图谱

## 🤝 贡献

欢迎提交Issue和PR!

---

**提示**: 使用AI功能前请先在设置中配置API Key。第一次使用建议先测试连接。

**支持**: 如有问题,请查看 [硅基流动文档](https://docs.siliconflow.cn) 或提交Issue。
