import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/core/config/api_config.dart';

/// 认证拦截器 - 自动添加 Token 和刷新过期 Token
class AuthInterceptor extends Interceptor {

  AuthInterceptor(this._dio);
  final Dio _dio;
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 获取存储的 token
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    // 如果有 token，添加到请求头
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 如果是 401 错误，尝试刷新 token
    if (err.response?.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(_refreshTokenKey);

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // 刷新 token
          final response = await _dio.post(
            ApiConfig.refreshTokenEndpoint,
            data: {'refreshToken': refreshToken},
            options: Options(
              headers: {'Authorization': null}, // 移除旧 token
            ),
          );

          if (response.statusCode == 200) {
            final data = response.data['data'];
            final newToken = data['token'];
            final newRefreshToken = data['refreshToken'];

            // 保存新 token
            await prefs.setString(_tokenKey, newToken);
            await prefs.setString(_refreshTokenKey, newRefreshToken);

            // 重试原始请求
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';

            final retryResponse = await _dio.fetch(options);
            return handler.resolve(retryResponse);
          }
        } catch (e) {
          // 刷新失败，清除 token
          await prefs.remove(_tokenKey);
          await prefs.remove(_refreshTokenKey);
          return handler.reject(err);
        }
      }
    }

    handler.next(err);
  }

  /// 保存认证 token
  static Future<void> saveTokens({
    required String token,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// 获取当前 token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// 获取刷新 token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// 清除 token
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  /// 检查是否已登录
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
