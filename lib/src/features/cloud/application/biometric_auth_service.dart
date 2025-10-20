import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:todolist/src/core/logging/app_logger.dart';

/// 生物识别认证服务
class BiometricAuthService {
  BiometricAuthService({
    required AppLogger logger,
  }) : _logger = logger;

  final AppLogger _logger;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // 安全存储的键
  static const String _keyUsername = 'biometric_username';
  static const String _keyPassword = 'biometric_password';
  static const String _keyRememberMe = 'remember_username';
  static const String _keySavedUsername = 'saved_username';

  /// 检查设备是否支持生物识别
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      _logger.error('检查生物识别支持失败', e, StackTrace.current);
      return false;
    }
  }

  /// 检查是否已注册生物识别
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      _logger.error('检查生物识别权限失败', e, StackTrace.current);
      return false;
    }
  }

  /// 获取可用的生物识别类型
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      _logger.error('获取生物识别类型失败', e, StackTrace.current);
      return [];
    }
  }

  /// 执行生物识别认证
  Future<bool> authenticate({
    String localizedReason = '请验证身份以登录',
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      _logger.error('生物识别认证失败', e, StackTrace.current);
      return false;
    }
  }

  /// 保存登录凭证（用于指纹登录）
  Future<void> saveCredentials({
    required String username,
    required String password,
  }) async {
    try {
      await _secureStorage.write(key: _keyUsername, value: username);
      await _secureStorage.write(key: _keyPassword, value: password);
      _logger.info('凭证已安全保存');
    } catch (e) {
      _logger.error('保存凭证失败', e, StackTrace.current);
    }
  }

  /// 获取保存的凭证
  Future<Map<String, String>?> getSavedCredentials() async {
    try {
      final username = await _secureStorage.read(key: _keyUsername);
      final password = await _secureStorage.read(key: _keyPassword);

      if (username != null && password != null) {
        return {'username': username, 'password': password};
      }

      return null;
    } catch (e) {
      _logger.error('读取凭证失败', e, StackTrace.current);
      return null;
    }
  }

  /// 删除保存的凭证
  Future<void> clearCredentials() async {
    try {
      await _secureStorage.delete(key: _keyUsername);
      await _secureStorage.delete(key: _keyPassword);
      _logger.info('凭证已清除');
    } catch (e) {
      _logger.error('清除凭证失败', e, StackTrace.current);
    }
  }

  /// 检查是否有保存的凭证
  Future<bool> hasCredentials() async {
    try {
      final username = await _secureStorage.read(key: _keyUsername);
      return username != null;
    } catch (e) {
      return false;
    }
  }

  /// 保存"记住我"设置
  Future<void> setRememberMe(bool remember, {String? username}) async {
    try {
      await _secureStorage.write(
        key: _keyRememberMe,
        value: remember.toString(),
      );
      if (remember && username != null) {
        await _secureStorage.write(key: _keySavedUsername, value: username);
      } else {
        await _secureStorage.delete(key: _keySavedUsername);
      }
    } catch (e) {
      _logger.error('保存记住我设置失败', e, StackTrace.current);
    }
  }

  /// 获取"记住我"状态
  Future<bool> getRememberMe() async {
    try {
      final value = await _secureStorage.read(key: _keyRememberMe);
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  /// 获取保存的用户名（记住我功能）
  Future<String?> getSavedUsername() async {
    try {
      return await _secureStorage.read(key: _keySavedUsername);
    } catch (e) {
      return null;
    }
  }
}

