// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'title.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TitleCategoryAdapter extends TypeAdapter<TitleCategory> {
  @override
  final int typeId = 61;

  @override
  TitleCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TitleCategory.achievement;
      case 1:
        return TitleCategory.time;
      case 2:
        return TitleCategory.special;
      case 3:
        return TitleCategory.social;
      default:
        return TitleCategory.achievement;
    }
  }

  @override
  void write(BinaryWriter writer, TitleCategory obj) {
    switch (obj) {
      case TitleCategory.achievement:
        writer.writeByte(0);
        break;
      case TitleCategory.time:
        writer.writeByte(1);
        break;
      case TitleCategory.special:
        writer.writeByte(2);
        break;
      case TitleCategory.social:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TitleCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TitleRarityAdapter extends TypeAdapter<TitleRarity> {
  @override
  final int typeId = 62;

  @override
  TitleRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TitleRarity.common;
      case 1:
        return TitleRarity.rare;
      case 2:
        return TitleRarity.epic;
      case 3:
        return TitleRarity.legendary;
      default:
        return TitleRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, TitleRarity obj) {
    switch (obj) {
      case TitleRarity.common:
        writer.writeByte(0);
        break;
      case TitleRarity.rare:
        writer.writeByte(1);
        break;
      case TitleRarity.epic:
        writer.writeByte(2);
        break;
      case TitleRarity.legendary:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TitleRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserTitleImpl _$$UserTitleImplFromJson(Map<String, dynamic> json) =>
    _$UserTitleImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$TitleCategoryEnumMap, json['category']),
      rarity: $enumDecode(_$TitleRarityEnumMap, json['rarity']),
      icon: json['icon'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
      requiredValue: (json['requiredValue'] as num?)?.toInt() ?? 0,
      requiredCondition: json['requiredCondition'] as String?,
      pointsBonus: (json['pointsBonus'] as num?)?.toInt() ?? 0,
      themeUnlock: json['themeUnlock'] as String?,
    );

Map<String, dynamic> _$$UserTitleImplToJson(_$UserTitleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': _$TitleCategoryEnumMap[instance.category]!,
      'rarity': _$TitleRarityEnumMap[instance.rarity]!,
      'icon': instance.icon,
      'isUnlocked': instance.isUnlocked,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
      'requiredValue': instance.requiredValue,
      'requiredCondition': instance.requiredCondition,
      'pointsBonus': instance.pointsBonus,
      'themeUnlock': instance.themeUnlock,
    };

const _$TitleCategoryEnumMap = {
  TitleCategory.achievement: 'achievement',
  TitleCategory.time: 'time',
  TitleCategory.special: 'special',
  TitleCategory.social: 'social',
};

const _$TitleRarityEnumMap = {
  TitleRarity.common: 'common',
  TitleRarity.rare: 'rare',
  TitleRarity.epic: 'epic',
  TitleRarity.legendary: 'legendary',
};
