import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/src/core/accessibility/contrast_auditor.dart';
import 'package:todolist/src/core/accessibility/contrast_checker.dart';
import 'package:todolist/src/core/design/gamification_colors.dart';

/// WCAG 2.1 AA对比度测试套件
/// 确保所有颜色组合符合无障碍标准
void main() {
  group('WCAG 2.1 AA 对比度测试', () {
    testWidgets('游戏化颜色系统对比度测试 - 亮色主题', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          home: Builder(
            builder: (context) {
              final issues = ContrastAuditor.auditAllColors(context);

              // 打印所有问题
              if (issues.isNotEmpty) {
                debugPrint('\n发现 ${issues.length} 个对比度问题:\n');
                for (final issue in issues) {
                  debugPrint(issue.toString());
                }
              }

              // 断言：不应有严重或高优先级问题
              final criticalIssues = issues.where((i) => i.severity == IssueSeverity.critical).toList();
              final highIssues = issues.where((i) => i.severity == IssueSeverity.high).toList();

              expect(
                criticalIssues,
                isEmpty,
                reason: '发现 ${criticalIssues.length} 个严重对比度问题（对比度 < 3:1）',
              );

              expect(
                highIssues,
                isEmpty,
                reason: '发现 ${highIssues.length} 个高优先级对比度问题（对比度 < 4.5:1）',
              );

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('游戏化颜色系统对比度测试 - 暗色主题', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(useMaterial3: true),
          home: Builder(
            builder: (context) {
              final issues = ContrastAuditor.auditAllColors(context);

              if (issues.isNotEmpty) {
                debugPrint('\n暗色主题发现 ${issues.length} 个对比度问题:\n');
                for (final issue in issues) {
                  debugPrint(issue.toString());
                }
              }

              final criticalIssues = issues.where((i) => i.severity == IssueSeverity.critical).toList();
              final highIssues = issues.where((i) => i.severity == IssueSeverity.high).toList();

              expect(
                criticalIssues,
                isEmpty,
                reason: '暗色主题发现 ${criticalIssues.length} 个严重对比度问题',
              );

              expect(
                highIssues,
                isEmpty,
                reason: '暗色主题发现 ${highIssues.length} 个高优先级对比度问题',
              );

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('Alpha透明度颜色对比度测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          home: Builder(
            builder: (context) {
              final issues = ContrastAuditor.auditAlphaColors(Theme.of(context).colorScheme);

              if (issues.isNotEmpty) {
                debugPrint('\n发现 ${issues.length} 个Alpha透明度对比度问题:\n');
                for (final issue in issues) {
                  debugPrint(issue.toString());
                }
              }

              // Alpha透明度可能会有一些中等优先级问题，但不应有严重问题
              final criticalIssues = issues.where((i) => i.severity == IssueSeverity.critical).toList();

              expect(
                criticalIssues,
                isEmpty,
                reason: '发现 ${criticalIssues.length} 个严重的Alpha透明度对比度问题',
              );

              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('对比度计算准确性测试', () {
      // 测试已知的对比度值
      const white = Colors.white;
      const black = Colors.black;

      // 白色与黑色的对比度应该是21:1
      final whiteBlackRatio = ContrastChecker.calculateContrast(white, black);
      expect(whiteBlackRatio, closeTo(21.0, 0.1));

      // 相同颜色的对比度应该是1:1
      final sameColorRatio = ContrastChecker.calculateContrast(white, white);
      expect(sameColorRatio, closeTo(1.0, 0.1));

      // 测试修复后的游戏化颜色组合
      // Blue 800 (修复后的蓝色) - 应满足AA正常文字标准
      final blueOnWhite = ContrastChecker.calculateContrast(
        const Color(0xFF1565C0), // 修复后的蓝色
        Colors.white,
      );
      expect(blueOnWhite, greaterThanOrEqualTo(4.5)); // AA正常文字: 4.5:1

      // Green 800 (修复后的绿色) - 应满足AA正常文字标准
      final greenOnWhite = ContrastChecker.calculateContrast(
        const Color(0xFF2E7D32), // 修复后的绿色
        Colors.white,
      );
      expect(greenOnWhite, greaterThanOrEqualTo(4.5)); // AA正常文字: 4.5:1
    });

    test('WCAG标准检查测试', () {
      const white = Colors.white;
      const black = Colors.black;

      // 白底黑字应该通过所有标准
      expect(ContrastChecker.meetsWCAGAANormal(black, white), isTrue);
      expect(ContrastChecker.meetsWCAGAALarge(black, white), isTrue);
      expect(ContrastChecker.meetsWCAGAAANormal(black, white), isTrue);

      // 测试边界情况
      final lightGray = Colors.grey[400]!;
      final darkGray = Colors.grey[800]!;

      final ratio = ContrastChecker.calculateContrast(lightGray, darkGray);
      debugPrint('浅灰与深灰对比度: ${ratio.toStringAsFixed(2)}:1');
    });

    testWidgets('生成完整审计报告', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          home: Builder(
            builder: (context) {
              final report = ContrastAuditor.generateFullReport(context);
              debugPrint('\n' + '=' * 80);
              debugPrint(report);
              debugPrint('=' * 80 + '\n');

              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('颜色建议算法测试', () {
      // 测试浅色背景上的颜色建议
      final lightBackground = Colors.grey[200]!;
      final poorColor = Colors.grey[400]!;

      final suggested = ContrastChecker.suggestForegroundColor(
        poorColor,
        lightBackground,
      );

      final newRatio = ContrastChecker.calculateContrast(suggested, lightBackground);
      debugPrint('原始对比度: ${ContrastChecker.calculateContrast(poorColor, lightBackground).toStringAsFixed(2)}:1');
      debugPrint('建议后对比度: ${newRatio.toStringAsFixed(2)}:1');

      expect(newRatio, greaterThanOrEqualTo(ContrastChecker.wcagAANormalText));
    });

    testWidgets('统计卡片颜色对比度测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          home: Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;
              final surface = colorScheme.surface;

              final statColors = [
                ('完成任务绿', StatCardColors.tasksCompleted),
                ('连续打卡橙', StatCardColors.currentStreak),
                ('专注时长蓝', StatCardColors.focusTime),
                ('最长连续紫', StatCardColors.longestStreak),
              ];

              debugPrint('\n统计卡片颜色对比度测试:');
              for (final (name, color) in statColors) {
                final ratio = ContrastChecker.calculateContrast(color, surface);
                final passes = ratio >= ContrastChecker.wcagAALargeText;
                debugPrint('$name: ${ratio.toStringAsFixed(2)}:1 ${passes ? '✅' : '❌'}');

                // 统计卡片使用大文字，应满足3:1
                expect(
                  passes,
                  isTrue,
                  reason: '$name 对比度不足（${ratio.toStringAsFixed(2)}:1 < 3:1）',
                );
              }

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('稀有度颜色对比度测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          home: Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;
              final surface = colorScheme.surface;

              final rarityColors = [
                ('普通', colorScheme.rarityCommon),
                ('罕见', colorScheme.rarityUncommon),
                ('稀有', colorScheme.rarityRare),
                ('史诗', colorScheme.rarityEpic),
                ('传说', colorScheme.rarityLegendary),
              ];

              debugPrint('\n稀有度颜色对比度测试:');
              for (final (name, color) in rarityColors) {
                final ratio = ContrastChecker.calculateContrast(color, surface);
                final passes = ratio >= ContrastChecker.wcagAANormalText;
                debugPrint('$name: ${ratio.toStringAsFixed(2)}:1 ${passes ? '✅' : '❌'}');

                expect(
                  passes,
                  isTrue,
                  reason: '稀有度[$name]对比度不足（${ratio.toStringAsFixed(2)}:1 < 4.5:1）',
                );
              }

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('状态颜色对比度测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          home: Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;
              final surface = colorScheme.surface;

              final statusColors = [
                ('完成', colorScheme.completedColor),
                ('进行中', colorScheme.inProgressColor),
                ('未开始', colorScheme.notStartedColor),
              ];

              debugPrint('\n状态颜色对比度测试:');
              for (final (name, color) in statusColors) {
                final ratio = ContrastChecker.calculateContrast(color, surface);
                final passes = ratio >= ContrastChecker.wcagAANormalText;
                debugPrint('$name: ${ratio.toStringAsFixed(2)}:1 ${passes ? '✅' : '❌'}');

                expect(
                  passes,
                  isTrue,
                  reason: '状态[$name]对比度不足（${ratio.toStringAsFixed(2)}:1 < 4.5:1）',
                );
              }

              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
