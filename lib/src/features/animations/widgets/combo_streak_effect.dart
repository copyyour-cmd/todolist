import 'package:flutter/material.dart';

/// 连击奖励特效
class ComboStreakEffect extends StatefulWidget {
  const ComboStreakEffect({
    super.key,
    required this.comboCount,
    required this.onDismiss,
  });

  final int comboCount;
  final VoidCallback onDismiss;

  @override
  State<ComboStreakEffect> createState() => _ComboStreakEffectState();
}

class _ComboStreakEffectState extends State<ComboStreakEffect>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _scaleController.forward();

    // 2秒后自动关闭
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _scaleController.reverse().then((_) {
          widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String get _getComboText {
    if (widget.comboCount >= 10) {
      return '🔥 超级连击！';
    } else if (widget.comboCount >= 5) {
      return '⚡ 连击中！';
    } else {
      return '✨ 连击！';
    }
  }

  Color get _getComboColor {
    if (widget.comboCount >= 10) {
      return Colors.deepOrange;
    } else if (widget.comboCount >= 5) {
      return Colors.orange;
    } else {
      return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getComboColor,
                          _getComboColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: _getComboColor.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getComboText,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'x${widget.comboCount}',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// 连击管理器（追踪连击状态）
class ComboStreakNotifier extends ChangeNotifier {
  int _currentCombo = 0;
  DateTime? _lastCompletionTime;

  // 连击超时时间（秒）
  static const int _comboTimeoutSeconds = 30;

  int get currentCombo => _currentCombo;

  /// 增加连击
  void increment() {
    final now = DateTime.now();

    // 检查是否超时
    if (_lastCompletionTime != null) {
      final timeDiff = now.difference(_lastCompletionTime!);
      if (timeDiff.inSeconds > _comboTimeoutSeconds) {
        _currentCombo = 0;
      }
    }

    _currentCombo++;
    _lastCompletionTime = now;
    notifyListeners();
  }

  /// 重置连击
  void reset() {
    _currentCombo = 0;
    _lastCompletionTime = null;
    notifyListeners();
  }

  /// 是否有连击
  bool get hasCombo => _currentCombo > 1;
}
