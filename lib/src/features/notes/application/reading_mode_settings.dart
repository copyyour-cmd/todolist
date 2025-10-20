import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 阅读模式设置
class ReadingModeSettings {
  const ReadingModeSettings({
    this.fontSize = 16.0,
    this.lineHeight = 1.6,
    this.isNightMode = false,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
  });

  final double fontSize; // 字体大小 (12-32)
  final double lineHeight; // 行高 (1.0-2.5)
  final bool isNightMode; // 是否夜间模式
  final Color backgroundColor; // 背景色
  final Color textColor; // 文字颜色

  ReadingModeSettings copyWith({
    double? fontSize,
    double? lineHeight,
    bool? isNightMode,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return ReadingModeSettings(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      isNightMode: isNightMode ?? this.isNightMode,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'lineHeight': lineHeight,
      'isNightMode': isNightMode,
      'backgroundColor': backgroundColor.value,
      'textColor': textColor.value,
    };
  }

  /// 从 JSON 创建
  factory ReadingModeSettings.fromJson(Map<String, dynamic> json) {
    return ReadingModeSettings(
      fontSize: json['fontSize'] as double? ?? 16.0,
      lineHeight: json['lineHeight'] as double? ?? 1.6,
      isNightMode: json['isNightMode'] as bool? ?? false,
      backgroundColor: Color(json['backgroundColor'] as int? ?? Colors.white.value),
      textColor: Color(json['textColor'] as int? ?? Colors.black87.value),
    );
  }

  /// 夜间模式预设
  static ReadingModeSettings get nightMode {
    return const ReadingModeSettings(
      fontSize: 16.0,
      lineHeight: 1.8,
      isNightMode: true,
      backgroundColor: Color(0xFF1E1E1E), // 深灰色背景
      textColor: Color(0xFFD4D4D4), // 浅灰色文字
    );
  }

  /// 日间模式预设
  static ReadingModeSettings get dayMode {
    return const ReadingModeSettings(
      fontSize: 16.0,
      lineHeight: 1.6,
      isNightMode: false,
      backgroundColor: Colors.white,
      textColor: Colors.black87,
    );
  }

  /// 护眼模式预设 (豆沙绿)
  static ReadingModeSettings get eyeCareMode {
    return const ReadingModeSettings(
      fontSize: 16.0,
      lineHeight: 1.8,
      isNightMode: false,
      backgroundColor: Color(0xFFC7EDCC), // 豆沙绿
      textColor: Color(0xFF2D2D2D),
    );
  }

  /// 羊皮纸模式
  static ReadingModeSettings get parchmentMode {
    return const ReadingModeSettings(
      fontSize: 16.0,
      lineHeight: 1.7,
      isNightMode: false,
      backgroundColor: Color(0xFFFFF8DC), // 米黄色
      textColor: Color(0xFF3E2723),
    );
  }
}

/// 阅读模式设置服务
class ReadingModeSettingsService extends StateNotifier<ReadingModeSettings> {
  ReadingModeSettingsService(this._prefs)
      : super(ReadingModeSettings.dayMode) {
    _loadSettings();
  }

  final SharedPreferences _prefs;

  static const _keyPrefix = 'reading_mode_';
  static const _keyFontSize = '${_keyPrefix}font_size';
  static const _keyLineHeight = '${_keyPrefix}line_height';
  static const _keyIsNightMode = '${_keyPrefix}is_night_mode';
  static const _keyBackgroundColor = '${_keyPrefix}background_color';
  static const _keyTextColor = '${_keyPrefix}text_color';

  /// 加载设置
  void _loadSettings() {
    final fontSize = _prefs.getDouble(_keyFontSize) ?? 16.0;
    final lineHeight = _prefs.getDouble(_keyLineHeight) ?? 1.6;
    final isNightMode = _prefs.getBool(_keyIsNightMode) ?? false;
    final bgColorValue = _prefs.getInt(_keyBackgroundColor) ?? Colors.white.value;
    final textColorValue = _prefs.getInt(_keyTextColor) ?? Colors.black87.value;

    state = ReadingModeSettings(
      fontSize: fontSize,
      lineHeight: lineHeight,
      isNightMode: isNightMode,
      backgroundColor: Color(bgColorValue),
      textColor: Color(textColorValue),
    );
  }

  /// 保存设置
  Future<void> _saveSettings() async {
    await _prefs.setDouble(_keyFontSize, state.fontSize);
    await _prefs.setDouble(_keyLineHeight, state.lineHeight);
    await _prefs.setBool(_keyIsNightMode, state.isNightMode);
    await _prefs.setInt(_keyBackgroundColor, state.backgroundColor.value);
    await _prefs.setInt(_keyTextColor, state.textColor.value);
  }

  /// 设置字体大小
  Future<void> setFontSize(double size) async {
    if (size < 12.0 || size > 32.0) return;
    state = state.copyWith(fontSize: size);
    await _saveSettings();
  }

  /// 增加字体大小
  Future<void> increaseFontSize() async {
    final newSize = (state.fontSize + 2).clamp(12.0, 32.0);
    await setFontSize(newSize);
  }

  /// 减小字体大小
  Future<void> decreaseFontSize() async {
    final newSize = (state.fontSize - 2).clamp(12.0, 32.0);
    await setFontSize(newSize);
  }

  /// 设置行高
  Future<void> setLineHeight(double height) async {
    if (height < 1.0 || height > 2.5) return;
    state = state.copyWith(lineHeight: height);
    await _saveSettings();
  }

  /// 切换夜间模式
  Future<void> toggleNightMode() async {
    if (state.isNightMode) {
      // 切换到日间模式
      state = ReadingModeSettings.dayMode.copyWith(
        fontSize: state.fontSize,
        lineHeight: state.lineHeight,
      );
    } else {
      // 切换到夜间模式
      state = ReadingModeSettings.nightMode.copyWith(
        fontSize: state.fontSize,
        lineHeight: state.lineHeight,
      );
    }
    await _saveSettings();
  }

  /// 应用预设主题
  Future<void> applyPreset(ReadingModeSettings preset) async {
    state = preset.copyWith(
      fontSize: state.fontSize, // 保留当前字体大小
      lineHeight: state.lineHeight, // 保留当前行高
    );
    await _saveSettings();
  }

  /// 设置自定义颜色
  Future<void> setCustomColors({
    Color? backgroundColor,
    Color? textColor,
  }) async {
    state = state.copyWith(
      backgroundColor: backgroundColor,
      textColor: textColor,
      isNightMode: false, // 自定义颜色时取消夜间模式标记
    );
    await _saveSettings();
  }

  /// 重置为默认设置
  Future<void> reset() async {
    state = ReadingModeSettings.dayMode;
    await _saveSettings();
  }
}

/// 阅读模式设置 Provider
final readingModeSettingsProvider =
    StateNotifierProvider<ReadingModeSettingsService, ReadingModeSettings>(
  (ref) {
    // 需要在bootstrap中初始化
    throw UnimplementedError('readingModeSettingsProvider must be overridden');
  },
);
