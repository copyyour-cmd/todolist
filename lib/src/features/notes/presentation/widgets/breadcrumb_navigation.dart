import 'package:flutter/material.dart';
import 'package:todolist/src/features/notes/domain/note_folder.dart';

/// 面包屑导航
class BreadcrumbNavigation extends StatelessWidget {
  const BreadcrumbNavigation({
    required this.path,
    this.onTap,
    super.key,
  });

  final List<NoteFolder> path;
  final ValueChanged<String?>? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (path.isEmpty) {
      // 显示"全部笔记"
      return _buildBreadcrumbItem(
        context,
        icon: Icons.folder_special_rounded,
        label: '全部笔记',
        color: theme.colorScheme.primary,
        onTap: () => onTap?.call(null),
        isLast: true,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // "全部笔记" 根节点
          _buildBreadcrumbItem(
            context,
            icon: Icons.folder_special_rounded,
            label: '全部',
            color: theme.colorScheme.primary,
            onTap: () => onTap?.call(null),
            isLast: false,
          ),
          // 路径中的文件夹
          for (var i = 0; i < path.length; i++) ...[
            _buildSeparator(),
            _buildBreadcrumbItem(
              context,
              icon: _getIconData(path[i].icon),
              label: path[i].name,
              color: Color(path[i].color),
              onTap: () => onTap?.call(path[i].id),
              isLast: i == path.length - 1,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBreadcrumbItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isLast,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isLast ? color : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
                color: isLast
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.chevron_right,
        size: 16,
        color: Colors.grey,
      ),
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
