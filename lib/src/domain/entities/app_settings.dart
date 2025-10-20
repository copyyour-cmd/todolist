import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../infrastructure/hive/type_ids.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@HiveType(typeId: HiveTypeIds.appSettings, adapterName: 'AppSettingsAdapter')
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @HiveField(0) @Default(false) bool requirePassword,
    @HiveField(1) @Default('') String passwordHash,
    @HiveField(2) DateTime? updatedAt,
    @HiveField(3) @Default(AppThemeMode.light) AppThemeMode themeMode, // 已经是浅色模式
    @HiveField(4) String? languageCode,
    @HiveField(5) @Default(true) bool enableNotifications,
    @HiveField(6) @Default(AppThemeColor.bahamaBlue) AppThemeColor themeColor,
    @HiveField(7) int? customPrimaryColor,
    @HiveField(8) @Default(false) bool autoSwitchTheme, // 自动切换主题
    @HiveField(9) @Default(6) int dayThemeStartHour, // 日间主题开始时间（6:00）
    @HiveField(10) @Default(18) int nightThemeStartHour, // 夜间主题开始时间（18:00）
    @HiveField(11) AppThemeColor? dayThemeColor, // 日间主题颜色
    @HiveField(12) AppThemeColor? nightThemeColor, // 夜间主题颜色
    @HiveField(13) String? homeBackgroundImagePath, // 首页背景图片路径
    @HiveField(14) String? focusBackgroundImagePath, // 专注模式背景图片路径
    @HiveField(15) @Default(0.3) double backgroundBlurAmount, // 背景模糊程度 0-1
    @HiveField(16) @Default(0.5) double backgroundDarkenAmount, // 背景暗化程度 0-1
    @HiveField(17) @Default(false) bool enableBiometricAuth, // 启用生物识别认证（已废弃）
    @HiveField(18) @Default(false) bool enableFingerprintAuth, // 启用指纹识别
    @HiveField(19) @Default(false) bool enableFaceAuth, // 启用人脸识别
  }) = _AppSettings;

  const AppSettings._();

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  bool get hasPassword => passwordHash.isNotEmpty;
}

@HiveType(typeId: HiveTypeIds.appThemeMode, adapterName: 'AppThemeModeAdapter')
enum AppThemeMode {
  @HiveField(0)
  system,
  @HiveField(1)
  light,
  @HiveField(2)
  dark,
}

@HiveType(typeId: HiveTypeIds.appThemeColor, adapterName: 'AppThemeColorAdapter')
enum AppThemeColor {
  @HiveField(0)
  bahamaBlue,
  @HiveField(1)
  purple,
  @HiveField(2)
  green,
  @HiveField(3)
  orange,
  @HiveField(4)
  pink,
  @HiveField(5)
  teal,
  @HiveField(6)
  indigo,
  @HiveField(7)
  amber,
  @HiveField(8)
  custom,
  @HiveField(9)
  eyeCareGreen, // 护眼绿
  @HiveField(10)
  deepBlue, // 深邃蓝
  @HiveField(11)
  lavender, // 薰衣草紫
  @HiveField(12)
  mintGreen, // 薄荷绿
  @HiveField(13)
  sunset, // 日落橙红
  @HiveField(14)
  ocean, // 海洋蓝
}
