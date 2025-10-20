import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'sub_task.freezed.dart';
part 'sub_task.g.dart';

@freezed
class SubTask with _$SubTask {
  @HiveType(
    typeId: 1,
    adapterName: 'SubTaskAdapter',
  )
  const factory SubTask({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2)
    @Default(false)
    bool isCompleted,
    @HiveField(3) DateTime? completedAt,
  }) = _SubTask;

  const SubTask._();

  factory SubTask.fromJson(Map<String, dynamic> json) =>
      _$SubTaskFromJson(json);
}
