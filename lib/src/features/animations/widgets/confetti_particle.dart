import 'dart:math';
import 'package:flutter/material.dart';

/// 五彩纸屑粒子
class ConfettiParticle {
  ConfettiParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });

  Offset position;
  Offset velocity;
  final Color color;
  final double size;
  double rotation;
  final double rotationSpeed;
  double opacity = 1.0;

  void update(double dt) {
    // 更新位置
    position += velocity * dt;

    // 应用重力
    velocity = Offset(
      velocity.dx * 0.98, // 空气阻力
      velocity.dy + 500 * dt, // 重力加速度
    );

    // 更新旋转
    rotation += rotationSpeed * dt;

    // 淡出
    opacity -= dt * 0.5;
    if (opacity < 0) opacity = 0;
  }

  bool get isDead => opacity <= 0;
}

/// 五彩纸屑爆炸效果组件
class ConfettiExplosion extends StatefulWidget {
  const ConfettiExplosion({
    super.key,
    required this.origin,
    required this.particleCount,
    this.colors,
    this.onComplete,
  });

  final Offset origin;
  final int particleCount;
  final List<Color>? colors;
  final VoidCallback? onComplete;

  @override
  State<ConfettiExplosion> createState() => _ConfettiExplosionState();
}

class _ConfettiExplosionState extends State<ConfettiExplosion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<ConfettiParticle> _particles;

  static final _random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _initializeParticles();

    _controller.addListener(() {
      // 只有当还有活着的粒子时才更新
      if (_particles.any((p) => !p.isDead)) {
        setState(() {
          final dt = 1 / 60; // 假设60fps
          for (final particle in _particles) {
            if (!particle.isDead) {
              particle.update(dt);
            }
          }
        });
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _controller.forward();
  }

  void _initializeParticles() {
    final colors = widget.colors ??
        [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
          Colors.pink,
          Colors.teal,
        ];

    _particles = List.generate(widget.particleCount, (index) {
      final angle = (index / widget.particleCount) * 2 * pi;
      final speed = 200 + _random.nextDouble() * 300;
      final velocity = Offset(
        cos(angle) * speed,
        sin(angle) * speed - 100, // 向上的初速度
      );

      return ConfettiParticle(
        position: widget.origin,
        velocity: velocity,
        color: colors[_random.nextInt(colors.length)],
        size: 4 + _random.nextDouble() * 8,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ConfettiPainter(_particles),
      size: Size.infinite,
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.particles);

  final List<ConfettiParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      if (particle.isDead) continue;

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      // 绘制矩形粒子
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 1.5,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}

/// 简单的星形闪光效果
class SparkleEffect extends StatefulWidget {
  const SparkleEffect({
    super.key,
    required this.origin,
    this.color = Colors.yellow,
    this.onComplete,
  });

  final Offset origin;
  final Color color;
  final VoidCallback? onComplete;

  @override
  State<SparkleEffect> createState() => _SparkleEffectState();
}

class _SparkleEffectState extends State<SparkleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1, curve: Curves.easeOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _SparklePainter(
            origin: widget.origin,
            scale: _scaleAnimation.value,
            opacity: _opacityAnimation.value,
            color: widget.color,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _SparklePainter extends CustomPainter {
  _SparklePainter({
    required this.origin,
    required this.scale,
    required this.opacity,
    required this.color,
  });

  final Offset origin;
  final double scale;
  final double opacity;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;

    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.scale(scale);

    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    // 绘制四芒星
    final path = Path();
    const points = 8;
    const radius = 30.0;
    const innerRadius = 15.0;

    for (var i = 0; i < points; i++) {
      final angle = (i * pi / (points / 2)) - pi / 2;
      final r = i.isEven ? radius : innerRadius;
      final x = cos(angle) * r;
      final y = sin(angle) * r;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) {
    return oldDelegate.scale != scale || oldDelegate.opacity != opacity;
  }
}
