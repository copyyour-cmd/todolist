// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BadgeCategoryAdapter extends TypeAdapter<BadgeCategory> {
  @override
  final int typeId = 42;

  @override
  BadgeCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BadgeCategory.tasks;
      case 1:
        return BadgeCategory.focus;
      case 2:
        return BadgeCategory.streak;
      case 3:
        return BadgeCategory.special;
      default:
        return BadgeCategory.tasks;
    }
  }

  @override
  void write(BinaryWriter writer, BadgeCategory obj) {
    switch (obj) {
      case BadgeCategory.tasks:
        writer.writeByte(0);
        break;
      case BadgeCategory.focus:
        writer.writeByte(1);
        break;
      case BadgeCategory.streak:
        writer.writeByte(2);
        break;
      case BadgeCategory.special:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BadgeRarityAdapter extends TypeAdapter<BadgeRarity> {
  @override
  final int typeId = 43;

  @override
  BadgeRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BadgeRarity.common;
      case 1:
        return BadgeRarity.rare;
      case 2:
        return BadgeRarity.epic;
      case 3:
        return BadgeRarity.legendary;
      default:
        return BadgeRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, BadgeRarity obj) {
    switch (obj) {
      case BadgeRarity.common:
        writer.writeByte(0);
        break;
      case BadgeRarity.rare:
        writer.writeByte(1);
        break;
      case BadgeRarity.epic:
        writer.writeByte(2);
        break;
      case BadgeRarity.legendary:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeImpl _$$BadgeImplFromJson(Map<String, dynamic> json) => _$BadgeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      category: $enumDecode(_$BadgeCategoryEnumMap, json['category']),
      rarity: $enumDecode(_$BadgeRarityEnumMap, json['rarity']),
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
    );

Map<String, dynamic> _$$BadgeImplToJson(_$BadgeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'category': _$BadgeCategoryEnumMap[instance.category]!,
      'rarity': _$BadgeRarityEnumMap[instance.rarity]!,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
    };

const _$BadgeCategoryEnumMap = {
  BadgeCategory.tasks: 'tasks',
  BadgeCategory.focus: 'focus',
  BadgeCategory.streak: 'streak',
  BadgeCategory.special: 'special',
};

const _$BadgeRarityEnumMap = {
  BadgeRarity.common: 'common',
  BadgeRarity.rare: 'rare',
  BadgeRarity.epic: 'epic',
  BadgeRarity.legendary: 'legendary',
};
