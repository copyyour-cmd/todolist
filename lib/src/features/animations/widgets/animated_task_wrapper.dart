import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/features/animations/application/animation_providers.dart';
import 'package:todolist/src/features/animations/widgets/task_completion_animation.dart';
import 'package:todolist/src/features/animations/widgets/combo_streak_effect.dart';

/// 任务卡片动画包装器
///
/// 监听任务完成状态变化并触发动画效果
class AnimatedTaskWrapper extends ConsumerStatefulWidget {
  const AnimatedTaskWrapper({
    super.key,
    required this.task,
    required this.child,
  });

  final Task task;
  final Widget child;

  @override
  ConsumerState<AnimatedTaskWrapper> createState() => _AnimatedTaskWrapperState();
}

class _AnimatedTaskWrapperState extends ConsumerState<AnimatedTaskWrapper> {
  bool _previousCompletionState = false;
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();
    _previousCompletionState = widget.task.isCompleted;
  }

  @override
  void didUpdateWidget(AnimatedTaskWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 检测任务完成状态变化
    final wasCompleted = oldWidget.task.isCompleted;
    final isNowCompleted = widget.task.isCompleted;

    // 只在从未完成到完成时触发动画
    if (!wasCompleted && isNowCompleted) {
      _triggerCompletionAnimation();
    }

    _previousCompletionState = isNowCompleted;
  }

  void _triggerCompletionAnimation() {
    final settings = ref.read(animationSettingsProvider);

    // 检查是否启用动画
    if (!settings.enableCompletionAnimation) {
      return;
    }

    // 触发音效
    if (settings.enableSoundEffects) {
      final soundService = ref.read(soundEffectServiceProvider);
      soundService.playCompletionSound();
    }

    // 触发动画
    setState(() {
      _showAnimation = true;
    });

    // 触发连击系统
    if (settings.enableComboStreak) {
      final comboNotifier = ref.read(comboStreakProvider);
      comboNotifier.increment();

      // 播放连击音效
      if (settings.enableSoundEffects && comboNotifier.hasCombo) {
        final soundService = ref.read(soundEffectServiceProvider);
        soundService.playComboSound(comboNotifier.currentCombo);
      }

      _showComboEffect();
    }

    // 动画结束后重置状态
    Future.delayed(settings.animationDuration, () {
      if (mounted) {
        setState(() {
          _showAnimation = false;
        });
      }
    });
  }

  void _showComboEffect() {
    final comboNotifier = ref.read(comboStreakProvider);

    // 只在连击数大于1时显示特效
    if (!comboNotifier.hasCombo) {
      return;
    }

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.3,
        left: 0,
        right: 0,
        child: Center(
          child: ComboStreakEffect(
            comboCount: comboNotifier.currentCombo,
            onDismiss: () {
              overlayEntry.remove();
            },
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    // 如果动画未启用，直接返回子组件
    if (!_showAnimation) {
      return widget.child;
    }

    // 只在需要显示动画时读取设置
    final settings = ref.read(animationSettingsProvider);

    // 用动画包装子组件
    return TaskCompletionAnimation(
      isCompleted: _showAnimation,
      animationType: settings.animationType,
      duration: settings.animationDuration,
      child: widget.child,
    );
  }
}
