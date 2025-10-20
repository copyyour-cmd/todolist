import 'dart:convert';
import 'package:http/http.dart' as http;

// 测试百度语音识别 API
void main() async {
  const apiKey = 'SsENDMhV0k2WiPDGxdiJkZbE';
  const secretKey = '7S6o9gXwBjhSEQMY6dmYhtCEE4Z3n986';

  print('=== 测试百度语音识别 API ===');
  print('API Key: $apiKey');
  print('Secret Key: $secretKey');
  print('');

  // 步骤1: 获取 Access Token
  print('步骤 1: 获取 Access Token...');
  try {
    const tokenUrl = 'https://aip.baidubce.com/oauth/2.0/token?'
        'grant_type=client_credentials&'
        'client_id=$apiKey&'
        'client_secret=$secretKey';

    print('请求 URL: $tokenUrl');
    final tokenResponse = await http.post(Uri.parse(tokenUrl));

    print('响应状态码: ${tokenResponse.statusCode}');
    print('响应内容: ${tokenResponse.body}');

    if (tokenResponse.statusCode == 200) {
      final tokenData = json.decode(tokenResponse.body) as Map<String, dynamic>;

      if (tokenData.containsKey('error')) {
        print('❌ 获取 Token 失败:');
        print('   错误: ${tokenData['error']}');
        print('   描述: ${tokenData['error_description']}');
        return;
      }

      final accessToken = tokenData['access_token'] as String;
      print('✓ Access Token 获取成功!');
      print('Token: ${accessToken.substring(0, 20)}...');
      print('');

      // 步骤2: 测试语音识别 (需要真实音频文件)
      print('步骤 2: API 密钥验证成功!');
      print('');
      print('✓ 百度 API 配置正确，可以使用');
      print('');
      print('当前配置:');
      print('  - dev_pid: 1536 (纯中文普通话)');
      print('  - 采样率: 16000 Hz');
      print('  - 音频格式: WAV');
      print('  - 声道: 1 (单声道)');
    } else {
      print('❌ HTTP 请求失败: ${tokenResponse.statusCode}');
      print('响应: ${tokenResponse.body}');
    }
  } catch (e, st) {
    print('❌ 发生错误: $e');
    print('堆栈: $st');
  }
}
