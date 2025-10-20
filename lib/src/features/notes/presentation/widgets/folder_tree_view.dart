import 'package:flutter/material.dart';
import 'package:todolist/src/features/notes/data/note_folder_service.dart';
import 'package:todolist/src/features/notes/domain/note_folder.dart';

/// 文件夹树状视图
class FolderTreeView extends StatefulWidget {
  const FolderTreeView({
    required this.folderService,
    this.selectedFolderId,
    this.onFolderSelected,
    this.onFolderLongPress,
    super.key,
  });

  final NoteFolderService folderService;
  final String? selectedFolderId;
  final ValueChanged<String?>? onFolderSelected;
  final ValueChanged<NoteFolder>? onFolderLongPress;

  @override
  State<FolderTreeView> createState() => _FolderTreeViewState();
}

class _FolderTreeViewState extends State<FolderTreeView> {
  List<FolderNode> _folderTree = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  void _loadFolders() {
    setState(() {
      _folderTree = widget.folderService.buildFolderTree();
    });
  }

  void refresh() {
    _loadFolders();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // "全部笔记"选项
        _buildAllNotesItem(),
        const Divider(),
        // 文件夹树
        ..._folderTree.map((node) => _buildFolderNode(node, 0)),
      ],
    );
  }

  Widget _buildAllNotesItem() {
    final isSelected = widget.selectedFolderId == null;
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.folder_special_rounded,
          color: isSelected ? theme.colorScheme.primary : Colors.grey,
          size: 20,
        ),
      ),
      title: const Text(
        '全部笔记',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primary.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () => widget.onFolderSelected?.call(null),
    );
  }

  Widget _buildFolderNode(FolderNode node, int level) {
    final hasChildren = node.children.isNotEmpty;
    final isExpanded = node.folder.isExpanded;
    final isSelected = widget.selectedFolderId == node.folder.id;
    final theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(
            left: 16.0 + (level * 24.0),
            right: 16,
          ),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasChildren)
                IconButton(
                  icon: Icon(
                    isExpanded
                        ? Icons.expand_more
                        : Icons.chevron_right,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      node.folder.isExpanded = !node.folder.isExpanded;
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              else
                const SizedBox(width: 20),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(node.folder.color).withOpacity(0.2)
                      : Color(node.folder.color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconData(node.folder.icon),
                  color: Color(node.folder.color),
                  size: 20,
                ),
              ),
            ],
          ),
          title: Text(
            node.folder.name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          selected: isSelected,
          selectedTileColor: theme.colorScheme.primary.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: () => widget.onFolderSelected?.call(node.folder.id),
          onLongPress: () => widget.onFolderLongPress?.call(node.folder),
        ),
        if (hasChildren && isExpanded)
          ...node.children.map((child) => _buildFolderNode(child, level + 1)),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'work':
        return Icons.work_rounded;
      case 'person':
        return Icons.person_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'assignment':
        return Icons.assignment_rounded;
      case 'folder':
        return Icons.folder_rounded;
      case 'star':
        return Icons.star_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'bookmark':
        return Icons.bookmark_rounded;
      case 'category':
        return Icons.category_rounded;
      case 'label':
        return Icons.label_rounded;
      default:
        return Icons.folder_rounded;
    }
  }
}
