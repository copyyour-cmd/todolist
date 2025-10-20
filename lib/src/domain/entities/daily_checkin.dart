import 'package:freezed_annotation/freezed_annotation.dart';
import '../../infrastructure/hive/type_ids.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'daily_checkin.freezed.dart';
part 'daily_checkin.g.dart';

/// 每日签到记录
/// Hive TypeId: 47 (使用FreezedHiveAdapter存储)
@freezed
class DailyCheckIn with _$DailyCheckIn {
  const factory DailyCheckIn({
    required String id,
    required DateTime checkInDate, // 签到日期(年月日)
    required DateTime createdAt, // 签到时间
    @Default(10) int pointsEarned, // 获得积分
    @Default(1) int consecutiveDays, // 当时的连续天数
    @Default(false) bool isMakeup, // 是否补签
  }) = _DailyCheckIn;

  const DailyCheckIn._();

  factory DailyCheckIn.fromJson(Map<String, dynamic> json) =>
      _$DailyCheckInFromJson(json);
}

/// 补签卡
/// Hive TypeId: 48 (使用FreezedHiveAdapter存储)
@freezed
class MakeupCard with _$MakeupCard {
  const factory MakeupCard({
    required String id,
    required DateTime obtainedAt, // 获得时间
    DateTime? usedAt, // 使用时间
    @Default(false) bool isUsed, // 是否已使用
  }) = _MakeupCard;

  const MakeupCard._();

  factory MakeupCard.fromJson(Map<String, dynamic> json) =>
      _$MakeupCardFromJson(json);
}
