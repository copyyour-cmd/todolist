// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CustomColorConfig _$CustomColorConfigFromJson(Map<String, dynamic> json) {
  return _CustomColorConfig.fromJson(json);
}

/// @nodoc
mixin _$CustomColorConfig {
  @HiveField(0)
  int get primaryColor => throw _privateConstructorUsedError;
  @HiveField(1)
  int get secondaryColor => throw _privateConstructorUsedError;
  @HiveField(2)
  int? get tertiaryColor => throw _privateConstructorUsedError;
  @HiveField(3)
  int? get errorColor => throw _privateConstructorUsedError;
  @HiveField(4)
  int? get surfaceColor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomColorConfigCopyWith<CustomColorConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomColorConfigCopyWith<$Res> {
  factory $CustomColorConfigCopyWith(
          CustomColorConfig value, $Res Function(CustomColorConfig) then) =
      _$CustomColorConfigCopyWithImpl<$Res, CustomColorConfig>;
  @useResult
  $Res call(
      {@HiveField(0) int primaryColor,
      @HiveField(1) int secondaryColor,
      @HiveField(2) int? tertiaryColor,
      @HiveField(3) int? errorColor,
      @HiveField(4) int? surfaceColor});
}

/// @nodoc
class _$CustomColorConfigCopyWithImpl<$Res, $Val extends CustomColorConfig>
    implements $CustomColorConfigCopyWith<$Res> {
  _$CustomColorConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryColor = null,
    Object? secondaryColor = null,
    Object? tertiaryColor = freezed,
    Object? errorColor = freezed,
    Object? surfaceColor = freezed,
  }) {
    return _then(_value.copyWith(
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as int,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as int,
      tertiaryColor: freezed == tertiaryColor
          ? _value.tertiaryColor
          : tertiaryColor // ignore: cast_nullable_to_non_nullable
              as int?,
      errorColor: freezed == errorColor
          ? _value.errorColor
          : errorColor // ignore: cast_nullable_to_non_nullable
              as int?,
      surfaceColor: freezed == surfaceColor
          ? _value.surfaceColor
          : surfaceColor // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomColorConfigImplCopyWith<$Res>
    implements $CustomColorConfigCopyWith<$Res> {
  factory _$$CustomColorConfigImplCopyWith(_$CustomColorConfigImpl value,
          $Res Function(_$CustomColorConfigImpl) then) =
      __$$CustomColorConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int primaryColor,
      @HiveField(1) int secondaryColor,
      @HiveField(2) int? tertiaryColor,
      @HiveField(3) int? errorColor,
      @HiveField(4) int? surfaceColor});
}

/// @nodoc
class __$$CustomColorConfigImplCopyWithImpl<$Res>
    extends _$CustomColorConfigCopyWithImpl<$Res, _$CustomColorConfigImpl>
    implements _$$CustomColorConfigImplCopyWith<$Res> {
  __$$CustomColorConfigImplCopyWithImpl(_$CustomColorConfigImpl _value,
      $Res Function(_$CustomColorConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryColor = null,
    Object? secondaryColor = null,
    Object? tertiaryColor = freezed,
    Object? errorColor = freezed,
    Object? surfaceColor = freezed,
  }) {
    return _then(_$CustomColorConfigImpl(
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as int,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as int,
      tertiaryColor: freezed == tertiaryColor
          ? _value.tertiaryColor
          : tertiaryColor // ignore: cast_nullable_to_non_nullable
              as int?,
      errorColor: freezed == errorColor
          ? _value.errorColor
          : errorColor // ignore: cast_nullable_to_non_nullable
              as int?,
      surfaceColor: freezed == surfaceColor
          ? _value.surfaceColor
          : surfaceColor // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomColorConfigImpl extends _CustomColorConfig {
  const _$CustomColorConfigImpl(
      {@HiveField(0) required this.primaryColor,
      @HiveField(1) required this.secondaryColor,
      @HiveField(2) this.tertiaryColor,
      @HiveField(3) this.errorColor,
      @HiveField(4) this.surfaceColor})
      : super._();

  factory _$CustomColorConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomColorConfigImplFromJson(json);

  @override
  @HiveField(0)
  final int primaryColor;
  @override
  @HiveField(1)
  final int secondaryColor;
  @override
  @HiveField(2)
  final int? tertiaryColor;
  @override
  @HiveField(3)
  final int? errorColor;
  @override
  @HiveField(4)
  final int? surfaceColor;

  @override
  String toString() {
    return 'CustomColorConfig(primaryColor: $primaryColor, secondaryColor: $secondaryColor, tertiaryColor: $tertiaryColor, errorColor: $errorColor, surfaceColor: $surfaceColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomColorConfigImpl &&
            (identical(other.primaryColor, primaryColor) ||
                other.primaryColor == primaryColor) &&
            (identical(other.secondaryColor, secondaryColor) ||
                other.secondaryColor == secondaryColor) &&
            (identical(other.tertiaryColor, tertiaryColor) ||
                other.tertiaryColor == tertiaryColor) &&
            (identical(other.errorColor, errorColor) ||
                other.errorColor == errorColor) &&
            (identical(other.surfaceColor, surfaceColor) ||
                other.surfaceColor == surfaceColor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, primaryColor, secondaryColor,
      tertiaryColor, errorColor, surfaceColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomColorConfigImplCopyWith<_$CustomColorConfigImpl> get copyWith =>
      __$$CustomColorConfigImplCopyWithImpl<_$CustomColorConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomColorConfigImplToJson(
      this,
    );
  }
}

abstract class _CustomColorConfig extends CustomColorConfig {
  const factory _CustomColorConfig(
      {@HiveField(0) required final int primaryColor,
      @HiveField(1) required final int secondaryColor,
      @HiveField(2) final int? tertiaryColor,
      @HiveField(3) final int? errorColor,
      @HiveField(4) final int? surfaceColor}) = _$CustomColorConfigImpl;
  const _CustomColorConfig._() : super._();

  factory _CustomColorConfig.fromJson(Map<String, dynamic> json) =
      _$CustomColorConfigImpl.fromJson;

  @override
  @HiveField(0)
  int get primaryColor;
  @override
  @HiveField(1)
  int get secondaryColor;
  @override
  @HiveField(2)
  int? get tertiaryColor;
  @override
  @HiveField(3)
  int? get errorColor;
  @override
  @HiveField(4)
  int? get surfaceColor;
  @override
  @JsonKey(ignore: true)
  _$$CustomColorConfigImplCopyWith<_$CustomColorConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ThemeConfig _$ThemeConfigFromJson(Map<String, dynamic> json) {
  return _ThemeConfig.fromJson(json);
}

/// @nodoc
mixin _$ThemeConfig {
  @HiveField(0)
  ColorSchemePreset get colorScheme => throw _privateConstructorUsedError;
  @HiveField(1)
  CustomColorConfig? get customColors => throw _privateConstructorUsedError;
  @HiveField(2)
  FontSizePreset get fontSize => throw _privateConstructorUsedError;
  @HiveField(3)
  TaskCardStyle get cardStyle => throw _privateConstructorUsedError;
  @HiveField(4)
  bool get useMaterialYou => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get useSystemAccentColor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThemeConfigCopyWith<ThemeConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeConfigCopyWith<$Res> {
  factory $ThemeConfigCopyWith(
          ThemeConfig value, $Res Function(ThemeConfig) then) =
      _$ThemeConfigCopyWithImpl<$Res, ThemeConfig>;
  @useResult
  $Res call(
      {@HiveField(0) ColorSchemePreset colorScheme,
      @HiveField(1) CustomColorConfig? customColors,
      @HiveField(2) FontSizePreset fontSize,
      @HiveField(3) TaskCardStyle cardStyle,
      @HiveField(4) bool useMaterialYou,
      @HiveField(5) bool useSystemAccentColor});

  $CustomColorConfigCopyWith<$Res>? get customColors;
}

/// @nodoc
class _$ThemeConfigCopyWithImpl<$Res, $Val extends ThemeConfig>
    implements $ThemeConfigCopyWith<$Res> {
  _$ThemeConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? colorScheme = null,
    Object? customColors = freezed,
    Object? fontSize = null,
    Object? cardStyle = null,
    Object? useMaterialYou = null,
    Object? useSystemAccentColor = null,
  }) {
    return _then(_value.copyWith(
      colorScheme: null == colorScheme
          ? _value.colorScheme
          : colorScheme // ignore: cast_nullable_to_non_nullable
              as ColorSchemePreset,
      customColors: freezed == customColors
          ? _value.customColors
          : customColors // ignore: cast_nullable_to_non_nullable
              as CustomColorConfig?,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as FontSizePreset,
      cardStyle: null == cardStyle
          ? _value.cardStyle
          : cardStyle // ignore: cast_nullable_to_non_nullable
              as TaskCardStyle,
      useMaterialYou: null == useMaterialYou
          ? _value.useMaterialYou
          : useMaterialYou // ignore: cast_nullable_to_non_nullable
              as bool,
      useSystemAccentColor: null == useSystemAccentColor
          ? _value.useSystemAccentColor
          : useSystemAccentColor // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CustomColorConfigCopyWith<$Res>? get customColors {
    if (_value.customColors == null) {
      return null;
    }

    return $CustomColorConfigCopyWith<$Res>(_value.customColors!, (value) {
      return _then(_value.copyWith(customColors: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ThemeConfigImplCopyWith<$Res>
    implements $ThemeConfigCopyWith<$Res> {
  factory _$$ThemeConfigImplCopyWith(
          _$ThemeConfigImpl value, $Res Function(_$ThemeConfigImpl) then) =
      __$$ThemeConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) ColorSchemePreset colorScheme,
      @HiveField(1) CustomColorConfig? customColors,
      @HiveField(2) FontSizePreset fontSize,
      @HiveField(3) TaskCardStyle cardStyle,
      @HiveField(4) bool useMaterialYou,
      @HiveField(5) bool useSystemAccentColor});

  @override
  $CustomColorConfigCopyWith<$Res>? get customColors;
}

/// @nodoc
class __$$ThemeConfigImplCopyWithImpl<$Res>
    extends _$ThemeConfigCopyWithImpl<$Res, _$ThemeConfigImpl>
    implements _$$ThemeConfigImplCopyWith<$Res> {
  __$$ThemeConfigImplCopyWithImpl(
      _$ThemeConfigImpl _value, $Res Function(_$ThemeConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? colorScheme = null,
    Object? customColors = freezed,
    Object? fontSize = null,
    Object? cardStyle = null,
    Object? useMaterialYou = null,
    Object? useSystemAccentColor = null,
  }) {
    return _then(_$ThemeConfigImpl(
      colorScheme: null == colorScheme
          ? _value.colorScheme
          : colorScheme // ignore: cast_nullable_to_non_nullable
              as ColorSchemePreset,
      customColors: freezed == customColors
          ? _value.customColors
          : customColors // ignore: cast_nullable_to_non_nullable
              as CustomColorConfig?,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as FontSizePreset,
      cardStyle: null == cardStyle
          ? _value.cardStyle
          : cardStyle // ignore: cast_nullable_to_non_nullable
              as TaskCardStyle,
      useMaterialYou: null == useMaterialYou
          ? _value.useMaterialYou
          : useMaterialYou // ignore: cast_nullable_to_non_nullable
              as bool,
      useSystemAccentColor: null == useSystemAccentColor
          ? _value.useSystemAccentColor
          : useSystemAccentColor // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThemeConfigImpl extends _ThemeConfig {
  const _$ThemeConfigImpl(
      {@HiveField(0) this.colorScheme = ColorSchemePreset.blue,
      @HiveField(1) this.customColors,
      @HiveField(2) this.fontSize = FontSizePreset.medium,
      @HiveField(3) this.cardStyle = TaskCardStyle.comfortable,
      @HiveField(4) this.useMaterialYou = true,
      @HiveField(5) this.useSystemAccentColor = true})
      : super._();

  factory _$ThemeConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThemeConfigImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final ColorSchemePreset colorScheme;
  @override
  @HiveField(1)
  final CustomColorConfig? customColors;
  @override
  @JsonKey()
  @HiveField(2)
  final FontSizePreset fontSize;
  @override
  @JsonKey()
  @HiveField(3)
  final TaskCardStyle cardStyle;
  @override
  @JsonKey()
  @HiveField(4)
  final bool useMaterialYou;
  @override
  @JsonKey()
  @HiveField(5)
  final bool useSystemAccentColor;

  @override
  String toString() {
    return 'ThemeConfig(colorScheme: $colorScheme, customColors: $customColors, fontSize: $fontSize, cardStyle: $cardStyle, useMaterialYou: $useMaterialYou, useSystemAccentColor: $useSystemAccentColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeConfigImpl &&
            (identical(other.colorScheme, colorScheme) ||
                other.colorScheme == colorScheme) &&
            (identical(other.customColors, customColors) ||
                other.customColors == customColors) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.cardStyle, cardStyle) ||
                other.cardStyle == cardStyle) &&
            (identical(other.useMaterialYou, useMaterialYou) ||
                other.useMaterialYou == useMaterialYou) &&
            (identical(other.useSystemAccentColor, useSystemAccentColor) ||
                other.useSystemAccentColor == useSystemAccentColor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, colorScheme, customColors,
      fontSize, cardStyle, useMaterialYou, useSystemAccentColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeConfigImplCopyWith<_$ThemeConfigImpl> get copyWith =>
      __$$ThemeConfigImplCopyWithImpl<_$ThemeConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThemeConfigImplToJson(
      this,
    );
  }
}

abstract class _ThemeConfig extends ThemeConfig {
  const factory _ThemeConfig(
      {@HiveField(0) final ColorSchemePreset colorScheme,
      @HiveField(1) final CustomColorConfig? customColors,
      @HiveField(2) final FontSizePreset fontSize,
      @HiveField(3) final TaskCardStyle cardStyle,
      @HiveField(4) final bool useMaterialYou,
      @HiveField(5) final bool useSystemAccentColor}) = _$ThemeConfigImpl;
  const _ThemeConfig._() : super._();

  factory _ThemeConfig.fromJson(Map<String, dynamic> json) =
      _$ThemeConfigImpl.fromJson;

  @override
  @HiveField(0)
  ColorSchemePreset get colorScheme;
  @override
  @HiveField(1)
  CustomColorConfig? get customColors;
  @override
  @HiveField(2)
  FontSizePreset get fontSize;
  @override
  @HiveField(3)
  TaskCardStyle get cardStyle;
  @override
  @HiveField(4)
  bool get useMaterialYou;
  @override
  @HiveField(5)
  bool get useSystemAccentColor;
  @override
  @JsonKey(ignore: true)
  _$$ThemeConfigImplCopyWith<_$ThemeConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
