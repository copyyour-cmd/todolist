import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/core/config/cloud_config.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

/// HTTP客户端服务
class HttpClient {
  HttpClient({
    required AppLogger logger,
    required SharedPreferences prefs,
  })  : _logger = logger,
        _prefs = prefs {
    _dio = Dio(
      BaseOptions(
        baseUrl: CloudConfig.apiBaseUrl,
        connectTimeout: CloudConfig.connectTimeout,
        receiveTimeout: CloudConfig.receiveTimeout,
        sendTimeout: CloudConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(_createInterceptor());
  }

  final AppLogger _logger;
  final SharedPreferences _prefs;
  late final Dio _dio;

  Dio get dio => _dio;

  /// 创建拦截器
  InterceptorsWrapper _createInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 添加Token到请求头
        final token = _prefs.getString(CloudConfig.tokenKey);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        _logger.info(
          'HTTP Request: ${options.method} ${options.uri}',
          {'headers': options.headers, 'data': options.data},
        );

        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.info(
          'HTTP Response: ${response.statusCode} ${response.requestOptions.uri}',
          response.data,
        );
        return handler.next(response);
      },
      onError: (error, handler) async {
        _logger.error(
          'HTTP Error: ${error.requestOptions.uri}',
          error,
          StackTrace.current,
        );

        // 处理401未授权错误
        if (error.response?.statusCode == 401) {
          // 尝试刷新Token
          final refreshed = await _tryRefreshToken();
          if (refreshed) {
            // 重试原请求
            final options = error.requestOptions;
            final token = _prefs.getString(CloudConfig.tokenKey);
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            try {
              final response = await _dio.fetch(options);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
        }

        return handler.next(error);
      },
    );
  }

  /// 尝试刷新Token
  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = _prefs.getString(CloudConfig.refreshTokenKey);
      if (refreshToken == null) return false;

      final response = await _dio.post(
        CloudConfig.authRefreshToken,
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final newToken = response.data['data']['token'] as String;
        final newRefreshToken = response.data['data']['refreshToken'] as String;

        await _prefs.setString(CloudConfig.tokenKey, newToken);
        await _prefs.setString(CloudConfig.refreshTokenKey, newRefreshToken);

        _logger.info('Token刷新成功');
        return true;
      }

      return false;
    } catch (e) {
      _logger.warning('Token刷新失败', e);
      return false;
    }
  }

  /// 清除认证信息
  Future<void> clearAuth() async {
    await _prefs.remove(CloudConfig.tokenKey);
    await _prefs.remove(CloudConfig.refreshTokenKey);
    await _prefs.remove(CloudConfig.userIdKey);
  }
}

/// HTTP客户端Provider
final httpClientProvider = Provider<HttpClient>((ref) {
  final logger = ref.watch(appLoggerProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return HttpClient(logger: logger, prefs: prefs);
});

