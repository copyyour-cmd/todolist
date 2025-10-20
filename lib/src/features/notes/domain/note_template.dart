import 'package:hive/hive.dart';
import '../../../infrastructure/hive/type_ids.dart';
import 'package:uuid/uuid.dart';

part 'note_template.g.dart';

/// 笔记模板模型
@HiveType(typeId: 82)
class NoteTemplate extends HiveObject {
  /// 模板ID
  @HiveField(0)
  final String id;

  /// 模板名称
  @HiveField(1)
  String name;

  /// 模板描述
  @HiveField(2)
  String description;

  /// 图标名称
  @HiveField(3)
  String icon;

  /// 模板内容（Markdown格式）
  @HiveField(4)
  String content;

  /// 是否为预设模板
  @HiveField(5)
  final bool isPreset;

  /// 创建时间
  @HiveField(6)
  final DateTime createdAt;

  /// 更新时间
  @HiveField(7)
  DateTime updatedAt;

  /// 使用次数
  @HiveField(8)
  int usageCount;

  NoteTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.content,
    this.isPreset = false,
    required this.createdAt,
    required this.updatedAt,
    this.usageCount = 0,
  });

  /// 创建新模板
  factory NoteTemplate.create({
    required String name,
    required String description,
    required String icon,
    required String content,
    bool isPreset = false,
  }) {
    final now = DateTime.now();
    return NoteTemplate(
      id: const Uuid().v4(),
      name: name,
      description: description,
      icon: icon,
      content: content,
      isPreset: isPreset,
      createdAt: now,
      updatedAt: now,
      usageCount: 0,
    );
  }

  /// 复制并更新
  NoteTemplate copyWith({
    String? name,
    String? description,
    String? icon,
    String? content,
  }) {
    return NoteTemplate(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      content: content ?? this.content,
      isPreset: isPreset,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'NoteTemplate(id: $id, name: $name, isPreset: $isPreset)';
  }
}
