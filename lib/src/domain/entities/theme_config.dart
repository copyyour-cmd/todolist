import 'package:flutter/material.dart';
import '../../infrastructure/hive/type_ids.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'theme_config.freezed.dart';
part 'theme_config.g.dart';

/// Font size preset
@HiveType(typeId: HiveTypeIds.fontSizePreset, adapterName: 'FontSizePresetAdapter')
enum FontSizePreset {
  @HiveField(0)
  small,
  @HiveField(1)
  medium,
  @HiveField(2)
  large,
  @HiveField(3)
  extraLarge,
}

/// Task card style
@HiveType(typeId: HiveTypeIds.taskCardStyle, adapterName: 'TaskCardStyleAdapter')
enum TaskCardStyle {
  @HiveField(0)
  compact, // 紧凑样式
  @HiveField(1)
  comfortable, // 舒适样式
  @HiveField(2)
  spacious, // 宽松样式
}

/// Predefined color scheme
@HiveType(typeId: HiveTypeIds.colorSchemePreset, adapterName: 'ColorSchemePresetAdapter')
enum ColorSchemePreset {
  @HiveField(0)
  blue, // 默认蓝色
  @HiveField(1)
  indigo, // 靛蓝
  @HiveField(2)
  purple, // 紫色
  @HiveField(3)
  pink, // 粉色
  @HiveField(4)
  red, // 红色
  @HiveField(5)
  orange, // 橙色
  @HiveField(6)
  green, // 绿色
  @HiveField(7)
  teal, // 青色
  @HiveField(8)
  custom, // 自定义
}

/// Custom color configuration
@HiveType(typeId: HiveTypeIds.customColorConfig, adapterName: 'CustomColorConfigAdapter')
@freezed
class CustomColorConfig with _$CustomColorConfig {
  const factory CustomColorConfig({
    @HiveField(0) required int primaryColor,
    @HiveField(1) required int secondaryColor,
    @HiveField(2) int? tertiaryColor,
    @HiveField(3) int? errorColor,
    @HiveField(4) int? surfaceColor,
  }) = _CustomColorConfig;

  const CustomColorConfig._();

  factory CustomColorConfig.fromJson(Map<String, dynamic> json) =>
      _$CustomColorConfigFromJson(json);

  /// Create from Color objects
  factory CustomColorConfig.fromColors({
    required Color primary,
    required Color secondary,
    Color? tertiary,
    Color? error,
    Color? surface,
  }) {
    return CustomColorConfig(
      primaryColor: primary.value,
      secondaryColor: secondary.value,
      tertiaryColor: tertiary?.value,
      errorColor: error?.value,
      surfaceColor: surface?.value,
    );
  }

  /// Convert to Color objects
  Color get primary => Color(primaryColor);
  Color get secondary => Color(secondaryColor);
  Color? get tertiary => tertiaryColor != null ? Color(tertiaryColor!) : null;
  Color? get error => errorColor != null ? Color(errorColor!) : null;
  Color? get surface => surfaceColor != null ? Color(surfaceColor!) : null;
}

/// Complete theme configuration
@HiveType(typeId: HiveTypeIds.themeConfig, adapterName: 'ThemeConfigAdapter')
@freezed
class ThemeConfig with _$ThemeConfig {
  const factory ThemeConfig({
    @HiveField(0) @Default(ColorSchemePreset.blue) ColorSchemePreset colorScheme,
    @HiveField(1) CustomColorConfig? customColors,
    @HiveField(2) @Default(FontSizePreset.medium) FontSizePreset fontSize,
    @HiveField(3) @Default(TaskCardStyle.comfortable) TaskCardStyle cardStyle,
    @HiveField(4) @Default(true) bool useMaterialYou,
    @HiveField(5) @Default(true) bool useSystemAccentColor,
  }) = _ThemeConfig;

  const ThemeConfig._();

  factory ThemeConfig.fromJson(Map<String, dynamic> json) =>
      _$ThemeConfigFromJson(json);

  /// Get font scale based on preset
  double get fontScale {
    switch (fontSize) {
      case FontSizePreset.small:
        return 0.85;
      case FontSizePreset.medium:
        return 1;
      case FontSizePreset.large:
        return 1.15;
      case FontSizePreset.extraLarge:
        return 1.3;
    }
  }

  /// Get card padding based on style
  EdgeInsets get cardPadding {
    switch (cardStyle) {
      case TaskCardStyle.compact:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case TaskCardStyle.comfortable:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case TaskCardStyle.spacious:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }

  /// Get card spacing based on style
  double get cardSpacing {
    switch (cardStyle) {
      case TaskCardStyle.compact:
        return 6;
      case TaskCardStyle.comfortable:
        return 8;
      case TaskCardStyle.spacious:
        return 12;
    }
  }

  /// Get vertical spacing in cards
  double get verticalSpacing {
    switch (cardStyle) {
      case TaskCardStyle.compact:
        return 4;
      case TaskCardStyle.comfortable:
        return 8;
      case TaskCardStyle.spacious:
        return 12;
    }
  }
}

/// Extension to get primary color from preset
extension ColorSchemePresetX on ColorSchemePreset {
  Color get primaryColor {
    switch (this) {
      case ColorSchemePreset.blue:
        return Colors.blue;
      case ColorSchemePreset.indigo:
        return Colors.indigo;
      case ColorSchemePreset.purple:
        return Colors.purple;
      case ColorSchemePreset.pink:
        return Colors.pink;
      case ColorSchemePreset.red:
        return Colors.red;
      case ColorSchemePreset.orange:
        return Colors.orange;
      case ColorSchemePreset.green:
        return Colors.green;
      case ColorSchemePreset.teal:
        return Colors.teal;
      case ColorSchemePreset.custom:
        return Colors.blue; // Fallback
    }
  }

  String get displayName {
    switch (this) {
      case ColorSchemePreset.blue:
        return '蓝色';
      case ColorSchemePreset.indigo:
        return '靛蓝';
      case ColorSchemePreset.purple:
        return '紫色';
      case ColorSchemePreset.pink:
        return '粉色';
      case ColorSchemePreset.red:
        return '红色';
      case ColorSchemePreset.orange:
        return '橙色';
      case ColorSchemePreset.green:
        return '绿色';
      case ColorSchemePreset.teal:
        return '青色';
      case ColorSchemePreset.custom:
        return '自定义';
    }
  }
}

extension FontSizePresetX on FontSizePreset {
  String get displayName {
    switch (this) {
      case FontSizePreset.small:
        return '小';
      case FontSizePreset.medium:
        return '中';
      case FontSizePreset.large:
        return '大';
      case FontSizePreset.extraLarge:
        return '特大';
    }
  }
}

extension TaskCardStyleX on TaskCardStyle {
  String get displayName {
    switch (this) {
      case TaskCardStyle.compact:
        return '紧凑';
      case TaskCardStyle.comfortable:
        return '舒适';
      case TaskCardStyle.spacious:
        return '宽松';
    }
  }
}
