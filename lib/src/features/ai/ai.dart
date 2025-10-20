/// AI增强功能模块
///
/// 提供智能摘要、标签推荐、相关笔记推荐、智能问答等AI增强功能
///
/// ## 快速开始
///
/// ```dart
/// // 1. 导入模块
/// import 'package:todolist/src/features/ai/ai.dart';
///
/// // 2. 配置API Key
/// final saveApiKey = ref.read(saveAIApiKeyProvider);
/// await saveApiKey('你的API Key');
///
/// // 3. 使用AI功能
/// final summary = await ref.read(
///   generateNoteSummaryProvider(note).future,
/// );
/// ```
///
/// 详细文档请查看 [README.md](README.md)
library ai;

// Domain
export 'domain/ai_message.dart';
export 'domain/ai_service.dart';

// Data
export 'data/siliconflow_ai_service.dart';

// Application
export 'application/note_ai_service.dart';
export 'application/ai_providers.dart';

// Presentation
export 'presentation/ai_settings_page.dart';
export 'presentation/widgets/note_ai_actions.dart';
