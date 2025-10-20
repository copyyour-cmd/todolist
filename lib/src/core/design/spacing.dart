import 'package:flutter/material.dart';

/// 语义化间距系统 - 基于8pt网格和黄金比例
/// 统一的间距常量，确保UI一致性和视觉节奏
class GamificationSpacing {
  GamificationSpacing._();

  // 基础间距单位：8pt网格系统
  static const double unit = 8.0;

  // ========== 微观间距（组件内部） ==========
  static const double xxs = unit * 0.5; // 4px - 最小间距（图标间、文字行距）
  static const double xs = unit * 1; // 8px - 紧凑元素（图标与文字）
  static const double sm = unit * 1.5; // 12px - 卡片内相关元素
  static const double md = unit * 2; // 16px - 标准间距
  static const double lg = unit * 3; // 24px - 区块间距
  static const double xl = unit * 4; // 32px - 大区块间距
  static const double xxl = unit * 6; // 48px - 主要区域分隔

  // ========== 页面级间距（屏幕边缘呼吸感） ==========
  static const double pageHorizontal = lg; // 24px（增强呼吸感）
  static const double pageVertical = lg; // 24px

  // ========== 卡片系统（分层padding策略） ==========
  static const double cardPaddingCompact = md; // 16px - 紧凑型卡片（列表项）
  static const double cardPaddingStandard = lg; // 24px - 标准卡片（功能卡片）
  static const double cardPaddingHero = xl; // 32px - 英雄卡片（顶部焦点）

  // ========== 圆角系统（建立视觉层次） ==========
  static const double radiusSmall = unit * 1; // 8px - 小元素、徽章、标签
  static const double radiusMedium = unit * 1.5; // 12px - 标准卡片
  static const double radiusLarge = unit * 2; // 16px - 强调卡片
  static const double radiusXLarge = unit * 3; // 24px - Hero区域

  // 向后兼容的别名
  static const double cardBorderRadius = radiusMedium; // 12px

  // ========== Section间距（遵循黄金比例） ==========
  static const double sectionSpacing = lg; // 24px - 标准Section分隔
  static const double sectionSpacingLarge = unit * 5; // 40px - 主要区域分隔
  static const double sectionHeaderMargin = md; // 16px - 标题底部间距

  // ========== 网格间距（保持一致性） ==========
  static const double gridSpacing = md; // 16px（增加通气性）

  // ========== 特殊组件间距 ==========
  static const double heroPadding = cardPaddingHero; // 32px - Hero区域内边距
  static const double heroMargin = md; // 16px（已废弃，使用sectionSpacing）
  static const double cardMargin = md; // 16px（已废弃，使用gridSpacing）
}

/// 视觉层次的elevation和阴影定义
class GamificationElevation {
  GamificationElevation._();

  // ========== 层级1：低elevation（次要卡片） ==========
  static List<BoxShadow> cardShadowLow(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  // ========== 层级2：中elevation（标准卡片） ==========
  static List<BoxShadow> cardShadowMedium(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.12),
          offset: const Offset(0, 4),
          blurRadius: 16,
          spreadRadius: 0,
        ),
      ];

  // ========== 层级3：高elevation（强调卡片） ==========
  static List<BoxShadow> cardShadowHigh(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.16),
          offset: const Offset(0, 8),
          blurRadius: 24,
          spreadRadius: 0,
        ),
      ];

  // ========== 特殊：Hero阴影（带品牌色光晕） ==========
  static List<BoxShadow> heroShadow(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.24),
          offset: const Offset(0, 12),
          blurRadius: 32,
          spreadRadius: 0,
        ),
      ];
}

/// 标准化的卡片尺寸定义
class CardDimensions {
  CardDimensions._();

  // Hero卡片（固定高度，确保视觉焦点）
  static const double heroCardHeight = 160.0;

  // 每日任务卡片（等高设计，避免长短不一）
  static const double dailyTaskCardMinHeight = 320.0;

  // 统计卡片（等高网格，视觉平衡）
  static const double statCardHeight = 88.0;

  // 统计卡片图标尺寸
  static const double statCardIconSize = 32.0;

  // Tab内容区域
  static const double tabContentHeight = 440.0;

  // 按钮高度标准
  static const double buttonHeightCompact = 40.0;
  static const double buttonHeightStandard = 48.0;
  static const double buttonHeightLarge = 56.0;
}
