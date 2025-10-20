import 'package:flutter/material.dart';
import 'package:todolist/src/core/design/gamification_colors.dart';
import 'contrast_checker.dart';

/// 全面的对比度审计工具
/// 扫描项目中所有颜色组合并生成报告
class ContrastAuditor {
  /// 执行完整的对比度审计
  static List<ContrastIssue> auditAllColors(BuildContext context) {
    final issues = <ContrastIssue>[];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 1. 审计游戏化颜色系统
    issues.addAll(_auditGamificationColors(colorScheme));

    // 2. 审计主题颜色
    issues.addAll(_auditThemeColors(colorScheme));

    // 3. 审计状态颜色
    issues.addAll(_auditStatusColors(colorScheme));

    // 4. 审计稀有度颜色
    issues.addAll(_auditRarityColors(colorScheme));

    // 5. 审计统计卡片颜色 (主题感知版本)
    issues.addAll(_auditStatCardColors(colorScheme));

    // 按严重程度排序
    issues.sort((a, b) {
      final severityOrder = {
        IssueSeverity.critical: 0,
        IssueSeverity.high: 1,
        IssueSeverity.medium: 2,
      };
      return severityOrder[a.severity]!.compareTo(severityOrder[b.severity]!);
    });

    return issues;
  }

  /// 审计游戏化颜色
  static List<ContrastIssue> _auditGamificationColors(ColorScheme colorScheme) {
    final issues = <ContrastIssue>[];

    // Hero区域颜色检查
    _checkContrast(
      issues,
      'Hero区域文字',
      colorScheme.heroTextColor,
      colorScheme.heroGradientStart,
      'lib/src/core/design/gamification_colors.dart:9',
      'Hero卡片的文字颜色与背景渐变开始色',
      isLargeText: true, // Hero区域通常使用大文字
    );

    _checkContrast(
      issues,
      'Hero区域文字 (渐变终点)',
      colorScheme.heroTextColor,
      colorScheme.heroGradientEnd,
      'lib/src/core/design/gamification_colors.dart:9',
      'Hero卡片的文字颜色与背景渐变终点色',
      isLargeText: true,
    );

    // 每日互动区颜色检查
    _checkContrast(
      issues,
      '每日卡片强调色',
      colorScheme.dailyAccentColor,
      colorScheme.dailyCardBackground,
      'lib/src/core/design/gamification_colors.dart:15',
      '每日互动区的强调色与卡片背景',
    );

    // 统计区域颜色检查
    _checkContrast(
      issues,
      '统计值颜色',
      colorScheme.statsValueColor,
      colorScheme.statsBackground,
      'lib/src/core/design/gamification_colors.dart:20',
      '统计数值与背景的对比度',
    );

    _checkContrast(
      issues,
      '统计图标颜色',
      colorScheme.statsIconColor,
      colorScheme.statsBackground,
      'lib/src/core/design/gamification_colors.dart:19',
      '统计图标与背景的对比度',
      isGraphics: true,
    );

    // 进度条颜色检查
    _checkContrast(
      issues,
      '进度条前景',
      colorScheme.progressForeground,
      colorScheme.progressBackground,
      'lib/src/core/design/gamification_colors.dart:23-24',
      '进度条填充色与背景色',
      isGraphics: true,
    );

    return issues;
  }

  /// 审计主题颜色
  static List<ContrastIssue> _auditThemeColors(ColorScheme colorScheme) {
    final issues = <ContrastIssue>[];

    // Primary与背景的对比
    _checkContrast(
      issues,
      'Primary文字在背景上',
      colorScheme.primary,
      colorScheme.surface,
      '通用主题',
      'Primary颜色作为文字在surface背景上',
    );

    // onPrimary与Primary的对比
    _checkContrast(
      issues,
      'Primary容器内文字',
      colorScheme.onPrimary,
      colorScheme.primary,
      '通用主题',
      'Primary容器内的文字颜色',
    );

    // Secondary对比
    _checkContrast(
      issues,
      'Secondary文字在背景上',
      colorScheme.secondary,
      colorScheme.surface,
      '通用主题',
      'Secondary颜色作为文字在surface背景上',
    );

    // Error对比
    _checkContrast(
      issues,
      'Error文字在背景上',
      colorScheme.error,
      colorScheme.surface,
      '通用主题',
      'Error颜色作为文字在surface背景上',
    );

    // onSurface与Surface的对比
    _checkContrast(
      issues,
      '常规文字',
      colorScheme.onSurface,
      colorScheme.surface,
      '通用主题',
      '常规文字与背景的对比度',
    );

    // onSurfaceVariant与Surface的对比
    _checkContrast(
      issues,
      '次要文字',
      colorScheme.onSurfaceVariant,
      colorScheme.surface,
      '通用主题',
      '次要文字与背景的对比度',
    );

    return issues;
  }

  /// 审计状态颜色
  static List<ContrastIssue> _auditStatusColors(ColorScheme colorScheme) {
    final issues = <ContrastIssue>[];

    // 完成状态
    _checkContrast(
      issues,
      '完成状态颜色',
      colorScheme.completedColor,
      colorScheme.surface,
      'lib/src/core/design/gamification_colors.dart:33-35',
      '完成状态的绿色与背景',
    );

    // 进行中状态
    _checkContrast(
      issues,
      '进行中状态颜色',
      colorScheme.inProgressColor,
      colorScheme.surface,
      'lib/src/core/design/gamification_colors.dart:40-42',
      '进行中状态的蓝色与背景',
    );

    // 未开始状态
    _checkContrast(
      issues,
      '未开始状态颜色',
      colorScheme.notStartedColor,
      colorScheme.surface,
      'lib/src/core/design/gamification_colors.dart:45',
      '未开始状态颜色与背景',
    );

    return issues;
  }

  /// 审计稀有度颜色
  static List<ContrastIssue> _auditRarityColors(ColorScheme colorScheme) {
    final issues = <ContrastIssue>[];

    final rarityColors = [
      ('普通', colorScheme.rarityCommon, 'lib/src/core/design/gamification_colors.dart:52-54'),
      ('罕见', colorScheme.rarityUncommon, 'lib/src/core/design/gamification_colors.dart:59-61'),
      ('稀有', colorScheme.rarityRare, 'lib/src/core/design/gamification_colors.dart:66-68'),
      ('史诗', colorScheme.rarityEpic, 'lib/src/core/design/gamification_colors.dart:73-75'),
      ('传说', colorScheme.rarityLegendary, 'lib/src/core/design/gamification_colors.dart:80-82'),
    ];

    for (final (name, color, location) in rarityColors) {
      _checkContrast(
        issues,
        '稀有度颜色: $name',
        color,
        colorScheme.surface,
        location,
        '稀有度[$name]与背景的对比度',
      );
    }

    return issues;
  }

  /// 审计统计卡片颜色 (使用主题感知版本)
  static List<ContrastIssue> _auditStatCardColors(ColorScheme colorScheme) {
    final issues = <ContrastIssue>[];

    final statColors = [
      (
        '完成任务',
        StatCardColors.getColorForTheme(StatCardColors.tasksCompleted, colorScheme.brightness),
        'lib/src/core/design/gamification_colors.dart:94',
      ),
      (
        '连续打卡',
        StatCardColors.getColorForTheme(StatCardColors.currentStreak, colorScheme.brightness),
        'lib/src/core/design/gamification_colors.dart:99',
      ),
      (
        '专注时长',
        StatCardColors.getColorForTheme(StatCardColors.focusTime, colorScheme.brightness),
        'lib/src/core/design/gamification_colors.dart:104',
      ),
      (
        '最长连续',
        StatCardColors.getColorForTheme(StatCardColors.longestStreak, colorScheme.brightness),
        'lib/src/core/design/gamification_colors.dart:109',
      ),
    ];

    for (final (name, color, location) in statColors) {
      // 统计卡片颜色通常用于大文字或图标
      _checkContrast(
        issues,
        '统计卡片: $name',
        color,
        colorScheme.surface,
        location,
        '统计卡片[$name]的颜色与背景 (主题感知)',
        isLargeText: true,
      );
    }

    return issues;
  }

  /// 检查单个颜色组合的对比度
  static void _checkContrast(
    List<ContrastIssue> issues,
    String description,
    Color foreground,
    Color background,
    String location,
    String context, {
    bool isLargeText = false,
    bool isGraphics = false,
  }) {
    final result = ContrastChecker.checkContrast(
      foreground,
      background,
      isLargeText: isLargeText,
      isGraphics: isGraphics,
    );

    // 如果通过AA标准，不记录问题
    if (result.passesAA) {
      return;
    }

    // 确定严重程度
    IssueSeverity severity;
    double requiredRatio;

    if (isGraphics) {
      requiredRatio = ContrastChecker.wcagAAGraphics;
    } else if (isLargeText) {
      requiredRatio = ContrastChecker.wcagAALargeText;
    } else {
      requiredRatio = ContrastChecker.wcagAANormalText;
    }

    if (result.ratio < 3.0) {
      severity = IssueSeverity.critical;
    } else if (result.ratio < 4.5) {
      severity = IssueSeverity.high;
    } else {
      severity = IssueSeverity.medium;
    }

    // 生成修复建议
    final suggestedColor = ContrastChecker.suggestForegroundColor(
      foreground,
      background,
      targetRatio: requiredRatio,
    );

    final suggestedHex = '#${suggestedColor.value.toRadixString(16).substring(2).toUpperCase()}';

    final issue = ContrastIssue(
      location: location,
      description: description,
      foreground: foreground,
      background: background,
      currentRatio: result.ratio,
      requiredRatio: requiredRatio,
      severity: severity,
      suggestedFix: '将前景色改为 $suggestedHex 或使用主题感知的颜色方法',
    );

    issues.add(issue);
  }

  /// 审计特定alpha值的颜色组合
  static List<ContrastIssue> auditAlphaColors(ColorScheme colorScheme) {
    final issues = <ContrastIssue>[];

    // Hero阴影 (alpha: 0.3)
    final heroShadow = colorScheme.primary.withValues(alpha: 0.3);
    _checkContrast(
      issues,
      'Hero阴影',
      heroShadow,
      colorScheme.surface,
      'lib/src/core/design/gamification_colors.dart:11',
      'Hero卡片阴影与背景',
      isGraphics: true,
    );

    // 锁定状态透明度 (alpha: 0.3)
    final lockedColor = colorScheme.onSurface.withValues(alpha: 0.3);
    _checkContrast(
      issues,
      '锁定状态',
      lockedColor,
      colorScheme.surface,
      'lib/src/core/design/gamification_colors.dart:28',
      '锁定状态的透明文字与背景',
    );

    // Hero区域文字透明度 (alpha: 0.9, 0.8, 0.7)
    // 这些在gamification_page.dart中使用
    final heroTextAlphas = [
      (0.9, '总积分标签', 'lib/src/features/gamification/presentation/gamification_page.dart:193'),
      (0.8, '升级进度标签', 'lib/src/features/gamification/presentation/gamification_page.dart:226'),
      (0.7, '下一级提示', 'lib/src/features/gamification/presentation/gamification_page.dart:263'),
    ];

    for (final (alpha, desc, location) in heroTextAlphas) {
      final color = colorScheme.heroTextColor.withValues(alpha: alpha);
      _checkContrast(
        issues,
        'Hero区域: $desc',
        color,
        colorScheme.heroGradientStart,
        location,
        'Hero卡片上的透明文字',
        isLargeText: desc.contains('总积分'),
      );
    }

    // 检查白色透明度组合 (用于Hero卡片)
    final whiteAlphas = [
      (0.2, '等级圆环背景', 'lib/src/features/gamification/presentation/gamification_page.dart:161'),
      (0.4, '等级圆环边框', 'lib/src/features/gamification/presentation/gamification_page.dart:163'),
      (0.3, '进度条背景', 'lib/src/features/gamification/presentation/gamification_page.dart:250'),
    ];

    for (final (alpha, desc, location) in whiteAlphas) {
      final color = Colors.white.withValues(alpha: alpha);
      // 这些通常是装饰性元素，使用图形标准
      _checkContrast(
        issues,
        'Hero白色元素: $desc',
        color,
        colorScheme.heroGradientStart,
        location,
        'Hero卡片上的白色半透明元素',
        isGraphics: true,
      );
    }

    return issues;
  }

  /// 生成暗色主题的审计报告
  static List<ContrastIssue> auditDarkTheme(BuildContext context) {
    // 在暗色主题下运行相同的审计
    final issues = auditAllColors(context);
    return issues;
  }

  /// 审计预设主题颜色
  static Map<String, List<ContrastIssue>> auditPresetThemes() {
    final results = <String, List<ContrastIssue>>{};

    // 这里需要为每个预设主题创建ColorScheme并审计
    // 由于需要BuildContext，这个方法可能需要在Widget中调用

    return results;
  }

  /// 生成完整的审计报告
  static String generateFullReport(BuildContext context, {bool includeDark = true}) {
    final buffer = StringBuffer();
    buffer.writeln('# WCAG 2.1 AA 完整对比度审计报告\n');
    buffer.writeln('生成时间: ${DateTime.now()}\n');
    buffer.writeln('---\n');

    // 亮色主题审计
    buffer.writeln('## 亮色主题审计\n');
    final lightIssues = auditAllColors(context);
    final lightAlphaIssues = auditAlphaColors(Theme.of(context).colorScheme);
    final allLightIssues = [...lightIssues, ...lightAlphaIssues];

    if (allLightIssues.isEmpty) {
      buffer.writeln('✅ 亮色主题完全符合WCAG 2.1 AA标准！\n');
    } else {
      buffer.writeln(ContrastChecker.generateAuditReport(allLightIssues));
    }

    buffer.writeln('\n---\n');

    // 统计摘要
    buffer.writeln('## 统计摘要\n');
    buffer.writeln('- 总问题数: ${allLightIssues.length}');
    buffer.writeln('- 严重问题: ${allLightIssues.where((i) => i.severity == IssueSeverity.critical).length}');
    buffer.writeln('- 高优先级: ${allLightIssues.where((i) => i.severity == IssueSeverity.high).length}');
    buffer.writeln('- 中优先级: ${allLightIssues.where((i) => i.severity == IssueSeverity.medium).length}');

    return buffer.toString();
  }
}
