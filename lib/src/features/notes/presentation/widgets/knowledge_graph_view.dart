import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/features/notes/data/note_link_service.dart';

/// 知识图谱视图
/// 使用力导向图算法可视化笔记间的链接关系
class KnowledgeGraphView extends StatefulWidget {
  const KnowledgeGraphView({
    required this.notes,
    required this.linkRelations,
    this.highlightNoteId,
    this.onNoteTap,
    super.key,
  });

  final List<Note> notes;
  final List<NoteLinkRelation> linkRelations;
  final String? highlightNoteId; // 高亮显示的笔记
  final ValueChanged<Note>? onNoteTap;

  @override
  State<KnowledgeGraphView> createState() => _KnowledgeGraphViewState();
}

class _KnowledgeGraphViewState extends State<KnowledgeGraphView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<GraphNode> _nodes = [];
  final List<GraphEdge> _edges = [];
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // ~60fps
    )..addListener(_simulatePhysics);

    _buildGraph();
    _animationController.repeat();
  }

  @override
  void didUpdateWidget(KnowledgeGraphView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notes != oldWidget.notes ||
        widget.linkRelations != oldWidget.linkRelations) {
      _buildGraph();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _buildGraph() {
    _nodes.clear();
    _edges.clear();

    // 创建节点
    for (final note in widget.notes) {
      final isHighlighted = note.id == widget.highlightNoteId;
      final connectionCount = widget.linkRelations
          .where((r) => r.sourceNoteId == note.id || r.targetNoteId == note.id)
          .length;

      _nodes.add(GraphNode(
        id: note.id,
        label: note.title,
        note: note,
        isHighlighted: isHighlighted,
        connectionCount: connectionCount,
      ));
    }

    // 创建边
    final nodeMap = {for (var node in _nodes) node.id: node};
    for (final relation in widget.linkRelations) {
      final source = nodeMap[relation.sourceNoteId];
      final target = nodeMap[relation.targetNoteId];

      if (source != null && target != null) {
        _edges.add(GraphEdge(source: source, target: target));
      }
    }
  }

  void _simulatePhysics() {
    if (_nodes.isEmpty) return;

    const double repulsionStrength = 5000.0;
    const double attractionStrength = 0.01;
    const double damping = 0.9;

    // 计算节点间的斥力
    for (var i = 0; i < _nodes.length; i++) {
      for (var j = i + 1; j < _nodes.length; j++) {
        final node1 = _nodes[i];
        final node2 = _nodes[j];

        final dx = node2.x - node1.x;
        final dy = node2.y - node1.y;
        final distance = math.sqrt(dx * dx + dy * dy).clamp(1.0, double.infinity);

        final force = repulsionStrength / (distance * distance);
        final fx = (dx / distance) * force;
        final fy = (dy / distance) * force;

        node1.vx -= fx;
        node1.vy -= fy;
        node2.vx += fx;
        node2.vy += fy;
      }
    }

    // 计算边的引力
    for (final edge in _edges) {
      final dx = edge.target.x - edge.source.x;
      final dy = edge.target.y - edge.source.y;
      final distance = math.sqrt(dx * dx + dy * dy);

      final force = distance * attractionStrength;
      final fx = (dx / distance) * force;
      final fy = (dy / distance) * force;

      edge.source.vx += fx;
      edge.source.vy += fy;
      edge.target.vx -= fx;
      edge.target.vy -= fy;
    }

    // 更新节点位置
    for (final node in _nodes) {
      node.x += node.vx;
      node.y += node.vy;
      node.vx *= damping;
      node.vy *= damping;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_nodes.isEmpty) {
      return _buildEmptyState(theme);
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // 标题栏
            _buildHeader(theme),
            const Divider(height: 1),

            // 图谱视图
            Expanded(
              child: InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: const EdgeInsets.all(200),
                minScale: 0.1,
                maxScale: 4.0,
                child: CustomPaint(
                  painter: GraphPainter(
                    nodes: _nodes,
                    edges: _edges,
                    theme: theme,
                  ),
                  child: GestureDetector(
                    onTapUp: (details) {
                      _handleTap(details.localPosition);
                    },
                    child: Container(
                      width: 2000,
                      height: 2000,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),

            // 底部控制栏
            _buildControls(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.hub_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '知识图谱',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_nodes.length} 个笔记 · ${_edges.length} 条连接',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.zoom_in,
            label: '放大',
            onPressed: () {
              final currentScale = _transformationController.value.getMaxScaleOnAxis();
              _transformationController.value =
                  _transformationController.value.scaled(1.2);
            },
          ),
          _buildControlButton(
            icon: Icons.zoom_out,
            label: '缩小',
            onPressed: () {
              _transformationController.value =
                  _transformationController.value.scaled(0.8);
            },
          ),
          _buildControlButton(
            icon: Icons.center_focus_strong,
            label: '重置',
            onPressed: () {
              _transformationController.value = Matrix4.identity();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.hub_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              '暂无笔记网络',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '创建笔记并使用 [[笔记名]] 建立链接',
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(Offset position) {
    // 考虑变换矩阵
    final inverse = _transformationController.value.clone()..invert();
    final transformedPosition = MatrixUtils.transformPoint(inverse, position);

    for (final node in _nodes) {
      final dx = transformedPosition.dx - node.x - 1000;
      final dy = transformedPosition.dy - node.y - 1000;
      final distance = math.sqrt(dx * dx + dy * dy);

      if (distance < node.radius) {
        widget.onNoteTap?.call(node.note);
        break;
      }
    }
  }
}

/// 图谱节点
class GraphNode {
  GraphNode({
    required this.id,
    required this.label,
    required this.note,
    this.isHighlighted = false,
    this.connectionCount = 0,
  })  : x = math.Random().nextDouble() * 800 + 100,
        y = math.Random().nextDouble() * 800 + 100;

  final String id;
  final String label;
  final Note note;
  final bool isHighlighted;
  final int connectionCount;

  double x;
  double y;
  double vx = 0.0;
  double vy = 0.0;

  // 根据连接数计算节点大小
  double get radius {
    final baseRadius = 30.0;
    final bonus = math.min(connectionCount * 5.0, 30.0);
    return baseRadius + bonus;
  }
}

/// 图谱边
class GraphEdge {
  const GraphEdge({
    required this.source,
    required this.target,
  });

  final GraphNode source;
  final GraphNode target;
}

/// 图谱绘制器
class GraphPainter extends CustomPainter {
  GraphPainter({
    required this.nodes,
    required this.edges,
    required this.theme,
  });

  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制边
    final edgePaint = Paint()
      ..color = theme.colorScheme.outline.withOpacity(0.3)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final edge in edges) {
      canvas.drawLine(
        Offset(edge.source.x + 1000, edge.source.y + 1000),
        Offset(edge.target.x + 1000, edge.target.y + 1000),
        edgePaint,
      );
    }

    // 绘制节点
    for (final node in nodes) {
      final center = Offset(node.x + 1000, node.y + 1000);

      // 节点圆形
      final nodePaint = Paint()
        ..color = node.isHighlighted
            ? theme.colorScheme.primary
            : _getCategoryColor(node.note.category)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, node.radius, nodePaint);

      // 边框
      final borderPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(center, node.radius, borderPaint);

      // 标签
      final textPainter = TextPainter(
        text: TextSpan(
          text: node.label.length > 8
              ? '${node.label.substring(0, 8)}...'
              : node.label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2,
        ),
      );
    }
  }

  Color _getCategoryColor(NoteCategory category) {
    switch (category) {
      case NoteCategory.work:
        return const Color(0xFF3B82F6);
      case NoteCategory.personal:
        return const Color(0xFF10B981);
      case NoteCategory.study:
        return const Color(0xFFF59E0B);
      case NoteCategory.project:
        return const Color(0xFF8B5CF6);
      case NoteCategory.meeting:
        return const Color(0xFFEC4899);
      case NoteCategory.journal:
        return const Color(0xFF06B6D4);
      case NoteCategory.reference:
        return const Color(0xFF64748B);
      default:
        return const Color(0xFF6366F1);
    }
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) => true;
}
