import 'package:flutter/material.dart';
import '../../infrastructure/hive/type_ids.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:todolist/src/domain/entities/recurrence_rule.dart';
import 'package:todolist/src/domain/entities/sub_task.dart';
import 'package:todolist/src/domain/entities/task.dart';

part 'task_template.freezed.dart';
part 'task_template.g.dart';

/// 任务模板分类
@HiveType(typeId: HiveTypeIds.templateCategory, adapterName: 'TemplateCategoryAdapter')
enum TemplateCategory {
  @HiveField(0) fitness,      // 健身运动
  @HiveField(1) work,         // 工作学习
  @HiveField(2) life,         // 日常生活
  @HiveField(3) health,       // 健康医疗
  @HiveField(4) social,       // 社交娱乐
  @HiveField(5) finance,      // 财务管理
  @HiveField(6) cooking,      // 烹饪美食
  @HiveField(7) learning,     // 学习教育
  @HiveField(8) home,         // 家务清洁
  @HiveField(9) creative,     // 创意设计
  @HiveField(10) travel,      // 旅行规划
  @HiveField(11) shopping,    // 购物清单
  @HiveField(12) project,     // 项目管理
  @HiveField(13) habit,       // 习惯养成
  @HiveField(14) maintenance, // 维护保养
  @HiveField(15) custom,      // 自定义
}

extension TemplateCategoryExtension on TemplateCategory {
  String get displayName {
    switch (this) {
      case TemplateCategory.fitness:
        return '健身运动';
      case TemplateCategory.work:
        return '工作学习';
      case TemplateCategory.life:
        return '日常生活';
      case TemplateCategory.health:
        return '健康医疗';
      case TemplateCategory.social:
        return '社交娱乐';
      case TemplateCategory.finance:
        return '财务管理';
      case TemplateCategory.cooking:
        return '烹饪美食';
      case TemplateCategory.learning:
        return '学习教育';
      case TemplateCategory.home:
        return '家务清洁';
      case TemplateCategory.creative:
        return '创意设计';
      case TemplateCategory.travel:
        return '旅行规划';
      case TemplateCategory.shopping:
        return '购物清单';
      case TemplateCategory.project:
        return '项目管理';
      case TemplateCategory.habit:
        return '习惯养成';
      case TemplateCategory.maintenance:
        return '维护保养';
      case TemplateCategory.custom:
        return '自定义';
    }
  }

  IconData get icon {
    switch (this) {
      case TemplateCategory.fitness:
        return Icons.fitness_center;
      case TemplateCategory.work:
        return Icons.work;
      case TemplateCategory.life:
        return Icons.home;
      case TemplateCategory.health:
        return Icons.favorite;
      case TemplateCategory.social:
        return Icons.people;
      case TemplateCategory.finance:
        return Icons.account_balance;
      case TemplateCategory.cooking:
        return Icons.restaurant;
      case TemplateCategory.learning:
        return Icons.school;
      case TemplateCategory.home:
        return Icons.cleaning_services;
      case TemplateCategory.creative:
        return Icons.palette;
      case TemplateCategory.travel:
        return Icons.flight;
      case TemplateCategory.shopping:
        return Icons.shopping_cart;
      case TemplateCategory.project:
        return Icons.folder;
      case TemplateCategory.habit:
        return Icons.track_changes;
      case TemplateCategory.maintenance:
        return Icons.build;
      case TemplateCategory.custom:
        return Icons.star;
    }
  }
}

/// 任务模板
@HiveType(typeId: HiveTypeIds.taskTemplate, adapterName: 'TaskTemplateAdapter')
@freezed
class TaskTemplate with _$TaskTemplate {
  const factory TaskTemplate({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(3) required TemplateCategory category, @HiveField(2) String? description,
    @HiveField(4) @Default(TaskPriority.medium) TaskPriority priority,
    @HiveField(5) int? estimatedMinutes,
    @HiveField(6) @Default([]) List<String> tags,
    @HiveField(7) int? iconCodePoint,
    @HiveField(8) @Default(false) bool isBuiltIn,
    @HiveField(9) @Default(0) int usageCount,
    @HiveField(10) DateTime? createdAt,
    @HiveField(11) @Default([]) List<SubTask> defaultSubtasks,
    @HiveField(12) RecurrenceRule? defaultRecurrence,
  }) = _TaskTemplate;

  const TaskTemplate._();

  factory TaskTemplate.fromJson(Map<String, dynamic> json) =>
      _$TaskTemplateFromJson(json);

  IconData? get icon {
    if (iconCodePoint != null) {
      return IconData(iconCodePoint!, fontFamily: 'MaterialIcons');
    }
    return null;
  }
}
