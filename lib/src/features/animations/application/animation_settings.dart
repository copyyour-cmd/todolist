import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../infrastructure/hive/type_ids.dart';
import 'package:hive/hive.dart';
import 'package:todolist/src/features/animations/widgets/task_completion_animation.dart';

part 'animation_settings.freezed.dart';
part 'animation_settings.g.dart';

/// 动画设置
@HiveType(typeId: 38, adapterName: 'AnimationSettingsAdapter')
@freezed
class AnimationSettings with _$AnimationSettings {
  const factory AnimationSettings({
    @HiveField(0) @Default(true) bool enableCompletionAnimation,
    @HiveField(1)
    @Default(CompletionAnimationType.confetti)
    CompletionAnimationType animationType,
    @HiveField(2) @Default(true) bool enableComboStreak,
    @HiveField(3) @Default(true) bool enableAchievementCelebration,
    @HiveField(4) @Default(true) bool enableSoundEffects,
    @HiveField(5) @Default(0.8) double animationSpeed, // 0.5 - 2.0
  }) = _AnimationSettings;

  const AnimationSettings._();

  factory AnimationSettings.fromJson(Map<String, dynamic> json) =>
      _$AnimationSettingsFromJson(json);

  /// 获取动画持续时间（根据速度调整）
  Duration get animationDuration {
    final baseDuration = 800; // 毫秒
    final adjusted = (baseDuration / animationSpeed).round();
    return Duration(milliseconds: adjusted);
  }
}

/// 动画类型适配器
@HiveType(typeId: 39, adapterName: 'CompletionAnimationTypeAdapter')
enum CompletionAnimationTypeHive {
  @HiveField(0)
  confetti,
  @HiveField(1)
  sparkle,
  @HiveField(2)
  scale,
  @HiveField(3)
  slideOut,
  @HiveField(4)
  bounce,
}

/// 扩展方法：转换到UI类型
extension CompletionAnimationTypeHiveX on CompletionAnimationTypeHive {
  CompletionAnimationType toUIType() {
    switch (this) {
      case CompletionAnimationTypeHive.confetti:
        return CompletionAnimationType.confetti;
      case CompletionAnimationTypeHive.sparkle:
        return CompletionAnimationType.sparkle;
      case CompletionAnimationTypeHive.scale:
        return CompletionAnimationType.scale;
      case CompletionAnimationTypeHive.slideOut:
        return CompletionAnimationType.slideOut;
      case CompletionAnimationTypeHive.bounce:
        return CompletionAnimationType.bounce;
    }
  }
}

extension CompletionAnimationTypeX on CompletionAnimationType {
  CompletionAnimationTypeHive toHiveType() {
    switch (this) {
      case CompletionAnimationType.confetti:
        return CompletionAnimationTypeHive.confetti;
      case CompletionAnimationType.sparkle:
        return CompletionAnimationTypeHive.sparkle;
      case CompletionAnimationType.scale:
        return CompletionAnimationTypeHive.scale;
      case CompletionAnimationType.slideOut:
        return CompletionAnimationTypeHive.slideOut;
      case CompletionAnimationType.bounce:
        return CompletionAnimationTypeHive.bounce;
    }
  }

  String get displayName {
    switch (this) {
      case CompletionAnimationType.confetti:
        return '🎊 五彩纸屑';
      case CompletionAnimationType.sparkle:
        return '✨ 闪光';
      case CompletionAnimationType.scale:
        return '📏 缩放';
      case CompletionAnimationType.slideOut:
        return '➡️ 滑出';
      case CompletionAnimationType.bounce:
        return '🎈 弹跳';
    }
  }

  String get description {
    switch (this) {
      case CompletionAnimationType.confetti:
        return '完成任务时爆炸五彩纸屑';
      case CompletionAnimationType.sparkle:
        return '完成任务时闪烁星光';
      case CompletionAnimationType.scale:
        return '完成任务时缩放淡出';
      case CompletionAnimationType.slideOut:
        return '完成任务时滑出屏幕';
      case CompletionAnimationType.bounce:
        return '完成任务时弹跳';
    }
  }
}
