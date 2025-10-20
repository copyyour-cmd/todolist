// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomColorConfigAdapter extends TypeAdapter<CustomColorConfig> {
  @override
  final int typeId = 27;

  @override
  CustomColorConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomColorConfig(
      primaryColor: fields[0] as int,
      secondaryColor: fields[1] as int,
      tertiaryColor: fields[2] as int?,
      errorColor: fields[3] as int?,
      surfaceColor: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomColorConfig obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.primaryColor)
      ..writeByte(1)
      ..write(obj.secondaryColor)
      ..writeByte(2)
      ..write(obj.tertiaryColor)
      ..writeByte(3)
      ..write(obj.errorColor)
      ..writeByte(4)
      ..write(obj.surfaceColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomColorConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemeConfigAdapter extends TypeAdapter<ThemeConfig> {
  @override
  final int typeId = 23;

  @override
  ThemeConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeConfig(
      colorScheme: fields[0] as ColorSchemePreset,
      customColors: fields[1] as CustomColorConfig?,
      fontSize: fields[2] as FontSizePreset,
      cardStyle: fields[3] as TaskCardStyle,
      useMaterialYou: fields[4] as bool,
      useSystemAccentColor: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeConfig obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.colorScheme)
      ..writeByte(1)
      ..write(obj.customColors)
      ..writeByte(2)
      ..write(obj.fontSize)
      ..writeByte(3)
      ..write(obj.cardStyle)
      ..writeByte(4)
      ..write(obj.useMaterialYou)
      ..writeByte(5)
      ..write(obj.useSystemAccentColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FontSizePresetAdapter extends TypeAdapter<FontSizePreset> {
  @override
  final int typeId = 24;

  @override
  FontSizePreset read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FontSizePreset.small;
      case 1:
        return FontSizePreset.medium;
      case 2:
        return FontSizePreset.large;
      case 3:
        return FontSizePreset.extraLarge;
      default:
        return FontSizePreset.small;
    }
  }

  @override
  void write(BinaryWriter writer, FontSizePreset obj) {
    switch (obj) {
      case FontSizePreset.small:
        writer.writeByte(0);
        break;
      case FontSizePreset.medium:
        writer.writeByte(1);
        break;
      case FontSizePreset.large:
        writer.writeByte(2);
        break;
      case FontSizePreset.extraLarge:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FontSizePresetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskCardStyleAdapter extends TypeAdapter<TaskCardStyle> {
  @override
  final int typeId = 25;

  @override
  TaskCardStyle read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskCardStyle.compact;
      case 1:
        return TaskCardStyle.comfortable;
      case 2:
        return TaskCardStyle.spacious;
      default:
        return TaskCardStyle.compact;
    }
  }

  @override
  void write(BinaryWriter writer, TaskCardStyle obj) {
    switch (obj) {
      case TaskCardStyle.compact:
        writer.writeByte(0);
        break;
      case TaskCardStyle.comfortable:
        writer.writeByte(1);
        break;
      case TaskCardStyle.spacious:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskCardStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ColorSchemePresetAdapter extends TypeAdapter<ColorSchemePreset> {
  @override
  final int typeId = 26;

  @override
  ColorSchemePreset read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ColorSchemePreset.blue;
      case 1:
        return ColorSchemePreset.indigo;
      case 2:
        return ColorSchemePreset.purple;
      case 3:
        return ColorSchemePreset.pink;
      case 4:
        return ColorSchemePreset.red;
      case 5:
        return ColorSchemePreset.orange;
      case 6:
        return ColorSchemePreset.green;
      case 7:
        return ColorSchemePreset.teal;
      case 8:
        return ColorSchemePreset.custom;
      default:
        return ColorSchemePreset.blue;
    }
  }

  @override
  void write(BinaryWriter writer, ColorSchemePreset obj) {
    switch (obj) {
      case ColorSchemePreset.blue:
        writer.writeByte(0);
        break;
      case ColorSchemePreset.indigo:
        writer.writeByte(1);
        break;
      case ColorSchemePreset.purple:
        writer.writeByte(2);
        break;
      case ColorSchemePreset.pink:
        writer.writeByte(3);
        break;
      case ColorSchemePreset.red:
        writer.writeByte(4);
        break;
      case ColorSchemePreset.orange:
        writer.writeByte(5);
        break;
      case ColorSchemePreset.green:
        writer.writeByte(6);
        break;
      case ColorSchemePreset.teal:
        writer.writeByte(7);
        break;
      case ColorSchemePreset.custom:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorSchemePresetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomColorConfigImpl _$$CustomColorConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$CustomColorConfigImpl(
      primaryColor: (json['primaryColor'] as num).toInt(),
      secondaryColor: (json['secondaryColor'] as num).toInt(),
      tertiaryColor: (json['tertiaryColor'] as num?)?.toInt(),
      errorColor: (json['errorColor'] as num?)?.toInt(),
      surfaceColor: (json['surfaceColor'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CustomColorConfigImplToJson(
        _$CustomColorConfigImpl instance) =>
    <String, dynamic>{
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'tertiaryColor': instance.tertiaryColor,
      'errorColor': instance.errorColor,
      'surfaceColor': instance.surfaceColor,
    };

_$ThemeConfigImpl _$$ThemeConfigImplFromJson(Map<String, dynamic> json) =>
    _$ThemeConfigImpl(
      colorScheme: $enumDecodeNullable(
              _$ColorSchemePresetEnumMap, json['colorScheme']) ??
          ColorSchemePreset.blue,
      customColors: json['customColors'] == null
          ? null
          : CustomColorConfig.fromJson(
              json['customColors'] as Map<String, dynamic>),
      fontSize:
          $enumDecodeNullable(_$FontSizePresetEnumMap, json['fontSize']) ??
              FontSizePreset.medium,
      cardStyle:
          $enumDecodeNullable(_$TaskCardStyleEnumMap, json['cardStyle']) ??
              TaskCardStyle.comfortable,
      useMaterialYou: json['useMaterialYou'] as bool? ?? true,
      useSystemAccentColor: json['useSystemAccentColor'] as bool? ?? true,
    );

Map<String, dynamic> _$$ThemeConfigImplToJson(_$ThemeConfigImpl instance) =>
    <String, dynamic>{
      'colorScheme': _$ColorSchemePresetEnumMap[instance.colorScheme]!,
      'customColors': instance.customColors,
      'fontSize': _$FontSizePresetEnumMap[instance.fontSize]!,
      'cardStyle': _$TaskCardStyleEnumMap[instance.cardStyle]!,
      'useMaterialYou': instance.useMaterialYou,
      'useSystemAccentColor': instance.useSystemAccentColor,
    };

const _$ColorSchemePresetEnumMap = {
  ColorSchemePreset.blue: 'blue',
  ColorSchemePreset.indigo: 'indigo',
  ColorSchemePreset.purple: 'purple',
  ColorSchemePreset.pink: 'pink',
  ColorSchemePreset.red: 'red',
  ColorSchemePreset.orange: 'orange',
  ColorSchemePreset.green: 'green',
  ColorSchemePreset.teal: 'teal',
  ColorSchemePreset.custom: 'custom',
};

const _$FontSizePresetEnumMap = {
  FontSizePreset.small: 'small',
  FontSizePreset.medium: 'medium',
  FontSizePreset.large: 'large',
  FontSizePreset.extraLarge: 'extraLarge',
};

const _$TaskCardStyleEnumMap = {
  TaskCardStyle.compact: 'compact',
  TaskCardStyle.comfortable: 'comfortable',
  TaskCardStyle.spacious: 'spacious',
};
