import 'package:flutter/material.dart';
import 'package:todolist/src/features/animations/widgets/confetti_particle.dart';

/// 任务完成动画效果枚举
enum CompletionAnimationType {
  confetti, // 五彩纸屑
  sparkle, // 闪光
  scale, // 缩放
  slideOut, // 滑出
  bounce, // 弹跳
}

/// 任务完成动画包装器
class TaskCompletionAnimation extends StatefulWidget {
  const TaskCompletionAnimation({
    super.key,
    required this.child,
    required this.isCompleted,
    this.animationType = CompletionAnimationType.confetti,
    this.duration = const Duration(milliseconds: 800),
    this.onAnimationComplete,
  });

  final Widget child;
  final bool isCompleted;
  final CompletionAnimationType animationType;
  final Duration duration;
  final VoidCallback? onAnimationComplete;

  @override
  State<TaskCompletionAnimation> createState() =>
      _TaskCompletionAnimationState();
}

class _TaskCompletionAnimationState extends State<TaskCompletionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;

  bool _showConfetti = false;
  Offset? _confettiOrigin;
  bool _showSparkle = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // 缩放动画：先放大再缩小
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    // 淡出动画
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // 滑出动画
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // 旋转动画
    _rotationAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(TaskCompletionAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isCompleted && !oldWidget.isCompleted) {
      _triggerAnimation();
    } else if (!widget.isCompleted && oldWidget.isCompleted) {
      _controller.reverse();
      setState(() {
        _showConfetti = false;
        _showSparkle = false;
      });
    }
  }

  void _triggerAnimation() {
    _controller.forward(from: 0);

    // 获取widget中心位置
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final RenderBox? box = context.findRenderObject() as RenderBox?;
      if (box != null) {
        final center = box.size.center(Offset.zero);
        final globalPosition = box.localToGlobal(center);

        setState(() {
          if (widget.animationType == CompletionAnimationType.confetti) {
            _showConfetti = true;
            _confettiOrigin = globalPosition;
          } else if (widget.animationType == CompletionAnimationType.sparkle) {
            _showSparkle = true;
            _confettiOrigin = globalPosition;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget animatedChild = widget.child;

    if (widget.isCompleted) {
      switch (widget.animationType) {
        case CompletionAnimationType.confetti:
          animatedChild = AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: 0.7 + (_opacityAnimation.value * 0.3),
                  child: child,
                ),
              );
            },
            child: widget.child,
          );
          break;

        case CompletionAnimationType.sparkle:
          animatedChild = AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: widget.child,
          );
          break;

        case CompletionAnimationType.scale:
          animatedChild = AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: child,
                ),
              );
            },
            child: widget.child,
          );
          break;

        case CompletionAnimationType.slideOut:
          animatedChild = AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  _slideAnimation.value.dx * MediaQuery.of(context).size.width,
                  0,
                ),
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: child,
                  ),
                ),
              );
            },
            child: widget.child,
          );
          break;

        case CompletionAnimationType.bounce:
          animatedChild = AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: widget.child,
          );
          break;
      }
    }

    return Stack(
      children: [
        animatedChild,
        if (_showConfetti && _confettiOrigin != null)
          Positioned.fill(
            child: ConfettiExplosion(
              origin: _confettiOrigin!,
              particleCount: 30,
              onComplete: () {
                setState(() {
                  _showConfetti = false;
                });
              },
            ),
          ),
        if (_showSparkle && _confettiOrigin != null)
          Positioned.fill(
            child: SparkleEffect(
              origin: _confettiOrigin!,
              color: Colors.amber,
              onComplete: () {
                setState(() {
                  _showSparkle = false;
                });
              },
            ),
          ),
      ],
    );
  }
}

/// 成就解锁庆祝动画
class AchievementCelebration extends StatefulWidget {
  const AchievementCelebration({
    super.key,
    required this.title,
    required this.description,
    this.icon = '🎉',
    this.onDismiss,
  });

  final String title;
  final String description;
  final String icon;
  final VoidCallback? onDismiss;

  @override
  State<AchievementCelebration> createState() => _AchievementCelebrationState();
}

class _AchievementCelebrationState extends State<AchievementCelebration>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _bounceController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(_bounceController);

    _slideController.forward();

    _slideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showConfetti = true;
        });
        _bounceController.forward();

        // 3秒后自动关闭
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _dismiss();
          }
        });
      }
    });
  }

  void _dismiss() {
    _slideController.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SlideTransition(
      position: _slideAnimation,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _bounceController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Text(
                          widget.icon,
                          style: const TextStyle(fontSize: 48),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              if (_showConfetti)
                Positioned.fill(
                  child: ConfettiExplosion(
                    origin: const Offset(0, 0),
                    particleCount: 50,
                    onComplete: () {
                      setState(() {
                        _showConfetti = false;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
