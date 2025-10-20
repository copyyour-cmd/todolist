// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CloudUserImpl _$$CloudUserImplFromJson(Map<String, dynamic> json) =>
    _$CloudUserImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      status: (json['status'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      phone: json['phone'] as String?,
      lastLoginAt: json['last_login_at'] == null
          ? null
          : DateTime.parse(json['last_login_at'] as String),
      lastLoginIp: json['last_login_ip'] as String?,
    );

Map<String, dynamic> _$$CloudUserImplToJson(_$CloudUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
      'phone': instance.phone,
      'last_login_at': instance.lastLoginAt?.toIso8601String(),
      'last_login_ip': instance.lastLoginIp,
    };

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      user: CloudUser.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
