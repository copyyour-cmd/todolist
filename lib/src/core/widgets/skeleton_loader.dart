import 'package:flutter/material.dart';

/// 骨架屏加载器基类
/// 提供统一的加载占位效果
class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    super.key,
    required this.child,
    this.enabled = true,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget child;
  final bool enabled;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final theme = Theme.of(context);
    final baseColor = widget.baseColor ?? Colors.grey.shade300;
    final highlightColor = widget.highlightColor ?? Colors.grey.shade100;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
              transform: GradientRotation(_animation.value * 3.14 / 4),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// 骨架屏容器 - 用于创建各种形状的骨架
class SkeletonContainer extends StatelessWidget {
  const SkeletonContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}

/// 骨架屏任务卡片
class SkeletonTaskCard extends StatelessWidget {
  const SkeletonTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SkeletonLoader(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 优先级圆点
                  SkeletonContainer(
                    width: 12,
                    height: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(width: 12),
                  // 标题
                  Expanded(
                    child: SkeletonContainer(
                      height: 18,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 复选框
                  SkeletonContainer(
                    width: 24,
                    height: 24,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 描述文本
              SkeletonContainer(
                height: 14,
                width: double.infinity * 0.8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              // 标签
              Row(
                children: [
                  SkeletonContainer(
                    width: 80,
                    height: 24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(width: 8),
                  SkeletonContainer(
                    width: 60,
                    height: 24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 骨架屏列表项
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: ListTile(
        leading: SkeletonContainer(
          width: 40,
          height: 40,
          borderRadius: BorderRadius.circular(20),
        ),
        title: SkeletonContainer(
          height: 16,
          width: double.infinity,
          borderRadius: BorderRadius.circular(4),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SkeletonContainer(
            height: 14,
            width: double.infinity * 0.6,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

/// 骨架屏文本行
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({
    super.key,
    this.width,
    this.height = 16,
    this.margin,
  });

  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: SkeletonContainer(
        width: width,
        height: height,
        margin: margin,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// 骨架屏圆形
class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: SkeletonContainer(
        width: size,
        height: size,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}

/// 骨架屏统计卡片
class SkeletonStatCard extends StatelessWidget {
  const SkeletonStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(
                height: 14,
                width: 60,
              ),
              const SizedBox(height: 8),
              SkeletonLine(
                height: 24,
                width: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
