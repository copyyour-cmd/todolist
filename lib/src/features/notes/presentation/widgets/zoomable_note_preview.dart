import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/features/notes/domain/note_link_parser.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

/// 可缩放的笔记预览组件
/// 支持捏合手势缩放查看笔记内容
class ZoomableNotePreview extends ConsumerStatefulWidget {
  const ZoomableNotePreview({
    required this.note,
    super.key,
  });

  final Note note;

  @override
  ConsumerState<ZoomableNotePreview> createState() => _ZoomableNotePreviewState();
}

class _ZoomableNotePreviewState extends ConsumerState<ZoomableNotePreview>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  // 缩放范围
  static const double _minScale = 0.8;
  static const double _maxScale = 3.0;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    // 双击重置缩放
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    final targetScale = currentScale > 1.0 ? 1.0 : 2.0;

    final targetMatrix = Matrix4.identity()..scale(targetScale);

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: targetMatrix,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward(from: 0).then((_) {
      _animation = null;
    });

    _animation!.addListener(() {
      _transformationController.value = _animation!.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          widget.note.title,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Colors.white),
            onPressed: () {
              final currentScale =
                  _transformationController.value.getMaxScaleOnAxis();
              if (currentScale > _minScale) {
                final newScale = (currentScale - 0.2).clamp(_minScale, _maxScale);
                _transformationController.value = Matrix4.identity()
                  ..scale(newScale);
              }
            },
            tooltip: '缩小',
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: () {
              final currentScale =
                  _transformationController.value.getMaxScaleOnAxis();
              if (currentScale < _maxScale) {
                final newScale = (currentScale + 0.2).clamp(_minScale, _maxScale);
                _transformationController.value = Matrix4.identity()
                  ..scale(newScale);
              }
            },
            tooltip: '放大',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _transformationController.value = Matrix4.identity();
            },
            tooltip: '重置',
          ),
        ],
      ),
      body: GestureDetector(
        onDoubleTap: _handleDoubleTap,
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: _minScale,
          maxScale: _maxScale,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getCategoryColor(widget.note.category),
                                _getCategoryColor(widget.note.category)
                                    .withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.note.getCategoryIcon(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.note.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 元数据
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _buildMetaChip(
                          icon: Icons.category,
                          label: widget.note.getCategoryName(),
                          color: _getCategoryColor(widget.note.category),
                        ),
                        _buildMetaChip(
                          icon: Icons.access_time,
                          label: _formatDate(widget.note.updatedAt),
                          color: Colors.grey,
                        ),
                        _buildMetaChip(
                          icon: Icons.text_fields,
                          label:
                              '${widget.note.wordCount ?? widget.note.content.length}字',
                          color: Colors.blue,
                        ),
                        if (widget.note.viewCount > 0)
                          _buildMetaChip(
                            icon: Icons.visibility,
                            label: '${widget.note.viewCount}次',
                            color: Colors.purple,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 标签
                    if (widget.note.tags.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.note.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.label,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  tag,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 24),

                    // 分隔线
                    Divider(color: theme.dividerColor),
                    const SizedBox(height: 24),

                    // 内容 - 支持Markdown
                    _buildContent(theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black87,
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              const Text(
                '捏合缩放 · 双击重置 · 拖动查看',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    // 检查是否为Markdown格式
    if (widget.note.content.contains('**') ||
        widget.note.content.contains('##') ||
        widget.note.content.contains('- ')) {
      return FutureBuilder<String>(
        future: _convertNoteLinks(widget.note),
        builder: (context, snapshot) {
          final displayContent = snapshot.data ?? widget.note.content;

          return MarkdownBody(
            data: displayContent,
            onTapLink: (text, href, title) {
              if (href != null) {
                _handleLinkTap(href);
              }
            },
            styleSheet: MarkdownStyleSheet(
              p: theme.textTheme.bodyLarge?.copyWith(
                height: 1.8,
                fontSize: 16,
              ),
              h1: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              h2: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              h3: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              listBullet: theme.textTheme.bodyLarge,
              code: theme.textTheme.bodyMedium?.copyWith(
                backgroundColor: theme.colorScheme.surface,
                fontFamily: 'monospace',
              ),
              a: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          );
        },
      );
    }

    // 普通文本
    return SelectableText(
      widget.note.content,
      style: theme.textTheme.bodyLarge?.copyWith(
        height: 1.8,
        fontSize: 16,
      ),
    );
  }

  /// 将 [[笔记链接]] 转换为可点击的 Markdown 链接
  Future<String> _convertNoteLinks(Note note) async {
    final repository = ref.read(noteRepositoryProvider);
    final notes = await repository.getAll();

    final titleToIdMap = <String, String>{};
    for (final n in notes) {
      titleToIdMap[n.title] = n.id;
    }

    return NoteLinkParser.convertToMarkdownLinks(note.content, titleToIdMap);
  }

  /// 处理链接点击
  void _handleLinkTap(String href) {
    if (href.startsWith('note://')) {
      // 笔记链接 - 导航到笔记详情
      final noteId = href.replaceFirst('note://', '');
      context.push('/notes/$noteId');
    } else if (href.startsWith('task://')) {
      // 任务链接
      final taskId = href.replaceFirst('task://', '');
      context.push('/tasks/$taskId');
    }
    // 可以在这里添加外部链接处理
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(NoteCategory category) {
    switch (category) {
      case NoteCategory.work:
        return Colors.blue;
      case NoteCategory.personal:
        return Colors.green;
      case NoteCategory.study:
        return Colors.purple;
      case NoteCategory.project:
        return Colors.orange;
      case NoteCategory.meeting:
        return Colors.teal;
      case NoteCategory.journal:
        return Colors.pink;
      case NoteCategory.reference:
        return Colors.amber;
      case NoteCategory.general:
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日 '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
