import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/entities/task.dart';

/// 备份数据模型
class BackupData {
  BackupData({
    required this.version,
    required this.createdAt,
    required this.tasks,
    required this.notes,
    this.appVersion,
  });

  /// 备份格式版本
  final String version;

  /// 备份创建时间
  final DateTime createdAt;

  /// 应用版本
  final String? appVersion;

  /// 任务列表
  final List<Task> tasks;

  /// 笔记列表
  final List<Note> notes;

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'appVersion': appVersion,
      'tasks': tasks.map((t) => t.toJson()).toList(),
      'notes': notes.map((n) => n.toJson()).toList(),
    };
  }

  /// 从JSON创建
  factory BackupData.fromJson(Map<String, dynamic> json) {
    return BackupData(
      version: json['version'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      appVersion: json['appVersion'] as String?,
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: (json['notes'] as List<dynamic>)
          .map((e) => Note.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 获取数据统计
  Map<String, int> getStatistics() {
    return {
      'totalTasks': tasks.length,
      'completedTasks': tasks.where((t) => t.status == TaskStatus.completed).length,
      'totalNotes': notes.length,
    };
  }
}
