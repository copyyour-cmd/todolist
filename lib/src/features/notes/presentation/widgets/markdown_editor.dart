import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/features/notes/presentation/widgets/table_wizard_dialog.dart';
import 'package:todolist/src/features/notes/presentation/widgets/custom_markdown_image_builder.dart';
import 'package:todolist/src/features/notes/presentation/widgets/custom_markdown_audio_builder.dart';
import 'package:todolist/src/features/notes/application/note_image_service.dart';
import 'package:todolist/src/features/notes/domain/note_link_parser.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';

/// Markdown编辑器组件
class MarkdownEditor extends StatefulWidget {
  const MarkdownEditor({
    super.key,
    required this.controller,
    this.onChanged,
    this.minLines = 10,
    this.maxLines,
    this.autofocus = false,
    this.showPreview = true,
    this.showToolbar = true,
    this.splitView = false, // 新增：是否启用分屏模式
    this.noteRepository, // 新增：用于链接转换
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final int minLines;
  final int? maxLines;
  final bool autofocus;
  final bool showPreview;
  final bool showToolbar;
  final bool splitView;
  final NoteRepository? noteRepository; // 用于获取笔记ID映射

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditing = true;
  bool _isSplitView = false;
  final NoteImageService _imageService = NoteImageService();

  @override
  void initState() {
    super.initState();
    _isSplitView = widget.splitView;
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isEditing = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // 顶部Tab切换/分屏切换 - 美化设计
        if (widget.showPreview)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFF1E1E1E),
                        const Color(0xFF2C2C2C),
                      ]
                    : [
                        const Color(0xFFF8F9FF),
                        const Color(0xFFEEF2FF),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: _isSplitView
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.vertical_split, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      '分屏模式',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : TabBar(
                              controller: _tabController,
                              indicator: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isDark
                                      ? [const Color(0xFF4C51BF), const Color(0xFF6366F1)]
                                      : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              labelColor: Colors.white,
                              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              tabs: [
                                Tab(
                                  height: 48,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.edit_rounded, size: 18),
                                      SizedBox(width: 6),
                                      Text('编辑'),
                                    ],
                                  ),
                                ),
                                Tab(
                                  height: 48,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.visibility_rounded, size: 18),
                                      SizedBox(width: 6),
                                      Text('预览'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 分屏切换按钮
                  IconButton(
                    icon: Icon(
                      _isSplitView ? Icons.tab : Icons.vertical_split,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: _isSplitView ? '切换到标签模式' : '切换到分屏模式',
                    onPressed: () {
                      setState(() {
                        _isSplitView = !_isSplitView;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

        // 工具栏
        if (widget.showToolbar && (_isEditing || _isSplitView))
          _buildToolbar(theme, isDark),

        // 内容区域 - 根据模式显示
        Expanded(
          child: _isSplitView
              ? Row(
                  children: [
                    Expanded(child: _buildEditor(theme)),
                    Container(
                      width: 1,
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                    Expanded(child: _buildPreview(theme)),
                  ],
                )
              : TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildEditor(theme),
                    _buildPreview(theme),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildToolbar(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF2C2C2C),
                  const Color(0xFF1E1E1E),
                ]
              : [
                  Colors.white,
                  const Color(0xFFF8F9FF),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _ToolbarButton(
              icon: Icons.format_bold,
              tooltip: '粗体',
              onPressed: () => _insertMarkdown('**', '**', '粗体文本'),
            ),
            const SizedBox(width: 4),
            _ToolbarButton(
              icon: Icons.format_italic,
              tooltip: '斜体',
              onPressed: () => _insertMarkdown('*', '*', '斜体文本'),
            ),
            const SizedBox(width: 4),
            _ToolbarButton(
              icon: Icons.format_strikethrough,
              tooltip: '删除线',
              onPressed: () => _insertMarkdown('~~', '~~', '删除线文本'),
            ),
            _buildDivider(theme),
            _ToolbarButton(
              icon: Icons.title,
              tooltip: '标题',
              onPressed: () => _showHeadingMenu(),
            ),
            const SizedBox(width: 4),
            _ToolbarButton(
              icon: Icons.format_quote,
              tooltip: '引用',
              onPressed: () => _insertMarkdown('> ', '', '引用文本'),
            ),
            const SizedBox(width: 4),
            _ToolbarButton(
              icon: Icons.code,
              tooltip: '行内代码',
              onPressed: () => _insertMarkdown('`', '`', '代码'),
            ),
            const SizedBox(width: 4),
            _ToolbarButton(
              icon: Icons.data_object,
              tooltip: '代码块',
              onPressed: () => _insertMarkdown('```\n', '\n```', '代码块'),
            ),
            _buildDivider(theme),
            _ToolbarButton(
              icon: Icons.format_list_bulleted,
              tooltip: '无序列表',
              onPressed: () => _insertMarkdown('- ', '', '列表项'),
            ),
            const SizedBox(width: 4),
            _ToolbarButton(
              icon: Icons.format_list_numbered,
              tooltip: '有序列表',
              onPressed: () => _insertMarkdown('1. ', '', '列表项'),
            ),
            const SizedBox(width: 4),
            _ToolbarButton(
              icon: Icons.check_box,
              tooltip: '任务列表',
              onPressed: () => _insertMarkdown('- [ ] ', '', '任务项'),
            ),
            _buildDivider(theme),
            _ToolbarButton(
              icon: Icons.link,
              tooltip: '链接',
              onPressed: () => _insertMarkdown('[', '](url)', '链接文本'),
            ),
            const SizedBox(width: 4),
            _ToolbarButton(
              icon: Icons.image,
              tooltip: '图片',
              onPressed: _insertImage,
            ),
            const SizedBox(width: 4),
            _ToolbarButton(
              icon: Icons.table_chart,
              tooltip: '表格',
              onPressed: () => _insertTable(),
            ),
            const SizedBox(width: 4),
            _ToolbarButton(
              icon: Icons.horizontal_rule,
              tooltip: '分隔线',
              onPressed: () => _insertMarkdown('\n---\n', '', ''),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 1,
      height: 24,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.outline.withOpacity(0.1),
            theme.colorScheme.outline.withOpacity(0.3),
            theme.colorScheme.outline.withOpacity(0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildEditor(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        autofocus: widget.autofocus,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          height: 1.5,
          color: theme.colorScheme.onSurface,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '第一行将作为笔记标题\n\n开始输入Markdown内容...\n支持标题、列表、代码块、表格等',
        ),
        // 使用 buildCounter 来自定义文本样式
        buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPreview(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: FutureBuilder<String>(
        future: _convertNoteLinksTapable(),
        builder: (context, snapshot) {
          String displayContent = snapshot.data ?? widget.controller.text;

          // 解析并渲染内容
          return _buildEnhancedPreview(displayContent, theme);
        },
      ),
    );
  }

  /// 构建增强的预览(支持音频和附件)
  Widget _buildEnhancedPreview(String content, ThemeData theme) {
    if (content.isEmpty) {
      return Markdown(
        data: '# 预览\n\n开始输入内容以查看预览效果...',
        selectable: true,
        styleSheet: _getMarkdownStyleSheet(theme),
      );
    }

    // 提取音频链接
    final audioWidgets = <Widget>[];
    final lines = content.split('\n');
    final processedLines = <String>[];

    for (final line in lines) {
      // 匹配音频链接格式: 🎵 [文件名](路径) (音频, 大小)
      final audioRegex = RegExp(r'🎵 \[(.*?)\]\((.*?)\) \((音频|文件), (.*?)\)');
      final match = audioRegex.firstMatch(line);

      if (match != null) {
        final fileName = match.group(1)!;
        final filePath = match.group(2)!;
        final fileSize = match.group(4)!;

        // 添加音频播放器widget
        audioWidgets.add(AudioPlayerWidget(
          audioPath: filePath,
          fileName: fileName,
          fileSize: fileSize,
        ));
        // 用占位符替换该行
        processedLines.add('<!-- AUDIO_PLAYER_${audioWidgets.length - 1} -->');
      } else {
        processedLines.add(line);
      }
    }

    final processedContent = processedLines.join('\n');

    // 如果没有音频,直接使用Markdown渲染
    if (audioWidgets.isEmpty) {
      return Markdown(
        data: processedContent,
        selectable: true,
        onTapLink: (text, href, title) {
          if (href != null) {
            _handleLinkTap(href);
          }
        },
        builders: {
          'img': CustomMarkdownImageBuilder(),
        },
        styleSheet: _getMarkdownStyleSheet(theme),
      );
    }

    // 有音频,需要混合渲染
    return ListView(
      children: _buildMixedContent(processedContent, audioWidgets, theme),
    );
  }

  /// 构建混合内容(Markdown + 音频播放器)
  List<Widget> _buildMixedContent(
    String content,
    List<Widget> audioWidgets,
    ThemeData theme,
  ) {
    final widgets = <Widget>[];
    final paragraphs = content.split('<!-- AUDIO_PLAYER_');

    for (int i = 0; i < paragraphs.length; i++) {
      if (i == 0) {
        // 第一段,直接渲染Markdown
        if (paragraphs[i].trim().isNotEmpty) {
          widgets.add(
            Markdown(
              data: paragraphs[i],
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              selectable: true,
              onTapLink: (text, href, title) {
                if (href != null) {
                  _handleLinkTap(href);
                }
              },
              builders: {
                'img': CustomMarkdownImageBuilder(),
              },
              styleSheet: _getMarkdownStyleSheet(theme),
            ),
          );
        }
      } else {
        // 提取音频index
        final indexMatch = RegExp(r'^(\d+) -->').firstMatch(paragraphs[i]);
        if (indexMatch != null) {
          final audioIndex = int.parse(indexMatch.group(1)!);
          // 添加音频播放器
          widgets.add(audioWidgets[audioIndex]);

          // 渲染剩余的Markdown内容
          final remainingContent = paragraphs[i].substring(indexMatch.group(0)!.length);
          if (remainingContent.trim().isNotEmpty) {
            widgets.add(
              Markdown(
                data: remainingContent,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                selectable: true,
                onTapLink: (text, href, title) {
                  if (href != null) {
                    _handleLinkTap(href);
                  }
                },
                builders: {
                  'img': CustomMarkdownImageBuilder(),
                },
                styleSheet: _getMarkdownStyleSheet(theme),
              ),
            );
          }
        }
      }
    }

    return widgets;
  }

  /// 获取Markdown样式表
  MarkdownStyleSheet _getMarkdownStyleSheet(ThemeData theme) {
    return MarkdownStyleSheet(
      h1: theme.textTheme.headlineLarge,
      h2: theme.textTheme.headlineMedium,
      h3: theme.textTheme.headlineSmall,
      p: theme.textTheme.bodyLarge,
      code: TextStyle(
        fontFamily: 'monospace',
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),
      codeblockDecoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      blockquote: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontStyle: FontStyle.italic,
      ),
      blockquoteDecoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.primary,
            width: 4,
          ),
        ),
      ),
      a: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
    );
  }

  /// 将 [[笔记链接]] 转换为可点击的 Markdown 链接
  Future<String> _convertNoteLinksTapable() async {
    final content = widget.controller.text;
    if (content.isEmpty || widget.noteRepository == null) {
      return content;
    }

    // 构建标题到ID的映射
    final notes = await widget.noteRepository!.getAll();
    final titleToIdMap = <String, String>{};
    for (final note in notes) {
      titleToIdMap[note.title] = note.id;
    }

    // 使用 NoteLinkParser 转换链接
    return NoteLinkParser.convertToMarkdownLinks(content, titleToIdMap);
  }

  /// 处理链接点击
  void _handleLinkTap(String href) {
    if (href.startsWith('note://')) {
      // 笔记链接
      final noteId = href.replaceFirst('note://', '');
      context.push('/notes/reading/$noteId');
    } else if (href.startsWith('task://')) {
      // 任务链接
      final taskId = href.replaceFirst('task://', '');
      context.push('/tasks/$taskId');
    } else {
      // 其他链接（网络链接等）暂不处理
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('外部链接: $href')),
      );
    }
  }

  /// 插入Markdown标记
  void _insertMarkdown(String prefix, String suffix, String placeholder) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    String newText;
    int newCursorPos;

    if (selection.start == selection.end) {
      // 无选中文本,插入占位符
      newText = text.substring(0, selection.start) +
          prefix +
          placeholder +
          suffix +
          text.substring(selection.start);
      newCursorPos = selection.start + prefix.length;
    } else {
      // 有选中文本,包裹选中内容
      final selectedText = text.substring(selection.start, selection.end);
      newText = text.substring(0, selection.start) +
          prefix +
          selectedText +
          suffix +
          text.substring(selection.end);
      newCursorPos = selection.start + prefix.length + selectedText.length;
    }

    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );

    if (widget.onChanged != null) {
      widget.onChanged!(newText);
    }
  }

  /// 显示标题级别选择菜单
  void _showHeadingMenu() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('选择标题级别'),
        children: [
          for (int i = 1; i <= 6; i++)
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _insertMarkdown('${'#' * i} ', '', '标题 $i');
              },
              child: Text(
                '${'#' * i} 标题 $i',
                style: TextStyle(
                  fontSize: 24 - i * 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 插入表格
  Future<void> _insertTable() async {
    final table = await showDialog<String>(
      context: context,
      builder: (context) => const TableWizardDialog(),
    );

    if (table != null) {
      _insertMarkdown('\n', '', table);
    }
  }

  /// 插入图片
  Future<void> _insertImage() async {
    final source = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择图片来源'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('插入网络图片链接'),
              onTap: () => Navigator.pop(context, 'url'),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    if (source == 'url') {
      // 插入URL占位符
      _insertMarkdown('![', '](https://)', '图片描述');
    } else {
      // 显示加载对话框
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('正在处理图片...'),
                ],
              ),
            ),
          ),
        ),
      );

      // 选择并保存图片
      String? imagePath;
      if (source == 'gallery') {
        imagePath = await _imageService.pickImageFromGallery();
      } else if (source == 'camera') {
        imagePath = await _imageService.pickImageFromCamera();
      }

      // 关闭加载对话框
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (imagePath != null) {
        // 插入图片Markdown
        _insertMarkdown('![', ']($imagePath)', '图片');
      }
    }
  }
}

/// 工具栏按钮
class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF3C3C3C),
                        const Color(0xFF2C2C2C),
                      ]
                    : [
                        const Color(0xFFFFFFFF),
                        const Color(0xFFF3F4F6),
                      ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
