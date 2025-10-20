import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/features/voice/application/voice_input_service.dart';

final voiceInputServiceProvider = Provider<VoiceInputService>((ref) {
  final logger = ref.watch(appLoggerProvider);
  return VoiceInputService(logger);
});
