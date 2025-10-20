import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/core/config/cloud_config.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/domain/entities/cloud_user.dart';
import 'package:todolist/src/infrastructure/http/http_client.dart';

/// 云端认证服务
class CloudAuthService {
  CloudAuthService({
    required AppLogger logger,
    required HttpClient httpClient,
    required SharedPreferences prefs,
  })  : _logger = logger,
        _httpClient = httpClient,
        _prefs = prefs;

  final AppLogger _logger;
  final HttpClient _httpClient;
  final SharedPreferences _prefs;

  /// 用户注册
  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
    String? nickname,
  }) async {
    try {
      _logger.info('开始用户注册: $username');

      final response = await _httpClient.dio.post(
        CloudConfig.authRegister,
        data: {
          'username': username,
          'email': email,
          'password': password,
          if (nickname != null) 'nickname': nickname,
        },
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        final authData = response.data['data'];
        final user = CloudUser.fromJson(authData['user']);
        final token = authData['token'] as String;
        final refreshToken = authData['refreshToken'] as String;

        // 保存Token
        await _saveAuthData(user.id, token, refreshToken);

        _logger.info('注册成功: ${user.username}');

        return AuthResponse(
          user: user,
          token: token,
          refreshToken: refreshToken,
        );
      }

      throw Exception(response.data['message'] ?? '注册失败');
    } on DioException catch (e) {
      _logger.error('注册失败', e, StackTrace.current);
      final message = e.response?.data['message'] ?? e.message ?? '网络错误';
      throw Exception(message);
    } catch (e) {
      _logger.error('注册异常', e, StackTrace.current);
      throw Exception('注册失败: $e');
    }
  }

  /// 用户登录
  Future<AuthResponse> login({
    required String username,
    required String password,
    String? deviceId,
    String? deviceName,
    String? deviceType,
  }) async {
    try {
      _logger.info('开始用户登录: $username');

      final response = await _httpClient.dio.post(
        CloudConfig.authLogin,
        data: {
          'username': username,
          'password': password,
          if (deviceId != null) 'deviceId': deviceId,
          if (deviceName != null) 'deviceName': deviceName,
          if (deviceType != null) 'deviceType': deviceType,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final authData = response.data['data'];
        final user = CloudUser.fromJson(authData['user']);
        final token = authData['token'] as String;
        final refreshToken = authData['refreshToken'] as String;

        // 保存Token
        await _saveAuthData(user.id, token, refreshToken);

        _logger.info('登录成功: ${user.username}');

        return AuthResponse(
          user: user,
          token: token,
          refreshToken: refreshToken,
        );
      }

      throw Exception(response.data['message'] ?? '登录失败');
    } on DioException catch (e) {
      _logger.error('登录失败', e, StackTrace.current);
      final message = e.response?.data['message'] ?? e.message ?? '网络错误';
      throw Exception(message);
    } catch (e) {
      _logger.error('登录异常', e, StackTrace.current);
      throw Exception('登录失败: $e');
    }
  }

  /// 退出登录
  Future<void> logout() async {
    try {
      _logger.info('开始退出登录');

      // 调用服务器注销API
      await _httpClient.dio.post(CloudConfig.authLogout);

      // 清除本地认证数据
      await _clearAuthData();

      _logger.info('退出登录成功');
    } catch (e) {
      _logger.warning('退出登录请求失败，但仍清除本地数据', e);
      // 即使服务器请求失败，也要清除本地数据
      await _clearAuthData();
    }
  }

  /// 获取当前用户信息
  Future<CloudUser> getCurrentUser() async {
    try {
      _logger.info('获取当前用户信息');

      final response = await _httpClient.dio.get(CloudConfig.authMe);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final user = CloudUser.fromJson(response.data['data']);
        _logger.info('获取用户信息成功: ${user.username}');
        return user;
      }

      throw Exception(response.data['message'] ?? '获取用户信息失败');
    } on DioException catch (e) {
      _logger.error('获取用户信息失败', e, StackTrace.current);
      final message = e.response?.data['message'] ?? e.message ?? '网络错误';
      throw Exception(message);
    }
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    final token = _prefs.getString(CloudConfig.tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// 获取存储的Token
  String? getToken() {
    return _prefs.getString(CloudConfig.tokenKey);
  }

  /// 保存认证数据
  Future<void> _saveAuthData(int userId, String token, String refreshToken) async {
    await _prefs.setInt(CloudConfig.userIdKey, userId);
    await _prefs.setString(CloudConfig.tokenKey, token);
    await _prefs.setString(CloudConfig.refreshTokenKey, refreshToken);
  }

  /// 清除认证数据
  Future<void> _clearAuthData() async {
    await _prefs.remove(CloudConfig.userIdKey);
    await _prefs.remove(CloudConfig.tokenKey);
    await _prefs.remove(CloudConfig.refreshTokenKey);
  }
}

