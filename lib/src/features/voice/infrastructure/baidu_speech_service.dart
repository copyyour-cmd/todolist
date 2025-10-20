import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:todolist/src/core/logging/app_logger.dart';

/// 百度语音识别服务
class BaiduSpeechService {
  BaiduSpeechService({
    required this.apiKey,
    required this.secretKey,
    required AppLogger logger,
  }) : _logger = logger;

  final String apiKey;
  final String secretKey;
  final AppLogger _logger;

  String? _accessToken;
  DateTime? _tokenExpireTime;

  /// 获取Access Token
  Future<String> _getAccessToken() async {
    // 如果token还在有效期内，直接返回
    if (_accessToken != null &&
        _tokenExpireTime != null &&
        DateTime.now().isBefore(_tokenExpireTime!)) {
      return _accessToken!;
    }

    try {
      final url = 'https://aip.baidubce.com/oauth/2.0/token?'
          'grant_type=client_credentials&'
          'client_id=$apiKey&'
          'client_secret=$secretKey';

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        _accessToken = data['access_token'] as String;

        // token有效期30天，我们设置为29天后过期
        _tokenExpireTime = DateTime.now().add(const Duration(days: 29));

        _logger.info('百度语音: Access token获取成功');
        return _accessToken!;
      } else {
        throw Exception('获取access token失败: ${response.body}');
      }
    } catch (e, st) {
      _logger.error('获取百度access token失败', e, st);
      rethrow;
    }
  }

  /// 识别音频文件
  /// [audioPath] 音频文件路径，支持PCM/WAV/AMR格式
  /// [format] 音频格式: pcm/wav/amr
  /// [rate] 采样率: 8000/16000
  Future<String> recognizeAudio({
    required String audioPath,
    String format = 'wav',
    int rate = 16000,
  }) async {
    try {
      final token = await _getAccessToken();

      // 读取音频文件
      final audioFile = File(audioPath);
      if (!await audioFile.exists()) {
        throw Exception('音频文件不存在: $audioPath');
      }

      final audioBytes = await audioFile.readAsBytes();
      final audioBase64 = base64Encode(audioBytes);

      // 构建请求
      const url = 'https://vop.baidu.com/server_api';
      final body = json.encode({
        'format': format,
        'rate': rate,
        'channel': 1,
        'cuid': 'todolist_app',
        'token': token,
        'speech': audioBase64,
        'len': audioBytes.length,
        'dev_pid': 1536, // 1536=纯中文普通话，识别更准确
        'lm_id': null,   // 不使用语言模型
      });

      _logger.info('百度语音: 开始识别，文件大小=${audioBytes.length}字节');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // err_no: 0表示成功
        if (data['err_no'] == 0) {
          final results = data['result'] as List<dynamic>?;
          if (results != null && results.isNotEmpty) {
            final text = results.first as String;
            _logger.info('百度语音: 识别成功 = $text');
            return text;
          } else {
            _logger.warning('百度语音: API成功但未识别到内容');
            return ''; // 返回空字符串表示未识别到内容
          }
        } else {
          final errMsg = data['err_msg'] as String? ?? '未知错误';
          final error = Exception('识别失败: $errMsg (${data['err_no']})');
          _logger.error('百度语音: API错误', error, StackTrace.current);
          throw error;
        }
      }

      final error = Exception('识别请求失败: ${response.statusCode}');
      _logger.error('百度语音: HTTP错误', error, StackTrace.current);
      throw error;
    } catch (e, st) {
      _logger.error('百度语音识别失败', e, st);
      rethrow;
    }
  }

  /// 检查API密钥是否有效
  Future<bool> validateKeys() async {
    try {
      await _getAccessToken();
      return true;
    } catch (e) {
      return false;
    }
  }
}
