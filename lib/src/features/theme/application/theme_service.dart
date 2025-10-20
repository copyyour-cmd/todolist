import 'package:hive/hive.dart';
import 'package:todolist/src/domain/entities/theme_config.dart';

/// Service for managing theme configuration
class ThemeService {
  static const String _boxName = 'theme_config';
  static const String _configKey = 'config';

  Box<ThemeConfig> get _box => Hive.box<ThemeConfig>(_boxName);

  /// Get current theme configuration
  ThemeConfig getThemeConfig() {
    return _box.get(_configKey) ?? const ThemeConfig();
  }

  /// Save theme configuration
  Future<void> saveThemeConfig(ThemeConfig config) async {
    await _box.put(_configKey, config);
  }

  /// Update color scheme
  Future<void> updateColorScheme(ColorSchemePreset preset) async {
    final current = getThemeConfig();
    await saveThemeConfig(current.copyWith(
      colorScheme: preset,
      customColors: preset == ColorSchemePreset.custom ? current.customColors : null,
    ));
  }

  /// Update custom colors
  Future<void> updateCustomColors(CustomColorConfig colors) async {
    final current = getThemeConfig();
    await saveThemeConfig(current.copyWith(
      colorScheme: ColorSchemePreset.custom,
      customColors: colors,
    ));
  }

  /// Update font size
  Future<void> updateFontSize(FontSizePreset fontSize) async {
    final current = getThemeConfig();
    await saveThemeConfig(current.copyWith(fontSize: fontSize));
  }

  /// Update card style
  Future<void> updateCardStyle(TaskCardStyle cardStyle) async {
    final current = getThemeConfig();
    await saveThemeConfig(current.copyWith(cardStyle: cardStyle));
  }

  /// Toggle Material You
  Future<void> toggleMaterialYou(bool enabled) async {
    final current = getThemeConfig();
    await saveThemeConfig(current.copyWith(useMaterialYou: enabled));
  }

  /// Toggle system accent color
  Future<void> toggleSystemAccentColor(bool enabled) async {
    final current = getThemeConfig();
    await saveThemeConfig(current.copyWith(useSystemAccentColor: enabled));
  }

  /// Reset to default
  Future<void> resetToDefault() async {
    await saveThemeConfig(const ThemeConfig());
  }
}
