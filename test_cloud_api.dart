/// 云服务API测试脚本
///
/// 使用方法：dart run test_cloud_api.dart
import 'dart:convert';
import 'dart:io';

const String baseUrl = 'http://43.156.6.206:3000';

Future<void> main() async {
  print('🚀 开始测试TodoList云服务API\n');
  print('服务器地址: $baseUrl\n');

  final client = HttpClient();

  try {
    // 1. 测试健康检查
    print('📡 1. 测试健康检查接口...');
    await testHealth(client);

    // 2. 测试用户注册
    print('\n📝 2. 测试用户注册...');
    final registerData = await testRegister(client);

    if (registerData == null) {
      print('❌ 注册失败，无法继续测试');
      return;
    }

    final token = registerData['token'] as String;
    print('✅ 获取到Token: ${token.substring(0, 20)}...');

    // 3. 测试用户登录
    print('\n🔐 3. 测试用户登录...');
    await testLogin(client);

    // 4. 测试获取用户信息
    print('\n👤 4. 测试获取当前用户信息...');
    await testGetMe(client, token);

    print('\n✨ 所有测试通过！');

  } catch (e) {
    print('\n❌ 测试失败: $e');
  } finally {
    client.close();
  }
}

/// 测试健康检查
Future<void> testHealth(HttpClient client) async {
  final request = await client.getUrl(Uri.parse('$baseUrl/health'));
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();

  if (response.statusCode == 200) {
    final data = jsonDecode(body);
    print('   ✅ 健康检查通过');
    print('   状态: ${data['status']}');
    print('   时间: ${data['timestamp']}');
  } else {
    print('   ❌ 健康检查失败: ${response.statusCode}');
  }
}

/// 测试用户注册
Future<Map<String, dynamic>?> testRegister(HttpClient client) async {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final username = 'test_${timestamp % 10000}'; // 限制用户名长度
  final email = 'test_$timestamp@example.com';
  final password = 'Test123456';

  print('   用户名: $username');
  print('   邮箱: $email');

  final request = await client.postUrl(Uri.parse('$baseUrl/api/auth/register'));
  request.headers.set('content-type', 'application/json');
  request.write(jsonEncode({
    'username': username,
    'email': email,
    'password': password,
  }));

  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  final data = jsonDecode(body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    print('   ✅ 注册成功');
    print('   用户ID: ${data['data']['user']['id']}');
    return data['data'] as Map<String, dynamic>;
  } else {
    print('   ❌ 注册失败: ${data['message']}');
    return null;
  }
}

/// 测试用户登录
Future<void> testLogin(HttpClient client) async {
  // 使用服务器上已存在的测试账户
  final username = 'testuser';
  final password = 'Test123456';

  print('   用户名: $username');

  final request = await client.postUrl(Uri.parse('$baseUrl/api/auth/login'));
  request.headers.set('content-type', 'application/json');
  request.write(jsonEncode({
    'username': username,
    'password': password,
  }));

  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  final data = jsonDecode(body);

  if (response.statusCode == 200) {
    print('   ✅ 登录成功');
    print('   用户ID: ${data['data']['user']['id']}');
    print('   邮箱: ${data['data']['user']['email']}');
  } else {
    print('   ❌ 登录失败: ${data['message']}');
  }
}

/// 测试获取当前用户信息
Future<void> testGetMe(HttpClient client, String token) async {
  final request = await client.getUrl(Uri.parse('$baseUrl/api/auth/me'));
  request.headers.set('authorization', 'Bearer $token');

  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();

  if (response.statusCode == 200) {
    final data = jsonDecode(body);
    print('   ✅ 获取用户信息成功');
    print('   用户名: ${data['data']['username']}');
    print('   邮箱: ${data['data']['email']}');
  } else {
    print('   ❌ 获取用户信息失败: ${response.statusCode}');
    print('   响应: $body');
  }
}
