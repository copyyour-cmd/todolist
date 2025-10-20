# 游戏化界面设计快速参考

> 快速查找常用设计值和代码模板

---

## 🎨 间距速查表

| 用途 | 代码 | 值 |
|-----|------|-----|
| 页面边距 | `GamificationSpacing.pageHorizontal` | 24px |
| Section分隔 | `GamificationSpacing.sectionSpacing` | 24px |
| 网格间距 | `GamificationSpacing.gridSpacing` | 16px |
| 标准间距 | `GamificationSpacing.md` | 16px |
| 区块间距 | `GamificationSpacing.lg` | 24px |
| 大区块间距 | `GamificationSpacing.xl` | 32px |
| 小间距 | `GamificationSpacing.sm` | 12px |
| 紧凑间距 | `GamificationSpacing.xs` | 8px |
| 最小间距 | `GamificationSpacing.xxs` | 4px |

---

## 📐 卡片尺寸速查

| 卡片类型 | 代码 | 值 |
|---------|------|-----|
| Hero卡片高度 | `CardDimensions.heroCardHeight` | 160px |
| 每日任务卡片高度 | `CardDimensions.dailyTaskCardMinHeight` | 320px |
| 统计卡片高度 | `CardDimensions.statCardHeight` | 88px |
| Tab内容高度 | `CardDimensions.tabContentHeight` | 440px |
| 统计卡片图标 | `CardDimensions.statCardIconSize` | 32px |

---

## 🔘 圆角速查

| 用途 | 代码 | 值 |
|-----|------|-----|
| Hero区域 | `GamificationSpacing.radiusXLarge` | 24px |
| 强调卡片 | `GamificationSpacing.radiusLarge` | 16px |
| 标准卡片 | `GamificationSpacing.radiusMedium` | 12px |
| 小元素/标签 | `GamificationSpacing.radiusSmall` | 8px |

---

## 💫 阴影速查

| 层级 | 代码 | 用途 |
|-----|------|------|
| 低阴影 | `GamificationElevation.cardShadowLow(context)` | 次要卡片 |
| 中阴影 | `GamificationElevation.cardShadowMedium(context)` | 标准卡片 |
| 高阴影 | `GamificationElevation.cardShadowHigh(context)` | 强调卡片 |
| Hero阴影 | `GamificationElevation.heroShadow(context)` | Hero区域 |

---

## 📏 Padding速查

| 卡片类型 | 代码 | 值 |
|---------|------|-----|
| Hero卡片 | `GamificationSpacing.cardPaddingHero` | 32px |
| 标准卡片 | `GamificationSpacing.cardPaddingStandard` | 24px |
| 紧凑卡片 | `GamificationSpacing.cardPaddingCompact` | 16px |

---

## 🎨 常用代码模板

### Hero卡片模板

```dart
Container(
  height: CardDimensions.heroCardHeight,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        theme.colorScheme.heroGradientStart,
        theme.colorScheme.heroGradientEnd,
      ],
    ),
    borderRadius: BorderRadius.circular(GamificationSpacing.radiusXLarge),
    boxShadow: GamificationElevation.heroShadow(context),
  ),
  padding: EdgeInsets.all(GamificationSpacing.cardPaddingHero),
  child: YourContent(),
)
```

### 标准卡片模板

```dart
Container(
  height: CardDimensions.statCardHeight,
  padding: EdgeInsets.all(GamificationSpacing.md),
  decoration: BoxDecoration(
    color: theme.colorScheme.surface,
    borderRadius: BorderRadius.circular(GamificationSpacing.radiusMedium),
    border: Border.all(
      color: theme.colorScheme.outlineVariant,
      width: 1,
    ),
    boxShadow: GamificationElevation.cardShadowLow(context),
  ),
  child: YourContent(),
)
```

### 等高两列布局

```dart
SizedBox(
  height: CardDimensions.dailyTaskCardMinHeight,
  child: Row(
    children: [
      Expanded(child: LeftCard()),
      SizedBox(width: GamificationSpacing.gridSpacing),
      Expanded(child: RightCard()),
    ],
  ),
)
```

### 2x2网格布局

```dart
Column(
  children: [
    Row(
      children: [
        Expanded(child: Card1()),
        SizedBox(width: GamificationSpacing.gridSpacing),
        Expanded(child: Card2()),
      ],
    ),
    SizedBox(height: GamificationSpacing.gridSpacing),
    Row(
      children: [
        Expanded(child: Card3()),
        SizedBox(width: GamificationSpacing.gridSpacing),
        Expanded(child: Card4()),
      ],
    ),
  ],
)
```

### Section分隔

```dart
Column(
  children: [
    HeroSection(),
    SizedBox(height: GamificationSpacing.sectionSpacing),
    DailyTasksSection(),
    SizedBox(height: GamificationSpacing.sectionSpacing),
    StatsSection(),
  ],
)
```

---

## 🎯 设计检查清单

### 新增卡片时
- [ ] 使用固定高度常量（避免长短不一）
- [ ] 应用正确的圆角值（8/12/16/24px）
- [ ] 选择合适的阴影层级
- [ ] Padding使用标准值（16/24/32px）
- [ ] 间距使用Spacing常量

### 布局调整时
- [ ] 确保间距是8的倍数
- [ ] Section间距统一24px
- [ ] 网格间距统一16px
- [ ] 等宽布局使用Expanded
- [ ] 固定高度使用SizedBox

### 视觉审查时
- [ ] 同级卡片等高
- [ ] 圆角统一
- [ ] 阴影层次清晰
- [ ] 色彩对比度≥4.5:1
- [ ] 触摸目标≥48px

---

## 🔢 关键数值记忆

### 8pt网格
```
4, 8, 12, 16, 24, 32, 48
(xxs, xs, sm, md, lg, xl, xxl)
```

### 卡片高度
```
Hero: 160px
每日任务: 320px
统计: 88px
Tab内容: 440px
```

### 圆角
```
8, 12, 16, 24
(small, medium, large, xlarge)
```

### Padding
```
16, 24, 32
(compact, standard, hero)
```

---

## 🎨 色彩使用

### 品牌色
```dart
theme.colorScheme.primary          // 主色
theme.colorScheme.secondary        // 辅色
theme.colorScheme.tertiary         // 第三色
```

### 语义色
```dart
StatCardColors.tasksCompleted   // #4CAF50 绿色
StatCardColors.currentStreak    // #FF9800 橙色
StatCardColors.focusTime        // #2196F3 蓝色
StatCardColors.longestStreak    // #9C27B0 紫色
```

### Hero区域
```dart
theme.colorScheme.heroGradientStart  // primary
theme.colorScheme.heroGradientEnd    // secondary
theme.colorScheme.heroTextColor      // onPrimary
```

---

## ⏱️ 动画时长

| 动画类型 | 时长 | 曲线 |
|---------|------|------|
| 点击反馈 | 150ms | easeInOut |
| 淡入淡出 | 300ms | easeIn |
| 进度条 | 600ms | easeOutCubic |
| 数字滚动 | 800ms | linear |
| 呼吸动画 | 2000ms | easeInOut |

```dart
// 快速反馈
duration: Duration(milliseconds: 150)

// 内容过渡
duration: Duration(milliseconds: 300)

// 复杂动画
duration: Duration(milliseconds: 600)

// 呼吸效果
duration: Duration(seconds: 2)
```

---

## 📱 响应式断点

```dart
// 紧凑布局（手机竖屏）
if (width < 600) {
  // 单列布局
}

// 中等布局（手机横屏/小平板）
else if (width < 900) {
  // 两列布局
}

// 宽松布局（平板/桌面）
else {
  // 三列或更复杂布局
}
```

---

## 🛠️ 常见问题解决

### 卡片高度不一致
```dart
// ❌ 错误
Row(
  children: [
    Expanded(child: Card1()),  // 高度不等
    Expanded(child: Card2()),
  ],
)

// ✅ 正确
SizedBox(
  height: CardDimensions.dailyTaskCardMinHeight,
  child: Row(
    children: [
      Expanded(child: Card1()),
      SizedBox(width: GamificationSpacing.gridSpacing),
      Expanded(child: Card2()),
    ],
  ),
)
```

### 间距不统一
```dart
// ❌ 错误
SizedBox(height: 20)  // 硬编码

// ✅ 正确
SizedBox(height: GamificationSpacing.lg)  // 使用常量
```

### 圆角混乱
```dart
// ❌ 错误
borderRadius: BorderRadius.circular(15)  // 随意值

// ✅ 正确
borderRadius: BorderRadius.circular(GamificationSpacing.radiusMedium)
```

---

## 📂 文件位置

```
lib/src/core/design/
├── spacing.dart              # 间距、圆角、尺寸系统
└── gamification_colors.dart  # 色彩扩展

lib/src/features/gamification/presentation/
└── gamification_page.dart    # 主页面实现
```

---

## 🔗 相关文档

- 完整设计规范：`DESIGN_SPEC_游戏化界面.md`
- 视觉对比分析：`DESIGN_IMPROVEMENTS_视觉对比.md`

---

**快速参考版本**：v1.0
**更新日期**：2025-10-20
