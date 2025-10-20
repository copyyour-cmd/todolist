import 'package:flutter/services.dart';

/// 触觉反馈辅助类
/// 提供统一的触觉反馈接口,增强用户交互体验
class HapticFeedbackHelper {
  /// 轻触反馈
  /// 适用场景: 按钮点击、选择切换、轻量操作
  /// 强度: ⭐
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// 中等反馈
  /// 适用场景: 完成任务、保存数据、重要操作
  /// 强度: ⭐⭐
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// 重触反馈
  /// 适用场景: 删除操作、长按菜单、警告提示
  /// 强度: ⭐⭐⭐
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// 选择反馈
  /// 适用场景: 滚动选择器、拖拽排序、滑动切换
  /// 特点: 清脆的咔哒声
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// 振动反馈
  /// 适用场景: 错误提示、警告对话框
  /// 特点: 持续振动
  static Future<void> vibrate() async {
    await HapticFeedback.vibrate();
  }

  /// 成功反馈
  /// 适用场景: 任务完成、数据同步成功
  /// 效果: 双击轻触
  static Future<void> success() async {
    await HapticFeedback.lightImpact();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  /// 错误反馈
  /// 适用场景: 操作失败、验证错误
  /// 效果: 三次重触
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// 警告反馈
  /// 适用场景: 删除确认、重要操作提示
  /// 效果: 中等+重触组合
  static Future<void> warning() async {
    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.heavyImpact();
  }

  /// 长按反馈
  /// 适用场景: 长按菜单、拖拽开始
  /// 效果: 重触+选择组合
  static Future<void> longPress() async {
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.selectionClick();
  }

  /// 滑动开始反馈
  /// 适用场景: 滑动操作开始
  static Future<void> swipeStart() async {
    await HapticFeedback.selectionClick();
  }

  /// 滑动结束反馈
  /// 适用场景: 滑动操作完成
  static Future<void> swipeEnd() async {
    await HapticFeedback.lightImpact();
  }

  /// 切换反馈
  /// 适用场景: 开关切换、选项卡切换
  static Future<void> toggle() async {
    await HapticFeedback.selectionClick();
  }

  /// 刷新反馈
  /// 适用场景: 下拉刷新完成
  static Future<void> refresh() async {
    await HapticFeedback.mediumImpact();
  }
}

