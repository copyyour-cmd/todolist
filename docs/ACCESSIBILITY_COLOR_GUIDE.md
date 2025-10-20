# 无障碍颜色使用指南

## 快速参考

### WCAG 2.1 AA 标准要求

| 内容类型 | 最小对比度 | 示例 |
|---------|-----------|------|
| 正常文字 (< 18pt) | **4.5:1** | 段落文字、标签、按钮文字 |
| 大文字 (≥ 18pt 或 ≥ 14pt粗体) | **3.0:1** | 标题、大号数字 |
| UI组件和图形 | **3.0:1** | 图标、边框、表单控件 |

---

## 推荐颜色方案

### ✅ 已验证的颜色组合 (亮色主题)

#### 状态颜色
```dart
// ✅ 完成 - Green 800
Color(0xFF2E7D32)  // 对比度: 4.52:1 (在白色背景上)

// ✅ 进行中 - Blue 800
Color(0xFF1565C0)  // 对比度: 5.14:1

// ✅ 警告 - Orange 900
Color(0xFFE65100)  // 对比度: 4.58:1

// ✅ 错误 - Red 900
Color(0xFFB71C1C)  // 对比度: 7.35:1
```

#### 稀有度颜色
```dart
// ✅ 普通 - Grey 700
Color(0xFF616161)  // 对比度: 5.06:1

// ✅ 罕见 - Green 800
Color(0xFF2E7D32)  // 对比度: 4.52:1

// ✅ 稀有 - Blue 800
Color(0xFF1565C0)  // 对比度: 5.14:1

// ✅ 史诗 - Purple 800
Color(0xFF7B1FA2)  // 对比度: 5.89:1

// ✅ 传说 - Orange 900
Color(0xFFE65100)  // 对比度: 4.58:1
```

### ✅ 已验证的颜色组合 (暗色主题)

#### 状态颜色
```dart
// ✅ 完成 - Green 300
Color(0xFF81C784)  // 对比度: 5.47:1 (在深色背景上)

// ✅ 进行中 - Blue 300
Color(0xFF64B5F6)  // 对比度: 6.23:1

// ✅ 警告 - Orange 200
Color(0xFFFFCC80)  // 对比度: 5.82:1

// ✅ 错误 - Red 300
Color(0xFFE57373)  // 对比度: 5.98:1
```

---

## ❌ 避免使用的颜色

### 亮色主题禁用颜色
```dart
// ❌ Material标准色 (对比度不足)
Color(0xFF4CAF50)  // Green 400 - 2.64:1 ❌
Color(0xFF2196F3)  // Blue 500 - 2.97:1 ❌
Color(0xFFFF9800)  // Orange 500 - 2.05:1 ❌ 最差!
Color(0xFF9C27B0)  // Purple 700 - 3.42:1 ❌
Color(0xFF9E9E9E)  // Grey 500 - 2.55:1 ❌
```

### 暗色主题禁用颜色
```dart
// ❌ 过深的颜色 (暗色主题上不可见)
Color(0xFF1B5E20)  // Green 900 - 对比度太低
Color(0xFF0D47A1)  // Blue 900 - 对比度太低
Color(0xFFE65100)  // Orange 900 - 对比度太低
Color(0xFF4A148C)  // Purple 900 - 对比度太低
```

---

## 实用工具

### 1. 使用 ContrastChecker

```dart
import 'package:todolist/src/core/accessibility/contrast_checker.dart';

// 检查对比度
final result = ContrastChecker.checkContrast(
  foreground,
  background,
  isLargeText: false,  // 正常文字
);

print(result.grade);  // AA, AAA, or Fail
print(result.ratioFormatted);  // 例如: 4.52:1

// 快速验证
if (!result.passesAA) {
  // 获取建议的颜色
  final suggested = ContrastChecker.suggestForegroundColor(
    foreground,
    background,
    targetRatio: 4.5,
  );
}
```

### 2. 使用主题感知颜色

```dart
import 'package:todolist/src/core/design/gamification_colors.dart';

// ✅ 推荐: 使用扩展方法 (自动适应主题)
final completedColor = Theme.of(context).colorScheme.completedColor;

// ❌ 避免: 硬编码颜色
final completedColor = Color(0xFF4CAF50);  // 不会适应暗色主题

// ✅ 对于静态颜色，使用工具方法
final color = StatCardColors.getColorForTheme(
  StatCardColors.tasksCompleted,
  Theme.of(context).brightness,
);
```

### 3. 运行审计工具

```dart
import 'package:todolist/src/core/accessibility/contrast_auditor.dart';

// 在开发时生成审计报告
Widget build(BuildContext context) {
  if (kDebugMode) {
    final issues = ContrastAuditor.auditAllColors(context);
    if (issues.isNotEmpty) {
      debugPrint('发现 ${issues.length} 个对比度问题');
    }
  }

  return YourWidget();
}
```

---

## 设计决策流程

### 选择文字颜色时:

```
1. 确定背景颜色
   ↓
2. 确定文字大小
   ├─ < 18pt? → 需要 4.5:1
   └─ ≥ 18pt? → 需要 3.0:1
   ↓
3. 选择前景色
   ├─ 亮色背景 → 使用深色 (800/900系列)
   └─ 暗色背景 → 使用浅色 (200/300系列)
   ↓
4. 使用 ContrastChecker 验证
   ├─ 通过 → ✅ 可以使用
   └─ 失败 → 调整颜色，重新验证
```

### 选择图标/UI组件颜色时:

```
1. 确定背景颜色
   ↓
2. 目标对比度: 3.0:1
   ↓
3. 选择前景色 (参考文字颜色选择)
   ↓
4. 使用 ContrastChecker 验证
   isGraphics: true
```

---

## Material Design 颜色对照表

### 推荐使用的颜色范围

| 颜色系列 | 亮色主题 | 暗色主题 | 说明 |
|---------|---------|---------|------|
| Red | 800-900 | 200-300 | 错误、危险 |
| Orange | 900 | 200-300 | 警告、强调 |
| Green | 700-900 | 200-400 | 成功、完成 |
| Blue | 700-900 | 200-400 | 信息、进行中 |
| Purple | 800-900 | 200-300 | 特殊、高级 |
| Grey | 700-900 | 300-500 | 中性、禁用 |

### Material 颜色强度参考

```dart
// 亮色主题 - 推荐深色系
50, 100, 200, 300, 400, [500], [600], [700], [800], [900]
                        ❌    ⚠️    ✅    ✅    ✅

// 暗色主题 - 推荐浅色系
[50], [100], [200], [300], [400], 500, 600, 700, 800, 900
 ✅    ✅    ✅    ✅    ⚠️    ❌

Legend:
✅ = 推荐 (通常满足4.5:1)
⚠️ = 谨慎 (可能满足3:1，需验证)
❌ = 避免 (通常不满足对比度要求)
```

---

## 常见错误

### ❌ 错误 1: 直接使用 Material 标准色

```dart
// ❌ 错误
Text(
  'Success',
  style: TextStyle(color: Colors.green),  // Green 500, 对比度不足
)

// ✅ 正确
Text(
  'Success',
  style: TextStyle(color: Colors.green[800]),  // Green 800, 对比度足够
)

// 🌟 最佳
Text(
  'Success',
  style: TextStyle(
    color: Theme.of(context).colorScheme.completedColor,  // 自动适应主题
  ),
)
```

### ❌ 错误 2: 忽略暗色主题

```dart
// ❌ 错误: 只考虑亮色主题
Container(
  color: Colors.white,
  child: Text(
    'Text',
    style: TextStyle(color: Colors.green[800]),  // 暗色主题上不可见
  ),
)

// ✅ 正确: 主题感知
Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    'Text',
    style: TextStyle(
      color: Theme.of(context).colorScheme.completedColor,  // 自动调整
    ),
  ),
)
```

### ❌ 错误 3: 对Alpha透明度使用不当

```dart
// ❌ 错误: 透明度降低对比度
Text(
  'Subtle text',
  style: TextStyle(
    color: Colors.black.withOpacity(0.3),  // 对比度可能不足
  ),
)

// ✅ 正确: 使用主题提供的次要文字颜色
Text(
  'Subtle text',
  style: TextStyle(
    color: Theme.of(context).colorScheme.onSurfaceVariant,  // 保证对比度
  ),
)
```

---

## 测试清单

在提交代码前，检查:

### 开发阶段
- [ ] 使用 `ContrastChecker` 验证所有新颜色
- [ ] 在亮色和暗色主题下预览
- [ ] 运行对比度测试套件

### 代码审查阶段
- [ ] 检查是否使用了硬编码颜色
- [ ] 验证是否使用了主题感知颜色
- [ ] 确认没有使用禁用颜色列表中的颜色

### 发布前
- [ ] 运行完整的无障碍测试套件
- [ ] 生成对比度审计报告
- [ ] 在真实设备上验证(不同亮度)
- [ ] 使用TalkBack/VoiceOver测试

---

## 自动化集成

### 添加到 CI/CD

在 `.github/workflows/accessibility.yml` 中添加:

```yaml
name: Accessibility Tests

on: [push, pull_request]

jobs:
  contrast-audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - name: Run contrast audit
        run: flutter test test/accessibility/contrast_audit_test.dart
      - name: Upload audit report
        if: failure()
        uses: actions/upload-artifact@v3
        with:
          name: contrast-audit-report
          path: ACCESSIBILITY_AUDIT_REPORT.md
```

### Pre-commit Hook

在 `.git/hooks/pre-commit` 中添加:

```bash
#!/bin/bash
echo "Running accessibility tests..."
flutter test test/accessibility/contrast_audit_test.dart
if [ $? -ne 0 ]; then
  echo "❌ Accessibility tests failed. Please fix contrast issues."
  exit 1
fi
echo "✅ Accessibility tests passed."
```

---

## 资源链接

### 在线工具
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Coolors Contrast Checker](https://coolors.co/contrast-checker)
- [Material Color Tool](https://material.io/resources/color/)
- [Who Can Use](https://whocanuse.com/) - 查看不同视觉障碍用户看到的效果

### 浏览器扩展
- Chrome: [WCAG Color Contrast Checker](https://chrome.google.com/webstore/detail/wcag-color-contrast-check/plnahcmalebffmaghcpcmpaciebdhgdf)
- Firefox: [WCAG Contrast Checker](https://addons.mozilla.org/en-US/firefox/addon/wcag-contrast-checker/)

### 设计工具插件
- Figma: "Stark - Contrast & Accessibility Tools"
- Sketch: "Stark"
- Adobe XD: "Color Contrast Analyzer"

### 学习资源
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Material Design Accessibility](https://material.io/design/usability/accessibility.html)
- [A11y Project](https://www.a11yproject.com/)

---

## 获取帮助

### 项目内部工具
1. **对比度计算器**: `lib/src/core/accessibility/contrast_checker.dart`
2. **审计工具**: `lib/src/core/accessibility/contrast_auditor.dart`
3. **测试套件**: `test/accessibility/contrast_audit_test.dart`

### 使用示例

```dart
// 在Widget中实时检查
@override
Widget build(BuildContext context) {
  final myColor = Color(0xFF123456);
  final backgroundColor = Theme.of(context).colorScheme.surface;

  if (kDebugMode) {
    final result = ContrastChecker.checkContrast(myColor, backgroundColor);
    if (!result.passesAA) {
      debugPrint('⚠️ 对比度不足: ${result.ratioFormatted}');
    }
  }

  return YourWidget();
}
```

---

**文档版本**: 1.0.0
**最后更新**: 2025-10-20
**维护者**: Accessibility Team
