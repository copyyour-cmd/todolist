// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  @HiveField(0)
  bool get requirePassword => throw _privateConstructorUsedError;
  @HiveField(1)
  String get passwordHash => throw _privateConstructorUsedError;
  @HiveField(2)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(3)
  AppThemeMode get themeMode => throw _privateConstructorUsedError; // 已经是浅色模式
  @HiveField(4)
  String? get languageCode => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get enableNotifications => throw _privateConstructorUsedError;
  @HiveField(6)
  AppThemeColor get themeColor => throw _privateConstructorUsedError;
  @HiveField(7)
  int? get customPrimaryColor => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get autoSwitchTheme => throw _privateConstructorUsedError; // 自动切换主题
  @HiveField(9)
  int get dayThemeStartHour =>
      throw _privateConstructorUsedError; // 日间主题开始时间（6:00）
  @HiveField(10)
  int get nightThemeStartHour =>
      throw _privateConstructorUsedError; // 夜间主题开始时间（18:00）
  @HiveField(11)
  AppThemeColor? get dayThemeColor =>
      throw _privateConstructorUsedError; // 日间主题颜色
  @HiveField(12)
  AppThemeColor? get nightThemeColor =>
      throw _privateConstructorUsedError; // 夜间主题颜色
  @HiveField(13)
  String? get homeBackgroundImagePath =>
      throw _privateConstructorUsedError; // 首页背景图片路径
  @HiveField(14)
  String? get focusBackgroundImagePath =>
      throw _privateConstructorUsedError; // 专注模式背景图片路径
  @HiveField(15)
  double get backgroundBlurAmount =>
      throw _privateConstructorUsedError; // 背景模糊程度 0-1
  @HiveField(16)
  double get backgroundDarkenAmount =>
      throw _privateConstructorUsedError; // 背景暗化程度 0-1
  @HiveField(17)
  bool get enableBiometricAuth =>
      throw _privateConstructorUsedError; // 启用生物识别认证（已废弃）
  @HiveField(18)
  bool get enableFingerprintAuth =>
      throw _privateConstructorUsedError; // 启用指纹识别
  @HiveField(19)
  bool get enableFaceAuth => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {@HiveField(0) bool requirePassword,
      @HiveField(1) String passwordHash,
      @HiveField(2) DateTime? updatedAt,
      @HiveField(3) AppThemeMode themeMode,
      @HiveField(4) String? languageCode,
      @HiveField(5) bool enableNotifications,
      @HiveField(6) AppThemeColor themeColor,
      @HiveField(7) int? customPrimaryColor,
      @HiveField(8) bool autoSwitchTheme,
      @HiveField(9) int dayThemeStartHour,
      @HiveField(10) int nightThemeStartHour,
      @HiveField(11) AppThemeColor? dayThemeColor,
      @HiveField(12) AppThemeColor? nightThemeColor,
      @HiveField(13) String? homeBackgroundImagePath,
      @HiveField(14) String? focusBackgroundImagePath,
      @HiveField(15) double backgroundBlurAmount,
      @HiveField(16) double backgroundDarkenAmount,
      @HiveField(17) bool enableBiometricAuth,
      @HiveField(18) bool enableFingerprintAuth,
      @HiveField(19) bool enableFaceAuth});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requirePassword = null,
    Object? passwordHash = null,
    Object? updatedAt = freezed,
    Object? themeMode = null,
    Object? languageCode = freezed,
    Object? enableNotifications = null,
    Object? themeColor = null,
    Object? customPrimaryColor = freezed,
    Object? autoSwitchTheme = null,
    Object? dayThemeStartHour = null,
    Object? nightThemeStartHour = null,
    Object? dayThemeColor = freezed,
    Object? nightThemeColor = freezed,
    Object? homeBackgroundImagePath = freezed,
    Object? focusBackgroundImagePath = freezed,
    Object? backgroundBlurAmount = null,
    Object? backgroundDarkenAmount = null,
    Object? enableBiometricAuth = null,
    Object? enableFingerprintAuth = null,
    Object? enableFaceAuth = null,
  }) {
    return _then(_value.copyWith(
      requirePassword: null == requirePassword
          ? _value.requirePassword
          : requirePassword // ignore: cast_nullable_to_non_nullable
              as bool,
      passwordHash: null == passwordHash
          ? _value.passwordHash
          : passwordHash // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as AppThemeMode,
      languageCode: freezed == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String?,
      enableNotifications: null == enableNotifications
          ? _value.enableNotifications
          : enableNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      themeColor: null == themeColor
          ? _value.themeColor
          : themeColor // ignore: cast_nullable_to_non_nullable
              as AppThemeColor,
      customPrimaryColor: freezed == customPrimaryColor
          ? _value.customPrimaryColor
          : customPrimaryColor // ignore: cast_nullable_to_non_nullable
              as int?,
      autoSwitchTheme: null == autoSwitchTheme
          ? _value.autoSwitchTheme
          : autoSwitchTheme // ignore: cast_nullable_to_non_nullable
              as bool,
      dayThemeStartHour: null == dayThemeStartHour
          ? _value.dayThemeStartHour
          : dayThemeStartHour // ignore: cast_nullable_to_non_nullable
              as int,
      nightThemeStartHour: null == nightThemeStartHour
          ? _value.nightThemeStartHour
          : nightThemeStartHour // ignore: cast_nullable_to_non_nullable
              as int,
      dayThemeColor: freezed == dayThemeColor
          ? _value.dayThemeColor
          : dayThemeColor // ignore: cast_nullable_to_non_nullable
              as AppThemeColor?,
      nightThemeColor: freezed == nightThemeColor
          ? _value.nightThemeColor
          : nightThemeColor // ignore: cast_nullable_to_non_nullable
              as AppThemeColor?,
      homeBackgroundImagePath: freezed == homeBackgroundImagePath
          ? _value.homeBackgroundImagePath
          : homeBackgroundImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      focusBackgroundImagePath: freezed == focusBackgroundImagePath
          ? _value.focusBackgroundImagePath
          : focusBackgroundImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundBlurAmount: null == backgroundBlurAmount
          ? _value.backgroundBlurAmount
          : backgroundBlurAmount // ignore: cast_nullable_to_non_nullable
              as double,
      backgroundDarkenAmount: null == backgroundDarkenAmount
          ? _value.backgroundDarkenAmount
          : backgroundDarkenAmount // ignore: cast_nullable_to_non_nullable
              as double,
      enableBiometricAuth: null == enableBiometricAuth
          ? _value.enableBiometricAuth
          : enableBiometricAuth // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFingerprintAuth: null == enableFingerprintAuth
          ? _value.enableFingerprintAuth
          : enableFingerprintAuth // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFaceAuth: null == enableFaceAuth
          ? _value.enableFaceAuth
          : enableFaceAuth // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) bool requirePassword,
      @HiveField(1) String passwordHash,
      @HiveField(2) DateTime? updatedAt,
      @HiveField(3) AppThemeMode themeMode,
      @HiveField(4) String? languageCode,
      @HiveField(5) bool enableNotifications,
      @HiveField(6) AppThemeColor themeColor,
      @HiveField(7) int? customPrimaryColor,
      @HiveField(8) bool autoSwitchTheme,
      @HiveField(9) int dayThemeStartHour,
      @HiveField(10) int nightThemeStartHour,
      @HiveField(11) AppThemeColor? dayThemeColor,
      @HiveField(12) AppThemeColor? nightThemeColor,
      @HiveField(13) String? homeBackgroundImagePath,
      @HiveField(14) String? focusBackgroundImagePath,
      @HiveField(15) double backgroundBlurAmount,
      @HiveField(16) double backgroundDarkenAmount,
      @HiveField(17) bool enableBiometricAuth,
      @HiveField(18) bool enableFingerprintAuth,
      @HiveField(19) bool enableFaceAuth});
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requirePassword = null,
    Object? passwordHash = null,
    Object? updatedAt = freezed,
    Object? themeMode = null,
    Object? languageCode = freezed,
    Object? enableNotifications = null,
    Object? themeColor = null,
    Object? customPrimaryColor = freezed,
    Object? autoSwitchTheme = null,
    Object? dayThemeStartHour = null,
    Object? nightThemeStartHour = null,
    Object? dayThemeColor = freezed,
    Object? nightThemeColor = freezed,
    Object? homeBackgroundImagePath = freezed,
    Object? focusBackgroundImagePath = freezed,
    Object? backgroundBlurAmount = null,
    Object? backgroundDarkenAmount = null,
    Object? enableBiometricAuth = null,
    Object? enableFingerprintAuth = null,
    Object? enableFaceAuth = null,
  }) {
    return _then(_$AppSettingsImpl(
      requirePassword: null == requirePassword
          ? _value.requirePassword
          : requirePassword // ignore: cast_nullable_to_non_nullable
              as bool,
      passwordHash: null == passwordHash
          ? _value.passwordHash
          : passwordHash // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as AppThemeMode,
      languageCode: freezed == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String?,
      enableNotifications: null == enableNotifications
          ? _value.enableNotifications
          : enableNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      themeColor: null == themeColor
          ? _value.themeColor
          : themeColor // ignore: cast_nullable_to_non_nullable
              as AppThemeColor,
      customPrimaryColor: freezed == customPrimaryColor
          ? _value.customPrimaryColor
          : customPrimaryColor // ignore: cast_nullable_to_non_nullable
              as int?,
      autoSwitchTheme: null == autoSwitchTheme
          ? _value.autoSwitchTheme
          : autoSwitchTheme // ignore: cast_nullable_to_non_nullable
              as bool,
      dayThemeStartHour: null == dayThemeStartHour
          ? _value.dayThemeStartHour
          : dayThemeStartHour // ignore: cast_nullable_to_non_nullable
              as int,
      nightThemeStartHour: null == nightThemeStartHour
          ? _value.nightThemeStartHour
          : nightThemeStartHour // ignore: cast_nullable_to_non_nullable
              as int,
      dayThemeColor: freezed == dayThemeColor
          ? _value.dayThemeColor
          : dayThemeColor // ignore: cast_nullable_to_non_nullable
              as AppThemeColor?,
      nightThemeColor: freezed == nightThemeColor
          ? _value.nightThemeColor
          : nightThemeColor // ignore: cast_nullable_to_non_nullable
              as AppThemeColor?,
      homeBackgroundImagePath: freezed == homeBackgroundImagePath
          ? _value.homeBackgroundImagePath
          : homeBackgroundImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      focusBackgroundImagePath: freezed == focusBackgroundImagePath
          ? _value.focusBackgroundImagePath
          : focusBackgroundImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundBlurAmount: null == backgroundBlurAmount
          ? _value.backgroundBlurAmount
          : backgroundBlurAmount // ignore: cast_nullable_to_non_nullable
              as double,
      backgroundDarkenAmount: null == backgroundDarkenAmount
          ? _value.backgroundDarkenAmount
          : backgroundDarkenAmount // ignore: cast_nullable_to_non_nullable
              as double,
      enableBiometricAuth: null == enableBiometricAuth
          ? _value.enableBiometricAuth
          : enableBiometricAuth // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFingerprintAuth: null == enableFingerprintAuth
          ? _value.enableFingerprintAuth
          : enableFingerprintAuth // ignore: cast_nullable_to_non_nullable
              as bool,
      enableFaceAuth: null == enableFaceAuth
          ? _value.enableFaceAuth
          : enableFaceAuth // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl extends _AppSettings {
  const _$AppSettingsImpl(
      {@HiveField(0) this.requirePassword = false,
      @HiveField(1) this.passwordHash = '',
      @HiveField(2) this.updatedAt,
      @HiveField(3) this.themeMode = AppThemeMode.light,
      @HiveField(4) this.languageCode,
      @HiveField(5) this.enableNotifications = true,
      @HiveField(6) this.themeColor = AppThemeColor.bahamaBlue,
      @HiveField(7) this.customPrimaryColor,
      @HiveField(8) this.autoSwitchTheme = false,
      @HiveField(9) this.dayThemeStartHour = 6,
      @HiveField(10) this.nightThemeStartHour = 18,
      @HiveField(11) this.dayThemeColor,
      @HiveField(12) this.nightThemeColor,
      @HiveField(13) this.homeBackgroundImagePath,
      @HiveField(14) this.focusBackgroundImagePath,
      @HiveField(15) this.backgroundBlurAmount = 0.3,
      @HiveField(16) this.backgroundDarkenAmount = 0.5,
      @HiveField(17) this.enableBiometricAuth = false,
      @HiveField(18) this.enableFingerprintAuth = false,
      @HiveField(19) this.enableFaceAuth = false})
      : super._();

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final bool requirePassword;
  @override
  @JsonKey()
  @HiveField(1)
  final String passwordHash;
  @override
  @HiveField(2)
  final DateTime? updatedAt;
  @override
  @JsonKey()
  @HiveField(3)
  final AppThemeMode themeMode;
// 已经是浅色模式
  @override
  @HiveField(4)
  final String? languageCode;
  @override
  @JsonKey()
  @HiveField(5)
  final bool enableNotifications;
  @override
  @JsonKey()
  @HiveField(6)
  final AppThemeColor themeColor;
  @override
  @HiveField(7)
  final int? customPrimaryColor;
  @override
  @JsonKey()
  @HiveField(8)
  final bool autoSwitchTheme;
// 自动切换主题
  @override
  @JsonKey()
  @HiveField(9)
  final int dayThemeStartHour;
// 日间主题开始时间（6:00）
  @override
  @JsonKey()
  @HiveField(10)
  final int nightThemeStartHour;
// 夜间主题开始时间（18:00）
  @override
  @HiveField(11)
  final AppThemeColor? dayThemeColor;
// 日间主题颜色
  @override
  @HiveField(12)
  final AppThemeColor? nightThemeColor;
// 夜间主题颜色
  @override
  @HiveField(13)
  final String? homeBackgroundImagePath;
// 首页背景图片路径
  @override
  @HiveField(14)
  final String? focusBackgroundImagePath;
// 专注模式背景图片路径
  @override
  @JsonKey()
  @HiveField(15)
  final double backgroundBlurAmount;
// 背景模糊程度 0-1
  @override
  @JsonKey()
  @HiveField(16)
  final double backgroundDarkenAmount;
// 背景暗化程度 0-1
  @override
  @JsonKey()
  @HiveField(17)
  final bool enableBiometricAuth;
// 启用生物识别认证（已废弃）
  @override
  @JsonKey()
  @HiveField(18)
  final bool enableFingerprintAuth;
// 启用指纹识别
  @override
  @JsonKey()
  @HiveField(19)
  final bool enableFaceAuth;

  @override
  String toString() {
    return 'AppSettings(requirePassword: $requirePassword, passwordHash: $passwordHash, updatedAt: $updatedAt, themeMode: $themeMode, languageCode: $languageCode, enableNotifications: $enableNotifications, themeColor: $themeColor, customPrimaryColor: $customPrimaryColor, autoSwitchTheme: $autoSwitchTheme, dayThemeStartHour: $dayThemeStartHour, nightThemeStartHour: $nightThemeStartHour, dayThemeColor: $dayThemeColor, nightThemeColor: $nightThemeColor, homeBackgroundImagePath: $homeBackgroundImagePath, focusBackgroundImagePath: $focusBackgroundImagePath, backgroundBlurAmount: $backgroundBlurAmount, backgroundDarkenAmount: $backgroundDarkenAmount, enableBiometricAuth: $enableBiometricAuth, enableFingerprintAuth: $enableFingerprintAuth, enableFaceAuth: $enableFaceAuth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.requirePassword, requirePassword) ||
                other.requirePassword == requirePassword) &&
            (identical(other.passwordHash, passwordHash) ||
                other.passwordHash == passwordHash) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.enableNotifications, enableNotifications) ||
                other.enableNotifications == enableNotifications) &&
            (identical(other.themeColor, themeColor) ||
                other.themeColor == themeColor) &&
            (identical(other.customPrimaryColor, customPrimaryColor) ||
                other.customPrimaryColor == customPrimaryColor) &&
            (identical(other.autoSwitchTheme, autoSwitchTheme) ||
                other.autoSwitchTheme == autoSwitchTheme) &&
            (identical(other.dayThemeStartHour, dayThemeStartHour) ||
                other.dayThemeStartHour == dayThemeStartHour) &&
            (identical(other.nightThemeStartHour, nightThemeStartHour) ||
                other.nightThemeStartHour == nightThemeStartHour) &&
            (identical(other.dayThemeColor, dayThemeColor) ||
                other.dayThemeColor == dayThemeColor) &&
            (identical(other.nightThemeColor, nightThemeColor) ||
                other.nightThemeColor == nightThemeColor) &&
            (identical(
                    other.homeBackgroundImagePath, homeBackgroundImagePath) ||
                other.homeBackgroundImagePath == homeBackgroundImagePath) &&
            (identical(
                    other.focusBackgroundImagePath, focusBackgroundImagePath) ||
                other.focusBackgroundImagePath == focusBackgroundImagePath) &&
            (identical(other.backgroundBlurAmount, backgroundBlurAmount) ||
                other.backgroundBlurAmount == backgroundBlurAmount) &&
            (identical(other.backgroundDarkenAmount, backgroundDarkenAmount) ||
                other.backgroundDarkenAmount == backgroundDarkenAmount) &&
            (identical(other.enableBiometricAuth, enableBiometricAuth) ||
                other.enableBiometricAuth == enableBiometricAuth) &&
            (identical(other.enableFingerprintAuth, enableFingerprintAuth) ||
                other.enableFingerprintAuth == enableFingerprintAuth) &&
            (identical(other.enableFaceAuth, enableFaceAuth) ||
                other.enableFaceAuth == enableFaceAuth));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        requirePassword,
        passwordHash,
        updatedAt,
        themeMode,
        languageCode,
        enableNotifications,
        themeColor,
        customPrimaryColor,
        autoSwitchTheme,
        dayThemeStartHour,
        nightThemeStartHour,
        dayThemeColor,
        nightThemeColor,
        homeBackgroundImagePath,
        focusBackgroundImagePath,
        backgroundBlurAmount,
        backgroundDarkenAmount,
        enableBiometricAuth,
        enableFingerprintAuth,
        enableFaceAuth
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings extends AppSettings {
  const factory _AppSettings(
      {@HiveField(0) final bool requirePassword,
      @HiveField(1) final String passwordHash,
      @HiveField(2) final DateTime? updatedAt,
      @HiveField(3) final AppThemeMode themeMode,
      @HiveField(4) final String? languageCode,
      @HiveField(5) final bool enableNotifications,
      @HiveField(6) final AppThemeColor themeColor,
      @HiveField(7) final int? customPrimaryColor,
      @HiveField(8) final bool autoSwitchTheme,
      @HiveField(9) final int dayThemeStartHour,
      @HiveField(10) final int nightThemeStartHour,
      @HiveField(11) final AppThemeColor? dayThemeColor,
      @HiveField(12) final AppThemeColor? nightThemeColor,
      @HiveField(13) final String? homeBackgroundImagePath,
      @HiveField(14) final String? focusBackgroundImagePath,
      @HiveField(15) final double backgroundBlurAmount,
      @HiveField(16) final double backgroundDarkenAmount,
      @HiveField(17) final bool enableBiometricAuth,
      @HiveField(18) final bool enableFingerprintAuth,
      @HiveField(19) final bool enableFaceAuth}) = _$AppSettingsImpl;
  const _AppSettings._() : super._();

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  @HiveField(0)
  bool get requirePassword;
  @override
  @HiveField(1)
  String get passwordHash;
  @override
  @HiveField(2)
  DateTime? get updatedAt;
  @override
  @HiveField(3)
  AppThemeMode get themeMode;
  @override // 已经是浅色模式
  @HiveField(4)
  String? get languageCode;
  @override
  @HiveField(5)
  bool get enableNotifications;
  @override
  @HiveField(6)
  AppThemeColor get themeColor;
  @override
  @HiveField(7)
  int? get customPrimaryColor;
  @override
  @HiveField(8)
  bool get autoSwitchTheme;
  @override // 自动切换主题
  @HiveField(9)
  int get dayThemeStartHour;
  @override // 日间主题开始时间（6:00）
  @HiveField(10)
  int get nightThemeStartHour;
  @override // 夜间主题开始时间（18:00）
  @HiveField(11)
  AppThemeColor? get dayThemeColor;
  @override // 日间主题颜色
  @HiveField(12)
  AppThemeColor? get nightThemeColor;
  @override // 夜间主题颜色
  @HiveField(13)
  String? get homeBackgroundImagePath;
  @override // 首页背景图片路径
  @HiveField(14)
  String? get focusBackgroundImagePath;
  @override // 专注模式背景图片路径
  @HiveField(15)
  double get backgroundBlurAmount;
  @override // 背景模糊程度 0-1
  @HiveField(16)
  double get backgroundDarkenAmount;
  @override // 背景暗化程度 0-1
  @HiveField(17)
  bool get enableBiometricAuth;
  @override // 启用生物识别认证（已废弃）
  @HiveField(18)
  bool get enableFingerprintAuth;
  @override // 启用指纹识别
  @HiveField(19)
  bool get enableFaceAuth;
  @override
  @JsonKey(ignore: true)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
