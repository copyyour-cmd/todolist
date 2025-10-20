import 'dart:math';
import 'package:flutter/material.dart';

/// WCAG 2.1颜色对比度检查工具
/// 实现WCAG 2.1 AA/AAA标准的对比度计算和验证
class ContrastChecker {
  /// WCAG 2.1 AA级别对比度要求
  static const double wcagAANormalText = 4.5; // 正常文字
  static const double wcagAALargeText = 3.0; // 大文字(18pt+或14pt粗体+)
  static const double wcagAAGraphics = 3.0; // UI组件和图形

  /// WCAG 2.1 AAA级别对比度要求
  static const double wcagAAANormalText = 7.0;
  static const double wcagAAALargeText = 4.5;

  /// 计算两个颜色之间的对比度
  /// 返回对比度比率 (1-21)
  static double calculateContrast(Color foreground, Color background) {
    final fgLuminance = _calculateRelativeLuminance(foreground);
    final bgLuminance = _calculateRelativeLuminance(background);

    // WCAG公式: (L1 + 0.05) / (L2 + 0.05)
    // 其中L1是较亮颜色的相对亮度，L2是较暗颜色的相对亮度
    final lighter = max(fgLuminance, bgLuminance);
    final darker = min(fgLuminance, bgLuminance);

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// 计算颜色的相对亮度 (0-1)
  static double _calculateRelativeLuminance(Color color) {
    // 转换为0-1范围
    final r = _linearize(color.red / 255.0);
    final g = _linearize(color.green / 255.0);
    final b = _linearize(color.blue / 255.0);

    // WCAG公式: L = 0.2126 * R + 0.7152 * G + 0.0722 * B
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// 线性化RGB通道值
  static double _linearize(double value) {
    if (value <= 0.03928) {
      return value / 12.92;
    } else {
      return pow((value + 0.055) / 1.055, 2.4).toDouble();
    }
  }

  /// 检查是否满足WCAG AA级别 - 正常文字
  static bool meetsWCAGAANormal(Color foreground, Color background) {
    return calculateContrast(foreground, background) >= wcagAANormalText;
  }

  /// 检查是否满足WCAG AA级别 - 大文字
  static bool meetsWCAGAALarge(Color foreground, Color background) {
    return calculateContrast(foreground, background) >= wcagAALargeText;
  }

  /// 检查是否满足WCAG AA级别 - UI组件
  static bool meetsWCAGAAGraphics(Color foreground, Color background) {
    return calculateContrast(foreground, background) >= wcagAAGraphics;
  }

  /// 检查是否满足WCAG AAA级别 - 正常文字
  static bool meetsWCAGAAANormal(Color foreground, Color background) {
    return calculateContrast(foreground, background) >= wcagAAANormalText;
  }

  /// 检查是否满足WCAG AAA级别 - 大文字
  static bool meetsWCAGAAALarge(Color foreground, Color background) {
    return calculateContrast(foreground, background) >= wcagAAALargeText;
  }

  /// 获取对比度检查结果的详细信息
  static ContrastResult checkContrast(
    Color foreground,
    Color background, {
    bool isLargeText = false,
    bool isGraphics = false,
  }) {
    final ratio = calculateContrast(foreground, background);

    return ContrastResult(
      ratio: ratio,
      foreground: foreground,
      background: background,
      isLargeText: isLargeText,
      isGraphics: isGraphics,
    );
  }

  /// 建议一个更好的前景色以满足WCAG AA标准
  static Color suggestForegroundColor(
    Color original,
    Color background, {
    double targetRatio = wcagAANormalText,
  }) {
    // 先尝试加深或变浅原色
    Color suggested = original;
    double currentRatio = calculateContrast(suggested, background);

    if (currentRatio >= targetRatio) {
      return suggested;
    }

    // 尝试调整亮度
    final bgLuminance = _calculateRelativeLuminance(background);

    // 如果背景较暗，使前景色更亮；如果背景较亮，使前景色更暗
    if (bgLuminance < 0.5) {
      // 背景较暗，尝试白色系
      suggested = _adjustColorBrightness(original, 1.0);
      currentRatio = calculateContrast(suggested, background);
      if (currentRatio >= targetRatio) return suggested;

      // 如果仍不够，返回白色
      return Colors.white;
    } else {
      // 背景较亮，尝试黑色系
      suggested = _adjustColorBrightness(original, 0.0);
      currentRatio = calculateContrast(suggested, background);
      if (currentRatio >= targetRatio) return suggested;

      // 如果仍不够，返回黑色
      return Colors.black;
    }
  }

  /// 调整颜色亮度
  static Color _adjustColorBrightness(Color color, double targetBrightness) {
    final hslColor = HSLColor.fromColor(color);
    return hslColor.withLightness(targetBrightness).toColor();
  }

  /// 生成对比度审计报告
  static String generateAuditReport(List<ContrastIssue> issues) {
    if (issues.isEmpty) {
      return '✅ 恭喜！所有颜色组合都符合WCAG 2.1 AA标准。';
    }

    final critical = issues.where((i) => i.severity == IssueSeverity.critical).toList();
    final high = issues.where((i) => i.severity == IssueSeverity.high).toList();
    final medium = issues.where((i) => i.severity == IssueSeverity.medium).toList();

    final buffer = StringBuffer();
    buffer.writeln('# WCAG 2.1 AA 颜色对比度审计报告\n');
    buffer.writeln('总计发现 ${issues.length} 个问题\n');
    buffer.writeln('- 🔴 严重 (对比度 < 3:1): ${critical.length}');
    buffer.writeln('- 🟠 高 (对比度 3:1-4.5:1): ${high.length}');
    buffer.writeln('- 🟡 中 (对比度 4.5:1-7:1): ${medium.length}\n');

    if (critical.isNotEmpty) {
      buffer.writeln('## 🔴 严重问题 (必须立即修复)\n');
      for (final issue in critical) {
        buffer.writeln(issue.toString());
        buffer.writeln();
      }
    }

    if (high.isNotEmpty) {
      buffer.writeln('## 🟠 高优先级问题\n');
      for (final issue in high) {
        buffer.writeln(issue.toString());
        buffer.writeln();
      }
    }

    if (medium.isNotEmpty) {
      buffer.writeln('## 🟡 中优先级问题\n');
      for (final issue in medium) {
        buffer.writeln(issue.toString());
        buffer.writeln();
      }
    }

    return buffer.toString();
  }
}

/// 对比度检查结果
class ContrastResult {
  final double ratio;
  final Color foreground;
  final Color background;
  final bool isLargeText;
  final bool isGraphics;

  ContrastResult({
    required this.ratio,
    required this.foreground,
    required this.background,
    this.isLargeText = false,
    this.isGraphics = false,
  });

  /// 是否通过WCAG AA标准
  bool get passesAA {
    if (isGraphics) {
      return ratio >= ContrastChecker.wcagAAGraphics;
    }
    return isLargeText
        ? ratio >= ContrastChecker.wcagAALargeText
        : ratio >= ContrastChecker.wcagAANormalText;
  }

  /// 是否通过WCAG AAA标准
  bool get passesAAA {
    return isLargeText
        ? ratio >= ContrastChecker.wcagAAALargeText
        : ratio >= ContrastChecker.wcagAAANormalText;
  }

  /// 获取等级评价
  String get grade {
    if (passesAAA) return 'AAA';
    if (passesAA) return 'AA';
    return 'Fail';
  }

  /// 格式化对比度值
  String get ratioFormatted => '${ratio.toStringAsFixed(2)}:1';

  @override
  String toString() {
    return 'Contrast: $ratioFormatted ($grade)';
  }
}

/// 对比度问题
class ContrastIssue {
  final String location; // 文件路径和行号
  final String description; // 问题描述
  final Color foreground;
  final Color background;
  final double currentRatio;
  final double requiredRatio;
  final IssueSeverity severity;
  final String suggestedFix; // 修复建议

  ContrastIssue({
    required this.location,
    required this.description,
    required this.foreground,
    required this.background,
    required this.currentRatio,
    required this.requiredRatio,
    required this.severity,
    required this.suggestedFix,
  });

  String get foregroundHex => '#${foreground.value.toRadixString(16).substring(2).toUpperCase()}';
  String get backgroundHex => '#${background.value.toRadixString(16).substring(2).toUpperCase()}';

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('### $description');
    buffer.writeln('**位置**: `$location`');
    buffer.writeln('**前景色**: $foregroundHex');
    buffer.writeln('**背景色**: $backgroundHex');
    buffer.writeln('**当前对比度**: ${currentRatio.toStringAsFixed(2)}:1');
    buffer.writeln('**要求对比度**: ${requiredRatio.toStringAsFixed(1)}:1');
    buffer.writeln('**修复建议**: $suggestedFix');
    return buffer.toString();
  }
}

/// 问题严重程度
enum IssueSeverity {
  critical, // 对比度 < 3:1
  high, // 对比度 3:1-4.5:1
  medium, // 对比度 4.5:1-7:1 (不满足AAA)
}

/// 扩展IssueSeverity以获取严重程度
extension IssueSeverityX on IssueSeverity {
  String get label {
    switch (this) {
      case IssueSeverity.critical:
        return '严重';
      case IssueSeverity.high:
        return '高';
      case IssueSeverity.medium:
        return '中';
    }
  }
}
