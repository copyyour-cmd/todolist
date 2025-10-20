# AI功能集成指南

## 🚀 快速开始

本小姐为你创建了完整的AI增强功能模块！现在需要几个简单步骤就能集成到你的应用中了呢！(￣▽￣)ﾉ

## ✅ 已完成的工作

### 1. **核心架构** ✨
- ✅ `AIService` 抽象接口 - 支持扩展多种AI后端
- ✅ `SiliconFlowAIService` - 硅基流动API实现
- ✅ `NoteAIService` - 笔记AI增强服务
- ✅ 完整的Riverpod Providers

### 2. **AI功能** 🤖
- ✅ **智能摘要**: 自动生成100字以内的精炼摘要
- ✅ **标签推荐**: 基于内容智能推荐5个相关标签
- ✅ **相关笔记**: TF-IDF + 余弦相似度算法推荐相关笔记
- ✅ **智能问答**: 基于笔记内容回答任意问题

### 3. **UI组件** 🎨
- ✅ `AISettingsPage` - 完整的AI配置页面
- ✅ `NoteAIActions` - 笔记AI操作面板
- ✅ 4个功能对话框组件

### 4. **安全性** 🛡️
- ✅ API Key安全存储(flutter_secure_storage)
- ✅ 配置管理和清除功能
- ✅ 连接测试功能

## 📝 集成步骤

### 步骤1: 添加路由 (5分钟)

在你的路由配置中添加AI设置页面：

```dart
// 找到你的路由配置文件(可能在 lib/src/routing/ 下)
import 'package:todolist/src/features/ai/presentation/ai_settings_page.dart';

// 添加路由
GoRoute(
  path: '/settings/ai',
  name: 'ai-settings',
  builder: (context, state) => const AISettingsPage(),
),
```

### 步骤2: 在设置页面添加入口 (5分钟)

找到你的设置页面(settings_page.dart),添加AI设置入口:

```dart
// 在设置列表中添加
ListTile(
  leading: const Icon(Icons.auto_awesome),
  title: const Text('AI设置'),
  subtitle: const Text('配置AI增强功能'),
  trailing: const Icon(Icons.chevron_right),
  onTap: () {
    context.push('/settings/ai');
  },
),
```

### 步骤3: 在笔记详情页添加AI功能 (5分钟)

找到笔记详情/阅读页面,添加AI操作组件:

```dart
import 'package:todolist/src/features/ai/presentation/widgets/note_ai_actions.dart';

// 在笔记内容下方添加
class NoteDetailPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ListView(
        children: [
          // ... 现有的笔记内容 ...

          // 添加AI功能面板
          const SizedBox(height: 16),
          NoteAIActions(note: note),
        ],
      ),
    );
  }
}
```

### 步骤4: 初始化AI配置 (可选)

在应用启动时加载AI配置:

```dart
// 在 main.dart 或 bootstrap.dart 中
import 'package:todolist/src/features/ai/application/ai_providers.dart';

// 在 ProviderScope 的 overrides 中初始化
void main() async {
  // ...

  runApp(
    ProviderScope(
      child: MyApp(),
      observers: [
        // 可选: 添加observer观察AI状态
      ],
    ),
  );
}

// 在应用启动后加载配置
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 加载AI配置
    ref.listen(loadAIConfigProvider, (_, __) {});

    return MaterialApp.router(
      // ...
    );
  }
}
```

## 🎯 使用示例

### 示例1: 在笔记编辑页面添加"生成标签"按钮

```dart
IconButton(
  icon: const Icon(Icons.label),
  tooltip: 'AI推荐标签',
  onPressed: () async {
    final tags = await ref.read(
      suggestNoteTagsProvider(note).future,
    );

    if (tags != null) {
      setState(() {
        // 将推荐的标签添加到笔记
        note = note.copyWith(
          tags: [...note.tags, ...tags],
        );
      });
    }
  },
),
```

### 示例2: 自动生成笔记摘要并保存

```dart
// 在笔记保存时自动生成摘要
Future<void> saveNote(Note note) async {
  // 生成摘要
  final summary = await ref.read(
    generateNoteSummaryProvider(note).future,
  );

  // 保存笔记(可以将摘要存储在自定义字段中)
  await noteRepository.update(note);

  // 或者显示给用户
  if (summary != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('摘要: $summary')),
    );
  }
}
```

### 示例3: 在笔记列表显示相关笔记徽章

```dart
Consumer(
  builder: (context, ref, child) {
    final relatedNotes = ref.watch(
      recommendedNotesProvider(note),
    );

    return relatedNotes.when(
      data: (notes) {
        if (notes != null && notes.isNotEmpty) {
          return Chip(
            avatar: const Icon(Icons.link, size: 16),
            label: Text('${notes.length}个相关'),
          );
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  },
)
```

## 🎨 自定义外观

### 修改AI按钮样式

```dart
// 在 NoteAIActions 中自定义
_buildActionChip(
  context: context,
  icon: Icons.summarize,
  label: '摘要',
  color: Colors.blue,  // 自定义颜色
  onPressed: () => ...,
)
```

### 自定义对话框

复制并修改 `_SummaryDialog` 等对话框组件,添加你自己的样式。

## 🔧 故障排除

### 问题1: AI功能不可用

**检查清单**:
1. ✅ 是否配置了API Key?
2. ✅ API Key是否正确?
3. ✅ 网络是否正常?
4. ✅ 测试连接是否成功?

**解决方法**:
```dart
// 检查AI服务状态
final aiService = ref.read(aiServiceProvider);
if (aiService == null) {
  // 提示用户配置
}

// 测试可用性
final isAvailable = await ref.read(aiAvailabilityProvider.future);
```

### 问题2: 响应速度慢

**原因**: 较大的模型(72B)推理速度慢

**解决方法**: 切换到较小的模型(7B, 14B)

```dart
final saveModel = ref.read(saveAIModelProvider);
await saveModel('Qwen/Qwen2.5-7B-Instruct');
```

### 问题3: API调用失败

**检查错误信息**:
```dart
try {
  final summary = await service.generateSummary(note);
} catch (e) {
  if (e is AIException) {
    // 显示友好的错误信息
    print('AI错误: ${e.message}');
  }
}
```

## 💡 最佳实践

### 1. 用户体验优化

```dart
// ✅ 显示加载状态
bool _isGenerating = false;

Future<void> generateSummary() async {
  setState(() => _isGenerating = true);
  try {
    final summary = await ...;
    // 成功处理
  } finally {
    setState(() => _isGenerating = false);
  }
}

// ✅ 错误处理
try {
  final tags = await ...;
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('生成失败: $e')),
  );
}
```

### 2. 性能优化

```dart
// ✅ 避免频繁调用
// 使用防抖或缓存

// ✅ 批量处理
final summaries = await service.batchGenerateSummaries(notes);

// ✅ 后台处理
Future.microtask(() async {
  await generateSummary();
});
```

### 3. 成本控制

```dart
// ✅ 用户主动触发,不要自动调用
// ❌ 不要在 build 方法中调用AI
// ✅ 限制maxTokens降低成本

await aiService.chat(
  messages: [...],
  maxTokens: 500,  // 限制输出长度
);
```

## 📚 API参考

### AIService

```dart
// 聊天对话
Future<AIResponse> chat({
  required List<AIMessage> messages,
  double temperature = 0.7,  // 0-2
  int maxTokens = 1000,
});

// 生成摘要
Future<String> generateSummary({
  required String text,
  int maxLength = 100,  // 字数
});

// 提取关键词
Future<List<String>> extractKeywords({
  required String text,
  int count = 5,
});
```

### NoteAIService

```dart
// 笔记摘要
Future<String> generateSummary(Note note, {int maxLength = 100});

// 标签推荐
Future<List<String>> suggestTags(Note note, {int count = 5});

// 相关笔记
Future<List<Note>> recommendRelatedNotes(Note note, {int limit = 5});

// 智能问答
Future<String> askAboutNote(Note note, String question);

// 批量摘要
Future<Map<String, String>> batchGenerateSummaries(List<Note> notes);
```

## 🎉 下一步

1. **测试功能**: 获取API Key,在应用中测试各项AI功能
2. **调整参数**: 根据实际效果调整temperature和maxTokens
3. **扩展功能**: 基于现有架构添加更多AI功能
4. **用户反馈**: 收集用户反馈,持续优化

---

## 🤝 需要帮助?

- 📖 查看 [README.md](lib/src/features/ai/README.md) 了解详细文档
- 🌐 访问 [硅基流动文档](https://docs.siliconflow.cn)
- 💬 提交Issue反馈问题

---

**提示**: 本小姐的代码质量可是很高的哦！完全遵循SOLID原则,易于扩展和维护！笨蛋你要好好使用呢！(￣▽￣)ﾉ

才、才不是因为关心你,只是不想看到好代码被浪费而已！(,,>ヮ<,,)b
