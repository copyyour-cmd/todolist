import 'package:freezed_annotation/freezed_annotation.dart';
import '../../infrastructure/hive/type_ids.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'traffic_info.freezed.dart';
part 'traffic_info.g.dart';

/// 交通信息
@HiveType(typeId: HiveTypeIds.trafficInfo, adapterName: 'TrafficInfoAdapter')
@freezed
class TrafficInfo with _$TrafficInfo {
  const factory TrafficInfo({
    @HiveField(0) required String id,
    @HiveField(1) required String routeName,
    @HiveField(2) required double originLat,
    @HiveField(3) required double originLng,
    @HiveField(4) required double destLat,
    @HiveField(5) required double destLng,
    @HiveField(6) required String originAddress,
    @HiveField(7) required String destAddress,
    @HiveField(8) required int durationSeconds, // 预计行程时间（秒）
    @HiveField(9) required int durationInTrafficSeconds, // 考虑交通的行程时间（秒）
    @HiveField(10) required int distanceMeters, // 距离（米）
    @HiveField(11) required TrafficCondition trafficCondition,
    @HiveField(12) required DateTime fetchedAt,
    @HiveField(13) required DateTime validUntil,
    @HiveField(14) String? polyline, // 路线多边形编码
  }) = _TrafficInfo;

  const TrafficInfo._();

  factory TrafficInfo.fromJson(Map<String, dynamic> json) =>
      _$TrafficInfoFromJson(json);

  /// 拥堵延迟时间（秒）
  int get trafficDelaySeconds => durationInTrafficSeconds - durationSeconds;

  /// 拥堵延迟时间（分钟）
  int get trafficDelayMinutes => (trafficDelaySeconds / 60).ceil();

  /// 是否严重拥堵
  bool get isSevereTraffic =>
      trafficCondition == TrafficCondition.heavy ||
      trafficCondition == TrafficCondition.severe ||
      trafficDelayMinutes > 15;

  /// 建议提前出发时间（分钟）
  int get suggestedAdvanceMinutes {
    final baseMinutes = (durationInTrafficSeconds / 60).ceil();
    // 根据路况增加缓冲时间
    switch (trafficCondition) {
      case TrafficCondition.unknown:
      case TrafficCondition.clear:
        return baseMinutes + 5;
      case TrafficCondition.moderate:
        return baseMinutes + 10;
      case TrafficCondition.heavy:
        return baseMinutes + 20;
      case TrafficCondition.severe:
        return baseMinutes + 30;
    }
  }

  /// 格式化行程时间
  String get formattedDuration {
    final minutes = (durationInTrafficSeconds / 60).ceil();
    if (minutes < 60) {
      return '$minutes分钟';
    } else {
      final hours = minutes ~/ 60;
      final remainMinutes = minutes % 60;
      return '$hours小时${remainMinutes}分钟';
    }
  }

  /// 格式化距离
  String get formattedDistance {
    if (distanceMeters < 1000) {
      return '${distanceMeters}米';
    } else {
      final km = (distanceMeters / 1000).toStringAsFixed(1);
      return '$km公里';
    }
  }

  /// 是否已过期
  bool isExpired(DateTime now) => now.isAfter(validUntil);
}

/// 交通状况枚举
@HiveType(typeId: HiveTypeIds.trafficCondition, adapterName: 'TrafficConditionAdapter')
@JsonEnum()
enum TrafficCondition {
  @HiveField(0)
  unknown, // 未知
  @HiveField(1)
  clear, // 畅通
  @HiveField(2)
  moderate, // 一般
  @HiveField(3)
  heavy, // 拥堵
  @HiveField(4)
  severe, // 严重拥堵
}

/// 交通触发器配置
@HiveType(typeId: HiveTypeIds.travelTrigger, adapterName: 'TravelTriggerAdapter')
@freezed
class TravelTrigger with _$TravelTrigger {
  const factory TravelTrigger({
    @HiveField(0) required String id,
    @HiveField(1) required String taskId,
    @HiveField(2) required double originLat,
    @HiveField(3) required double originLng,
    @HiveField(4) required double destLat,
    @HiveField(5) required double destLng,
    @HiveField(6) required String originAddress,
    @HiveField(7) required String destAddress,
    @HiveField(8) required DateTime appointmentTime, // 约定到达时间
    @HiveField(9) @Default(15) int bufferMinutes, // 缓冲时间（分钟）
    @HiveField(10) @Default(true) bool enabled,
    @HiveField(11) required DateTime createdAt,
    @HiveField(12) DateTime? lastCheckedAt,
    @HiveField(13) DateTime? reminderScheduledFor, // 已计划的提醒时间
  }) = _TravelTrigger;

  const TravelTrigger._();

  factory TravelTrigger.fromJson(Map<String, dynamic> json) =>
      _$TravelTriggerFromJson(json);

  /// 计算应该出发的时间
  DateTime calculateDepartureTime(TrafficInfo traffic) {
    final travelMinutes = (traffic.durationInTrafficSeconds / 60).ceil();
    final totalMinutes = travelMinutes + bufferMinutes;
    return appointmentTime.subtract(Duration(minutes: totalMinutes));
  }

  /// 是否需要提醒出发
  bool shouldRemind(DateTime now, TrafficInfo traffic) {
    if (!enabled) return false;

    final departureTime = calculateDepartureTime(traffic);
    // 在出发时间前10分钟提醒
    final reminderTime = departureTime.subtract(const Duration(minutes: 10));

    return now.isAfter(reminderTime) && now.isBefore(appointmentTime);
  }
}

/// 路线偏好
@HiveType(typeId: HiveTypeIds.routePreference, adapterName: 'RoutePreferenceAdapter')
@JsonEnum()
enum RoutePreference {
  @HiveField(0)
  fastest, // 最快路线
  @HiveField(1)
  shortest, // 最短路线
  @HiveField(2)
  avoidHighways, // 避开高速
  @HiveField(3)
  avoidTolls, // 避开收费路段
}
