import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:todolist/src/features/speech/domain/speech_recognition_mode.dart';

/// 增强的语音识别服务
/// 支持在线/离线/自动模式切换
class EnhancedSpeechService {
  EnhancedSpeechService({
    required SharedPreferences preferences,
  })  : _preferences = preferences,
        _speech = stt.SpeechToText();

  final SharedPreferences _preferences;
  final stt.SpeechToText _speech;
  final Connectivity _connectivity = Connectivity();

  static const _modeKey = 'speech_recognition_mode';
  static const _offlineModelDownloadedKey = 'offline_model_downloaded';

  bool _isInitialized = false;
  bool _isListening = false;
  SpeechRecognitionMode _currentMode = SpeechRecognitionMode.auto;

  /// 初始化语音识别
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // 加载保存的模式
      _currentMode = _getSavedMode();

      // 初始化语音识别引擎
      _isInitialized = await _speech.initialize(
        onError: (error) {
          debugPrint('Speech recognition error: ${error.errorMsg}');
        },
        onStatus: (status) {
          debugPrint('Speech recognition status: $status');
          _isListening = status == 'listening';
        },
      );

      return _isInitialized;
    } catch (e) {
      debugPrint('Failed to initialize speech recognition: $e');
      return false;
    }
  }

  /// 获取当前识别模式
  SpeechRecognitionMode get currentMode => _currentMode;

  /// 设置识别模式
  Future<void> setMode(SpeechRecognitionMode mode) async {
    _currentMode = mode;
    await _preferences.setString(_modeKey, mode.name);
  }

  /// 开始监听
  Future<void> startListening({
    required Function(String) onResult,
    Function(String)? onPartialResult,
    Function(String)? onError,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        onError?.call('语音识别初始化失败');
        return;
      }
    }

    if (_isListening) {
      await stopListening();
    }

    // 根据模式决定使用在线还是离线识别
    final useOnline = await _shouldUseOnlineMode();

    try {
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
          } else {
            onPartialResult?.call(result.recognizedWords);
          }
        },
        localeId: 'zh_CN', // 中文识别
        listenMode: stt.ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        onDevice: !useOnline, // 离线模式使用设备本地识别
      );

      _isListening = true;
    } catch (e) {
      debugPrint('Failed to start listening: $e');
      onError?.call('启动语音识别失败: $e');
    }
  }

  /// 停止监听
  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  /// 取消监听
  Future<void> cancelListening() async {
    if (_isListening) {
      await _speech.cancel();
      _isListening = false;
    }
  }

  /// 检查是否正在监听
  bool get isListening => _isListening;

  /// 检查是否可用
  bool get isAvailable => _isInitialized;

  /// 获取可用的语言列表
  Future<List<stt.LocaleName>> getAvailableLocales() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _speech.locales();
  }

  /// 检查离线模型是否已下载
  bool isOfflineModelDownloaded() {
    return _preferences.getBool(_offlineModelDownloadedKey) ?? false;
  }

  /// 标记离线模型已下载
  Future<void> markOfflineModelDownloaded() async {
    await _preferences.setBool(_offlineModelDownloadedKey, true);
  }

  /// 清除离线模型标记
  Future<void> clearOfflineModelDownloaded() async {
    await _preferences.remove(_offlineModelDownloadedKey);
  }

  /// 获取当前网络状态
  Future<bool> _isNetworkAvailable() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
  }

  /// 根据模式和网络状态决定是否使用在线模式
  Future<bool> _shouldUseOnlineMode() async {
    switch (_currentMode) {
      case SpeechRecognitionMode.online:
        return true;
      case SpeechRecognitionMode.offline:
        return false;
      case SpeechRecognitionMode.auto:
        // 自动模式：有网络用在线，无网络用离线
        return await _isNetworkAvailable();
    }
  }

  /// 获取保存的模式
  SpeechRecognitionMode _getSavedMode() {
    final modeName = _preferences.getString(_modeKey);
    if (modeName == null) return SpeechRecognitionMode.auto;

    return SpeechRecognitionMode.values.firstWhere(
      (mode) => mode.name == modeName,
      orElse: () => SpeechRecognitionMode.auto,
    );
  }

  /// 释放资源
  Future<void> dispose() async {
    await stopListening();
  }

  /// 获取识别统计信息
  Map<String, dynamic> getStatistics() {
    return {
      'isInitialized': _isInitialized,
      'isListening': _isListening,
      'currentMode': _currentMode.displayName,
      'offlineModelDownloaded': isOfflineModelDownloaded(),
    };
  }
}
