// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lucky_draw.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrizeTypeAdapter extends TypeAdapter<PrizeType> {
  @override
  final int typeId = 51;

  @override
  PrizeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PrizeType.points;
      case 1:
        return PrizeType.badge;
      case 2:
        return PrizeType.makeupCard;
      case 3:
        return PrizeType.title;
      default:
        return PrizeType.points;
    }
  }

  @override
  void write(BinaryWriter writer, PrizeType obj) {
    switch (obj) {
      case PrizeType.points:
        writer.writeByte(0);
        break;
      case PrizeType.badge:
        writer.writeByte(1);
        break;
      case PrizeType.makeupCard:
        writer.writeByte(2);
        break;
      case PrizeType.title:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrizeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrizeRarityAdapter extends TypeAdapter<PrizeRarity> {
  @override
  final int typeId = 52;

  @override
  PrizeRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PrizeRarity.common;
      case 1:
        return PrizeRarity.rare;
      case 2:
        return PrizeRarity.epic;
      case 3:
        return PrizeRarity.legendary;
      default:
        return PrizeRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, PrizeRarity obj) {
    switch (obj) {
      case PrizeRarity.common:
        writer.writeByte(0);
        break;
      case PrizeRarity.rare:
        writer.writeByte(1);
        break;
      case PrizeRarity.epic:
        writer.writeByte(2);
        break;
      case PrizeRarity.legendary:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrizeRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrizeConfigImpl _$$PrizeConfigImplFromJson(Map<String, dynamic> json) =>
    _$PrizeConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$PrizeTypeEnumMap, json['type']),
      rarity: $enumDecode(_$PrizeRarityEnumMap, json['rarity']),
      icon: json['icon'] as String,
      value: (json['value'] as num?)?.toInt() ?? 0,
      itemId: json['itemId'] as String?,
    );

Map<String, dynamic> _$$PrizeConfigImplToJson(_$PrizeConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$PrizeTypeEnumMap[instance.type]!,
      'rarity': _$PrizeRarityEnumMap[instance.rarity]!,
      'icon': instance.icon,
      'value': instance.value,
      'itemId': instance.itemId,
    };

const _$PrizeTypeEnumMap = {
  PrizeType.points: 'points',
  PrizeType.badge: 'badge',
  PrizeType.makeupCard: 'makeupCard',
  PrizeType.title: 'title',
};

const _$PrizeRarityEnumMap = {
  PrizeRarity.common: 'common',
  PrizeRarity.rare: 'rare',
  PrizeRarity.epic: 'epic',
  PrizeRarity.legendary: 'legendary',
};

_$LuckyDrawRecordImpl _$$LuckyDrawRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$LuckyDrawRecordImpl(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      prizeId: json['prizeId'] as String,
      prizeName: json['prizeName'] as String,
      prizeType: $enumDecode(_$PrizeTypeEnumMap, json['prizeType']),
      prizeRarity: $enumDecode(_$PrizeRarityEnumMap, json['prizeRarity']),
      costPoints: (json['costPoints'] as num?)?.toInt() ?? 0,
      isFree: json['isFree'] as bool? ?? false,
    );

Map<String, dynamic> _$$LuckyDrawRecordImplToJson(
        _$LuckyDrawRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'prizeId': instance.prizeId,
      'prizeName': instance.prizeName,
      'prizeType': _$PrizeTypeEnumMap[instance.prizeType]!,
      'prizeRarity': _$PrizeRarityEnumMap[instance.prizeRarity]!,
      'costPoints': instance.costPoints,
      'isFree': instance.isFree,
    };

_$LuckyDrawStatsImpl _$$LuckyDrawStatsImplFromJson(Map<String, dynamic> json) =>
    _$LuckyDrawStatsImpl(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      totalDraws: (json['totalDraws'] as num?)?.toInt() ?? 0,
      freeDrawsToday: (json['freeDrawsToday'] as num?)?.toInt() ?? 0,
      lastFreeDrawDate: json['lastFreeDrawDate'] == null
          ? null
          : DateTime.parse(json['lastFreeDrawDate'] as String),
      pityCounter: (json['pityCounter'] as num?)?.toInt() ?? 0,
      epicPityCounter: (json['epicPityCounter'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$LuckyDrawStatsImplToJson(
        _$LuckyDrawStatsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'totalDraws': instance.totalDraws,
      'freeDrawsToday': instance.freeDrawsToday,
      'lastFreeDrawDate': instance.lastFreeDrawDate?.toIso8601String(),
      'pityCounter': instance.pityCounter,
      'epicPityCounter': instance.epicPityCounter,
    };
