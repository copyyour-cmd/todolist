import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/features/ai/application/note_ai_service.dart';
import 'package:todolist/src/features/ai/data/siliconflow_ai_service.dart';
import 'package:todolist/src/features/ai/domain/ai_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

/// 安全存储Provider
final _secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// AI API Key存储键
const _aiApiKeyStorageKey = 'ai_api_key';
const _aiModelStorageKey = 'ai_model';

/// AI API Key Provider
final aiApiKeyProvider = StateProvider<String?>((ref) {
  return null;
});

/// AI模型Provider
final aiModelProvider = StateProvider<String>((ref) {
  return 'Qwen/Qwen2.5-7B-Instruct'; // 默认模型
});

/// 从安全存储加载AI配置
final loadAIConfigProvider = FutureProvider<void>((ref) async {
  final storage = ref.watch(_secureStorageProvider);

  // 加载API Key
  final apiKey = await storage.read(key: _aiApiKeyStorageKey);
  if (apiKey != null) {
    ref.read(aiApiKeyProvider.notifier).state = apiKey;
  }

  // 加载模型配置
  final model = await storage.read(key: _aiModelStorageKey);
  if (model != null) {
    ref.read(aiModelProvider.notifier).state = model;
  }
});

/// 保存AI API Key
final saveAIApiKeyProvider = Provider<Future<void> Function(String)>((ref) {
  return (String apiKey) async {
    final storage = ref.watch(_secureStorageProvider);
    await storage.write(key: _aiApiKeyStorageKey, value: apiKey);
    ref.read(aiApiKeyProvider.notifier).state = apiKey;
  };
});

/// 保存AI模型配置
final saveAIModelProvider = Provider<Future<void> Function(String)>((ref) {
  return (String model) async {
    final storage = ref.watch(_secureStorageProvider);
    await storage.write(key: _aiModelStorageKey, value: model);
    ref.read(aiModelProvider.notifier).state = model;
  };
});

/// 清除AI配置
final clearAIConfigProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final storage = ref.watch(_secureStorageProvider);
    await storage.delete(key: _aiApiKeyStorageKey);
    await storage.delete(key: _aiModelStorageKey);
    ref.read(aiApiKeyProvider.notifier).state = null;
    ref.read(aiModelProvider.notifier).state = 'Qwen/Qwen2.5-7B-Instruct';
  };
});

/// AI服务Provider
final aiServiceProvider = Provider<AIService?>((ref) {
  final apiKey = ref.watch(aiApiKeyProvider);
  final model = ref.watch(aiModelProvider);

  if (apiKey == null || apiKey.isEmpty) {
    return null;
  }

  return SiliconFlowAIService(
    apiKey: apiKey,
    model: model,
  );
});

/// 笔记AI服务Provider
final noteAIServiceProvider = Provider<NoteAIService?>((ref) {
  final aiService = ref.watch(aiServiceProvider);
  final noteRepository = ref.watch(noteRepositoryProvider);

  if (aiService == null) {
    return null;
  }

  return NoteAIService(
    aiService: aiService,
    noteRepository: noteRepository,
  );
});

/// AI可用性检查Provider
final aiAvailabilityProvider = FutureProvider<bool>((ref) async {
  final aiService = ref.watch(aiServiceProvider);
  if (aiService == null) {
    return false;
  }

  try {
    return await aiService.isAvailable();
  } catch (e) {
    return false;
  }
});

/// 生成笔记摘要Provider
final generateNoteSummaryProvider = FutureProvider.family<String?, Note>(
  (ref, note) async {
    final service = ref.watch(noteAIServiceProvider);
    if (service == null) {
      return null;
    }

    try {
      return await service.generateSummary(note);
    } catch (e) {
      throw Exception('生成摘要失败: $e');
    }
  },
);

/// 推荐笔记标签Provider
final suggestNoteTagsProvider = FutureProvider.family<List<String>?, Note>(
  (ref, note) async {
    final service = ref.watch(noteAIServiceProvider);
    if (service == null) {
      return null;
    }

    try {
      return await service.suggestTags(note);
    } catch (e) {
      throw Exception('标签推荐失败: $e');
    }
  },
);

/// 推荐相关笔记Provider
final recommendedNotesProvider = FutureProvider.family<List<Note>?, Note>(
  (ref, note) async {
    final service = ref.watch(noteAIServiceProvider);
    if (service == null) {
      return null;
    }

    try {
      return await service.recommendRelatedNotes(note);
    } catch (e) {
      throw Exception('笔记推荐失败: $e');
    }
  },
);

/// 智能问答Provider
final askAboutNoteProvider = FutureProvider.family<String?, ({Note note, String question})>(
  (ref, params) async {
    final service = ref.watch(noteAIServiceProvider);
    if (service == null) {
      return null;
    }

    try {
      return await service.askAboutNote(params.note, params.question);
    } catch (e) {
      throw Exception('问答失败: $e');
    }
  },
);
