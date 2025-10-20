import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:todolist/src/features/speech/domain/speech_recognition_mode.dart';
import 'package:todolist/src/features/speech/domain/speech_recognition_history.dart';
import 'package:uuid/uuid.dart';

/// 高级语音识别服务
/// 支持连续识别、多语言、标点符号、历史记录等功能
class AdvancedSpeechService {
  AdvancedSpeechService({
    required SharedPreferences preferences,
    required Box<SpeechRecognitionHistory> historyBox,
  })  : _preferences = preferences,
        _historyBox = historyBox,
        _speech = stt.SpeechToText();

  final SharedPreferences _preferences;
  final Box<SpeechRecognitionHistory> _historyBox;
  final stt.SpeechToText _speech;
  final Connectivity _connectivity = Connectivity();
  final _uuid = const Uuid();

  static const _modeKey = 'speech_recognition_mode';
  static const _languageKey = 'speech_recognition_language';
  static const _continuousModeKey = 'speech_continuous_mode';
  static const _autoPunctuationKey = 'speech_auto_punctuation';
  static const _offlineModelDownloadedKey = 'offline_model_downloaded';

  bool _isInitialized = false;
  bool _isListening = false;
  bool _isContinuousMode = false;
  SpeechRecognitionMode _currentMode = SpeechRecognitionMode.auto;
  String _currentLanguage = 'zh_CN';
  DateTime? _listeningStartTime;
  Timer? _continuousListeningTimer;

  /// 初始化语音识别
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // 加载保存的设置
      _currentMode = _getSavedMode();
      _currentLanguage = _getSavedLanguage();
      _isContinuousMode = getContinuousModeEnabled();

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

  /// 获取当前语言
  String get currentLanguage => _currentLanguage;

  /// 设置识别模式
  Future<void> setMode(SpeechRecognitionMode mode) async {
    _currentMode = mode;
    await _preferences.setString(_modeKey, mode.name);
  }

  /// 设置识别语言
  Future<void> setLanguage(String localeId) async {
    _currentLanguage = localeId;
    await _preferences.setString(_languageKey, localeId);
  }

  /// 启用/禁用连续识别模式
  Future<void> setContinuousMode(bool enabled) async {
    _isContinuousMode = enabled;
    await _preferences.setBool(_continuousModeKey, enabled);
  }

  /// 获取连续模式状态
  bool getContinuousModeEnabled() {
    return _preferences.getBool(_continuousModeKey) ?? false;
  }

  /// 启用/禁用自动标点符号
  Future<void> setAutoPunctuation(bool enabled) async {
    await _preferences.setBool(_autoPunctuationKey, enabled);
  }

  /// 获取自动标点符号状态
  bool getAutoPunctuationEnabled() {
    return _preferences.getBool(_autoPunctuationKey) ?? true;
  }

  /// 开始监听（支持连续模式）
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

    _listeningStartTime = DateTime.now();

    // 根据模式决定使用在线还是离线识别
    final useOnline = await _shouldUseOnlineMode();

    try {
      if (_isContinuousMode) {
        // 连续识别模式
        await _startContinuousListening(
          onResult: onResult,
          onPartialResult: onPartialResult,
          onError: onError,
          useOnline: useOnline,
        );
      } else {
        // 单次识别模式
        await _startSingleListening(
          onResult: onResult,
          onPartialResult: onPartialResult,
          onError: onError,
          useOnline: useOnline,
        );
      }

      _isListening = true;
    } catch (e) {
      debugPrint('Failed to start listening: $e');
      onError?.call('启动语音识别失败: $e');
    }
  }

  /// 单次识别
  Future<void> _startSingleListening({
    required Function(String) onResult,
    Function(String)? onPartialResult,
    Function(String)? onError,
    required bool useOnline,
  }) async {
    await _speech.listen(
      onResult: (result) async {
        String text = result.recognizedWords;

        // 添加标点符号
        if (getAutoPunctuationEnabled() && result.finalResult) {
          text = _addPunctuation(text);
        }

        if (result.finalResult) {
          onResult(text);

          // 保存到历史记录
          await _saveToHistory(text);
        } else {
          onPartialResult?.call(text);
        }
      },
      localeId: _currentLanguage,
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: true,
      partialResults: true,
      onDevice: !useOnline,
    );
  }

  /// 连续识别
  Future<void> _startContinuousListening({
    required Function(String) onResult,
    Function(String)? onPartialResult,
    Function(String)? onError,
    required bool useOnline,
  }) async {
    // 存储累积的文本
    String accumulatedText = '';

    await _speech.listen(
      onResult: (result) async {
        String text = result.recognizedWords;

        // 添加标点符号
        if (getAutoPunctuationEnabled() && result.finalResult) {
          text = _addPunctuation(text);
        }

        if (result.finalResult) {
          // 累积文本
          if (accumulatedText.isNotEmpty) {
            accumulatedText += ' ';
          }
          accumulatedText += text;

          onResult(accumulatedText);

          // 保存到历史记录
          await _saveToHistory(text);

          // 自动重启监听（连续模式）
          if (_isContinuousMode && _isListening) {
            _continuousListeningTimer?.cancel();
            _continuousListeningTimer = Timer(const Duration(milliseconds: 500), () {
              if (_isListening) {
                _startContinuousListening(
                  onResult: onResult,
                  onPartialResult: onPartialResult,
                  onError: onError,
                  useOnline: useOnline,
                );
              }
            });
          }
        } else {
          // 实时显示部分结果
          String displayText = accumulatedText;
          if (displayText.isNotEmpty) {
            displayText += ' ';
          }
          displayText += text;
          onPartialResult?.call(displayText);
        }
      },
      localeId: _currentLanguage,
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: false, // 连续模式不在错误时取消
      partialResults: true,
      onDevice: !useOnline,
    );
  }

  /// 停止监听
  Future<void> stopListening() async {
    _continuousListeningTimer?.cancel();
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  /// 取消监听
  Future<void> cancelListening() async {
    _continuousListeningTimer?.cancel();
    if (_isListening) {
      await _speech.cancel();
      _isListening = false;
    }
  }

  /// 添加标点符号（智能添加）
  String _addPunctuation(String text) {
    if (text.isEmpty) return text;

    // 如果文本已经以标点结尾，不再添加
    if (text.endsWith('。') ||
        text.endsWith('！') ||
        text.endsWith('？') ||
        text.endsWith('.') ||
        text.endsWith('!') ||
        text.endsWith('?')) {
      return text;
    }

    // 根据语言和内容智能添加标点
    if (_currentLanguage.startsWith('zh')) {
      // 中文：根据语气判断
      if (text.contains('吗') || text.contains('呢') || text.contains('么')) {
        return text + '？';
      } else if (text.contains('啊') || text.contains('呀') || text.contains('哇')) {
        return text + '！';
      } else {
        return text + '。';
      }
    } else {
      // 英文：默认添加句号
      if (text.toLowerCase().startsWith('is ') ||
          text.toLowerCase().startsWith('are ') ||
          text.toLowerCase().startsWith('do ') ||
          text.toLowerCase().startsWith('does ') ||
          text.toLowerCase().startsWith('can ') ||
          text.toLowerCase().startsWith('will ') ||
          text.toLowerCase().startsWith('would ')) {
        return text + '?';
      } else {
        return text + '.';
      }
    }
  }

  /// 保存到历史记录
  Future<void> _saveToHistory(String text) async {
    if (text.trim().isEmpty) return;

    final duration = _listeningStartTime != null
        ? DateTime.now().difference(_listeningStartTime!).inSeconds
        : null;

    final history = SpeechRecognitionHistory(
      id: _uuid.v4(),
      text: text,
      language: _currentLanguage,
      timestamp: DateTime.now(),
      duration: duration,
      mode: _currentMode.name,
    );

    await _historyBox.add(history);

    // 限制历史记录数量（最多保留 100 条）
    if (_historyBox.length > 100) {
      final oldestKey = _historyBox.keys.first;
      await _historyBox.delete(oldestKey);
    }
  }

  /// 获取历史记录
  List<SpeechRecognitionHistory> getHistory({int? limit}) {
    final histories = _historyBox.values.toList();
    // 按时间倒序排列
    histories.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (limit != null && limit > 0) {
      return histories.take(limit).toList();
    }
    return histories;
  }

  /// 搜索历史记录
  List<SpeechRecognitionHistory> searchHistory(String query) {
    if (query.trim().isEmpty) return getHistory();

    final queryLower = query.toLowerCase();
    return getHistory().where((history) {
      return history.text.toLowerCase().contains(queryLower);
    }).toList();
  }

  /// 删除历史记录
  Future<void> deleteHistory(String id) async {
    final key = _historyBox.keys.firstWhere(
      (k) => _historyBox.get(k)?.id == id,
      orElse: () => null,
    );

    if (key != null) {
      await _historyBox.delete(key);
    }
  }

  /// 清空历史记录
  Future<void> clearHistory() async {
    await _historyBox.clear();
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

  /// 获取保存的语言
  String _getSavedLanguage() {
    return _preferences.getString(_languageKey) ?? 'zh_CN';
  }

  /// 释放资源
  Future<void> dispose() async {
    _continuousListeningTimer?.cancel();
    await stopListening();
  }

  /// 获取识别统计信息
  Map<String, dynamic> getStatistics() {
    return {
      'isInitialized': _isInitialized,
      'isListening': _isListening,
      'currentMode': _currentMode.displayName,
      'currentLanguage': _getLanguageDisplayName(_currentLanguage),
      'continuousMode': _isContinuousMode,
      'autoPunctuation': getAutoPunctuationEnabled(),
      'offlineModelDownloaded': isOfflineModelDownloaded(),
      'historyCount': _historyBox.length,
    };
  }

  /// 获取语言显示名称
  String _getLanguageDisplayName(String localeId) {
    switch (localeId) {
      case 'zh_CN':
        return '中文（简体）';
      case 'zh_TW':
        return '中文（繁体）';
      case 'en_US':
        return '英文（美国）';
      case 'en_GB':
        return '英文（英国）';
      case 'ja_JP':
        return '日文';
      case 'ko_KR':
        return '韩文';
      default:
        return localeId;
    }
  }
}
