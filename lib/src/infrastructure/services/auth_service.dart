import 'package:dio/dio.dart';
import 'package:todolist/src/core/config/api_config.dart';
import 'package:todolist/src/infrastructure/http/auth_interceptor.dart';
import 'package:todolist/src/infrastructure/http/dio_client.dart';

/// 用户信息模型
class UserInfo {

  UserInfo({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt, this.nickname,
    this.avatarUrl,
    this.phone,
    this.lastLoginAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      nickname: json['nickname'],
      avatarUrl: json['avatar_url'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['created_at']),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'])
          : null,
    );
  }
  final int id;
  final String username;
  final String email;
  final String? nickname;
  final String? avatarUrl;
  final String? phone;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'nickname': nickname,
      'avatar_url': avatarUrl,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }
}

/// 认证服务
class AuthService {

  AuthService(this._client);
  final DioClient _client;

  /// 用户注册
  Future<UserInfo> register({
    required String username,
    required String email,
    required String password,
    String? nickname,
    String? deviceType,
  }) async {
    final response = await _client.post(
      ApiConfig.registerEndpoint,
      data: {
        'username': username,
        'email': email,
        'password': password,
        'nickname': nickname,
        'deviceType': deviceType,
      },
    );

    final data = response.data['data'];

    // 保存 token
    await AuthInterceptor.saveTokens(
      token: data['token'],
      refreshToken: data['refreshToken'],
    );

    return UserInfo.fromJson(data['user']);
  }

  /// 用户登录
  Future<UserInfo> login({
    required String username,
    required String password,
    String? deviceType,
    String? deviceId,
    String? deviceName,
  }) async {
    final response = await _client.post(
      ApiConfig.loginEndpoint,
      data: {
        'username': username,
        'password': password,
        'deviceType': deviceType,
        'deviceId': deviceId,
        'deviceName': deviceName,
      },
    );

    final data = response.data['data'];

    // 保存 token
    await AuthInterceptor.saveTokens(
      token: data['token'],
      refreshToken: data['refreshToken'],
    );

    return UserInfo.fromJson(data['user']);
  }

  /// 退出登录
  Future<void> logout() async {
    try {
      await _client.post(ApiConfig.logoutEndpoint);
    } finally {
      // 无论成功失败都清除本地 token
      await AuthInterceptor.clearTokens();
    }
  }

  /// 获取当前用户信息
  Future<UserInfo> getCurrentUser() async {
    final response = await _client.get(ApiConfig.getMeEndpoint);
    return UserInfo.fromJson(response.data['data']);
  }

  /// 刷新 token
  Future<void> refreshToken() async {
    final refreshToken = await AuthInterceptor.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('未找到刷新令牌');
    }

    final response = await _client.post(
      ApiConfig.refreshTokenEndpoint,
      data: {'refreshToken': refreshToken},
    );

    final data = response.data['data'];

    // 保存新 token
    await AuthInterceptor.saveTokens(
      token: data['token'],
      refreshToken: data['refreshToken'],
    );
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    return AuthInterceptor.isLoggedIn();
  }

  /// 更新用户资料
  Future<UserInfo> updateProfile({
    String? nickname,
    String? email,
    String? phone,
  }) async {
    final response = await _client.put(
      '/api/auth/profile',
      data: {
        if (nickname != null) 'nickname': nickname,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      },
    );

    return UserInfo.fromJson(response.data['data']);
  }

  /// 修改密码
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _client.post(
      '/api/auth/change-password',
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      },
    );
  }

  /// 上传头像
  Future<String> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath),
    });

    final response = await _client.post(
      '/api/auth/avatar',
      data: formData,
    );

    return response.data['data']['avatar_url'];
  }
}
