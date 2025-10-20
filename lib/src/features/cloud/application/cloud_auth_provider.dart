import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/domain/entities/cloud_user.dart';
import 'package:todolist/src/features/cloud/application/biometric_auth_service.dart';
import 'package:todolist/src/features/cloud/application/cloud_auth_service.dart';
import 'package:todolist/src/infrastructure/http/http_client.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

part 'cloud_auth_provider.g.dart';

/// 生物识别认证服务Provider
@riverpod
BiometricAuthService biometricAuthService(BiometricAuthServiceRef ref) {
  final logger = ref.watch(appLoggerProvider);
  return BiometricAuthService(logger: logger);
}

/// 认证服务Provider
@riverpod
CloudAuthService cloudAuthService(CloudAuthServiceRef ref) {
  final logger = ref.watch(appLoggerProvider);
  final httpClient = ref.watch(httpClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);

  return CloudAuthService(
    logger: logger,
    httpClient: httpClient,
    prefs: prefs,
  );
}

/// 认证状态Notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier({
    required CloudAuthService authService,
    required AppLogger logger,
  })  : _authService = authService,
        _logger = logger,
        super(const AuthState()) {
    _checkAuthStatus();
  }

  final CloudAuthService _authService;
  final AppLogger _logger;

  /// 检查认证状态
  Future<void> _checkAuthStatus() async {
    try {
      state = state.copyWith(status: AuthStatus.loading);

      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        // 尝试获取用户信息
        final user = await _authService.getCurrentUser();
        final token = _authService.getToken();

        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          token: token,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: null,
        );
      }
    } catch (e) {
      _logger.warning('检查认证状态失败', e);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: null,
      );
    }
  }

  /// 注册
  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? nickname,
  }) async {
    try {
      state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

      final authResponse = await _authService.register(
        username: username,
        email: email,
        password: password,
        nickname: nickname,
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: authResponse.user,
        token: authResponse.token,
        refreshToken: authResponse.refreshToken,
        errorMessage: null,
      );

      _logger.info('用户注册成功: ${authResponse.user.username}');
    } catch (e) {
      _logger.error('注册失败', e, StackTrace.current);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      rethrow;
    }
  }

  /// 登录
  Future<void> login({
    required String username,
    required String password,
    String? deviceId,
    String? deviceName,
    String? deviceType,
  }) async {
    try {
      state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

      final authResponse = await _authService.login(
        username: username,
        password: password,
        deviceId: deviceId,
        deviceName: deviceName,
        deviceType: deviceType,
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: authResponse.user,
        token: authResponse.token,
        refreshToken: authResponse.refreshToken,
        errorMessage: null,
      );

      _logger.info('用户登录成功: ${authResponse.user.username}');
    } catch (e) {
      _logger.error('登录失败', e, StackTrace.current);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      rethrow;
    }
  }

  /// 退出登录
  Future<void> logout() async {
    try {
      await _authService.logout();

      state = const AuthState(status: AuthStatus.unauthenticated);

      _logger.info('用户退出登录');
    } catch (e) {
      _logger.error('退出登录失败', e, StackTrace.current);
      // 即使失败也要清除状态
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// 刷新用户信息
  Future<void> refreshUser() async {
    try {
      final user = await _authService.getCurrentUser();
      state = state.copyWith(user: user);
    } catch (e) {
      _logger.error('刷新用户信息失败', e, StackTrace.current);
    }
  }

  /// 清除错误信息
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// 认证状态Provider
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authService = ref.watch(cloudAuthServiceProvider);
  final logger = ref.watch(appLoggerProvider);

  return AuthStateNotifier(
    authService: authService,
    logger: logger,
  );
});

