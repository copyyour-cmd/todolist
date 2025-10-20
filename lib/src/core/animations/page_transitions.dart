import 'package:flutter/material.dart';

/// 自定义页面过渡动画构建器
/// 提供流畅的淡入淡出+轻微上滑效果
class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  const CustomPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // 使用淡入淡出 + 轻微上滑的组合动画
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.03), // 从下方3%的位置开始
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic, // 使用三次贝塞尔曲线,更自然
          ),
        ),
        child: child,
      ),
    );
  }
}

/// 从右侧滑入的页面过渡动画(类似iOS)
class SlideRightTransitionsBuilder extends PageTransitionsBuilder {
  const SlideRightTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0), // 从右侧完全开始
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
        ),
      ),
      child: child,
    );
  }
}

/// 缩放+淡入动画(适合对话框风格的页面)
class ScaleFadeTransitionsBuilder extends PageTransitionsBuilder {
  const ScaleFadeTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.9,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

/// 共享元素过渡动画辅助类
/// 用于在页面间创建Hero动画
class PageTransitionHelpers {
  /// 创建带Hero动画的页面路由
  static Route<T> createHeroRoute<T>({
    required Widget page,
    required String heroTag,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// 创建底部滑入动画路由(适合模态框)
  static Route<T> createBottomSheetRoute<T>({
    required Widget page,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // 从底部开始
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
      fullscreenDialog: fullscreenDialog,
    );
  }

  /// 创建淡入淡出路由
  static Route<T> createFadeRoute<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// 创建旋转+缩放动画路由(适合特殊场景)
  static Route<T> createRotateScaleRoute<T>({
    required Widget page,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.elasticOut,
              ),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 800),
    );
  }
}

/// 页面过渡动画类型枚举
enum PageTransitionType {
  /// 默认(淡入+轻微上滑)
  fade,

  /// 从右侧滑入
  slideRight,

  /// 缩放+淡入
  scaleFade,

  /// 底部滑入
  bottomSheet,

  /// 仅淡入淡出
  fadeOnly,
}

/// 获取对应的PageTransitionsBuilder
PageTransitionsBuilder getTransitionBuilder(PageTransitionType type) {
  return switch (type) {
    PageTransitionType.fade => const CustomPageTransitionsBuilder(),
    PageTransitionType.slideRight => const SlideRightTransitionsBuilder(),
    PageTransitionType.scaleFade => const ScaleFadeTransitionsBuilder(),
    PageTransitionType.bottomSheet => const CustomPageTransitionsBuilder(),
    PageTransitionType.fadeOnly => const CustomPageTransitionsBuilder(),
  };
}
