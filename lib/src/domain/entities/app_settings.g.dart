// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 20;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      requirePassword: fields[0] as bool,
      passwordHash: fields[1] as String,
      updatedAt: fields[2] as DateTime?,
      themeMode: fields[3] as AppThemeMode,
      languageCode: fields[4] as String?,
      enableNotifications: fields[5] as bool,
      themeColor: fields[6] as AppThemeColor,
      customPrimaryColor: fields[7] as int?,
      autoSwitchTheme: fields[8] as bool,
      dayThemeStartHour: fields[9] as int,
      nightThemeStartHour: fields[10] as int,
      dayThemeColor: fields[11] as AppThemeColor?,
      nightThemeColor: fields[12] as AppThemeColor?,
      homeBackgroundImagePath: fields[13] as String?,
      focusBackgroundImagePath: fields[14] as String?,
      backgroundBlurAmount: fields[15] as double,
      backgroundDarkenAmount: fields[16] as double,
      enableBiometricAuth: fields[17] as bool,
      enableFingerprintAuth: fields[18] as bool,
      enableFaceAuth: fields[19] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.requirePassword)
      ..writeByte(1)
      ..write(obj.passwordHash)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.themeMode)
      ..writeByte(4)
      ..write(obj.languageCode)
      ..writeByte(5)
      ..write(obj.enableNotifications)
      ..writeByte(6)
      ..write(obj.themeColor)
      ..writeByte(7)
      ..write(obj.customPrimaryColor)
      ..writeByte(8)
      ..write(obj.autoSwitchTheme)
      ..writeByte(9)
      ..write(obj.dayThemeStartHour)
      ..writeByte(10)
      ..write(obj.nightThemeStartHour)
      ..writeByte(11)
      ..write(obj.dayThemeColor)
      ..writeByte(12)
      ..write(obj.nightThemeColor)
      ..writeByte(13)
      ..write(obj.homeBackgroundImagePath)
      ..writeByte(14)
      ..write(obj.focusBackgroundImagePath)
      ..writeByte(15)
      ..write(obj.backgroundBlurAmount)
      ..writeByte(16)
      ..write(obj.backgroundDarkenAmount)
      ..writeByte(17)
      ..write(obj.enableBiometricAuth)
      ..writeByte(18)
      ..write(obj.enableFingerprintAuth)
      ..writeByte(19)
      ..write(obj.enableFaceAuth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppThemeModeAdapter extends TypeAdapter<AppThemeMode> {
  @override
  final int typeId = 21;

  @override
  AppThemeMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppThemeMode.system;
      case 1:
        return AppThemeMode.light;
      case 2:
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }

  @override
  void write(BinaryWriter writer, AppThemeMode obj) {
    switch (obj) {
      case AppThemeMode.system:
        writer.writeByte(0);
        break;
      case AppThemeMode.light:
        writer.writeByte(1);
        break;
      case AppThemeMode.dark:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppThemeColorAdapter extends TypeAdapter<AppThemeColor> {
  @override
  final int typeId = 22;

  @override
  AppThemeColor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppThemeColor.bahamaBlue;
      case 1:
        return AppThemeColor.purple;
      case 2:
        return AppThemeColor.green;
      case 3:
        return AppThemeColor.orange;
      case 4:
        return AppThemeColor.pink;
      case 5:
        return AppThemeColor.teal;
      case 6:
        return AppThemeColor.indigo;
      case 7:
        return AppThemeColor.amber;
      case 8:
        return AppThemeColor.custom;
      case 9:
        return AppThemeColor.eyeCareGreen;
      case 10:
        return AppThemeColor.deepBlue;
      case 11:
        return AppThemeColor.lavender;
      case 12:
        return AppThemeColor.mintGreen;
      case 13:
        return AppThemeColor.sunset;
      case 14:
        return AppThemeColor.ocean;
      default:
        return AppThemeColor.bahamaBlue;
    }
  }

  @override
  void write(BinaryWriter writer, AppThemeColor obj) {
    switch (obj) {
      case AppThemeColor.bahamaBlue:
        writer.writeByte(0);
        break;
      case AppThemeColor.purple:
        writer.writeByte(1);
        break;
      case AppThemeColor.green:
        writer.writeByte(2);
        break;
      case AppThemeColor.orange:
        writer.writeByte(3);
        break;
      case AppThemeColor.pink:
        writer.writeByte(4);
        break;
      case AppThemeColor.teal:
        writer.writeByte(5);
        break;
      case AppThemeColor.indigo:
        writer.writeByte(6);
        break;
      case AppThemeColor.amber:
        writer.writeByte(7);
        break;
      case AppThemeColor.custom:
        writer.writeByte(8);
        break;
      case AppThemeColor.eyeCareGreen:
        writer.writeByte(9);
        break;
      case AppThemeColor.deepBlue:
        writer.writeByte(10);
        break;
      case AppThemeColor.lavender:
        writer.writeByte(11);
        break;
      case AppThemeColor.mintGreen:
        writer.writeByte(12);
        break;
      case AppThemeColor.sunset:
        writer.writeByte(13);
        break;
      case AppThemeColor.ocean:
        writer.writeByte(14);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      requirePassword: json['requirePassword'] as bool? ?? false,
      passwordHash: json['passwordHash'] as String? ?? '',
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      themeMode:
          $enumDecodeNullable(_$AppThemeModeEnumMap, json['themeMode']) ??
              AppThemeMode.light,
      languageCode: json['languageCode'] as String?,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      themeColor:
          $enumDecodeNullable(_$AppThemeColorEnumMap, json['themeColor']) ??
              AppThemeColor.bahamaBlue,
      customPrimaryColor: (json['customPrimaryColor'] as num?)?.toInt(),
      autoSwitchTheme: json['autoSwitchTheme'] as bool? ?? false,
      dayThemeStartHour: (json['dayThemeStartHour'] as num?)?.toInt() ?? 6,
      nightThemeStartHour: (json['nightThemeStartHour'] as num?)?.toInt() ?? 18,
      dayThemeColor:
          $enumDecodeNullable(_$AppThemeColorEnumMap, json['dayThemeColor']),
      nightThemeColor:
          $enumDecodeNullable(_$AppThemeColorEnumMap, json['nightThemeColor']),
      homeBackgroundImagePath: json['homeBackgroundImagePath'] as String?,
      focusBackgroundImagePath: json['focusBackgroundImagePath'] as String?,
      backgroundBlurAmount:
          (json['backgroundBlurAmount'] as num?)?.toDouble() ?? 0.3,
      backgroundDarkenAmount:
          (json['backgroundDarkenAmount'] as num?)?.toDouble() ?? 0.5,
      enableBiometricAuth: json['enableBiometricAuth'] as bool? ?? false,
      enableFingerprintAuth: json['enableFingerprintAuth'] as bool? ?? false,
      enableFaceAuth: json['enableFaceAuth'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'requirePassword': instance.requirePassword,
      'passwordHash': instance.passwordHash,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'themeMode': _$AppThemeModeEnumMap[instance.themeMode]!,
      'languageCode': instance.languageCode,
      'enableNotifications': instance.enableNotifications,
      'themeColor': _$AppThemeColorEnumMap[instance.themeColor]!,
      'customPrimaryColor': instance.customPrimaryColor,
      'autoSwitchTheme': instance.autoSwitchTheme,
      'dayThemeStartHour': instance.dayThemeStartHour,
      'nightThemeStartHour': instance.nightThemeStartHour,
      'dayThemeColor': _$AppThemeColorEnumMap[instance.dayThemeColor],
      'nightThemeColor': _$AppThemeColorEnumMap[instance.nightThemeColor],
      'homeBackgroundImagePath': instance.homeBackgroundImagePath,
      'focusBackgroundImagePath': instance.focusBackgroundImagePath,
      'backgroundBlurAmount': instance.backgroundBlurAmount,
      'backgroundDarkenAmount': instance.backgroundDarkenAmount,
      'enableBiometricAuth': instance.enableBiometricAuth,
      'enableFingerprintAuth': instance.enableFingerprintAuth,
      'enableFaceAuth': instance.enableFaceAuth,
    };

const _$AppThemeModeEnumMap = {
  AppThemeMode.system: 'system',
  AppThemeMode.light: 'light',
  AppThemeMode.dark: 'dark',
};

const _$AppThemeColorEnumMap = {
  AppThemeColor.bahamaBlue: 'bahamaBlue',
  AppThemeColor.purple: 'purple',
  AppThemeColor.green: 'green',
  AppThemeColor.orange: 'orange',
  AppThemeColor.pink: 'pink',
  AppThemeColor.teal: 'teal',
  AppThemeColor.indigo: 'indigo',
  AppThemeColor.amber: 'amber',
  AppThemeColor.custom: 'custom',
  AppThemeColor.eyeCareGreen: 'eyeCareGreen',
  AppThemeColor.deepBlue: 'deepBlue',
  AppThemeColor.lavender: 'lavender',
  AppThemeColor.mintGreen: 'mintGreen',
  AppThemeColor.sunset: 'sunset',
  AppThemeColor.ocean: 'ocean',
};
