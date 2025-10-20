import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/features/notes/data/note_link_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

/// 笔记链接关系展示卡片
/// 显示正向链接(该笔记链接到的笔记)和反向链接(链接到该笔记的笔记)
class NoteLinksCard extends ConsumerStatefulWidget {
  const NoteLinksCard({
    required this.noteId,
    this.onNoteTap,
    super.key,
  });

  final String noteId;
  final Function(String noteId)? onNoteTap;

  @override
  ConsumerState<NoteLinksCard> createState() => _NoteLinksCardState();
}

class _NoteLinksCardState extends ConsumerState<NoteLinksCard> {
  NoteLinkStats? _linkStats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLinkStats();
  }

  @override
  void didUpdateWidget(NoteLinksCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.noteId != widget.noteId) {
      _loadLinkStats();
    }
  }

  Future<void> _loadLinkStats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final noteRepository = ref.read(noteRepositoryProvider);
      final linkService = NoteLinkService(noteRepository: noteRepository);
      final stats = await linkService.getLinkStats(widget.noteId);

      setState(() {
        _linkStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Card(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_linkStats == null || !_linkStats!.hasLinks) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surfaceVariant.withOpacity(0.5),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.link,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '笔记链接',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_linkStats!.totalConnections} 个关联笔记',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _buildStatsChip(
                    '${_linkStats!.outboundLinks.length}',
                    Icons.arrow_forward,
                    Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildStatsChip(
                    '${_linkStats!.backlinks.length}',
                    Icons.arrow_back,
                    Colors.green,
                  ),
                ],
              ),
            ),

            // 正向链接
            if (_linkStats!.outboundLinks.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '链接到 (${_linkStats!.outboundLinks.length})',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              ..._linkStats!.outboundLinks
                  .map((note) => _buildLinkItem(note, theme, true)),
            ],

            // 反向链接
            if (_linkStats!.backlinks.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '被链接 (${_linkStats!.backlinks.length})',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              ..._linkStats!.backlinks
                  .map((note) => _buildLinkItem(note, theme, false)),
            ],

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsChip(String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem(Note note, ThemeData theme, bool isOutbound) {
    final accentColor = isOutbound ? Colors.blue : Colors.green;

    return InkWell(
      onTap: () => widget.onNoteTap?.call(note.id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: accentColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getCategoryColor(note.category).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                note.getCategoryIcon(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (note.content.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      note.content,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: accentColor,
            ),
          ],
        ),
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
}
