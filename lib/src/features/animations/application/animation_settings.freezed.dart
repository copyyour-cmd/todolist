// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animation_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnimationSettings _$AnimationSettingsFromJson(Map<String, dynamic> json) {
  return _AnimationSettings.fromJson(json);
}

/// @nodoc
mixin _$AnimationSettings {
  @HiveField(0)
  bool get enableCompletionAnimation => throw _privateConstructorUsedError;
  @HiveField(1)
  CompletionAnimationType get animationType =>
      throw _privateConstructorUsedError;
  @HiveField(2)
  bool get enableComboStreak => throw _privateConstructorUsedError;
  @HiveField(3)
  bool get enableAchievementCelebration => throw _privateConstructorUsedError;
  @HiveField(4)
  bool get enableSoundEffects => throw _privateConstructorUsedError;
  @HiveField(5)
  double get animationSpeed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AnimationSettingsCopyWith<AnimationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimationSettingsCopyWith<$Res> {
  factory $AnimationSettingsCopyWith(
          AnimationSettings value, $Res Function(AnimationSettings) then) =
      _$AnimationSettingsCopyWithImpl<$Res, AnimationSettings>;
  @useResult
  $Res call(
      {@HiveField(0) bool enableCompletionAnimation,
      @HiveField(1) CompletionAnimationType animationType,
      @HiveField(2) bool enableComboStreak,
      @HiveField(3) bool enableAchievementCelebration,
      @HiveField(4) bool enableSoundEffects,
      @HiveField(5) double animationSpeed});
}

/// @nodoc
class _$AnimationSettingsCopyWithImpl<$Res, $Val extends AnimationSettings>
    implements $AnimationSettingsCopyWith<$Res> {
  _$AnimationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableCompletionAnimation = null,
    Object? animationType = null,
    Object? enableComboStreak = null,
    Object? enableAchievementCelebration = null,
    Object? enableSoundEffects = null,
    Object? animationSpeed = null,
  }) {
    return _then(_value.copyWith(
      enableCompletionAnimation: null == enableCompletionAnimation
          ? _value.enableCompletionAnimation
          : enableCompletionAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      animationType: null == animationType
          ? _value.animationType
          : animationType // ignore: cast_nullable_to_non_nullable
              as CompletionAnimationType,
      enableComboStreak: null == enableComboStreak
          ? _value.enableComboStreak
          : enableComboStreak // ignore: cast_nullable_to_non_nullable
              as bool,
      enableAchievementCelebration: null == enableAchievementCelebration
          ? _value.enableAchievementCelebration
          : enableAchievementCelebration // ignore: cast_nullable_to_non_nullable
              as bool,
      enableSoundEffects: null == enableSoundEffects
          ? _value.enableSoundEffects
          : enableSoundEffects // ignore: cast_nullable_to_non_nullable
              as bool,
      animationSpeed: null == animationSpeed
          ? _value.animationSpeed
          : animationSpeed // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnimationSettingsImplCopyWith<$Res>
    implements $AnimationSettingsCopyWith<$Res> {
  factory _$$AnimationSettingsImplCopyWith(_$AnimationSettingsImpl value,
          $Res Function(_$AnimationSettingsImpl) then) =
      __$$AnimationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) bool enableCompletionAnimation,
      @HiveField(1) CompletionAnimationType animationType,
      @HiveField(2) bool enableComboStreak,
      @HiveField(3) bool enableAchievementCelebration,
      @HiveField(4) bool enableSoundEffects,
      @HiveField(5) double animationSpeed});
}

/// @nodoc
class __$$AnimationSettingsImplCopyWithImpl<$Res>
    extends _$AnimationSettingsCopyWithImpl<$Res, _$AnimationSettingsImpl>
    implements _$$AnimationSettingsImplCopyWith<$Res> {
  __$$AnimationSettingsImplCopyWithImpl(_$AnimationSettingsImpl _value,
      $Res Function(_$AnimationSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableCompletionAnimation = null,
    Object? animationType = null,
    Object? enableComboStreak = null,
    Object? enableAchievementCelebration = null,
    Object? enableSoundEffects = null,
    Object? animationSpeed = null,
  }) {
    return _then(_$AnimationSettingsImpl(
      enableCompletionAnimation: null == enableCompletionAnimation
          ? _value.enableCompletionAnimation
          : enableCompletionAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      animationType: null == animationType
          ? _value.animationType
          : animationType // ignore: cast_nullable_to_non_nullable
              as CompletionAnimationType,
      enableComboStreak: null == enableComboStreak
          ? _value.enableComboStreak
          : enableComboStreak // ignore: cast_nullable_to_non_nullable
              as bool,
      enableAchievementCelebration: null == enableAchievementCelebration
          ? _value.enableAchievementCelebration
          : enableAchievementCelebration // ignore: cast_nullable_to_non_nullable
              as bool,
      enableSoundEffects: null == enableSoundEffects
          ? _value.enableSoundEffects
          : enableSoundEffects // ignore: cast_nullable_to_non_nullable
              as bool,
      animationSpeed: null == animationSpeed
          ? _value.animationSpeed
          : animationSpeed // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnimationSettingsImpl extends _AnimationSettings {
  const _$AnimationSettingsImpl(
      {@HiveField(0) this.enableCompletionAnimation = true,
      @HiveField(1) this.animationType = CompletionAnimationType.confetti,
      @HiveField(2) this.enableComboStreak = true,
      @HiveField(3) this.enableAchievementCelebration = true,
      @HiveField(4) this.enableSoundEffects = true,
      @HiveField(5) this.animationSpeed = 0.8})
      : super._();

  factory _$AnimationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnimationSettingsImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final bool enableCompletionAnimation;
  @override
  @JsonKey()
  @HiveField(1)
  final CompletionAnimationType animationType;
  @override
  @JsonKey()
  @HiveField(2)
  final bool enableComboStreak;
  @override
  @JsonKey()
  @HiveField(3)
  final bool enableAchievementCelebration;
  @override
  @JsonKey()
  @HiveField(4)
  final bool enableSoundEffects;
  @override
  @JsonKey()
  @HiveField(5)
  final double animationSpeed;

  @override
  String toString() {
    return 'AnimationSettings(enableCompletionAnimation: $enableCompletionAnimation, animationType: $animationType, enableComboStreak: $enableComboStreak, enableAchievementCelebration: $enableAchievementCelebration, enableSoundEffects: $enableSoundEffects, animationSpeed: $animationSpeed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimationSettingsImpl &&
            (identical(other.enableCompletionAnimation,
                    enableCompletionAnimation) ||
                other.enableCompletionAnimation == enableCompletionAnimation) &&
            (identical(other.animationType, animationType) ||
                other.animationType == animationType) &&
            (identical(other.enableComboStreak, enableComboStreak) ||
                other.enableComboStreak == enableComboStreak) &&
            (identical(other.enableAchievementCelebration,
                    enableAchievementCelebration) ||
                other.enableAchievementCelebration ==
                    enableAchievementCelebration) &&
            (identical(other.enableSoundEffects, enableSoundEffects) ||
                other.enableSoundEffects == enableSoundEffects) &&
            (identical(other.animationSpeed, animationSpeed) ||
                other.animationSpeed == animationSpeed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      enableCompletionAnimation,
      animationType,
      enableComboStreak,
      enableAchievementCelebration,
      enableSoundEffects,
      animationSpeed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimationSettingsImplCopyWith<_$AnimationSettingsImpl> get copyWith =>
      __$$AnimationSettingsImplCopyWithImpl<_$AnimationSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnimationSettingsImplToJson(
      this,
    );
  }
}

abstract class _AnimationSettings extends AnimationSettings {
  const factory _AnimationSettings(
      {@HiveField(0) final bool enableCompletionAnimation,
      @HiveField(1) final CompletionAnimationType animationType,
      @HiveField(2) final bool enableComboStreak,
      @HiveField(3) final bool enableAchievementCelebration,
      @HiveField(4) final bool enableSoundEffects,
      @HiveField(5) final double animationSpeed}) = _$AnimationSettingsImpl;
  const _AnimationSettings._() : super._();

  factory _AnimationSettings.fromJson(Map<String, dynamic> json) =
      _$AnimationSettingsImpl.fromJson;

  @override
  @HiveField(0)
  bool get enableCompletionAnimation;
  @override
  @HiveField(1)
  CompletionAnimationType get animationType;
  @override
  @HiveField(2)
  bool get enableComboStreak;
  @override
  @HiveField(3)
  bool get enableAchievementCelebration;
  @override
  @HiveField(4)
  bool get enableSoundEffects;
  @override
  @HiveField(5)
  double get animationSpeed;
  @override
  @JsonKey(ignore: true)
  _$$AnimationSettingsImplCopyWith<_$AnimationSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
