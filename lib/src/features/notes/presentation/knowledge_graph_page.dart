import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/features/notes/data/note_link_service.dart';
import 'package:todolist/src/features/notes/presentation/widgets/knowledge_graph_view.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

/// 知识图谱页面
class KnowledgeGraphPage extends ConsumerStatefulWidget {
  const KnowledgeGraphPage({super.key});

  @override
  ConsumerState<KnowledgeGraphPage> createState() =>
      _KnowledgeGraphPageState();
}

class _KnowledgeGraphPageState extends ConsumerState<KnowledgeGraphPage> {
  late NoteLinkService _linkService;
  List<Note> _notes = [];
  List<NoteLinkRelation> _linkRelations = [];
  bool _isLoading = true;
  String? _selectedNoteId;

  @override
  void initState() {
    super.initState();
    _linkService = NoteLinkService(
      noteRepository: ref.read(noteRepositoryProvider),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final notes = await ref.read(noteRepositoryProvider).getAll();
      final relations = await _linkService.getAllLinkRelations();

      setState(() {
        _notes = notes;
        _linkRelations = relations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('知识图谱'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: '刷新',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showHelpDialog(context),
            tooltip: '帮助',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(theme),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_notes.isEmpty) {
      return _buildEmptyState(theme);
    }

    return Row(
      children: [
        // 左侧：图谱视图
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: KnowledgeGraphView(
              notes: _notes,
              linkRelations: _linkRelations,
              highlightNoteId: _selectedNoteId,
              onNoteTap: (note) {
                setState(() {
                  _selectedNoteId = note.id;
                });
              },
            ),
          ),
        ),

        // 右侧：详情面板
        if (_selectedNoteId != null)
          SizedBox(
            width: 300,
            child: _buildDetailPanel(theme),
          ),
      ],
    );
  }

  Widget _buildDetailPanel(ThemeData theme) {
    final note = _notes.firstWhere((n) => n.id == _selectedNoteId);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      note.getCategoryIcon(),
                      style: const TextStyle(fontSize: 24),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _selectedNoteId = null;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note.getCategoryName(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // 统计信息
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '连接统计',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatItem(
                  icon: Icons.arrow_forward,
                  label: '链接到',
                  count: note.linkedNoteIds.length,
                  color: const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<Note>>(
                  future: _linkService.getBacklinks(note.id),
                  builder: (context, snapshot) {
                    final count = snapshot.data?.length ?? 0;
                    return _buildStatItem(
                      icon: Icons.arrow_back,
                      label: '被链接',
                      count: count,
                      color: const Color(0xFF10B981),
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(),

          // 操作按钮
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    context.push('/notes/${note.id}');
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('打开笔记'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    // 在图谱中显示相关笔记
                    _showRelatedNotes(note);
                  },
                  icon: const Icon(Icons.hub),
                  label: const Text('显示相关'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hub_outlined,
            size: 80,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '还没有笔记',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '创建笔记并使用 [[笔记名]] 建立链接\n来构建你的知识网络',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              context.go('/notes');
            },
            icon: const Icon(Icons.add),
            label: const Text('创建笔记'),
          ),
        ],
      ),
    );
  }

  void _showRelatedNotes(Note note) {
    // TODO: 实现过滤显示相关笔记
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('功能开发中')),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help_outline),
            SizedBox(width: 8),
            Text('知识图谱使用说明'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🔗 创建链接',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('在笔记中使用 [[笔记名]] 语法来链接其他笔记。'),
              SizedBox(height: 16),
              Text(
                '🎨 节点说明',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('• 节点大小表示连接数量\n• 不同颜色代表不同分类\n• 点击节点查看详情'),
              SizedBox(height: 16),
              Text(
                '🖱️ 交互操作',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('• 拖拽移动视图\n• 双指缩放\n• 点击节点选择'),
              SizedBox(height: 16),
              Text(
                '💡 提示',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('建议使用横屏查看，体验更佳！'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}
