// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopItemCategoryAdapter extends TypeAdapter<ShopItemCategory> {
  @override
  final int typeId = 57;

  @override
  ShopItemCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ShopItemCategory.theme;
      case 1:
        return ShopItemCategory.icon;
      case 2:
        return ShopItemCategory.sound;
      case 3:
        return ShopItemCategory.special;
      case 4:
        return ShopItemCategory.powerUp;
      default:
        return ShopItemCategory.theme;
    }
  }

  @override
  void write(BinaryWriter writer, ShopItemCategory obj) {
    switch (obj) {
      case ShopItemCategory.theme:
        writer.writeByte(0);
        break;
      case ShopItemCategory.icon:
        writer.writeByte(1);
        break;
      case ShopItemCategory.sound:
        writer.writeByte(2);
        break;
      case ShopItemCategory.special:
        writer.writeByte(3);
        break;
      case ShopItemCategory.powerUp:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopItemCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShopItemRarityAdapter extends TypeAdapter<ShopItemRarity> {
  @override
  final int typeId = 58;

  @override
  ShopItemRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ShopItemRarity.common;
      case 1:
        return ShopItemRarity.rare;
      case 2:
        return ShopItemRarity.epic;
      case 3:
        return ShopItemRarity.legendary;
      default:
        return ShopItemRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, ShopItemRarity obj) {
    switch (obj) {
      case ShopItemRarity.common:
        writer.writeByte(0);
        break;
      case ShopItemRarity.rare:
        writer.writeByte(1);
        break;
      case ShopItemRarity.epic:
        writer.writeByte(2);
        break;
      case ShopItemRarity.legendary:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopItemRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShopItemImpl _$$ShopItemImplFromJson(Map<String, dynamic> json) =>
    _$ShopItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      category: $enumDecode(_$ShopItemCategoryEnumMap, json['category']),
      price: (json['price'] as num).toInt(),
      rarity: $enumDecode(_$ShopItemRarityEnumMap, json['rarity']),
      isLimited: json['isLimited'] as bool? ?? false,
      limitedUntil: json['limitedUntil'] == null
          ? null
          : DateTime.parse(json['limitedUntil'] as String),
      isPurchased: json['isPurchased'] as bool? ?? false,
      purchasedAt: json['purchasedAt'] == null
          ? null
          : DateTime.parse(json['purchasedAt'] as String),
      isAvailable: json['isAvailable'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      itemData: json['itemData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ShopItemImplToJson(_$ShopItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'category': _$ShopItemCategoryEnumMap[instance.category]!,
      'price': instance.price,
      'rarity': _$ShopItemRarityEnumMap[instance.rarity]!,
      'isLimited': instance.isLimited,
      'limitedUntil': instance.limitedUntil?.toIso8601String(),
      'isPurchased': instance.isPurchased,
      'purchasedAt': instance.purchasedAt?.toIso8601String(),
      'isAvailable': instance.isAvailable,
      'createdAt': instance.createdAt.toIso8601String(),
      'itemData': instance.itemData,
    };

const _$ShopItemCategoryEnumMap = {
  ShopItemCategory.theme: 'theme',
  ShopItemCategory.icon: 'icon',
  ShopItemCategory.sound: 'sound',
  ShopItemCategory.special: 'special',
  ShopItemCategory.powerUp: 'powerUp',
};

const _$ShopItemRarityEnumMap = {
  ShopItemRarity.common: 'common',
  ShopItemRarity.rare: 'rare',
  ShopItemRarity.epic: 'epic',
  ShopItemRarity.legendary: 'legendary',
};

_$PurchaseRecordImpl _$$PurchaseRecordImplFromJson(Map<String, dynamic> json) =>
    _$PurchaseRecordImpl(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      pricePaid: (json['pricePaid'] as num).toInt(),
      purchasedAt: DateTime.parse(json['purchasedAt'] as String),
      isFromLuckyDraw: json['isFromLuckyDraw'] as bool? ?? false,
    );

Map<String, dynamic> _$$PurchaseRecordImplToJson(
        _$PurchaseRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'pricePaid': instance.pricePaid,
      'purchasedAt': instance.purchasedAt.toIso8601String(),
      'isFromLuckyDraw': instance.isFromLuckyDraw,
    };

_$UserInventoryImpl _$$UserInventoryImplFromJson(Map<String, dynamic> json) =>
    _$UserInventoryImpl(
      id: json['id'] as String,
      ownedItemIds: (json['ownedItemIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      purchaseRecordIds: (json['purchaseRecordIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      lastLuckyDrawAt: json['lastLuckyDrawAt'] == null
          ? null
          : DateTime.parse(json['lastLuckyDrawAt'] as String),
      luckyDrawCount: (json['luckyDrawCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserInventoryImplToJson(_$UserInventoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownedItemIds': instance.ownedItemIds,
      'purchaseRecordIds': instance.purchaseRecordIds,
      'lastLuckyDrawAt': instance.lastLuckyDrawAt?.toIso8601String(),
      'luckyDrawCount': instance.luckyDrawCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
