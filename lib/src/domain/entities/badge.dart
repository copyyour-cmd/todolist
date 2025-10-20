import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/infrastructure/hive/type_ids.dart';

part 'badge.freezed.dart';
part 'badge.g.dart';

/// 徽章
// 注意: 使用 JSON adapter (在 hive_initializer.dart 中注册为 typeId: 41)
// 不使用 @HiveType 避免与 Freezed 冲突
@freezed
class Badge with _$Badge {
  const factory Badge({
    required String id,
    required String name,
    required String description,
    required String icon, // emoji 或图标名称
    required BadgeCategory category,
    required BadgeRarity rarity,
    DateTime? unlockedAt, // 解锁时间
  }) = _Badge;

  const Badge._();

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);

  /// 是否已解锁
  bool get isUnlocked => unlockedAt != null;

  /// 获取稀有度名称
  String get rarityName {
    switch (rarity) {
      case BadgeRarity.common:
        return '普通';
      case BadgeRarity.rare:
        return '稀有';
      case BadgeRarity.epic:
        return '史诗';
      case BadgeRarity.legendary:
        return '传说';
    }
  }

  /// 获取稀有度颜色
  String get rarityColor {
    switch (rarity) {
      case BadgeRarity.common:
        return '#9E9E9E'; // 灰色
      case BadgeRarity.rare:
        return '#2196F3'; // 蓝色
      case BadgeRarity.epic:
        return '#9C27B0'; // 紫色
      case BadgeRarity.legendary:
        return '#FF9800'; // 橙色
    }
  }
}

/// 徽章分类
@HiveType(typeId: HiveTypeIds.badgeCategory, adapterName: 'BadgeCategoryAdapter')
@JsonEnum()
enum BadgeCategory {
  @HiveField(0)
  tasks, // 任务相关
  @HiveField(1)
  focus, // 专注相关
  @HiveField(2)
  streak, // 连续打卡相关
  @HiveField(3)
  special, // 特殊成就
}

/// 徽章稀有度
@HiveType(typeId: HiveTypeIds.badgeRarity, adapterName: 'BadgeRarityAdapter')
@JsonEnum()
enum BadgeRarity {
  @HiveField(0)
  common, // 普通
  @HiveField(1)
  rare, // 稀有
  @HiveField(2)
  epic, // 史诗
  @HiveField(3)
  legendary, // 传说
}
