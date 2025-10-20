import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:todolist/src/core/animations/page_transitions.dart';
import 'package:todolist/src/domain/entities/app_settings.dart';

class AppTheme {
  static ThemeData light([AppThemeColor colorScheme = AppThemeColor.bahamaBlue, Color? customColor]) {
    if (colorScheme == AppThemeColor.custom && customColor != null) {
      return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: customColor,
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
        // 添加页面过渡动画
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CustomPageTransitionsBuilder(),
            TargetPlatform.windows: CustomPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );
    }

    return FlexThemeData.light(
      scheme: _getFlexScheme(colorScheme),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 9,
      subThemesData: const FlexSubThemesData(
        elevatedButtonRadius: 16,
        cardRadius: 16,
      ),
      // 添加页面过渡动画到FlexThemeData
    ).copyWith(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CustomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CustomPageTransitionsBuilder(),
          TargetPlatform.windows: CustomPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData dark([AppThemeColor colorScheme = AppThemeColor.bahamaBlue, Color? customColor]) {
    if (colorScheme == AppThemeColor.custom && customColor != null) {
      return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: customColor,
          brightness: Brightness.dark,
        ),
        cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
        // 添加页面过渡动画
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CustomPageTransitionsBuilder(),
            TargetPlatform.windows: CustomPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );
    }

    return FlexThemeData.dark(
      scheme: _getFlexScheme(colorScheme),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 15,
      subThemesData: const FlexSubThemesData(
        elevatedButtonRadius: 16,
        cardRadius: 16,
      ),
    ).copyWith(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CustomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CustomPageTransitionsBuilder(),
          TargetPlatform.windows: CustomPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static FlexScheme _getFlexScheme(AppThemeColor colorScheme) {
    return switch (colorScheme) {
      AppThemeColor.bahamaBlue => FlexScheme.bahamaBlue,
      AppThemeColor.purple => FlexScheme.deepPurple,
      AppThemeColor.green => FlexScheme.green,
      AppThemeColor.orange => FlexScheme.deepOrangeM3,
      AppThemeColor.pink => FlexScheme.sakura,
      AppThemeColor.teal => FlexScheme.aquaBlue,
      AppThemeColor.indigo => FlexScheme.indigoM3,
      AppThemeColor.amber => FlexScheme.amber,
      AppThemeColor.eyeCareGreen => FlexScheme.greenM3,
      AppThemeColor.deepBlue => FlexScheme.blueWhale,
      AppThemeColor.lavender => FlexScheme.deepPurple,
      AppThemeColor.mintGreen => FlexScheme.aquaBlue,
      AppThemeColor.sunset => FlexScheme.redM3,
      AppThemeColor.ocean => FlexScheme.blue,
      AppThemeColor.custom => FlexScheme.bahamaBlue, // fallback
    };
  }

  static String getThemeName(AppThemeColor colorScheme) {
    return switch (colorScheme) {
      AppThemeColor.bahamaBlue => '巴哈马蓝',
      AppThemeColor.purple => '深紫色',
      AppThemeColor.green => '自然绿',
      AppThemeColor.orange => '活力橙',
      AppThemeColor.pink => '樱花粉',
      AppThemeColor.teal => '青蓝色',
      AppThemeColor.indigo => '靛蓝色',
      AppThemeColor.amber => '琥珀色',
      AppThemeColor.eyeCareGreen => '护眼绿',
      AppThemeColor.deepBlue => '深邃蓝',
      AppThemeColor.lavender => '薰衣草',
      AppThemeColor.mintGreen => '薄荷绿',
      AppThemeColor.sunset => '日落橙',
      AppThemeColor.ocean => '海洋蓝',
      AppThemeColor.custom => '自定义',
    };
  }

  static Color getPreviewColor(AppThemeColor colorScheme) {
    return switch (colorScheme) {
      AppThemeColor.bahamaBlue => const Color(0xFF006B7D),
      AppThemeColor.purple => const Color(0xFF6B1B9A),
      AppThemeColor.green => const Color(0xFF2E7D32),
      AppThemeColor.orange => const Color(0xFFE65100),
      AppThemeColor.pink => const Color(0xFFE91E63),
      AppThemeColor.teal => const Color(0xFF00897B),
      AppThemeColor.indigo => const Color(0xFF3F51B5),
      AppThemeColor.amber => const Color(0xFFFFA000),
      AppThemeColor.eyeCareGreen => const Color(0xFF66BB6A), // 护眼绿
      AppThemeColor.deepBlue => const Color(0xFF1565C0), // 深邃蓝
      AppThemeColor.lavender => const Color(0xFF9575CD), // 薰衣草
      AppThemeColor.mintGreen => const Color(0xFF26A69A), // 薄荷绿
      AppThemeColor.sunset => const Color(0xFFFF5722), // 日落橙
      AppThemeColor.ocean => const Color(0xFF0277BD), // 海洋蓝
      AppThemeColor.custom => const Color(0xFF9E9E9E),
    };
  }
}
