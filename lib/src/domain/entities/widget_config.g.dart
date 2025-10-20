// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WidgetConfigAdapter extends TypeAdapter<WidgetConfig> {
  @override
  final int typeId = 35;

  @override
  WidgetConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WidgetConfig(
      size: fields[0] as WidgetSize,
      theme: fields[1] as WidgetTheme,
      maxTasks: fields[2] as int,
      showCompleted: fields[3] as bool,
      showOverdue: fields[4] as bool,
      backgroundColor: fields[5] as int,
      textColor: fields[6] as int,
      showQuickAdd: fields[7] as bool,
      showRefresh: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WidgetConfig obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.size)
      ..writeByte(1)
      ..write(obj.theme)
      ..writeByte(2)
      ..write(obj.maxTasks)
      ..writeByte(3)
      ..write(obj.showCompleted)
      ..writeByte(4)
      ..write(obj.showOverdue)
      ..writeByte(5)
      ..write(obj.backgroundColor)
      ..writeByte(6)
      ..write(obj.textColor)
      ..writeByte(7)
      ..write(obj.showQuickAdd)
      ..writeByte(8)
      ..write(obj.showRefresh);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WidgetSizeAdapter extends TypeAdapter<WidgetSize> {
  @override
  final int typeId = 36;

  @override
  WidgetSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WidgetSize.small;
      case 1:
        return WidgetSize.medium;
      case 2:
        return WidgetSize.large;
      default:
        return WidgetSize.small;
    }
  }

  @override
  void write(BinaryWriter writer, WidgetSize obj) {
    switch (obj) {
      case WidgetSize.small:
        writer.writeByte(0);
        break;
      case WidgetSize.medium:
        writer.writeByte(1);
        break;
      case WidgetSize.large:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WidgetThemeAdapter extends TypeAdapter<WidgetTheme> {
  @override
  final int typeId = 37;

  @override
  WidgetTheme read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WidgetTheme.auto;
      case 1:
        return WidgetTheme.light;
      case 2:
        return WidgetTheme.dark;
      default:
        return WidgetTheme.auto;
    }
  }

  @override
  void write(BinaryWriter writer, WidgetTheme obj) {
    switch (obj) {
      case WidgetTheme.auto:
        writer.writeByte(0);
        break;
      case WidgetTheme.light:
        writer.writeByte(1);
        break;
      case WidgetTheme.dark:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WidgetConfigImpl _$$WidgetConfigImplFromJson(Map<String, dynamic> json) =>
    _$WidgetConfigImpl(
      size: $enumDecodeNullable(_$WidgetSizeEnumMap, json['size']) ??
          WidgetSize.medium,
      theme: $enumDecodeNullable(_$WidgetThemeEnumMap, json['theme']) ??
          WidgetTheme.auto,
      maxTasks: (json['maxTasks'] as num?)?.toInt() ?? 5,
      showCompleted: json['showCompleted'] as bool? ?? true,
      showOverdue: json['showOverdue'] as bool? ?? true,
      backgroundColor: (json['backgroundColor'] as num?)?.toInt() ?? 0xFFFFFFFF,
      textColor: (json['textColor'] as num?)?.toInt() ?? 0xFF000000,
      showQuickAdd: json['showQuickAdd'] as bool? ?? true,
      showRefresh: json['showRefresh'] as bool? ?? true,
    );

Map<String, dynamic> _$$WidgetConfigImplToJson(_$WidgetConfigImpl instance) =>
    <String, dynamic>{
      'size': _$WidgetSizeEnumMap[instance.size]!,
      'theme': _$WidgetThemeEnumMap[instance.theme]!,
      'maxTasks': instance.maxTasks,
      'showCompleted': instance.showCompleted,
      'showOverdue': instance.showOverdue,
      'backgroundColor': instance.backgroundColor,
      'textColor': instance.textColor,
      'showQuickAdd': instance.showQuickAdd,
      'showRefresh': instance.showRefresh,
    };

const _$WidgetSizeEnumMap = {
  WidgetSize.small: 'small',
  WidgetSize.medium: 'medium',
  WidgetSize.large: 'large',
};

const _$WidgetThemeEnumMap = {
  WidgetTheme.auto: 'auto',
  WidgetTheme.light: 'light',
  WidgetTheme.dark: 'dark',
};
