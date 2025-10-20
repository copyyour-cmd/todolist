// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_checkin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyCheckInImpl _$$DailyCheckInImplFromJson(Map<String, dynamic> json) =>
    _$DailyCheckInImpl(
      id: json['id'] as String,
      checkInDate: DateTime.parse(json['checkInDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 10,
      consecutiveDays: (json['consecutiveDays'] as num?)?.toInt() ?? 1,
      isMakeup: json['isMakeup'] as bool? ?? false,
    );

Map<String, dynamic> _$$DailyCheckInImplToJson(_$DailyCheckInImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'checkInDate': instance.checkInDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'pointsEarned': instance.pointsEarned,
      'consecutiveDays': instance.consecutiveDays,
      'isMakeup': instance.isMakeup,
    };

_$MakeupCardImpl _$$MakeupCardImplFromJson(Map<String, dynamic> json) =>
    _$MakeupCardImpl(
      id: json['id'] as String,
      obtainedAt: DateTime.parse(json['obtainedAt'] as String),
      usedAt: json['usedAt'] == null
          ? null
          : DateTime.parse(json['usedAt'] as String),
      isUsed: json['isUsed'] as bool? ?? false,
    );

Map<String, dynamic> _$$MakeupCardImplToJson(_$MakeupCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'obtainedAt': instance.obtainedAt.toIso8601String(),
      'usedAt': instance.usedAt?.toIso8601String(),
      'isUsed': instance.isUsed,
    };
