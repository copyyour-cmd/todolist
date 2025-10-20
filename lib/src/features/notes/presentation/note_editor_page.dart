import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/features/notes/application/note_image_service.dart';
import 'package:todolist/src/features/notes/application/note_providers.dart';
import 'package:todolist/src/features/notes/application/note_service.dart';
import 'package:todolist/src/features/notes/data/note_template_service.dart';
import 'package:todolist/src/features/notes/domain/note_template.dart';
import 'package:todolist/src/features/notes/presentation/widgets/audio_recorder_dialog.dart';
import 'package:todolist/src/features/notes/presentation/widgets/drawing_dialog.dart';
import 'package:todolist/src/features/notes/presentation/widgets/markdown_editor.dart';
import 'package:todolist/src/features/notes/presentation/widgets/styled_text_field.dart';
import 'package:todolist/src/features/notes/presentation/widgets/task_selector_dialog.dart';
import 'package:todolist/src/features/notes/presentation/widgets/template_selector_dialog.dart';
import 'package:todolist/src/features/notes/presentation/widgets/note_link_selector.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';
import 'package:todolist/src/features/ai/application/note_ai_service.dart';
import 'package:todolist/src/features/ai/application/ai_providers.dart';

class NoteEditorPage extends ConsumerStatefulWidget {
  const NoteEditorPage({
    super.key,
    this.noteId,
    this.template,
  });

  final String? noteId;
  final NoteTemplate? template;

  static const routeName = 'note-editor';
  static const routePath = '/notes/new';

  @override
  ConsumerState<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends ConsumerState<NoteEditorPage> {
  final _contentController = StyledTextEditingController();
  final _scrollController = ScrollController();
  final _imageService = NoteImageService();

  Note? _existingNote;
  NoteCategory _selectedCategory = NoteCategory.general;
  List<String> _tags = [];
  List<String> _imageUrls = [];
  List<String> _attachmentUrls = [];
  List<String> _audioUrls = [];
  List<String> _linkedTaskIds = [];
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_markAsChanged);
    _loadNote();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadNote() async {
    // 如果提供了模板,应用模板内容
    if (widget.template != null && widget.noteId == null) {
      setState(() {
        _contentController.text = widget.template!.content;
        _markAsChanged();
      });
      return;
    }

    if (widget.noteId == null) return;

    final note = await ref.read(noteByIdProvider(widget.noteId!).future);
    if (note != null) {
      setState(() {
        _existingNote = note;
        // 将标题和内容合并,标题作为第一行
        final combinedContent = note.title.isNotEmpty
            ? '${note.title}\n${note.content}'
            : note.content;
        _contentController.text = combinedContent;
        _selectedCategory = note.category;
        _tags = [...note.tags];
        _imageUrls = [...note.imageUrls];
        _attachmentUrls = [...note.attachmentUrls];
        _linkedTaskIds = [...note.linkedTaskIds];
      });

      // 记录查看
      final service = ref.read(noteServiceProvider);
      await service.recordView(note);
    }
  }

  void _markAsChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showDiscardDialog();
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF1E1E1E),
                        const Color(0xFF2C2C2C),
                      ]
                    : [
                        const Color(0xFF6366F1),
                        const Color(0xFF8B5CF6),
                      ],
              ),
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.edit_note_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _existingNote == null ? '新建笔记' : '编辑笔记',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          elevation: 0,
          actions: [
            if (_hasChanges)
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _isLoading ? null : _saveNote,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Row(
                              children: const [
                                Icon(Icons.save_rounded, size: 18, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  '保存',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            if (_existingNote != null)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onSelected: (value) async {
                  switch (value) {
                    case 'reading':
                      context.push('/notes/reading/${_existingNote!.id}');
                      break;
                    case 'favorite':
                      await _toggleFavorite();
                      break;
                    case 'pin':
                      await _togglePin();
                      break;
                    case 'archive':
                      await _toggleArchive();
                      break;
                    case 'duplicate':
                      await _duplicateNote();
                      break;
                    case 'delete':
                      await _deleteNote();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'reading',
                    child: Row(
                      children: [
                        Icon(Icons.menu_book, color: Colors.indigo),
                        SizedBox(width: 12),
                        Text('阅读模式'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'favorite',
                    child: Row(
                      children: [
                        Icon(
                          _existingNote!.isFavorite ? Icons.star : Icons.star_outline,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 12),
                        Text(_existingNote!.isFavorite ? '取消收藏' : '收藏'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'pin',
                    child: Row(
                      children: [
                        Icon(
                          _existingNote!.isPinned
                              ? Icons.push_pin
                              : Icons.push_pin_outlined,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        Text(_existingNote!.isPinned ? '取消置顶' : '置顶'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'archive',
                    child: Row(
                      children: [
                        Icon(
                          _existingNote!.isArchived ? Icons.unarchive : Icons.archive,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 12),
                        Text(_existingNote!.isArchived ? '取消归档' : '归档'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy, color: Colors.purple),
                        SizedBox(width: 12),
                        Text('复制'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 12),
                        Text('删除', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        body: Column(
          children: [
            // Markdown编辑器
            Expanded(
              child: MarkdownEditor(
                controller: _contentController,
                onChanged: (value) => _markAsChanged(),
                noteRepository: ref.read(noteRepositoryProvider),
              ),
            ),

            // 底部工具栏 - 增强设计
            _buildBottomToolbar(theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomToolbar(ThemeData theme, bool isDark) {
    final wordCount = _contentController.text.length;
    final readingTime = (wordCount / 400).ceil();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  theme.colorScheme.surface,
                  const Color(0xFF1E1E1E),
                ]
              : [
                  Colors.white,
                  const Color(0xFFF8F9FF),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // 分类选择
              _buildToolbarButton(
                icon: Icons.category_rounded,
                label: _getCategoryIcon(_selectedCategory),
                onTap: _showCategoryPicker,
                gradientColors: const [Color(0xFFEC4899), Color(0xFFF43F5E)],
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(width: 10),

              // 模板选择
              _buildToolbarButton(
                icon: Icons.description_outlined,
                label: '模板',
                onTap: _applyTemplate,
                gradientColors: const [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(width: 10),

              // 标签管理
              _buildToolbarButton(
                icon: Icons.local_offer_rounded,
                label: _tags.isEmpty ? '标签' : '#${_tags.length}',
                onTap: _showTagPicker,
                gradientColors: const [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(width: 10),

              // 图片插入
              _buildToolbarButton(
                icon: Icons.image_rounded,
                label: '图片',
                onTap: _insertImage,
                gradientColors: const [Color(0xFF10B981), Color(0xFF059669)],
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(width: 10),

              // 链接任务
              _buildToolbarButton(
                icon: Icons.task_alt_rounded,
                label: _linkedTaskIds.isEmpty ? '任务' : '✓${_linkedTaskIds.length}',
                onTap: _linkTask,
                gradientColors: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(width: 10),

              // 笔记链接
              _buildToolbarButton(
                icon: Icons.link_rounded,
                label: '链接',
                onTap: _insertNoteLink,
                gradientColors: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(width: 10),

              // 更多附件选项
              _buildToolbarButton(
                icon: Icons.attach_file_rounded,
                label: _attachmentUrls.isEmpty ? '附件' : '📎${_attachmentUrls.length}',
                onTap: _showAttachmentMenu,
                gradientColors: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(width: 10),

              // AI助手
              if (_existingNote != null)
                _buildToolbarButton(
                  icon: Icons.auto_awesome,
                  label: 'AI',
                  onTap: _showAIAssistant,
                  gradientColors: const [Color(0xFFFFB800), Color(0xFFFF8A00)],
                  theme: theme,
                  isDark: isDark,
                ),
              if (_existingNote != null) const SizedBox(width: 10),

              // 统计信息 - 美化展示
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF1E1E1E),
                            const Color(0xFF2C2C2C),
                          ]
                        : [
                            const Color(0xFFF3F4F6),
                            const Color(0xFFE5E7EB),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.text_fields_rounded,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$wordCount字',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${readingTime}分钟',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required List<Color> gradientColors,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryIcon(NoteCategory category) {
    final note = Note(
      id: '',
      title: '',
      content: '',
      category: category,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return note.getCategoryIcon();
  }

  Future<void> _saveNote() async {
    final fullText = _contentController.text.trim();

    if (fullText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入笔记内容')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(noteServiceProvider);

      // 提取第一行作为标题,其余作为内容
      final lines = fullText.split('\n');
      final title = lines.first.trim();
      final content = lines.length > 1
          ? lines.sublist(1).join('\n').trim()
          : '';

      if (title.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('第一行不能为空,将作为标题')),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (_existingNote == null) {
        // 创建新笔记
        await service.createNote(
          NoteCreationInput(
            title: title,
            content: content,
            category: _selectedCategory,
            tags: _tags,
            imageUrls: _imageUrls,
            attachmentUrls: _attachmentUrls,
            linkedTaskIds: _linkedTaskIds,
          ),
        );
      } else {
        // 更新现有笔记
        await service.updateNote(
          _existingNote!,
          NoteUpdateInput(
            title: title,
            content: content,
            category: _selectedCategory,
            tags: _tags,
            imageUrls: _imageUrls,
            attachmentUrls: _attachmentUrls,
            linkedTaskIds: _linkedTaskIds,
          ),
        );
      }

      ref.invalidate(notesProvider);
      setState(() {
        _hasChanges = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存成功')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _showDiscardDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('放弃更改'),
        content: const Text('您有未保存的更改,确定要放弃吗?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('继续编辑'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('放弃'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: NoteCategory.values.map((category) {
            final note = Note(
              id: '',
              title: '',
              content: '',
              category: category,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            return ListTile(
              leading: Text(note.getCategoryIcon(), style: const TextStyle(fontSize: 24)),
              title: Text(note.getCategoryName()),
              trailing: _selectedCategory == category
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                  _markAsChanged();
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showTagPicker() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('管理标签'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '输入新标签',
                prefixIcon: Icon(Icons.local_offer),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty && !_tags.contains(value.trim())) {
                  setState(() {
                    _tags.add(value.trim());
                    _markAsChanged();
                  });
                  controller.clear();
                }
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () {
                    setState(() {
                      _tags.remove(tag);
                      _markAsChanged();
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Future<void> _insertImage() async {
    // 显示选择对话框: 图库 or 相机
    final source = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择图片来源'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('从图库选择'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text('拍照'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );

    if (source == null) return;

    if (!mounted) return;

    // 显示加载指示器
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      String? imagePath;
      if (source == 'gallery') {
        imagePath = await _imageService.pickImageFromGallery();
      } else if (source == 'camera') {
        imagePath = await _imageService.pickImageFromCamera();
      }

      if (mounted) {
        Navigator.pop(context); // 关闭加载指示器
      }

      if (imagePath != null) {
        final path = imagePath; // 类型提升
        // 添加到图片列表
        setState(() {
          _imageUrls.add(path);
          _markAsChanged();
        });

        // 插入Markdown图片标记
        final markdown = '\n![图片](file:///$path)\n';
        final text = _contentController.text;
        final selection = _contentController.selection;

        // 确保selection有效,避免RangeError
        final insertPosition = selection.start >= 0 && selection.start <= text.length
            ? selection.start
            : text.length;

        _contentController.value = TextEditingValue(
          text: text.substring(0, insertPosition) +
              markdown +
              text.substring(insertPosition),
          selection: TextSelection.collapsed(
            offset: insertPosition + markdown.length,
          ),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('图片已插入')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // 关闭加载指示器
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('插入图片失败: $e')),
        );
      }
    }
  }

  Future<void> _linkTask() async {
    final result = await showDialog<dynamic>(
      context: context,
      builder: (context) => TaskSelectorDialog(
        selectedTaskIds: _linkedTaskIds,
        multiSelect: true,
      ),
    );

    if (result != null && result is List<String>) {
      setState(() {
        _linkedTaskIds = result;
        _markAsChanged();
      });

      // 在内容中插入任务链接
      if (_linkedTaskIds.isNotEmpty && mounted) {
        final tasksAsync = await ref.read(allTasksProvider.future);
        final linkedTasks =
            tasksAsync.where((t) => _linkedTaskIds.contains(t.id)).toList();

        if (linkedTasks.isNotEmpty) {
          final taskLinks = linkedTasks
              .map((task) => '- [${task.title}](task://${task.id})')
              .join('\n');
          final markdown = '\n\n## 关联任务\n$taskLinks\n';
          final text = _contentController.text;

          // 检查是否已经有"关联任务"部分
          if (!text.contains('## 关联任务')) {
            _contentController.value = TextEditingValue(
              text: text + markdown,
              selection: TextSelection.collapsed(offset: (text + markdown).length),
            );
          }
        }
      }
    }
  }

  Future<void> _insertNoteLink() async {
    await showDialog(
      context: context,
      builder: (context) => NoteLinkSelector(
        currentNoteId: _existingNote?.id,
        onLinkSelected: (noteTitle) {
          // 插入[[笔记标题]]格式的链接
          final link = '[[${noteTitle}]]';
          final text = _contentController.text;
          final selection = _contentController.selection;

          // 确保selection有效,避免RangeError
          final insertPosition = selection.start >= 0 && selection.start <= text.length
              ? selection.start
              : text.length;

          _contentController.value = TextEditingValue(
            text: text.substring(0, insertPosition) +
                link +
                text.substring(insertPosition),
            selection: TextSelection.collapsed(
              offset: insertPosition + link.length,
            ),
          );

          _markAsChanged();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('笔记链接已插入')),
            );
          }
        },
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    if (_existingNote == null) return;
    final service = ref.read(noteServiceProvider);
    final updated = await service.toggleFavorite(_existingNote!);
    setState(() {
      _existingNote = updated;
    });
    ref.invalidate(notesProvider);
  }

  Future<void> _togglePin() async {
    if (_existingNote == null) return;
    final service = ref.read(noteServiceProvider);
    final updated = await service.togglePin(_existingNote!);
    setState(() {
      _existingNote = updated;
    });
    ref.invalidate(notesProvider);
  }

  Future<void> _toggleArchive() async {
    if (_existingNote == null) return;
    final service = ref.read(noteServiceProvider);
    final updated = _existingNote!.isArchived
        ? await service.unarchiveNote(_existingNote!)
        : await service.archiveNote(_existingNote!);
    setState(() {
      _existingNote = updated;
    });
    ref.invalidate(notesProvider);
  }

  Future<void> _duplicateNote() async {
    if (_existingNote == null) return;
    final service = ref.read(noteServiceProvider);
    await service.duplicateNote(_existingNote!);
    ref.invalidate(notesProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('笔记已复制')),
      );
      context.pop();
    }
  }

  Future<void> _deleteNote() async {
    if (_existingNote == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除笔记"${_existingNote!.title}"吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(noteServiceProvider);
      await service.deleteNote(_existingNote!.id);
      ref.invalidate(notesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('笔记已删除')),
        );
        context.pop();
      }
    }
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题栏
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.attach_file_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '添加附件',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 附件选项
              _buildAttachmentOption(
                icon: Icons.mic_rounded,
                title: '录音',
                subtitle: '录制语音笔记',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _recordAudio();
                },
              ),
              _buildAttachmentOption(
                icon: Icons.draw_rounded,
                title: '手写/涂鸦',
                subtitle: '手绘草图或手写笔记',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                  _openDrawingPad();
                },
              ),
              _buildAttachmentOption(
                icon: Icons.insert_drive_file_rounded,
                title: '文件',
                subtitle: '添加PDF、文档等文件',
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  _pickFile();
                },
              ),
              _buildAttachmentOption(
                icon: Icons.photo_library_rounded,
                title: '图片',
                subtitle: '从相册或相机添加图片',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  _insertImage();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Future<void> _recordAudio() async {
    final audioPath = await showDialog<String>(
      context: context,
      builder: (context) => const AudioRecorderDialog(),
    );

    if (audioPath != null) {
      // 添加到附件列表(音频也是附件的一种)
      setState(() {
        _attachmentUrls.add(audioPath);
        _audioUrls.add(audioPath);
        _markAsChanged();
      });

      // 计算音频时长和大小
      final file = File(audioPath);
      final fileSize = await file.length();
      final fileSizeStr = _formatFileSize(fileSize);
      final fileName = path.basename(audioPath);

      // 在内容中插入音频标记
      final markdown = '\n🎵 [$fileName]($audioPath) (音频, $fileSizeStr)\n';
      final text = _contentController.text;
      final selection = _contentController.selection;

      // 确保selection有效,避免RangeError
      final insertPosition = selection.start >= 0 && selection.start <= text.length
          ? selection.start
          : text.length;

      _contentController.value = TextEditingValue(
        text: text.substring(0, insertPosition) +
            markdown +
            text.substring(insertPosition),
        selection: TextSelection.collapsed(
          offset: insertPosition + markdown.length,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('录音已添加')),
        );
      }
    }
  }

  Future<void> _openDrawingPad() async {
    final imageData = await showDialog<Uint8List>(
      context: context,
      builder: (context) => const DrawingDialog(),
    );

    if (imageData != null) {
      try {
        // 保存绘制的图片
        final appDir = await getApplicationDocumentsDirectory();
        final drawingsDir = Directory('${appDir.path}/note_drawings');
        if (!await drawingsDir.exists()) {
          await drawingsDir.create(recursive: true);
        }

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filePath = '${drawingsDir.path}/drawing_$timestamp.png';
        final file = File(filePath);
        await file.writeAsBytes(imageData);

        // 添加到图片列表
        setState(() {
          _imageUrls.add(filePath);
          _attachmentUrls.add(filePath);
          _markAsChanged();
        });

        // 在内容中插入手绘图片
        final markdown = '\n![手绘图片](file:///$filePath)\n';
        final text = _contentController.text;
        final selection = _contentController.selection;

        // 确保selection有效,避免RangeError
        final insertPosition = selection.start >= 0 && selection.start <= text.length
            ? selection.start
            : text.length;

        _contentController.value = TextEditingValue(
          text: text.substring(0, insertPosition) +
              markdown +
              text.substring(insertPosition),
          selection: TextSelection.collapsed(
            offset: insertPosition + markdown.length,
          ),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('手绘图片已添加')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('保存手绘图片失败: $e')),
          );
        }
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx', 'ppt', 'pptx', 'zip'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.path == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('无法获取文件路径')),
          );
        }
        return;
      }

      // 显示加载指示器
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // 复制文件到应用存储目录
      final appDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory('${appDir.path}/note_attachments');
      if (!await attachmentsDir.exists()) {
        await attachmentsDir.create(recursive: true);
      }

      final fileName = file.name;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newFileName = '${timestamp}_$fileName';
      final newFilePath = '${attachmentsDir.path}/$newFileName';

      // 复制文件
      await File(file.path!).copy(newFilePath);

      if (mounted) {
        Navigator.pop(context); // 关闭加载指示器
      }

      // 添加到附件列表
      setState(() {
        _attachmentUrls.add(newFilePath);
        _markAsChanged();
      });

      // 在内容中插入文件链接
      final fileExt = path.extension(fileName).toUpperCase().replaceFirst('.', '');
      final fileSize = file.size;
      final fileSizeStr = _formatFileSize(fileSize);

      final markdown = '\n📎 [$fileName]($newFilePath) ($fileExt, $fileSizeStr)\n';
      final text = _contentController.text;
      final selection = _contentController.selection;

      // 确保selection有效,避免RangeError
      final insertPosition = selection.start >= 0 && selection.start <= text.length
          ? selection.start
          : text.length;

      _contentController.value = TextEditingValue(
        text: text.substring(0, insertPosition) +
            markdown +
            text.substring(insertPosition),
        selection: TextSelection.collapsed(
          offset: insertPosition + markdown.length,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('文件已添加: $fileName')),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // 关闭加载指示器
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('添加文件失败: $e')),
        );
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _applyTemplate() async {
    try {
      debugPrint('🔧 [模板功能] 点击了模板按钮');

      // 初始化模板服务
      debugPrint('🔧 [模板功能] 正在初始化模板服务...');
      final templateService = NoteTemplateService();
      await templateService.init();
      debugPrint('🔧 [模板功能] 模板服务初始化完成');

      // 获取模板列表
      final presetTemplates = templateService.getPresetTemplates();
      final customTemplates = templateService.getCustomTemplates();
      debugPrint('🔧 [模板功能] 获取到预设模板: ${presetTemplates.length}个, 自定义模板: ${customTemplates.length}个');

      if (!mounted) {
        debugPrint('⚠️ [模板功能] Widget已卸载,取消显示对话框');
        return;
      }

      // 显示模板选择对话框
      debugPrint('🔧 [模板功能] 正在显示模板选择对话框...');
      final selectedTemplate = await showDialog<NoteTemplate>(
        context: context,
        builder: (context) => TemplateSelectorDialog(
          presetTemplates: presetTemplates,
          customTemplates: customTemplates,
        ),
      );
      debugPrint('🔧 [模板功能] 对话框关闭,选择的模板: ${selectedTemplate?.name ?? "未选择"}');

      // 如果选择了模板,应用模板内容
      if (selectedTemplate != null) {
        if (!mounted) {
          debugPrint('⚠️ [模板功能] Widget已卸载,取消应用模板');
          return;
        }

        final shouldApply = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('应用模板'),
            content: Text('确定要应用"${selectedTemplate.name}"模板吗？\n\n当前内容将被替换。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('确定'),
              ),
            ],
          ),
        );
        debugPrint('🔧 [模板功能] 确认对话框结果: ${shouldApply == true ? "确定" : "取消"}');

        if (shouldApply == true) {
          setState(() {
            _contentController.text = selectedTemplate.content;
            _markAsChanged();
          });
          debugPrint('✅ [模板功能] 模板已应用');

          // 增加模板使用次数
          await templateService.incrementUsageCount(selectedTemplate.id);
          debugPrint('✅ [模板功能] 已增加使用次数');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('已应用"${selectedTemplate.name}"模板')),
            );
          }
        }
      } else {
        debugPrint('🔧 [模板功能] 用户未选择模板,已取消');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [模板功能] 发生错误: $e');
      debugPrint('❌ [模板功能] 堆栈跟踪:\n$stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('模板功能出错: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// 显示AI助手对话框
  Future<void> _showAIAssistant() async {
    if (_existingNote == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  // 标题栏
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFB800), Color(0xFFFF8A00)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'AI智能助手',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // AI功能选项
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildAIOption(
                          icon: Icons.summarize,
                          title: '智能摘要',
                          subtitle: '自动生成笔记摘要(100字内)',
                          color: Colors.blue,
                          onTap: () async {
                            Navigator.pop(context);
                            await _generateSummary();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildAIOption(
                          icon: Icons.label,
                          title: '推荐标签',
                          subtitle: '基于内容智能推荐5个标签',
                          color: Colors.purple,
                          onTap: () async {
                            Navigator.pop(context);
                            await _recommendTags();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildAIOption(
                          icon: Icons.link,
                          title: '相关笔记',
                          subtitle: '找出与当前笔记相关的其他笔记',
                          color: Colors.green,
                          onTap: () async {
                            Navigator.pop(context);
                            await _findRelatedNotes();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildAIOption(
                          icon: Icons.quiz,
                          title: '智能问答',
                          subtitle: '基于笔记内容回答问题',
                          color: Colors.orange,
                          onTap: () async {
                            Navigator.pop(context);
                            await _showQADialog();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAIOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  /// 生成智能摘要
  Future<void> _generateSummary() async {
    if (_existingNote == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final aiService = ref.read(noteAIServiceProvider);
      final summary = await aiService?.generateSummary(_existingNote!) ?? '暂无摘要';

      if (mounted) {
        Navigator.pop(context); // 关闭加载指示器

        // 显示摘要结果
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.summarize, color: Colors.blue),
                SizedBox(width: 8),
                Text('智能摘要'),
              ],
            ),
            content: SelectableText(summary),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
              FilledButton(
                onPressed: () {
                  // 将摘要插入到笔记开头
                  final text = _contentController.text;
                  final newText = '> $summary\n\n$text';
                  _contentController.text = newText;
                  _markAsChanged();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('摘要已插入笔记开头')),
                  );
                },
                child: const Text('插入笔记'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('生成摘要失败: $e')),
        );
      }
    }
  }

  /// 推荐标签
  Future<void> _recommendTags() async {
    if (_existingNote == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final aiService = ref.read(noteAIServiceProvider);
      final recommendedTags = await aiService?.suggestTags(_existingNote!) ?? <String>[];

      if (mounted) {
        Navigator.pop(context);

        // 显示推荐标签
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.label, color: Colors.purple),
                SizedBox(width: 8),
                Text('推荐标签'),
              ],
            ),
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recommendedTags.map((tag) {
                final isAdded = _tags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isAdded,
                  onSelected: (selected) {
                    setState(() {
                      if (selected && !isAdded) {
                        _tags.add(tag);
                        _markAsChanged();
                      } else if (!selected && isAdded) {
                        _tags.remove(tag);
                        _markAsChanged();
                      }
                    });
                  },
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('推荐标签失败: $e')),
        );
      }
    }
  }

  /// 查找相关笔记
  Future<void> _findRelatedNotes() async {
    if (_existingNote == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final aiService = ref.read(noteAIServiceProvider);
      final relatedNotes = await aiService?.recommendRelatedNotes(_existingNote!) ?? [];

      if (mounted) {
        Navigator.pop(context);

        if (relatedNotes.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('未找到相关笔记')),
          );
          return;
        }

        // 显示相关笔记列表
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.link, color: Colors.green),
                SizedBox(width: 8),
                Text('相关笔记'),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: relatedNotes.length,
                itemBuilder: (context, index) {
                  final note = relatedNotes[index];
                  return ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(note.title),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/notes/reading/${note.id}');
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('查找相关笔记失败: $e')),
        );
      }
    }
  }

  /// 显示问答对话框
  Future<void> _showQADialog() async {
    if (_existingNote == null) return;

    final questionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.quiz, color: Colors.orange),
            SizedBox(width: 8),
            Text('智能问答'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('基于笔记内容提问,AI将为您解答:'),
            const SizedBox(height: 16),
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                hintText: '请输入您的问题...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              final question = questionController.text.trim();
              if (question.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入问题')),
                );
                return;
              }

              Navigator.pop(context);
              await _answerQuestion(question);
            },
            child: const Text('提问'),
          ),
        ],
      ),
    );
  }

  /// 回答问题
  Future<void> _answerQuestion(String question) async {
    if (_existingNote == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final aiService = ref.read(noteAIServiceProvider);
      final answer = await aiService?.askAboutNote(_existingNote!, question) ?? '暂无回答';

      if (mounted) {
        Navigator.pop(context);

        // 显示答案
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.quiz, color: Colors.orange),
                SizedBox(width: 8),
                Text('AI回答'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '问题:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(question),
                  const SizedBox(height: 16),
                  const Text(
                    '回答:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(answer),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
              FilledButton(
                onPressed: () {
                  // 将问答插入到笔记末尾
                  final text = _contentController.text;
                  final qa = '\n\n## Q&A\n**Q: $question**\n\nA: $answer\n';
                  _contentController.text = text + qa;
                  _markAsChanged();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('问答已插入笔记末尾')),
                  );
                },
                child: const Text('插入笔记'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('回答问题失败: $e')),
        );
      }
    }
  }
}
