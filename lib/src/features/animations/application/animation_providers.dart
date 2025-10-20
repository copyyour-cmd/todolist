import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:todolist/src/features/animations/application/animation_settings.dart';
import 'package:todolist/src/features/animations/application/sound_effect_service.dart';
import 'package:todolist/src/features/animations/widgets/combo_streak_effect.dart';
import 'package:todolist/src/features/animations/widgets/task_completion_animation.dart';

/// 动画设置Box Provider
final animationSettingsBoxProvider = Provider<Box<AnimationSettings>>((ref) {
  return Hive.box<AnimationSettings>('animation_settings');
});

/// 动画设置Provider
final animationSettingsProvider =
    StateNotifierProvider<AnimationSettingsNotifier, AnimationSettings>((ref) {
  final box = ref.watch(animationSettingsBoxProvider);
  return AnimationSettingsNotifier(box);
});

/// 动画设置Notifier
class AnimationSettingsNotifier extends StateNotifier<AnimationSettings> {
  AnimationSettingsNotifier(this._box)
      : super(_box.get('settings') ?? const AnimationSettings());

  final Box<AnimationSettings> _box;

  Future<void> _save() async {
    await _box.put('settings', state);
  }

  /// 切换完成动画
  Future<void> toggleCompletionAnimation(bool enabled) async {
    state = state.copyWith(enableCompletionAnimation: enabled);
    await _save();
  }

  /// 更新动画类型
  Future<void> updateAnimationType(CompletionAnimationType type) async {
    state = state.copyWith(animationType: type);
    await _save();
  }

  /// 切换连击奖励
  Future<void> toggleComboStreak(bool enabled) async {
    state = state.copyWith(enableComboStreak: enabled);
    await _save();
  }

  /// 切换成就庆祝
  Future<void> toggleAchievementCelebration(bool enabled) async {
    state = state.copyWith(enableAchievementCelebration: enabled);
    await _save();
  }

  /// 切换音效
  Future<void> toggleSoundEffects(bool enabled) async {
    state = state.copyWith(enableSoundEffects: enabled);
    await _save();
  }

  /// 更新动画速度
  Future<void> updateAnimationSpeed(double speed) async {
    state = state.copyWith(animationSpeed: speed);
    await _save();
  }

  /// 重置为默认值
  Future<void> reset() async {
    state = const AnimationSettings();
    await _save();
  }
}

/// 连击管理器Provider
final comboStreakProvider =
    ChangeNotifierProvider<ComboStreakNotifier>((ref) {
  return ComboStreakNotifier();
});

/// 音效服务Provider
final soundEffectServiceProvider = Provider<SoundEffectService>((ref) {
  return DefaultSoundEffectService();
});
