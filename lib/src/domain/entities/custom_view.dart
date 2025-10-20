import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:todolist/src/domain/entities/task.dart';
import '../../infrastructure/hive/type_ids.dart';

part 'custom_view.freezed.dart';
part 'custom_view.g.dart';

/// Type of custom view
@HiveType(typeId: HiveTypeIds.viewType, adapterName: 'ViewTypeAdapter')
enum ViewType {
  @HiveField(0)
  custom, // User-created custom view
  @HiveField(1)
  smart, // System smart list
}

/// Filter operator for conditions
@HiveType(typeId: HiveTypeIds.filterOperator, adapterName: 'FilterOperatorAdapter')
enum FilterOperator {
  @HiveField(0)
  equals,
  @HiveField(1)
  notEquals,
  @HiveField(2)
  contains,
  @HiveField(3)
  notContains,
  @HiveField(4)
  greaterThan,
  @HiveField(5)
  lessThan,
  @HiveField(6)
  isNull,
  @HiveField(7)
  isNotNull,
}

/// Field to filter on
@HiveType(typeId: HiveTypeIds.filterField, adapterName: 'FilterFieldAdapter')
enum FilterField {
  @HiveField(0)
  status,
  @HiveField(1)
  priority,
  @HiveField(2)
  dueDate,
  @HiveField(3)
  tags,
  @HiveField(4)
  list,
  @HiveField(5)
  title,
  @HiveField(6)
  hasAttachments,
  @HiveField(7)
  hasReminder,
  @HiveField(8)
  createdDate,
  @HiveField(9)
  completedDate,
}

/// A single filter condition
@HiveType(typeId: HiveTypeIds.filterCondition, adapterName: 'FilterConditionAdapter')
@freezed
class FilterCondition with _$FilterCondition {
  const factory FilterCondition({
    @HiveField(0) required FilterField field,
    @HiveField(1) required FilterOperator operator,
    @HiveField(2) String? value,
  }) = _FilterCondition;

  const FilterCondition._();

  factory FilterCondition.fromJson(Map<String, dynamic> json) =>
      _$FilterConditionFromJson(json);
}

/// Sort order for views
@HiveType(typeId: HiveTypeIds.sortOrder, adapterName: 'SortOrderAdapter')
enum SortOrder {
  @HiveField(0)
  ascending,
  @HiveField(1)
  descending,
}

/// Sort configuration
@HiveType(typeId: HiveTypeIds.sortConfig, adapterName: 'SortConfigAdapter')
@freezed
class SortConfig with _$SortConfig {
  const factory SortConfig({
    @HiveField(0) required FilterField field,
    @HiveField(1) @Default(SortOrder.ascending) SortOrder order,
  }) = _SortConfig;

  const SortConfig._();

  factory SortConfig.fromJson(Map<String, dynamic> json) =>
      _$SortConfigFromJson(json);
}

/// Custom view/filter configuration
@HiveType(typeId: HiveTypeIds.customView, adapterName: 'CustomViewAdapter')
@freezed
class CustomView with _$CustomView {
  const factory CustomView({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(3) required ViewType type, @HiveField(9) required DateTime createdAt, @HiveField(10) required DateTime updatedAt, @HiveField(2) String? description,
    @HiveField(4) @Default([]) List<FilterCondition> filters,
    @HiveField(5) SortConfig? sortConfig,
    @HiveField(6) @Default(false) bool isFavorite,
    @HiveField(7) String? icon,
    @HiveField(8) String? color,
    @HiveField(11) @Default(0) int sortOrder,
  }) = _CustomView;

  const CustomView._();

  factory CustomView.fromJson(Map<String, dynamic> json) =>
      _$CustomViewFromJson(json);
}

/// Extension to apply filters to tasks
extension TaskFiltering on List<Task> {
  /// Apply a custom view's filters to a list of tasks
  List<Task> applyView(CustomView view) {
    var filtered = this;

    // Apply each filter condition
    for (final condition in view.filters) {
      filtered = filtered.where((task) {
        return _matchesCondition(task, condition);
      }).toList();
    }

    // Apply sorting
    if (view.sortConfig != null) {
      filtered = _applySorting(filtered, view.sortConfig!);
    }

    return filtered;
  }

  bool _matchesCondition(Task task, FilterCondition condition) {
    switch (condition.field) {
      case FilterField.status:
        final taskStatus = task.status.name;
        return _compareValues(
            taskStatus, condition.value, condition.operator);

      case FilterField.priority:
        final taskPriority = task.priority.name;
        return _compareValues(
            taskPriority, condition.value, condition.operator);

      case FilterField.dueDate:
        if (condition.operator == FilterOperator.isNull) {
          return task.dueAt == null;
        }
        if (condition.operator == FilterOperator.isNotNull) {
          return task.dueAt != null;
        }
        if (task.dueAt == null || condition.value == null) return false;
        final dueDate = task.dueAt!;
        final compareDate = DateTime.parse(condition.value!);
        return _compareDates(dueDate, compareDate, condition.operator);

      case FilterField.tags:
        final tagIds = task.tagIds.join(',');
        return _compareValues(tagIds, condition.value, condition.operator);

      case FilterField.list:
        return _compareValues(
            task.listId, condition.value, condition.operator);

      case FilterField.title:
        return _compareValues(task.title, condition.value, condition.operator);

      case FilterField.hasAttachments:
        final hasAttachments = task.attachments.isNotEmpty;
        return condition.operator == FilterOperator.equals
            ? hasAttachments
            : !hasAttachments;

      case FilterField.hasReminder:
        if (condition.operator == FilterOperator.isNull) {
          return task.remindAt == null;
        }
        return task.remindAt != null;

      case FilterField.createdDate:
        if (condition.value == null) return false;
        final compareDate = DateTime.parse(condition.value!);
        return _compareDates(task.createdAt, compareDate, condition.operator);

      case FilterField.completedDate:
        if (condition.operator == FilterOperator.isNull) {
          return task.completedAt == null;
        }
        if (condition.operator == FilterOperator.isNotNull) {
          return task.completedAt != null;
        }
        if (task.completedAt == null || condition.value == null) return false;
        final compareDate = DateTime.parse(condition.value!);
        return _compareDates(
            task.completedAt!, compareDate, condition.operator);
    }
  }

  bool _compareValues(String? actual, String? expected, FilterOperator op) {
    if (actual == null && op == FilterOperator.isNull) return true;
    if (actual != null && op == FilterOperator.isNotNull) return true;
    if (actual == null || expected == null) return false;

    switch (op) {
      case FilterOperator.equals:
        return actual == expected;
      case FilterOperator.notEquals:
        return actual != expected;
      case FilterOperator.contains:
        return actual.toLowerCase().contains(expected.toLowerCase());
      case FilterOperator.notContains:
        return !actual.toLowerCase().contains(expected.toLowerCase());
      default:
        return false;
    }
  }

  bool _compareDates(DateTime actual, DateTime expected, FilterOperator op) {
    switch (op) {
      case FilterOperator.equals:
        return actual.year == expected.year &&
            actual.month == expected.month &&
            actual.day == expected.day;
      case FilterOperator.greaterThan:
        return actual.isAfter(expected);
      case FilterOperator.lessThan:
        return actual.isBefore(expected);
      default:
        return false;
    }
  }

  List<Task> _applySorting(List<Task> tasks, SortConfig config) {
    final sorted = List<Task>.from(tasks);

    sorted.sort((a, b) {
      var comparison = 0;

      switch (config.field) {
        case FilterField.status:
          comparison = a.status.index.compareTo(b.status.index);
        case FilterField.priority:
          comparison = a.priority.index.compareTo(b.priority.index);
        case FilterField.dueDate:
          if (a.dueAt == null && b.dueAt == null) {
            comparison = 0;
          } else if (a.dueAt == null) {
            comparison = 1;
          } else if (b.dueAt == null) {
            comparison = -1;
          } else {
            comparison = a.dueAt!.compareTo(b.dueAt!);
          }
        case FilterField.title:
          comparison = a.title.compareTo(b.title);
        case FilterField.createdDate:
          comparison = a.createdAt.compareTo(b.createdAt);
        case FilterField.completedDate:
          if (a.completedAt == null && b.completedAt == null) {
            comparison = 0;
          } else if (a.completedAt == null) {
            comparison = 1;
          } else if (b.completedAt == null) {
            comparison = -1;
          } else {
            comparison = a.completedAt!.compareTo(b.completedAt!);
          }
        default:
          comparison = 0;
      }

      return config.order == SortOrder.ascending ? comparison : -comparison;
    });

    return sorted;
  }
}
