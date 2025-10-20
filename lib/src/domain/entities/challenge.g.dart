// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChallengeTypeAdapter extends TypeAdapter<ChallengeType> {
  @override
  final int typeId = 49;

  @override
  ChallengeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChallengeType.completeTasks;
      case 1:
        return ChallengeType.focusTime;
      case 2:
        return ChallengeType.completeAllDailyTasks;
      case 3:
        return ChallengeType.addIdeas;
      case 4:
        return ChallengeType.maintainStreak;
      default:
        return ChallengeType.completeTasks;
    }
  }

  @override
  void write(BinaryWriter writer, ChallengeType obj) {
    switch (obj) {
      case ChallengeType.completeTasks:
        writer.writeByte(0);
        break;
      case ChallengeType.focusTime:
        writer.writeByte(1);
        break;
      case ChallengeType.completeAllDailyTasks:
        writer.writeByte(2);
        break;
      case ChallengeType.addIdeas:
        writer.writeByte(3);
        break;
      case ChallengeType.maintainStreak:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengePeriodAdapter extends TypeAdapter<ChallengePeriod> {
  @override
  final int typeId = 50;

  @override
  ChallengePeriod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChallengePeriod.daily;
      case 1:
        return ChallengePeriod.weekly;
      default:
        return ChallengePeriod.daily;
    }
  }

  @override
  void write(BinaryWriter writer, ChallengePeriod obj) {
    switch (obj) {
      case ChallengePeriod.daily:
        writer.writeByte(0);
        break;
      case ChallengePeriod.weekly:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengePeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChallengeImpl _$$ChallengeImplFromJson(Map<String, dynamic> json) =>
    _$ChallengeImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$ChallengeTypeEnumMap, json['type']),
      period: $enumDecode(_$ChallengePeriodEnumMap, json['period']),
      targetValue: (json['targetValue'] as num).toInt(),
      pointsReward: (json['pointsReward'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      currentValue: (json['currentValue'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$ChallengeImplToJson(_$ChallengeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': _$ChallengeTypeEnumMap[instance.type]!,
      'period': _$ChallengePeriodEnumMap[instance.period]!,
      'targetValue': instance.targetValue,
      'pointsReward': instance.pointsReward,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'currentValue': instance.currentValue,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$ChallengeTypeEnumMap = {
  ChallengeType.completeTasks: 'completeTasks',
  ChallengeType.focusTime: 'focusTime',
  ChallengeType.completeAllDailyTasks: 'completeAllDailyTasks',
  ChallengeType.addIdeas: 'addIdeas',
  ChallengeType.maintainStreak: 'maintainStreak',
};

const _$ChallengePeriodEnumMap = {
  ChallengePeriod.daily: 'daily',
  ChallengePeriod.weekly: 'weekly',
};
