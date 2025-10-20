import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/features/voice/application/baidu_voice_input_service.dart';
import 'package:todolist/src/features/voice/infrastructure/super_nlp_parser.dart';
import 'package:todolist/src/features/voice/infrastructure/task_nlp_parser.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

final baiduVoiceServiceProvider = Provider<BaiduVoiceInputService>((ref) {
  final logger = ref.watch(appLoggerProvider);
  final prefs = ref.watch(sharedPreferencesProvider);

  return BaiduVoiceInputService(logger, prefs);
});

/// NLP 任务解析器 provider（旧版）
final taskNlpParserProvider = Provider<TaskNlpParser>((ref) {
  final logger = ref.watch(appLoggerProvider);
  return TaskNlpParser(logger);
});

/// 超强 NLP 任务解析器 provider
final enhancedTaskNlpParserProvider = Provider<SuperNlpParser>((ref) {
  final logger = ref.watch(appLoggerProvider);
  return SuperNlpParser(logger);
});
