# 游戏化界面视觉设计优化规范

## 设计概述

本文档提供游戏化界面的完整视觉设计规范，基于8pt网格系统、黄金比例原则和Material Design 3标准。

---

## 1. 设计原则

### 核心原则
- **一致性优先**：统一的间距、圆角、阴影系统
- **视觉呼吸感**：充足的留白，避免信息拥挤
- **等高设计**：同级卡片保持相同高度，避免参差不齐
- **层次分明**：通过尺寸、颜色、阴影建立清晰的视觉层次
- **响应式流畅**：适配不同屏幕尺寸，保持视觉平衡

---

## 2. 间距系统 - 8pt网格

### 基础单位
```dart
static const double unit = 8.0; // 所有间距的基础单位
```

### 间距层级

| 名称 | 值 | 用途 | 示例 |
|-----|----|----|------|
| `xxs` | 4px | 最小间距 | 进度条上下间距、图标间距 |
| `xs` | 8px | 紧凑元素 | 图标与文字、小标签 |
| `sm` | 12px | 相关元素 | 卡片内元素间距 |
| `md` | 16px | 标准间距 | 卡片padding、网格间距 |
| `lg` | 24px | 区块间距 | Section分隔、页面边距 |
| `xl` | 32px | 大区块 | Hero卡片padding |
| `xxl` | 48px | 主要区域 | 顶级Section分隔 |

### 实际应用

```dart
// 页面边距（增强呼吸感）
EdgeInsets.all(GamificationSpacing.pageHorizontal) // 24px

// Section间距
SizedBox(height: GamificationSpacing.sectionSpacing) // 24px

// 网格间距（统一）
SizedBox(width: GamificationSpacing.gridSpacing) // 16px

// 卡片内部padding（分层策略）
- 紧凑卡片：16px (cardPaddingCompact)
- 标准卡片：24px (cardPaddingStandard)
- Hero卡片：32px (cardPaddingHero)
```

---

## 3. 圆角系统

### 圆角层级

| 名称 | 值 | 用途 |
|-----|----|----|
| `radiusSmall` | 8px | 小元素、徽章、标签、进度条 |
| `radiusMedium` | 12px | 标准卡片 |
| `radiusLarge` | 16px | 强调卡片 |
| `radiusXLarge` | 24px | Hero区域 |

### 实际应用

```dart
// Hero卡片
BorderRadius.circular(GamificationSpacing.radiusXLarge) // 24px

// 标准卡片
BorderRadius.circular(GamificationSpacing.radiusMedium) // 12px

// 小元素（按钮、标签）
BorderRadius.circular(GamificationSpacing.radiusSmall) // 8px
```

---

## 4. 阴影系统（Elevation）

### 三级阴影层次

#### 低阴影 - 次要卡片
```dart
BoxShadow(
  color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
  offset: Offset(0, 2),
  blurRadius: 8,
  spreadRadius: 0,
)
```

#### 中阴影 - 标准卡片
```dart
BoxShadow(
  color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.12),
  offset: Offset(0, 4),
  blurRadius: 16,
  spreadRadius: 0,
)
```

#### 高阴影 - 强调卡片
```dart
BoxShadow(
  color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.16),
  offset: Offset(0, 8),
  blurRadius: 24,
  spreadRadius: 0,
)
```

#### 特殊阴影 - Hero区域（带品牌色光晕）
```dart
BoxShadow(
  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.24),
  offset: Offset(0, 12),
  blurRadius: 32,
  spreadRadius: 0,
)
```

### 使用方法

```dart
// 在Container中应用
decoration: BoxDecoration(
  boxShadow: GamificationElevation.cardShadowMedium(context),
)
```

---

## 5. 卡片尺寸规范

### 固定高度定义（解决长短不一问题）

```dart
class CardDimensions {
  // Hero卡片 - 固定高度，确保视觉焦点
  static const double heroCardHeight = 160.0;

  // 每日任务卡片 - 等高设计
  static const double dailyTaskCardMinHeight = 320.0;

  // 统计卡片 - 等高网格
  static const double statCardHeight = 88.0;

  // 统计卡片图标尺寸
  static const double statCardIconSize = 32.0;

  // Tab内容区域
  static const double tabContentHeight = 440.0;
}
```

### 实际应用

```dart
// Hero卡片
Container(
  height: CardDimensions.heroCardHeight, // 160px
  ...
)

// 每日任务区域（等高布局）
SizedBox(
  height: CardDimensions.dailyTaskCardMinHeight, // 320px
  child: Row(
    children: [
      Expanded(child: DailyCheckInCard()),
      SizedBox(width: GamificationSpacing.gridSpacing),
      Expanded(child: LuckyDrawCard()),
    ],
  ),
)

// 统计卡片（2x2网格等高）
Container(
  height: CardDimensions.statCardHeight, // 88px
  ...
)
```

---

## 6. 视觉层次结构

### 三层设计体系

#### Tier 1: Hero区域（最高视觉权重）
- **尺寸**：固定高度 160px
- **圆角**：24px (radiusXLarge)
- **阴影**：品牌色光晕阴影（heroShadow）
- **Padding**：32px (cardPaddingHero)
- **特点**：渐变背景、呼吸动画、最大视觉吸引力

#### Tier 2: 每日互动区（中等视觉权重）
- **尺寸**：固定高度 320px
- **圆角**：12px (radiusMedium)
- **阴影**：低阴影 (cardShadowLow)
- **Padding**：16px (cardPaddingCompact)
- **特点**：紧凑型设计、等高布局、交互友好

#### Tier 3: 数据统计和Tab（低视觉权重）
- **统计卡片**：固定高度 88px
- **圆角**：12px (radiusMedium)
- **阴影**：低阴影 (cardShadowLow)
- **Padding**：16px
- **特点**：紧凑高效、信息密度适中、响应式动画

---

## 7. 色彩对比度规范

### 品牌色应用
```dart
// Hero区域渐变
gradient: LinearGradient(
  colors: [
    theme.colorScheme.heroGradientStart, // primary
    theme.colorScheme.heroGradientEnd,   // secondary
  ],
)

// 统计卡片语义色
StatCardColors.tasksCompleted   // #4CAF50 绿色
StatCardColors.currentStreak    // #FF9800 橙色
StatCardColors.focusTime        // #2196F3 蓝色
StatCardColors.longestStreak    // #9C27B0 紫色
```

### 对比度要求
- **大文字**（18px+）：至少 3:1 对比度
- **小文字**（<18px）：至少 4.5:1 对比度
- **交互元素**：至少 3:1 对比度
- **品牌色在白色背景**：确保通过 WCAG AA 标准

---

## 8. 响应式布局规则

### 网格系统

```dart
// 2列等宽网格（每日任务卡片）
Row(
  children: [
    Expanded(child: Card1),
    SizedBox(width: GamificationSpacing.gridSpacing), // 16px
    Expanded(child: Card2),
  ],
)

// 2x2统计网格
Column(
  children: [
    Row([Card1, SizedBox(16px), Card2]),
    SizedBox(height: 16px),
    Row([Card3, SizedBox(16px), Card4]),
  ],
)
```

### 间距比例（黄金比例应用）

| 区域 | 间距值 | 比例关系 |
|-----|--------|---------|
| 页面边距 | 24px | 基准 |
| Section间距 | 24px | 1:1 |
| 网格间距 | 16px | 1:1.5 |
| 卡片内元素 | 12px | 1:2 |

---

## 9. 动画和微交互规范

### 时长标准
```dart
// 快速反馈（点击、悬停）
duration: Duration(milliseconds: 150)

// 内容过渡（淡入淡出）
duration: Duration(milliseconds: 300)

// 复杂动画（数字滚动、进度条）
duration: Duration(milliseconds: 600-800)

// 呼吸动画（Hero卡片）
duration: Duration(seconds: 2)
```

### 缓动曲线
```dart
Curves.easeInOut    // 标准交互
Curves.easeOutCubic // 进度条、滚动
Curves.easeIn       // 淡入
```

### 微交互示例
```dart
// 按压反馈
onTapDown: scale to 0.95
onTapUp: scale to 1.0

// 状态变化
- 边框宽度：1px → 2px
- 颜色透明度：0.5 → 0.6
- 阴影层级：low → medium
```

---

## 10. 实施检查清单

### 间距检查
- [ ] 所有间距值都是8的倍数
- [ ] 页面边距统一为24px
- [ ] Section间距统一为24px
- [ ] 网格间距统一为16px
- [ ] 卡片padding按层级分配（16/24/32px）

### 卡片检查
- [ ] Hero卡片高度160px，圆角24px
- [ ] 每日任务卡片等高320px
- [ ] 统计卡片等高88px
- [ ] 所有卡片圆角统一（8/12/16/24px）
- [ ] 阴影层级正确应用

### 视觉层次检查
- [ ] Hero区域视觉权重最高
- [ ] 每日互动区适中，不抢夺焦点
- [ ] 统计区紧凑高效
- [ ] 颜色对比度符合WCAG AA标准

### 响应式检查
- [ ] 等宽布局使用Expanded
- [ ] 固定高度应用SizedBox
- [ ] 网格间距一致
- [ ] 文字溢出处理（maxLines, overflow）

---

## 11. 代码使用示例

### 标准卡片模板

```dart
Container(
  height: CardDimensions.statCardHeight, // 固定高度
  padding: EdgeInsets.all(GamificationSpacing.md), // 16px
  decoration: BoxDecoration(
    color: theme.colorScheme.surface,
    borderRadius: BorderRadius.circular(GamificationSpacing.radiusMedium), // 12px
    border: Border.all(
      color: theme.colorScheme.outlineVariant,
      width: 1,
    ),
    boxShadow: GamificationElevation.cardShadowLow(context),
  ),
  child: YourContent(),
)
```

### Hero卡片模板

```dart
Container(
  height: CardDimensions.heroCardHeight, // 160px
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        theme.colorScheme.heroGradientStart,
        theme.colorScheme.heroGradientEnd,
      ],
    ),
    borderRadius: BorderRadius.circular(GamificationSpacing.radiusXLarge), // 24px
    boxShadow: GamificationElevation.heroShadow(context),
  ),
  padding: EdgeInsets.all(GamificationSpacing.cardPaddingHero), // 32px
  child: YourContent(),
)
```

### 等高网格模板

```dart
SizedBox(
  height: CardDimensions.dailyTaskCardMinHeight, // 320px
  child: Row(
    children: [
      Expanded(child: Card1()),
      SizedBox(width: GamificationSpacing.gridSpacing), // 16px
      Expanded(child: Card2()),
    ],
  ),
)
```

---

## 12. 设计改进对比

### 改进前问题
- ❌ 间距值混乱（4px, 8px, 12px, 16px, 20px, 24px随意使用）
- ❌ 卡片高度不一致，视觉参差不齐
- ❌ 圆角值不统一（8px, 12px, 20px混用）
- ❌ 阴影缺乏系统，视觉层次不清
- ❌ 信息密度过高，缺乏呼吸感

### 改进后效果
- ✅ 严格遵循8pt网格系统
- ✅ 固定高度设计，视觉整齐统一
- ✅ 四级圆角系统（8/12/16/24px）
- ✅ 四级阴影体系，层次分明
- ✅ 充足留白，视觉舒适

---

## 13. 维护指南

### 新增卡片时
1. 确定视觉层级（Tier 1/2/3）
2. 使用对应的固定高度常量
3. 应用相应的padding和圆角
4. 选择合适的阴影层级
5. 确保间距使用Spacing常量

### 修改间距时
1. 检查是否符合8pt网格
2. 优先使用已定义常量
3. 如需新值，添加到Spacing类
4. 更新本文档

### 颜色变更时
1. 确保对比度符合WCAG标准
2. 更新GamificationColors扩展
3. 测试明暗主题
4. 记录语义化用途

---

## 文件位置

- **间距系统**：`lib/src/core/design/spacing.dart`
- **颜色系统**：`lib/src/core/design/gamification_colors.dart`
- **主界面**：`lib/src/features/gamification/presentation/gamification_page.dart`

---

## 设计决策依据

1. **8pt网格**：Apple Human Interface Guidelines和Material Design推荐
2. **黄金比例**：视觉美学经典原则（1:1.618）
3. **等高设计**：减少视觉噪音，提升专业感
4. **三层视觉层次**：F型阅读模式优化
5. **固定高度**：确保响应式布局的稳定性

---

**版本**：v1.0
**更新日期**：2025-10-20
**设计师**：UI Designer Agent
**审核状态**：已优化实施
