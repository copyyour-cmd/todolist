/// 云服务配置
class CloudConfig {
  // 服务器地址配置
  static const String baseUrl = 'http://43.156.6.206:3000';
  static const String apiPrefix = '/api';

  // 完整API地址
  static String get apiBaseUrl => '$baseUrl$apiPrefix';

  // 连接超时配置
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 10);

  // Token存储键
  static const String tokenKey = 'cloud_auth_token';
  static const String refreshTokenKey = 'cloud_refresh_token';
  static const String userIdKey = 'cloud_user_id';

  // API端点
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authLogout = '/auth/logout';
  static const String authMe = '/auth/me';
  static const String authRefreshToken = '/auth/refresh-token';

  static const String tasks = '/tasks';
  static const String lists = '/lists';
  static const String tags = '/tags';
  static const String sync = '/sync';
  static const String syncFull = '/sync/full';
  static const String syncStatus = '/sync/status';
}


