import 'package:flutter/material.dart';
import 'package:todolist/src/features/notes/domain/note_folder.dart';

/// 文件夹编辑对话框
class FolderEditorDialog extends StatefulWidget {
  const FolderEditorDialog({
    this.folder,
    this.parentId,
    super.key,
  });

  final NoteFolder? folder; // null表示创建新文件夹
  final String? parentId;

  @override
  State<FolderEditorDialog> createState() => _FolderEditorDialogState();
}

class _FolderEditorDialogState extends State<FolderEditorDialog> {
  late TextEditingController _nameController;
  String _selectedIcon = 'folder';
  int _selectedColor = 0xFF6366F1;

  // 可用的图标
  final List<IconOption> _iconOptions = [
    IconOption('folder', Icons.folder_rounded, '文件夹'),
    IconOption('work', Icons.work_rounded, '工作'),
    IconOption('person', Icons.person_rounded, '个人'),
    IconOption('school', Icons.school_rounded, '学习'),
    IconOption('assignment', Icons.assignment_rounded, '项目'),
    IconOption('star', Icons.star_rounded, '重要'),
    IconOption('favorite', Icons.favorite_rounded, '收藏'),
    IconOption('bookmark', Icons.bookmark_rounded, '书签'),
    IconOption('category', Icons.category_rounded, '分类'),
    IconOption('label', Icons.label_rounded, '标签'),
  ];

  // 可用的颜色
  final List<ColorOption> _colorOptions = [
    ColorOption(0xFF6366F1, '蓝色'),
    ColorOption(0xFF10B981, '绿色'),
    ColorOption(0xFFF59E0B, '橙色'),
    ColorOption(0xFF8B5CF6, '紫色'),
    ColorOption(0xFFEF4444, '红色'),
    ColorOption(0xFFEC4899, '粉色'),
    ColorOption(0xFF06B6D4, '青色'),
    ColorOption(0xFF64748B, '灰色'),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.folder?.name ?? '',
    );
    if (widget.folder != null) {
      _selectedIcon = widget.folder!.icon;
      _selectedColor = widget.folder!.color;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.folder != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(_selectedColor),
                        Color(_selectedColor).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconData(_selectedIcon),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isEdit ? '编辑文件夹' : '新建文件夹',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 名称输入
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '文件夹名称',
                hintText: '请输入文件夹名称',
                prefixIcon: Icon(Icons.edit_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // 图标选择
            const Text(
              '选择图标',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _iconOptions.map((option) {
                final isSelected = option.name == _selectedIcon;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = option.name;
                    });
                  },
                  child: Tooltip(
                    message: option.label,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(_selectedColor).withOpacity(0.2)
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Color(_selectedColor)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        option.icon,
                        color: isSelected
                            ? Color(_selectedColor)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 颜色选择
            const Text(
              '选择颜色',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colorOptions.map((option) {
                final isSelected = option.value == _selectedColor;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = option.value;
                    });
                  },
                  child: Tooltip(
                    message: option.label,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(option.value),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Color(option.value).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // 按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请输入文件夹名称')),
                        );
                        return;
                      }

                      final result = FolderEditorResult(
                        name: name,
                        icon: _selectedIcon,
                        color: _selectedColor,
                      );

                      Navigator.pop(context, result);
                    },
                    child: Text(isEdit ? '保存' : '创建'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    return _iconOptions
        .firstWhere((o) => o.name == iconName, orElse: () => _iconOptions[0])
        .icon;
  }
}

class IconOption {
  final String name;
  final IconData icon;
  final String label;

  IconOption(this.name, this.icon, this.label);
}

class ColorOption {
  final int value;
  final String label;

  ColorOption(this.value, this.label);
}

class FolderEditorResult {
  final String name;
  final String icon;
  final int color;

  FolderEditorResult({
    required this.name,
    required this.icon,
    required this.color,
  });
}
