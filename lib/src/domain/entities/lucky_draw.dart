import 'package:freezed_annotation/freezed_annotation.dart';
import '../../infrastructure/hive/type_ids.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'lucky_draw.freezed.dart';
part 'lucky_draw.g.dart';

/// 抽奖奖品类型
@HiveType(typeId: HiveTypeIds.luckyDraw)
enum PrizeType {
  @HiveField(0)
  points, // 积分

  @HiveField(1)
  badge, // 徽章

  @HiveField(2)
  makeupCard, // 补签卡

  @HiveField(3)
  title, // 称号
}

/// 抽奖奖品稀有度
@HiveType(typeId: HiveTypeIds.luckyDrawType)
enum PrizeRarity {
  @HiveField(0)
  common, // 普通 (60%)

  @HiveField(1)
  rare, // 稀有 (25%)

  @HiveField(2)
  epic, // 史诗 (10%)

  @HiveField(3)
  legendary, // 传说 (5%)
}

extension PrizeRarityExtension on PrizeRarity {
  String get displayName {
    switch (this) {
      case PrizeRarity.common:
        return '普通';
      case PrizeRarity.rare:
        return '稀有';
      case PrizeRarity.epic:
        return '史诗';
      case PrizeRarity.legendary:
        return '传说';
    }
  }

  String get color {
    switch (this) {
      case PrizeRarity.common:
        return '#9E9E9E'; // 灰色
      case PrizeRarity.rare:
        return '#2196F3'; // 蓝色
      case PrizeRarity.epic:
        return '#9C27B0'; // 紫色
      case PrizeRarity.legendary:
        return '#FF9800'; // 橙色
    }
  }

  double get probability {
    switch (this) {
      case PrizeRarity.common:
        return 0.60;
      case PrizeRarity.rare:
        return 0.25;
      case PrizeRarity.epic:
        return 0.10;
      case PrizeRarity.legendary:
        return 0.05;
    }
  }
}

/// 抽奖奖品配置
/// Hive TypeId: 49 (使用FreezedHiveAdapter存储)
@freezed
class PrizeConfig with _$PrizeConfig {
  const factory PrizeConfig({
    required String id,
    required String name,
    required String description,
    required PrizeType type,
    required PrizeRarity rarity,
    required String icon,
    @Default(0) int value, // 积分数值或其他数值
    String? itemId, // 徽章ID、称号ID等
  }) = _PrizeConfig;

  const PrizeConfig._();

  factory PrizeConfig.fromJson(Map<String, dynamic> json) =>
      _$PrizeConfigFromJson(json);
}

/// 抽奖记录
/// Hive TypeId: 50 (使用FreezedHiveAdapter存储)
@freezed
class LuckyDrawRecord with _$LuckyDrawRecord {
  const factory LuckyDrawRecord({
    required String id,
    required DateTime createdAt,
    required String prizeId, // 奖品ID
    required String prizeName, // 奖品名称
    required PrizeType prizeType,
    required PrizeRarity prizeRarity,
    @Default(0) int costPoints, // 花费积分(免费为0)
    @Default(false) bool isFree, // 是否免费抽奖
  }) = _LuckyDrawRecord;

  const LuckyDrawRecord._();

  factory LuckyDrawRecord.fromJson(Map<String, dynamic> json) =>
      _$LuckyDrawRecordFromJson(json);
}

/// 抽奖统计
/// Hive TypeId: 51 (使用FreezedHiveAdapter存储)
@freezed
class LuckyDrawStats with _$LuckyDrawStats {
  const factory LuckyDrawStats({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int totalDraws, // 总抽奖次数
    @Default(0) int freeDrawsToday, // 今日免费次数
    DateTime? lastFreeDrawDate, // 最后免费抽奖日期
    @Default(0) int pityCounter, // 保底计数器
    @Default(0) int epicPityCounter, // 史诗保底计数器
  }) = _LuckyDrawStats;

  const LuckyDrawStats._();

  factory LuckyDrawStats.fromJson(Map<String, dynamic> json) =>
      _$LuckyDrawStatsFromJson(json);

  /// 今天是否还有免费抽奖机会
  bool get hasFreeDrawToday {
    if (lastFreeDrawDate == null) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDrawDay = DateTime(
      lastFreeDrawDate!.year,
      lastFreeDrawDate!.month,
      lastFreeDrawDate!.day,
    );

    return lastDrawDay.isBefore(today);
  }
}
