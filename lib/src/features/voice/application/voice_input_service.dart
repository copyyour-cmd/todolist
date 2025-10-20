import 'dart:io' show Platform;
import 'package:todolist/src/core/logging/app_logger.dart';

/// Service for voice input and speech-to-text
/// Note: speech_to_text plugin removed due to Windows compatibility issues
/// Use Baidu Voice API (BaiduSpeechService) instead
class VoiceInputService {
  VoiceInputService(this._logger);

  final AppLogger _logger;

  bool _isInitialized = false;
  bool _isListening = false;
  String _lastRecognizedText = '';

  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;
  String get lastRecognizedText => _lastRecognizedText;

  /// Initialize speech recognition
  /// Always returns false - use BaiduSpeechService instead
  Future<bool> initialize() async {
    _logger.info('VoiceInputService: Use BaiduSpeechService for voice recognition');
    return false;
  }

  /// Start listening for speech input
  /// Always returns false - use BaiduSpeechService instead
  Future<bool> startListening({
    required Function(String) onResult,
    String localeId = 'zh_CN',
  }) async {
    _logger.warning('VoiceInputService not supported, use BaiduSpeechService');
    return false;
  }

  /// Stop listening
  Future<void> stopListening() async {
    _isListening = false;
  }

  /// Cancel listening
  Future<void> cancel() async {
    _isListening = false;
  }

  /// Get available locales
  Future<List<String>> getAvailableLocales() async {
    return ['zh_CN', 'en_US'];
  }

  /// Dispose resources
  void dispose() {
    _isListening = false;
    _isInitialized = false;
  }
}
