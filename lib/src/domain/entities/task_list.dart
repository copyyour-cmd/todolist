import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'task_list.freezed.dart';
part 'task_list.g.dart';

@HiveType(typeId: 2, adapterName: 'TaskListAdapter')
@freezed
class TaskList with _$TaskList {
  const factory TaskList({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(5) required DateTime createdAt,
    @HiveField(6) required DateTime updatedAt,
    @HiveField(2) @Default(0) int sortOrder,
    @HiveField(3) String? iconName,
    @HiveField(4)
    @Default('#4C83FB')
    String colorHex,
    @HiveField(7)
    @Default(false)
    bool isDefault,
  }) = _TaskList;

  const TaskList._();

  factory TaskList.fromJson(Map<String, dynamic> json) =>
      _$TaskListFromJson(json);
}
