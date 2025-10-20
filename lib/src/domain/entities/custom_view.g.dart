// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_view.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FilterConditionAdapter extends TypeAdapter<FilterCondition> {
  @override
  final int typeId = 31;

  @override
  FilterCondition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FilterCondition(
      field: fields[0] as FilterField,
      operator: fields[1] as FilterOperator,
      value: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FilterCondition obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.field)
      ..writeByte(1)
      ..write(obj.operator)
      ..writeByte(2)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SortConfigAdapter extends TypeAdapter<SortConfig> {
  @override
  final int typeId = 33;

  @override
  SortConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SortConfig(
      field: fields[0] as FilterField,
      order: fields[1] as SortOrder,
    );
  }

  @override
  void write(BinaryWriter writer, SortConfig obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.field)
      ..writeByte(1)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CustomViewAdapter extends TypeAdapter<CustomView> {
  @override
  final int typeId = 34;

  @override
  CustomView read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomView(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[3] as ViewType,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      description: fields[2] as String?,
      filters: (fields[4] as List).cast<FilterCondition>(),
      sortConfig: fields[5] as SortConfig?,
      isFavorite: fields[6] as bool,
      icon: fields[7] as String?,
      color: fields[8] as String?,
      sortOrder: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CustomView obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.filters)
      ..writeByte(5)
      ..write(obj.sortConfig)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.icon)
      ..writeByte(8)
      ..write(obj.color)
      ..writeByte(11)
      ..write(obj.sortOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomViewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ViewTypeAdapter extends TypeAdapter<ViewType> {
  @override
  final int typeId = 28;

  @override
  ViewType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ViewType.custom;
      case 1:
        return ViewType.smart;
      default:
        return ViewType.custom;
    }
  }

  @override
  void write(BinaryWriter writer, ViewType obj) {
    switch (obj) {
      case ViewType.custom:
        writer.writeByte(0);
        break;
      case ViewType.smart:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ViewTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FilterOperatorAdapter extends TypeAdapter<FilterOperator> {
  @override
  final int typeId = 29;

  @override
  FilterOperator read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FilterOperator.equals;
      case 1:
        return FilterOperator.notEquals;
      case 2:
        return FilterOperator.contains;
      case 3:
        return FilterOperator.notContains;
      case 4:
        return FilterOperator.greaterThan;
      case 5:
        return FilterOperator.lessThan;
      case 6:
        return FilterOperator.isNull;
      case 7:
        return FilterOperator.isNotNull;
      default:
        return FilterOperator.equals;
    }
  }

  @override
  void write(BinaryWriter writer, FilterOperator obj) {
    switch (obj) {
      case FilterOperator.equals:
        writer.writeByte(0);
        break;
      case FilterOperator.notEquals:
        writer.writeByte(1);
        break;
      case FilterOperator.contains:
        writer.writeByte(2);
        break;
      case FilterOperator.notContains:
        writer.writeByte(3);
        break;
      case FilterOperator.greaterThan:
        writer.writeByte(4);
        break;
      case FilterOperator.lessThan:
        writer.writeByte(5);
        break;
      case FilterOperator.isNull:
        writer.writeByte(6);
        break;
      case FilterOperator.isNotNull:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterOperatorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FilterFieldAdapter extends TypeAdapter<FilterField> {
  @override
  final int typeId = 30;

  @override
  FilterField read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FilterField.status;
      case 1:
        return FilterField.priority;
      case 2:
        return FilterField.dueDate;
      case 3:
        return FilterField.tags;
      case 4:
        return FilterField.list;
      case 5:
        return FilterField.title;
      case 6:
        return FilterField.hasAttachments;
      case 7:
        return FilterField.hasReminder;
      case 8:
        return FilterField.createdDate;
      case 9:
        return FilterField.completedDate;
      default:
        return FilterField.status;
    }
  }

  @override
  void write(BinaryWriter writer, FilterField obj) {
    switch (obj) {
      case FilterField.status:
        writer.writeByte(0);
        break;
      case FilterField.priority:
        writer.writeByte(1);
        break;
      case FilterField.dueDate:
        writer.writeByte(2);
        break;
      case FilterField.tags:
        writer.writeByte(3);
        break;
      case FilterField.list:
        writer.writeByte(4);
        break;
      case FilterField.title:
        writer.writeByte(5);
        break;
      case FilterField.hasAttachments:
        writer.writeByte(6);
        break;
      case FilterField.hasReminder:
        writer.writeByte(7);
        break;
      case FilterField.createdDate:
        writer.writeByte(8);
        break;
      case FilterField.completedDate:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterFieldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SortOrderAdapter extends TypeAdapter<SortOrder> {
  @override
  final int typeId = 32;

  @override
  SortOrder read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SortOrder.ascending;
      case 1:
        return SortOrder.descending;
      default:
        return SortOrder.ascending;
    }
  }

  @override
  void write(BinaryWriter writer, SortOrder obj) {
    switch (obj) {
      case SortOrder.ascending:
        writer.writeByte(0);
        break;
      case SortOrder.descending:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FilterConditionImpl _$$FilterConditionImplFromJson(
        Map<String, dynamic> json) =>
    _$FilterConditionImpl(
      field: $enumDecode(_$FilterFieldEnumMap, json['field']),
      operator: $enumDecode(_$FilterOperatorEnumMap, json['operator']),
      value: json['value'] as String?,
    );

Map<String, dynamic> _$$FilterConditionImplToJson(
        _$FilterConditionImpl instance) =>
    <String, dynamic>{
      'field': _$FilterFieldEnumMap[instance.field]!,
      'operator': _$FilterOperatorEnumMap[instance.operator]!,
      'value': instance.value,
    };

const _$FilterFieldEnumMap = {
  FilterField.status: 'status',
  FilterField.priority: 'priority',
  FilterField.dueDate: 'dueDate',
  FilterField.tags: 'tags',
  FilterField.list: 'list',
  FilterField.title: 'title',
  FilterField.hasAttachments: 'hasAttachments',
  FilterField.hasReminder: 'hasReminder',
  FilterField.createdDate: 'createdDate',
  FilterField.completedDate: 'completedDate',
};

const _$FilterOperatorEnumMap = {
  FilterOperator.equals: 'equals',
  FilterOperator.notEquals: 'notEquals',
  FilterOperator.contains: 'contains',
  FilterOperator.notContains: 'notContains',
  FilterOperator.greaterThan: 'greaterThan',
  FilterOperator.lessThan: 'lessThan',
  FilterOperator.isNull: 'isNull',
  FilterOperator.isNotNull: 'isNotNull',
};

_$SortConfigImpl _$$SortConfigImplFromJson(Map<String, dynamic> json) =>
    _$SortConfigImpl(
      field: $enumDecode(_$FilterFieldEnumMap, json['field']),
      order: $enumDecodeNullable(_$SortOrderEnumMap, json['order']) ??
          SortOrder.ascending,
    );

Map<String, dynamic> _$$SortConfigImplToJson(_$SortConfigImpl instance) =>
    <String, dynamic>{
      'field': _$FilterFieldEnumMap[instance.field]!,
      'order': _$SortOrderEnumMap[instance.order]!,
    };

const _$SortOrderEnumMap = {
  SortOrder.ascending: 'ascending',
  SortOrder.descending: 'descending',
};

_$CustomViewImpl _$$CustomViewImplFromJson(Map<String, dynamic> json) =>
    _$CustomViewImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$ViewTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      description: json['description'] as String?,
      filters: (json['filters'] as List<dynamic>?)
              ?.map((e) => FilterCondition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      sortConfig: json['sortConfig'] == null
          ? null
          : SortConfig.fromJson(json['sortConfig'] as Map<String, dynamic>),
      isFavorite: json['isFavorite'] as bool? ?? false,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CustomViewImplToJson(_$CustomViewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$ViewTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'description': instance.description,
      'filters': instance.filters,
      'sortConfig': instance.sortConfig,
      'isFavorite': instance.isFavorite,
      'icon': instance.icon,
      'color': instance.color,
      'sortOrder': instance.sortOrder,
    };

const _$ViewTypeEnumMap = {
  ViewType.custom: 'custom',
  ViewType.smart: 'smart',
};
