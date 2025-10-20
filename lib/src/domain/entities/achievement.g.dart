// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AchievementTypeAdapter extends TypeAdapter<AchievementType> {
  @override
  final int typeId = 45;

  @override
  AchievementType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AchievementType.tasksCompleted;
      case 1:
        return AchievementType.focusMinutes;
      case 2:
        return AchievementType.streak;
      case 3:
        return AchievementType.dailyGoals;
      case 4:
        return AchievementType.ideas;
      case 5:
        return AchievementType.special;
      default:
        return AchievementType.tasksCompleted;
    }
  }

  @override
  void write(BinaryWriter writer, AchievementType obj) {
    switch (obj) {
      case AchievementType.tasksCompleted:
        writer.writeByte(0);
        break;
      case AchievementType.focusMinutes:
        writer.writeByte(1);
        break;
      case AchievementType.streak:
        writer.writeByte(2);
        break;
      case AchievementType.dailyGoals:
        writer.writeByte(3);
        break;
      case AchievementType.ideas:
        writer.writeByte(4);
        break;
      case AchievementType.special:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AchievementImpl _$$AchievementImplFromJson(Map<String, dynamic> json) =>
    _$AchievementImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      type: $enumDecode(_$AchievementTypeEnumMap, json['type']),
      targetValue: (json['targetValue'] as num).toInt(),
      pointsReward: (json['pointsReward'] as num).toInt(),
      currentValue: (json['currentValue'] as num?)?.toInt() ?? 0,
      badgeReward: json['badgeReward'] as String?,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
    );

Map<String, dynamic> _$$AchievementImplToJson(_$AchievementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'type': _$AchievementTypeEnumMap[instance.type]!,
      'targetValue': instance.targetValue,
      'pointsReward': instance.pointsReward,
      'currentValue': instance.currentValue,
      'badgeReward': instance.badgeReward,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
    };

const _$AchievementTypeEnumMap = {
  AchievementType.tasksCompleted: 'tasksCompleted',
  AchievementType.focusMinutes: 'focusMinutes',
  AchievementType.streak: 'streak',
  AchievementType.dailyGoals: 'dailyGoals',
  AchievementType.ideas: 'ideas',
  AchievementType.special: 'special',
};
