import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/features/notes/application/reading_mode_settings.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';
import 'package:todolist/src/features/notes/presentation/widgets/note_links_card.dart';
import 'package:todolist/src/features/notes/presentation/widgets/custom_markdown_image_builder.dart';
import 'package:todolist/src/features/notes/domain/note_link_parser.dart';
import 'package:todolist/src/features/ai/presentation/widgets/note_ai_actions.dart';

/// 笔记阅读模式页面
/// 提供专注阅读体验,支持字体调节、行距调节、夜间模式等
class NoteReadingPage extends ConsumerStatefulWidget {
  const NoteReadingPage({
    required this.noteId,
    super.key,
  });

  final String noteId;

  static const routePath = '/notes/reading/:id';
  static const routeName = 'note-reading';

  @override
  ConsumerState<NoteReadingPage> createState() => _NoteReadingPageState();
}

class _NoteReadingPageState extends ConsumerState<NoteReadingPage> {
  bool _showControls = true;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    // 3秒后自动隐藏控制栏
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  void _toggleFullScreen() {
    setState(() => _isFullScreen = !_isFullScreen);
    if (_isFullScreen) {
      // 进入全屏模式
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // 退出全屏模式
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void dispose() {
    // 退出时恢复系统UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteAsync = ref.watch(_noteProvider(widget.noteId));
    final settings = ref.watch(readingModeSettingsProvider);

    return noteAsync.when(
      data: (note) => _buildReadingView(note, settings),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('加载失败: $error'),
        ),
      ),
    );
  }

  Widget _buildReadingView(Note note, ReadingModeSettings settings) {
    return Scaffold(
      backgroundColor: settings.backgroundColor,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // 主要内容区域
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  // 顶部标题
                  if (_showControls || !_isFullScreen)
                    SliverToBoxAdapter(
                      child: AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: _buildHeader(note, settings),
                      ),
                    ),

                  // 内容区域
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _buildContent(note, settings),
                    ),
                  ),

                  // 笔记链接卡片
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: NoteLinksCard(
                        noteId: widget.noteId,
                        onNoteTap: (noteId) {
                          // 导航到另一个笔记的阅读页面
                          context.push('/notes/reading/$noteId');
                        },
                      ),
                    ),
                  ),

                  // AI功能面板
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: NoteAIActions(note: note),
                    ),
                  ),
                ],
              ),
            ),

            // 底部控制栏
            if (_showControls)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildControls(settings),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Note note, ReadingModeSettings settings) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: settings.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: settings.textColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: settings.textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: settings.textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(note.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: settings.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: settings.textColor,
            ),
            onPressed: _toggleFullScreen,
            tooltip: _isFullScreen ? '退出全屏' : '全屏',
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Note note, ReadingModeSettings settings) {
    final textStyle = TextStyle(
      fontSize: settings.fontSize,
      height: settings.lineHeight,
      color: settings.textColor,
      letterSpacing: 0.5,
    );

    // 如果是Markdown格式
    if (note.content.contains('**') ||
        note.content.contains('##') ||
        note.content.contains('- ')) {
      return FutureBuilder<String>(
        future: _convertNoteLinks(note),
        builder: (context, snapshot) {
          final displayContent = snapshot.data ?? note.content;

          return MarkdownBody(
            data: displayContent,
            onTapLink: (text, href, title) {
              if (href != null) {
                _handleLinkTap(href);
              }
            },
            builders: {
              'img': CustomMarkdownImageBuilder(),
            },
            styleSheet: MarkdownStyleSheet(
              p: textStyle,
              h1: textStyle.copyWith(
                fontSize: settings.fontSize + 8,
                fontWeight: FontWeight.bold,
              ),
              h2: textStyle.copyWith(
                fontSize: settings.fontSize + 6,
                fontWeight: FontWeight.bold,
              ),
              h3: textStyle.copyWith(
                fontSize: settings.fontSize + 4,
                fontWeight: FontWeight.bold,
              ),
              listBullet: textStyle,
              code: textStyle.copyWith(
                backgroundColor: settings.textColor.withOpacity(0.1),
                fontFamily: 'monospace',
              ),
              a: textStyle.copyWith(
                color: settings.textColor.withOpacity(0.8),
                decoration: TextDecoration.underline,
              ),
            ),
          );
        },
      );
    }

    // 普通文本
    return SelectableText(
      note.content,
      style: textStyle,
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
      // 笔记链接
      final noteId = href.replaceFirst('note://', '');
      context.push('/notes/reading/$noteId');
    } else if (href.startsWith('task://')) {
      // 任务链接
      final taskId = href.replaceFirst('task://', '');
      context.push('/tasks/$taskId');
    }
  }

  Widget _buildControls(ReadingModeSettings settings) {
    return AnimatedSlide(
      offset: _showControls ? Offset.zero : const Offset(0, 1),
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: settings.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 字体大小控制
              _buildFontSizeControl(settings),
              const Divider(height: 1),

              // 行距控制
              _buildLineHeightControl(settings),
              const Divider(height: 1),

              // 主题/模式切换
              _buildThemeControl(settings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeControl(ReadingModeSettings settings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(Icons.text_fields, color: settings.textColor, size: 20),
          const SizedBox(width: 12),
          Text(
            '字体',
            style: TextStyle(color: settings.textColor, fontSize: 14),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.remove, color: settings.textColor),
            onPressed: () {
              ref.read(readingModeSettingsProvider.notifier).decreaseFontSize();
            },
            tooltip: '减小字体',
          ),
          Expanded(
            child: Slider(
              value: settings.fontSize,
              min: 12.0,
              max: 32.0,
              divisions: 10,
              label: settings.fontSize.toInt().toString(),
              onChanged: (value) {
                ref
                    .read(readingModeSettingsProvider.notifier)
                    .setFontSize(value);
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: settings.textColor),
            onPressed: () {
              ref.read(readingModeSettingsProvider.notifier).increaseFontSize();
            },
            tooltip: '增大字体',
          ),
          Text(
            '${settings.fontSize.toInt()}',
            style: TextStyle(
              color: settings.textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineHeightControl(ReadingModeSettings settings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(Icons.format_line_spacing, color: settings.textColor, size: 20),
          const SizedBox(width: 12),
          Text(
            '行距',
            style: TextStyle(color: settings.textColor, fontSize: 14),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Slider(
              value: settings.lineHeight,
              min: 1.0,
              max: 2.5,
              divisions: 15,
              label: settings.lineHeight.toStringAsFixed(1),
              onChanged: (value) {
                ref
                    .read(readingModeSettingsProvider.notifier)
                    .setLineHeight(value);
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(
            settings.lineHeight.toStringAsFixed(1),
            style: TextStyle(
              color: settings.textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeControl(ReadingModeSettings settings) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette, color: settings.textColor, size: 20),
              const SizedBox(width: 12),
              Text(
                '阅读主题',
                style: TextStyle(color: settings.textColor, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildThemeButton(
                '日间',
                Icons.wb_sunny,
                ReadingModeSettings.dayMode,
                settings,
              ),
              _buildThemeButton(
                '夜间',
                Icons.nights_stay,
                ReadingModeSettings.nightMode,
                settings,
              ),
              _buildThemeButton(
                '护眼',
                Icons.visibility,
                ReadingModeSettings.eyeCareMode,
                settings,
              ),
              _buildThemeButton(
                '羊皮纸',
                Icons.article,
                ReadingModeSettings.parchmentMode,
                settings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeButton(
    String label,
    IconData icon,
    ReadingModeSettings preset,
    ReadingModeSettings current,
  ) {
    final isSelected = current.backgroundColor == preset.backgroundColor &&
        current.textColor == preset.textColor;

    return InkWell(
      onTap: () {
        ref.read(readingModeSettingsProvider.notifier).applyPreset(preset);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? preset.textColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? preset.textColor
                : current.textColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: preset.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: preset.textColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: preset.textColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: current.textColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return '今天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return '昨天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}

/// 获取笔记的Provider
final _noteProvider = FutureProvider.family<Note, String>((ref, noteId) async {
  final repository = ref.watch(noteRepositoryProvider);
  final note = await repository.getById(noteId);
  if (note == null) {
    throw Exception('笔记不存在');
  }
  return note;
});
