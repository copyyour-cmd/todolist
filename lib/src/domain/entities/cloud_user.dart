import 'package:freezed_annotation/freezed_annotation.dart';

part 'cloud_user.freezed.dart';
part 'cloud_user.g.dart';

/// 云端用户实体
@freezed
class CloudUser with _$CloudUser {
  const factory CloudUser({
    required int id,
    required String username,
    required String email,
    required int status, @JsonKey(name: 'created_at') required DateTime createdAt, @JsonKey(name: 'updated_at') required DateTime updatedAt, String? nickname,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? phone,
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
    @JsonKey(name: 'last_login_ip') String? lastLoginIp,
  }) = _CloudUser;

  const CloudUser._();

  factory CloudUser.fromJson(Map<String, dynamic> json) =>
      _$CloudUserFromJson(json);

  /// 是否正常状态
  bool get isActive => status == 1;

  /// 显示名称（优先使用昵称）
  String get displayName => nickname ?? username;
}

/// 认证响应数据
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required CloudUser user,
    required String token,
    required String refreshToken,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

/// 登录状态
enum AuthStatus {
  initial, // 初始状态
  authenticated, // 已认证
  unauthenticated, // 未认证
  loading, // 加载中
}

/// 认证状态
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    CloudUser? user,
    String? token,
    String? refreshToken,
    String? errorMessage,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => errorMessage != null;
}

