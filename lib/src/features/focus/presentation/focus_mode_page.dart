import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/l10n/app_localizations.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/domain/entities/focus_session.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/features/focus/application/focus_providers.dart';
import 'package:todolist/src/features/focus/presentation/focus_history_page.dart';
import 'package:todolist/src/features/settings/presentation/widgets/background_container.dart';
import 'package:todolist/src/features/tasks/application/task_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

class FocusModePage extends ConsumerStatefulWidget {
  const FocusModePage({super.key, this.taskId});

  final String? taskId;

  static const routeName = 'focus';
  static const routePath = '/focus';

  @override
  ConsumerState<FocusModePage> createState() => _FocusModePageState();
}

class _FocusModePageState extends ConsumerState<FocusModePage> {
  FocusDuration _selectedDuration = FocusDuration.standard;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final timerState = ref.watch(focusTimerServiceProvider);
    final todayMinutes = ref.watch(todayFocusMinutesProvider);

    return BackgroundContainer(
      backgroundType: BackgroundType.focus,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(l10n.focusTitle),
        actions: [
          if (timerState.isIdle)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: l10n.focusHistoryButton,
              onPressed: () => context.push(FocusHistoryPage.routePath),
            ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Today's focus time
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.today,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.focusTodayMinutes(todayMinutes),
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Timer Display
              _TimerDisplay(
                remainingSeconds: timerState.remainingSeconds,
                totalSeconds: timerState.totalSeconds,
                progress: timerState.progress,
              ),
              const SizedBox(height: 48),

              // Duration Selection (only when idle)
              if (timerState.isIdle) ...[
                Text(
                  l10n.focusSelectDuration,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                SegmentedButton<FocusDuration>(
                  segments: [
                    ButtonSegment(
                      value: FocusDuration.short,
                      label: Text(l10n.focusDurationShort),
                    ),
                    ButtonSegment(
                      value: FocusDuration.standard,
                      label: Text(l10n.focusDurationStandard),
                    ),
                    ButtonSegment(
                      value: FocusDuration.long,
                      label: Text(l10n.focusDurationLong),
                    ),
                  ],
                  selected: {_selectedDuration},
                  onSelectionChanged: (selection) {
                    setState(() => _selectedDuration = selection.first);
                  },
                ),
                const SizedBox(height: 32),
              ],

              // Control Buttons
              if (timerState.isIdle)
                FilledButton.icon(
                  onPressed: () {
                    ref.read(focusTimerServiceProvider.notifier).startTimer(
                          durationMinutes: _selectedDuration.minutes,
                          taskId: widget.taskId,
                        );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: Text(l10n.focusStart),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                )
              else if (timerState.isRunning)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _showInterruptionDialog(context, l10n),
                      icon: const Icon(Icons.pause),
                      label: Text(l10n.focusPause),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () => _showCancelDialog(context, l10n),
                      icon: const Icon(Icons.stop),
                      label: Text(l10n.focusCancel),
                    ),
                  ],
                )
              else if (timerState.isPaused)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        ref.read(focusTimerServiceProvider.notifier).resumeTimer();
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(l10n.focusResume),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () => _showCancelDialog(context, l10n),
                      icon: const Icon(Icons.stop),
                      label: Text(l10n.focusCancel),
                    ),
                  ],
                )
              else if (timerState.isCompleted)
                Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.focusCompleted,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 32),
                    if (timerState.currentSession?.taskId != null)
                      OutlinedButton.icon(
                        onPressed: () async {
                          await _completeTask(context, ref, l10n, timerState.currentSession!.taskId!);
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(l10n.focusCompleteTask),
                      ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        ref.read(focusTimerServiceProvider.notifier).resetTimer();
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.focusStartNew),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Future<void> _completeTask(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String taskId,
  ) async {
    try {
      final repository = ref.read(taskRepositoryProvider);
      final task = await repository.getById(taskId);

      if (task != null && task.status != TaskStatus.completed) {
        final service = ref.read(taskServiceProvider);
        await service.toggleCompletion(task, isCompleted: true);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.focusTaskCompleted)),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _showCancelDialog(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.focusCancelTitle),
        content: Text(l10n.focusCancelMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );

    if (confirmed ?? false && context.mounted) {
      await ref.read(focusTimerServiceProvider.notifier).cancelSession();
    }
  }

  Future<void> _showInterruptionDialog(BuildContext context, AppLocalizations l10n) async {
    const commonReasons = [
      '同事询问',
      '接电话',
      '查看消息',
      '喝水/休息',
      '紧急事项',
      '其他',
    ];

    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('打断原因'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final r in commonReasons)
              ListTile(
                title: Text(r),
                onTap: () => Navigator.of(context).pop(r),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonCancel),
          ),
        ],
      ),
    );

    if (reason != null && context.mounted) {
      ref.read(focusTimerServiceProvider.notifier).pauseTimer(reason: reason);
    }
  }
}

class _TimerDisplay extends StatelessWidget {
  const _TimerDisplay({
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.progress,
  });

  final int remainingSeconds;
  final int totalSeconds;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress Circle
          CustomPaint(
            size: const Size(280, 280),
            painter: _CircleProgressPainter(
              progress: progress,
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          // Time Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
              if (totalSeconds > 0) ...[
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  _CircleProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  final double progress;
  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const strokeWidth = 12.0;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
