import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/animations/application/animation_providers.dart';
import 'package:todolist/src/features/animations/application/animation_settings.dart';
import 'package:todolist/src/features/animations/widgets/task_completion_animation.dart';
import 'package:todolist/src/features/animations/widgets/combo_streak_effect.dart';

/// 动画设置页面
class AnimationSettingsPage extends ConsumerWidget {
  const AnimationSettingsPage({super.key});

  static const routePath = '/settings/animations';
  static const routeName = 'animation-settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(animationSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('✨'),
            SizedBox(width: 8),
            Text('动画效果'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _showResetDialog(context, ref),
            tooltip: '恢复默认',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 功能介绍
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(
                        '动画增强体验',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '本小姐精心设计的动画效果，让完成任务变得更有成就感！',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 完成动画开关
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.celebration),
              title: const Text('任务完成动画'),
              subtitle: const Text('完成任务时播放动画效果'),
              value: settings.enableCompletionAnimation,
              onChanged: (value) {
                ref
                    .read(animationSettingsProvider.notifier)
                    .toggleCompletionAnimation(value);
                if (value) {
                  _showPreviewSnackBar(context, '已启用任务完成动画');
                }
              },
            ),
          ),
          const SizedBox(height: 8),

          // 动画类型选择
          if (settings.enableCompletionAnimation) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '动画类型',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ...CompletionAnimationType.values.map((type) {
                      return RadioListTile<CompletionAnimationType>(
                        title: Text(type.displayName),
                        subtitle: Text(type.description),
                        value: type,
                        groupValue: settings.animationType,
                        onChanged: (value) {
                          if (value != null) {
                            ref
                                .read(animationSettingsProvider.notifier)
                                .updateAnimationType(value);
                            _showAnimationPreview(context, type);
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          // 连击奖励开关
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.flash_on),
              title: const Text('连击奖励特效'),
              subtitle: const Text('快速完成多个任务时显示连击特效'),
              value: settings.enableComboStreak,
              onChanged: (value) {
                ref
                    .read(animationSettingsProvider.notifier)
                    .toggleComboStreak(value);
                if (value) {
                  _showComboPreview(context);
                }
              },
            ),
          ),
          const SizedBox(height: 8),

          // 成就庆祝开关
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.emoji_events),
              title: const Text('成就庆祝动画'),
              subtitle: const Text('解锁成就时显示庆祝效果'),
              value: settings.enableAchievementCelebration,
              onChanged: (value) {
                ref
                    .read(animationSettingsProvider.notifier)
                    .toggleAchievementCelebration(value);
                if (value) {
                  _showAchievementPreview(context);
                }
              },
            ),
          ),
          const SizedBox(height: 8),

          // 音效开关
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.volume_up),
              title: const Text('音效'),
              subtitle: const Text('播放完成任务的音效（开发中）'),
              value: settings.enableSoundEffects,
              onChanged: (value) {
                ref
                    .read(animationSettingsProvider.notifier)
                    .toggleSoundEffects(value);
              },
            ),
          ),
          const SizedBox(height: 16),

          // 动画速度调节
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.speed),
                      const SizedBox(width: 8),
                      Text(
                        '动画速度',
                        style: theme.textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Text(
                        '${(settings.animationSpeed * 100).toInt()}%',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: settings.animationSpeed,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    label: '${(settings.animationSpeed * 100).toInt()}%',
                    onChanged: (value) {
                      ref
                          .read(animationSettingsProvider.notifier)
                          .updateAnimationSpeed(value);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '慢 (50%)',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        '快 (200%)',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 预览按钮
          ElevatedButton.icon(
            onPressed: () => _showFullPreview(context, settings),
            icon: const Icon(Icons.play_arrow),
            label: const Text('预览所有效果'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('恢复默认设置'),
        content: const Text('确定要将所有动画设置恢复为默认值吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(animationSettingsProvider.notifier).reset();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已恢复默认设置')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showPreviewSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showAnimationPreview(
    BuildContext context,
    CompletionAnimationType type,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => _AnimationPreviewDialog(animationType: type),
    );
  }

  void _showComboPreview(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: ComboStreakEffect(
          comboCount: 5,
          onDismiss: () {},
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  void _showAchievementPreview(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: AchievementCelebration(
            title: '成就解锁！',
            description: '连续完成10个任务',
            icon: '🏆',
            onDismiss: () => overlayEntry.remove(),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  void _showFullPreview(BuildContext context, AnimationSettings settings) {
    showDialog<void>(
      context: context,
      builder: (context) => _FullPreviewDialog(settings: settings),
    );
  }
}

/// 动画预览对话框
class _AnimationPreviewDialog extends StatefulWidget {
  const _AnimationPreviewDialog({required this.animationType});

  final CompletionAnimationType animationType;

  @override
  State<_AnimationPreviewDialog> createState() =>
      _AnimationPreviewDialogState();
}

class _AnimationPreviewDialogState extends State<_AnimationPreviewDialog> {
  bool _isCompleted = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _playAnimation();
  }

  void _playAnimation() {
    // 重置状态
    setState(() {
      _isCompleted = false;
      _playCount++;
    });

    // 延迟触发动画
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isCompleted = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.animationType.displayName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.animationType.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // 使用 key 强制重建组件以重新播放动画
            TaskCompletionAnimation(
              key: ValueKey(_playCount),
              isCompleted: _isCompleted,
              animationType: widget.animationType,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '示例任务',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: _playAnimation,
                  icon: const Icon(Icons.replay),
                  label: const Text('重新播放'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('关闭'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 完整预览对话框
class _FullPreviewDialog extends StatelessWidget {
  const _FullPreviewDialog({required this.settings});

  final AnimationSettings settings;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('动画效果预览'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PreviewItem(
              title: '任务完成动画',
              enabled: settings.enableCompletionAnimation,
              type: settings.animationType,
            ),
            const Divider(),
            _PreviewItem(
              title: '连击奖励',
              enabled: settings.enableComboStreak,
            ),
            const Divider(),
            _PreviewItem(
              title: '成就庆祝',
              enabled: settings.enableAchievementCelebration,
            ),
            const Divider(),
            _PreviewItem(
              title: '音效',
              enabled: settings.enableSoundEffects,
            ),
            const SizedBox(height: 16),
            Text(
              '动画速度: ${(settings.animationSpeed * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
      ],
    );
  }
}

class _PreviewItem extends StatelessWidget {
  const _PreviewItem({
    required this.title,
    required this.enabled,
    this.type,
  });

  final String title;
  final bool enabled;
  final CompletionAnimationType? type;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          enabled ? Icons.check_circle : Icons.cancel,
          color: enabled ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (type != null && enabled)
                Text(
                  type!.displayName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
