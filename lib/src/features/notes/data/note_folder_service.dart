import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/features/notes/domain/note_folder.dart';

/// 笔记文件夹服务
class NoteFolderService {
  static const String _boxName = 'note_folders';
  Box<NoteFolder>? _box;

  /// 初始化
  Future<void> init() async {
    // 检查box是否已经打开
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box<NoteFolder>(_boxName);
    } else {
      _box = await Hive.openBox<NoteFolder>(_boxName);
    }

    // 如果是第一次运行，创建默认文件夹
    if (_box!.isEmpty) {
      await _initDefaultFolders();
    }
  }

  /// 初始化默认文件夹
  Future<void> _initDefaultFolders() async {
    final defaultFolders = [
      NoteFolder.create(
        name: '工作',
        icon: 'work',
        color: 0xFF3B82F6, // 蓝色
        order: 0,
      ),
      NoteFolder.create(
        name: '个人',
        icon: 'person',
        color: 0xFF10B981, // 绿色
        order: 1,
      ),
      NoteFolder.create(
        name: '学习',
        icon: 'school',
        color: 0xFFF59E0B, // 橙色
        order: 2,
      ),
      NoteFolder.create(
        name: '项目',
        icon: 'assignment',
        color: 0xFF8B5CF6, // 紫色
        order: 3,
      ),
    ];

    for (final folder in defaultFolders) {
      await _box!.add(folder);
    }
  }

  /// 获取所有文件夹
  List<NoteFolder> getAllFolders() {
    return _box?.values.toList() ?? [];
  }

  /// 获取根文件夹列表
  List<NoteFolder> getRootFolders() {
    return _box?.values.where((f) => f.isRoot).toList() ?? [];
  }

  /// 获取子文件夹
  List<NoteFolder> getSubFolders(String parentId) {
    return _box?.values.where((f) => f.parentId == parentId).toList() ?? [];
  }

  /// 根据ID获取文件夹
  NoteFolder? getFolderById(String id) {
    try {
      return _box?.values.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 获取文件夹路径（面包屑导航）
  List<NoteFolder> getFolderPath(String folderId) {
    final path = <NoteFolder>[];
    var currentFolder = getFolderById(folderId);

    while (currentFolder != null) {
      path.insert(0, currentFolder);
      if (currentFolder.parentId != null) {
        currentFolder = getFolderById(currentFolder.parentId!);
      } else {
        break;
      }
    }

    return path;
  }

  /// 获取文件夹的完整路径字符串（用于存储在笔记中）
  String getFolderPathString(String folderId) {
    final pathFolders = getFolderPath(folderId);
    if (pathFolders.isEmpty) return '';
    return pathFolders.map((f) => f.name).join('/');
  }

  /// 添加文件夹
  Future<NoteFolder> addFolder(NoteFolder folder) async {
    await _box!.add(folder);
    return folder;
  }

  /// 更新文件夹
  Future<void> updateFolder(NoteFolder folder) async {
    final index = _box!.values.toList().indexWhere((f) => f.id == folder.id);
    if (index != -1) {
      await _box!.putAt(index, folder);
    }
  }

  /// 删除文件夹
  Future<bool> deleteFolder(String id) async {
    // 检查是否有子文件夹
    final subFolders = getSubFolders(id);
    if (subFolders.isNotEmpty) {
      return false; // 有子文件夹，不能删除
    }

    final index = _box!.values.toList().indexWhere((f) => f.id == id);
    if (index != -1) {
      await _box!.deleteAt(index);
      return true;
    }
    return false;
  }

  /// 移动文件夹
  Future<bool> moveFolder(String folderId, String? newParentId) async {
    final folder = getFolderById(folderId);
    if (folder == null) return false;

    // 防止循环引用
    if (newParentId != null) {
      if (_isAncestor(folderId, newParentId)) {
        return false; // 不能移动到自己的子文件夹中
      }
    }

    final updatedFolder = folder.copyWith(parentId: newParentId);
    await updateFolder(updatedFolder);
    return true;
  }

  /// 检查是否为祖先文件夹（防止循环引用）
  bool _isAncestor(String ancestorId, String descendantId) {
    var current = getFolderById(descendantId);
    while (current != null) {
      if (current.id == ancestorId) {
        return true;
      }
      if (current.parentId != null) {
        current = getFolderById(current.parentId!);
      } else {
        break;
      }
    }
    return false;
  }

  /// 重命名文件夹
  Future<void> renameFolder(String id, String newName) async {
    final folder = getFolderById(id);
    if (folder != null) {
      final updatedFolder = folder.copyWith(name: newName);
      await updateFolder(updatedFolder);
    }
  }

  /// 更新文件夹图标
  Future<void> updateFolderIcon(String id, String icon, int color) async {
    final folder = getFolderById(id);
    if (folder != null) {
      final updatedFolder = folder.copyWith(icon: icon, color: color);
      await updateFolder(updatedFolder);
    }
  }

  /// 构建树状结构
  List<FolderNode> buildFolderTree() {
    final rootFolders = getRootFolders();
    return rootFolders.map((folder) => _buildNode(folder)).toList()
      ..sort((a, b) => a.folder.order.compareTo(b.folder.order));
  }

  FolderNode _buildNode(NoteFolder folder) {
    final children = getSubFolders(folder.id);
    return FolderNode(
      folder: folder,
      children: children.map(_buildNode).toList()
        ..sort((a, b) => a.folder.order.compareTo(b.folder.order)),
    );
  }

  /// 关闭数据库
  Future<void> close() async {
    await _box?.close();
  }
}

/// 文件夹树节点
class FolderNode {
  final NoteFolder folder;
  final List<FolderNode> children;

  FolderNode({
    required this.folder,
    required this.children,
  });

  /// 递归获取所有后代文件夹ID
  List<String> getAllDescendantIds() {
    final ids = <String>[folder.id];
    for (final child in children) {
      ids.addAll(child.getAllDescendantIds());
    }
    return ids;
  }
}
