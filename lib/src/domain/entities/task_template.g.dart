// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskTemplateAdapter extends TypeAdapter<TaskTemplate> {
  @override
  final int typeId = 84;

  @override
  TaskTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskTemplate(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[3] as TemplateCategory,
      description: fields[2] as String?,
      priority: fields[4] as TaskPriority,
      estimatedMinutes: fields[5] as int?,
      tags: (fields[6] as List).cast<String>(),
      iconCodePoint: fields[7] as int?,
      isBuiltIn: fields[8] as bool,
      usageCount: fields[9] as int,
      createdAt: fields[10] as DateTime?,
      defaultSubtasks: (fields[11] as List).cast<SubTask>(),
      defaultRecurrence: fields[12] as RecurrenceRule?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskTemplate obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.estimatedMinutes)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.iconCodePoint)
      ..writeByte(8)
      ..write(obj.isBuiltIn)
      ..writeByte(9)
      ..write(obj.usageCount)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.defaultSubtasks)
      ..writeByte(12)
      ..write(obj.defaultRecurrence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TemplateCategoryAdapter extends TypeAdapter<TemplateCategory> {
  @override
  final int typeId = 85;

  @override
  TemplateCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TemplateCategory.fitness;
      case 1:
        return TemplateCategory.work;
      case 2:
        return TemplateCategory.life;
      case 3:
        return TemplateCategory.health;
      case 4:
        return TemplateCategory.social;
      case 5:
        return TemplateCategory.finance;
      case 6:
        return TemplateCategory.cooking;
      case 7:
        return TemplateCategory.learning;
      case 8:
        return TemplateCategory.home;
      case 9:
        return TemplateCategory.creative;
      case 10:
        return TemplateCategory.travel;
      case 11:
        return TemplateCategory.shopping;
      case 12:
        return TemplateCategory.project;
      case 13:
        return TemplateCategory.habit;
      case 14:
        return TemplateCategory.maintenance;
      case 15:
        return TemplateCategory.custom;
      default:
        return TemplateCategory.fitness;
    }
  }

  @override
  void write(BinaryWriter writer, TemplateCategory obj) {
    switch (obj) {
      case TemplateCategory.fitness:
        writer.writeByte(0);
        break;
      case TemplateCategory.work:
        writer.writeByte(1);
        break;
      case TemplateCategory.life:
        writer.writeByte(2);
        break;
      case TemplateCategory.health:
        writer.writeByte(3);
        break;
      case TemplateCategory.social:
        writer.writeByte(4);
        break;
      case TemplateCategory.finance:
        writer.writeByte(5);
        break;
      case TemplateCategory.cooking:
        writer.writeByte(6);
        break;
      case TemplateCategory.learning:
        writer.writeByte(7);
        break;
      case TemplateCategory.home:
        writer.writeByte(8);
        break;
      case TemplateCategory.creative:
        writer.writeByte(9);
        break;
      case TemplateCategory.travel:
        writer.writeByte(10);
        break;
      case TemplateCategory.shopping:
        writer.writeByte(11);
        break;
      case TemplateCategory.project:
        writer.writeByte(12);
        break;
      case TemplateCategory.habit:
        writer.writeByte(13);
        break;
      case TemplateCategory.maintenance:
        writer.writeByte(14);
        break;
      case TemplateCategory.custom:
        writer.writeByte(15);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskTemplateImpl _$$TaskTemplateImplFromJson(Map<String, dynamic> json) =>
    _$TaskTemplateImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      category: $enumDecode(_$TemplateCategoryEnumMap, json['category']),
      description: json['description'] as String?,
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
          TaskPriority.medium,
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      iconCodePoint: (json['iconCodePoint'] as num?)?.toInt(),
      isBuiltIn: json['isBuiltIn'] as bool? ?? false,
      usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      defaultSubtasks: (json['defaultSubtasks'] as List<dynamic>?)
              ?.map((e) => SubTask.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      defaultRecurrence: json['defaultRecurrence'] == null
          ? null
          : RecurrenceRule.fromJson(
              json['defaultRecurrence'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TaskTemplateImplToJson(_$TaskTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': _$TemplateCategoryEnumMap[instance.category]!,
      'description': instance.description,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'estimatedMinutes': instance.estimatedMinutes,
      'tags': instance.tags,
      'iconCodePoint': instance.iconCodePoint,
      'isBuiltIn': instance.isBuiltIn,
      'usageCount': instance.usageCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'defaultSubtasks': instance.defaultSubtasks,
      'defaultRecurrence': instance.defaultRecurrence,
    };

const _$TemplateCategoryEnumMap = {
  TemplateCategory.fitness: 'fitness',
  TemplateCategory.work: 'work',
  TemplateCategory.life: 'life',
  TemplateCategory.health: 'health',
  TemplateCategory.social: 'social',
  TemplateCategory.finance: 'finance',
  TemplateCategory.cooking: 'cooking',
  TemplateCategory.learning: 'learning',
  TemplateCategory.home: 'home',
  TemplateCategory.creative: 'creative',
  TemplateCategory.travel: 'travel',
  TemplateCategory.shopping: 'shopping',
  TemplateCategory.project: 'project',
  TemplateCategory.habit: 'habit',
  TemplateCategory.maintenance: 'maintenance',
  TemplateCategory.custom: 'custom',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.none: 'none',
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
  TaskPriority.critical: 'critical',
};
