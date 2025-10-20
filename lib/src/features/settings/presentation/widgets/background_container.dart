import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/settings/application/app_settings_provider.dart';

/// 背景容器组件，支持自定义背景图片、模糊和暗化效果
class BackgroundContainer extends ConsumerWidget {
  const BackgroundContainer({
    required this.child,
    this.backgroundType = BackgroundType.home,
    super.key,
  });

  final Widget child;
  final BackgroundType backgroundType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final theme = Theme.of(context);

    return settingsAsync.when(
      data: (settings) {
        final imagePath = backgroundType == BackgroundType.home
            ? settings.homeBackgroundImagePath
            : settings.focusBackgroundImagePath;

        // 如果没有背景图片，返回带渐变背景的容器
        if (imagePath == null || !File(imagePath).existsSync()) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  theme.colorScheme.surface,
                  theme.colorScheme.secondaryContainer.withValues(alpha: 0.2),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: child,
          );
        }

        final blurAmount = settings.backgroundBlurAmount;
        final darkenAmount = settings.backgroundDarkenAmount;

        return Stack(
          fit: StackFit.expand,
          children: [
            // 背景图片
            Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
            // 模糊效果层
            if (blurAmount > 0)
              BackdropFilter(
                filter: ui.ImageFilter.blur(
                  sigmaX: blurAmount * 10,
                  sigmaY: blurAmount * 10,
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            // 暗化效果层
            if (darkenAmount > 0)
              Container(
                color: Colors.black.withValues(alpha: darkenAmount),
              ),
            // 内容
            child,
          ],
        );
      },
      loading: () => child,
      error: (_, __) => child,
    );
  }
}

enum BackgroundType {
  home,
  focus,
}
