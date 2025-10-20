import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/features/voice/infrastructure/baidu_speech_service.dart';

/// 基于百度API的语音输入服务
class BaiduVoiceInputService {
  BaiduVoiceInputService(this._logger, this._prefs);

  final AppLogger _logger;
  final SharedPreferences _prefs;
  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  String? _currentRecordingPath;

  // SharedPreferences keys
  static const String _keyApiKey = 'baidu_api_key';
  static const String _keySecretKey = 'baidu_secret_key';
  static const String _keyDevPid = 'baidu_dev_pid';

  // 默认测试密钥（用户可以在设置中替换）
  static const String _defaultApiKey = 'SsENDMhV0k2WiPDGxdiJkZbE';
  static const String _defaultSecretKey = '7S6o9gXwBjhSEQMY6dmYhtCEE4Z3n986';
  static const int _defaultDevPid = 1536; // 1536=纯中文普通话，更准确

  bool get isRecording => _isRecording;

  /// 获取API密钥
  String get apiKey => _prefs.getString(_keyApiKey) ?? _defaultApiKey;

  /// 获取Secret密钥
  String get secretKey => _prefs.getString(_keySecretKey) ?? _defaultSecretKey;

  /// 保存API密钥
  Future<void> saveApiKeys({
    required String apiKey,
    required String secretKey,
  }) async {
    await _prefs.setString(_keyApiKey, apiKey);
    await _prefs.setString(_keySecretKey, secretKey);
    _logger.info('百度API密钥已保存');
  }

  /// 清除API密钥（恢复默认）
  Future<void> clearApiKeys() async {
    await _prefs.remove(_keyApiKey);
    await _prefs.remove(_keySecretKey);
    _logger.info('百度API密钥已清除');
  }

  /// 检查是否配置了自定义密钥
  bool hasCustomKeys() {
    return _prefs.containsKey(_keyApiKey) && _prefs.containsKey(_keySecretKey);
  }

  /// 验证API密钥是否有效
  Future<bool> validateApiKeys({String? apiKey, String? secretKey}) async {
    try {
      final service = BaiduSpeechService(
        apiKey: apiKey ?? this.apiKey,
        secretKey: secretKey ?? this.secretKey,
        logger: _logger,
      );
      return await service.validateKeys();
    } catch (e) {
      return false;
    }
  }

  /// 开始录音
  Future<bool> startRecording() async {
    if (_isRecording) {
      _logger.warning('已经在录音中');
      return false;
    }

    try {
      // 检查权限
      if (!await _recorder.hasPermission()) {
        _logger.warning('没有录音权限');
        return false;
      }

      // 创建临时文件路径
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${tempDir.path}/voice_$timestamp.wav';

      // 开始录音 (WAV格式, 16000采样率)
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: _currentRecordingPath!,
      );

      _isRecording = true;
      _logger.info('开始录音: $_currentRecordingPath');
      return true;
    } catch (e, st) {
      _logger.error('开始录音失败', e, st);
      return false;
    }
  }

  /// 停止录音并识别
  Future<String?> stopRecordingAndRecognize() async {
    if (!_isRecording) {
      _logger.warning('没有在录音');
      return null;
    }

    try {
      // 停止录音
      final path = await _recorder.stop();
      _isRecording = false;

      if (path == null || !File(path).existsSync()) {
        _logger.warning('录音文件不存在');
        return null;
      }

      // 检查文件大小
      final audioFile = File(path);
      final fileSize = await audioFile.length();
      _logger.info('录音完成: $path, 文件大小: $fileSize 字节');

      // 检查文件是否太小（少于1KB可能是空文件）
      if (fileSize < 1024) {
        _logger.warning('录音文件太小，可能未录到声音: $fileSize 字节');
        try {
          await audioFile.delete();
        } catch (e) {
          _logger.warning('删除临时文件失败', e);
        }
        return null;
      }

      // 使用百度API识别
      final service = BaiduSpeechService(
        apiKey: apiKey,
        secretKey: secretKey,
        logger: _logger,
      );

      final result = await service.recognizeAudio(
        audioPath: path,
        format: 'wav',
        rate: 16000,
      );

      // 删除临时文件
      try {
        await audioFile.delete();
      } catch (e) {
        _logger.warning('删除临时文件失败', e);
      }

      return result;
    } catch (e, st) {
      _logger.error('语音识别失败', e, st);
      _isRecording = false;
      return null;
    }
  }

  /// 取消录音
  Future<void> cancelRecording() async {
    if (!_isRecording) return;

    try {
      await _recorder.stop();
      _isRecording = false;

      // 删除录音文件
      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      _logger.info('已取消录音');
    } catch (e, st) {
      _logger.error('取消录音失败', e, st);
    }
  }

  /// 释放资源
  void dispose() {
    _recorder.dispose();
  }
}
