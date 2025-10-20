// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animation_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnimationSettingsAdapter extends TypeAdapter<AnimationSettings> {
  @override
  final int typeId = 38;

  @override
  AnimationSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnimationSettings(
      enableCompletionAnimation: fields[0] as bool,
      animationType: fields[1] as CompletionAnimationType,
      enableComboStreak: fields[2] as bool,
      enableAchievementCelebration: fields[3] as bool,
      enableSoundEffects: fields[4] as bool,
      animationSpeed: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AnimationSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.enableCompletionAnimation)
      ..writeByte(1)
      ..write(obj.animationType)
      ..writeByte(2)
      ..write(obj.enableComboStreak)
      ..writeByte(3)
      ..write(obj.enableAchievementCelebration)
      ..writeByte(4)
      ..write(obj.enableSoundEffects)
      ..writeByte(5)
      ..write(obj.animationSpeed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimationSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompletionAnimationTypeAdapter
    extends TypeAdapter<CompletionAnimationTypeHive> {
  @override
  final int typeId = 39;

  @override
  CompletionAnimationTypeHive read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CompletionAnimationTypeHive.confetti;
      case 1:
        return CompletionAnimationTypeHive.sparkle;
      case 2:
        return CompletionAnimationTypeHive.scale;
      case 3:
        return CompletionAnimationTypeHive.slideOut;
      case 4:
        return CompletionAnimationTypeHive.bounce;
      default:
        return CompletionAnimationTypeHive.confetti;
    }
  }

  @override
  void write(BinaryWriter writer, CompletionAnimationTypeHive obj) {
    switch (obj) {
      case CompletionAnimationTypeHive.confetti:
        writer.writeByte(0);
        break;
      case CompletionAnimationTypeHive.sparkle:
        writer.writeByte(1);
        break;
      case CompletionAnimationTypeHive.scale:
        writer.writeByte(2);
        break;
      case CompletionAnimationTypeHive.slideOut:
        writer.writeByte(3);
        break;
      case CompletionAnimationTypeHive.bounce:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletionAnimationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnimationSettingsImpl _$$AnimationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$AnimationSettingsImpl(
      enableCompletionAnimation:
          json['enableCompletionAnimation'] as bool? ?? true,
      animationType: $enumDecodeNullable(
              _$CompletionAnimationTypeEnumMap, json['animationType']) ??
          CompletionAnimationType.confetti,
      enableComboStreak: json['enableComboStreak'] as bool? ?? true,
      enableAchievementCelebration:
          json['enableAchievementCelebration'] as bool? ?? true,
      enableSoundEffects: json['enableSoundEffects'] as bool? ?? true,
      animationSpeed: (json['animationSpeed'] as num?)?.toDouble() ?? 0.8,
    );

Map<String, dynamic> _$$AnimationSettingsImplToJson(
        _$AnimationSettingsImpl instance) =>
    <String, dynamic>{
      'enableCompletionAnimation': instance.enableCompletionAnimation,
      'animationType':
          _$CompletionAnimationTypeEnumMap[instance.animationType]!,
      'enableComboStreak': instance.enableComboStreak,
      'enableAchievementCelebration': instance.enableAchievementCelebration,
      'enableSoundEffects': instance.enableSoundEffects,
      'animationSpeed': instance.animationSpeed,
    };

const _$CompletionAnimationTypeEnumMap = {
  CompletionAnimationType.confetti: 'confetti',
  CompletionAnimationType.sparkle: 'sparkle',
  CompletionAnimationType.scale: 'scale',
  CompletionAnimationType.slideOut: 'slideOut',
  CompletionAnimationType.bounce: 'bounce',
};
