import 'package:hive/hive.dart';
import '../../../infrastructure/hive/type_ids.dart';
import 'package:uuid/uuid.dart';

part 'note_folder.g.dart';

/// 笔记文件夹模型
@HiveType(typeId: 83)
class NoteFolder extends HiveObject {
  /// 文件夹ID
  @HiveField(0)
  final String id;

  /// 文件夹名称
  @HiveField(1)
  String name;

  /// 父文件夹ID（null表示根文件夹）
  @HiveField(2)
  String? parentId;

  /// 图标名称
  @HiveField(3)
  String icon;

  /// 颜色值（ARGB格式）
  @HiveField(4)
  int color;

  /// 排序顺序
  @HiveField(5)
  int order;

  /// 创建时间
  @HiveField(6)
  final DateTime createdAt;

  /// 更新时间
  @HiveField(7)
  DateTime updatedAt;

  /// 是否展开（仅用于UI状态，不持久化）
  bool isExpanded;

  NoteFolder({
    required this.id,
    required this.name,
    this.parentId,
    this.icon = 'folder',
    this.color = 0xFF6366F1, // 默认蓝色
    this.order = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isExpanded = false,
  });

  /// 创建新文件夹
  factory NoteFolder.create({
    required String name,
    String? parentId,
    String icon = 'folder',
    int color = 0xFF6366F1,
    int order = 0,
  }) {
    final now = DateTime.now();
    return NoteFolder(
      id: const Uuid().v4(),
      name: name,
      parentId: parentId,
      icon: icon,
      color: color,
      order: order,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 复制并更新
  NoteFolder copyWith({
    String? name,
    String? parentId,
    String? icon,
    int? color,
    int? order,
    bool? isExpanded,
  }) {
    return NoteFolder(
      id: id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      order: order ?? this.order,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  /// 是否为根文件夹
  bool get isRoot => parentId == null;

  @override
  String toString() {
    return 'NoteFolder(id: $id, name: $name, parentId: $parentId)';
  }
}
