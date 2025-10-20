import 'package:freezed_annotation/freezed_annotation.dart';
import '../../infrastructure/hive/type_ids.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'title.freezed.dart';
part 'title.g.dart';

/// 称号类别
@HiveType(typeId: HiveTypeIds.title)
enum TitleCategory {
  @HiveField(0)
  achievement, // 成就类

  @HiveField(1)
  time, // 时间类

  @HiveField(2)
  special, // 特殊类

  @HiveField(3)
  social, // 社交类
}

extension TitleCategoryExtension on TitleCategory {
  String get displayName {
    switch (this) {
      case TitleCategory.achievement:
        return '成就';
      case TitleCategory.time:
        return '时间';
      case TitleCategory.special:
        return '特殊';
      case TitleCategory.social:
        return '社交';
    }
  }

  String get icon {
    switch (this) {
      case TitleCategory.achievement:
        return '🏆';
      case TitleCategory.time:
        return '⏰';
      case TitleCategory.special:
        return '⭐';
      case TitleCategory.social:
        return '👥';
    }
  }
}

/// 称号稀有度
@HiveType(typeId: HiveTypeIds.titleRarity)
enum TitleRarity {
  @HiveField(0)
  common, // 普通

  @HiveField(1)
  rare, // 稀有

  @HiveField(2)
  epic, // 史诗

  @HiveField(3)
  legendary, // 传说
}

extension TitleRarityExtension on TitleRarity {
  String get displayName {
    switch (this) {
      case TitleRarity.common:
        return '普通';
      case TitleRarity.rare:
        return '稀有';
      case TitleRarity.epic:
        return '史诗';
      case TitleRarity.legendary:
        return '传说';
    }
  }

  String get color {
    switch (this) {
      case TitleRarity.common:
        return '#9E9E9E'; // 灰色
      case TitleRarity.rare:
        return '#2196F3'; // 蓝色
      case TitleRarity.epic:
        return '#9C27B0'; // 紫色
      case TitleRarity.legendary:
        return '#FF9800'; // 橙色
    }
  }

  int get pointsBonus {
    switch (this) {
      case TitleRarity.common:
        return 5; // 5%
      case TitleRarity.rare:
        return 10; // 10%
      case TitleRarity.epic:
        return 15; // 15%
      case TitleRarity.legendary:
        return 20; // 20%
    }
  }
}

/// 用户称号
/// Hive TypeId: 57 (使用FreezedHiveAdapter存储)
@freezed
class UserTitle with _$UserTitle {
  const factory UserTitle({
    required String id,
    required String name, // 称号名称
    required String description, // 称号描述
    required TitleCategory category, // 类别
    required TitleRarity rarity, // 稀有度
    required String icon, // 图标
    @Default(false) bool isUnlocked, // 是否已解锁
    DateTime? unlockedAt, // 解锁时间
    @Default(0) int requiredValue, // 解锁所需数值
    String? requiredCondition, // 解锁条件描述
    @Default(0) int pointsBonus, // 积分加成百分比
    String? themeUnlock, // 解锁主题ID
  }) = _UserTitle;

  const UserTitle._();

  factory UserTitle.fromJson(Map<String, dynamic> json) =>
      _$UserTitleFromJson(json);
}
