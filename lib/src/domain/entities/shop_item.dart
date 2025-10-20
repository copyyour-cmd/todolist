import 'package:freezed_annotation/freezed_annotation.dart';
import '../../infrastructure/hive/type_ids.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'shop_item.freezed.dart';
part 'shop_item.g.dart';

/// 商店商品
/// Hive TypeId: 52 (使用FreezedHiveAdapter存储)
@freezed
class ShopItem with _$ShopItem {
  const factory ShopItem({
    required String id,
    required String name,
    required String description,
    required String icon,
    required ShopItemCategory category,
    required int price,
    required ShopItemRarity rarity,
    @Default(false) bool isLimited,
    DateTime? limitedUntil,
    @Default(false) bool isPurchased,
    DateTime? purchasedAt,
    @Default(true) bool isAvailable,
    required DateTime createdAt,
    /// 商品数据（JSON格式存储具体配置）
    Map<String, dynamic>? itemData,
  }) = _ShopItem;

  const ShopItem._();

  factory ShopItem.fromJson(Map<String, dynamic> json) =>
      _$ShopItemFromJson(json);

  /// 稀有度颜色
  String get rarityColorHex {
    switch (rarity) {
      case ShopItemRarity.common:
        return '#808080'; // 灰色
      case ShopItemRarity.rare:
        return '#4169E1'; // 蓝色
      case ShopItemRarity.epic:
        return '#9370DB'; // 紫色
      case ShopItemRarity.legendary:
        return '#FFD700'; // 金色
    }
  }

  /// 稀有度名称
  String get rarityName {
    switch (rarity) {
      case ShopItemRarity.common:
        return '普通';
      case ShopItemRarity.rare:
        return '稀有';
      case ShopItemRarity.epic:
        return '史诗';
      case ShopItemRarity.legendary:
        return '传说';
    }
  }

  /// 类别名称
  String get categoryName {
    switch (category) {
      case ShopItemCategory.theme:
        return '主题';
      case ShopItemCategory.icon:
        return '图标';
      case ShopItemCategory.sound:
        return '音效';
      case ShopItemCategory.special:
        return '特殊';
      case ShopItemCategory.powerUp:
        return '道具';
    }
  }
}

/// 商品类别
@HiveType(typeId: HiveTypeIds.shopItemCategory, adapterName: 'ShopItemCategoryAdapter')
@JsonEnum()
enum ShopItemCategory {
  @HiveField(0)
  theme, // 主题
  @HiveField(1)
  icon, // 图标包
  @HiveField(2)
  sound, // 音效包
  @HiveField(3)
  special, // 特殊装饰
  @HiveField(4)
  powerUp, // 能量道具
}

/// 商品稀有度
@HiveType(typeId: HiveTypeIds.shopItemRarity, adapterName: 'ShopItemRarityAdapter')
@JsonEnum()
enum ShopItemRarity {
  @HiveField(0)
  common, // 普通
  @HiveField(1)
  rare, // 稀有
  @HiveField(2)
  epic, // 史诗
  @HiveField(3)
  legendary, // 传说
}

/// 购买记录
/// Hive TypeId: 55 (使用FreezedHiveAdapter存储)
@freezed
class PurchaseRecord with _$PurchaseRecord {
  const factory PurchaseRecord({
    required String id,
    required String itemId,
    required String itemName,
    required int pricePaid,
    required DateTime purchasedAt,
    @Default(false) bool isFromLuckyDraw,
  }) = _PurchaseRecord;

  factory PurchaseRecord.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRecordFromJson(json);
}

/// 用户库存
/// Hive TypeId: 56 (使用FreezedHiveAdapter存储)
@freezed
class UserInventory with _$UserInventory {
  const factory UserInventory({
    required String id,
    @Default(<String>[]) List<String> ownedItemIds,
    @Default(<String>[]) List<String> purchaseRecordIds,
    DateTime? lastLuckyDrawAt,
    @Default(0) int luckyDrawCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserInventory;

  const UserInventory._();

  factory UserInventory.fromJson(Map<String, dynamic> json) =>
      _$UserInventoryFromJson(json);

  /// 是否可以进行今日抽奖
  bool canDrawToday(DateTime now) {
    if (lastLuckyDrawAt == null) return true;

    final lastDraw = DateTime(
      lastLuckyDrawAt!.year,
      lastLuckyDrawAt!.month,
      lastLuckyDrawAt!.day,
    );
    final today = DateTime(now.year, now.month, now.day);

    return today.isAfter(lastDraw);
  }
}
