import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/domain/entities/custom_view.dart';
import 'package:todolist/src/features/custom_views/application/custom_view_providers.dart';
import 'package:todolist/src/features/custom_views/presentation/view_editor_page.dart';

class ViewManagementPage extends ConsumerStatefulWidget {
  const ViewManagementPage({super.key});

  static const routePath = '/view-management';
  static const routeName = 'viewManagement';

  @override
  ConsumerState<ViewManagementPage> createState() =>
      _ViewManagementPageState();
}

class _ViewManagementPageState extends ConsumerState<ViewManagementPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewsAsync = ref.watch(allCustomViewsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义视图管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewView,
          ),
        ],
      ),
      body: viewsAsync.when(
        data: (views) {
          if (views.isEmpty) {
            return _buildEmptyState(theme);
          }

          // Separate smart and custom views
          final smartViews =
              views.where((v) => v.type == ViewType.smart).toList();
          final customViews =
              views.where((v) => v.type == ViewType.custom).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (smartViews.isNotEmpty) ...[
                Text(
                  '智能列表',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...smartViews.map((view) => _ViewCard(
                      view: view,
                      onTap: () => _editView(view),
                      onToggleFavorite: () => _toggleFavorite(view.id),
                      onDelete: null, // Smart views cannot be deleted
                    )),
                const SizedBox(height: 24),
              ],
              if (customViews.isNotEmpty) ...[
                Text(
                  '自定义视图',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...customViews.map((view) => _ViewCard(
                      view: view,
                      onTap: () => _editView(view),
                      onToggleFavorite: () => _toggleFavorite(view.id),
                      onDelete: () => _deleteView(view),
                    )),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('加载失败: $error'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.view_list,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '还没有自定义视图',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右上角 + 按钮创建新视图',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createNewView() async {
    context.push(ViewEditorPage.buildPath());
  }

  Future<void> _editView(CustomView view) async {
    context.push(ViewEditorPage.buildPath(viewId: view.id));
  }

  Future<void> _toggleFavorite(String viewId) async {
    try {
      final service = ref.read(customViewServiceProvider);
      await service.toggleFavorite(viewId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }

  Future<void> _deleteView(CustomView view) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除视图'),
        content: Text('确定要删除视图 "${view.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        final service = ref.read(customViewServiceProvider);
        await service.deleteView(view.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已删除')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('删除失败: $e')),
          );
        }
      }
    }
  }
}

class _ViewCard extends StatelessWidget {
  const _ViewCard({
    required this.view,
    required this.onTap,
    required this.onToggleFavorite,
    this.onDelete,
  });

  final CustomView view;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    IconData icon;
    switch (view.icon) {
      case 'star':
        icon = Icons.star;
      case 'error_outline':
        icon = Icons.error_outline;
      case 'label_off':
        icon = Icons.label_off;
      case 'attach_file':
        icon = Icons.attach_file;
      case 'check_circle':
        icon = Icons.check_circle;
      default:
        icon = Icons.view_list;
    }

    Color? cardColor;
    if (view.color != null) {
      switch (view.color) {
        case 'red':
          cardColor = Colors.red.withValues(alpha: 0.1);
        case 'orange':
          cardColor = Colors.orange.withValues(alpha: 0.1);
        case 'green':
          cardColor = Colors.green.withValues(alpha: 0.1);
        case 'blue':
          cardColor = Colors.blue.withValues(alpha: 0.1);
        case 'grey':
          cardColor = Colors.grey.withValues(alpha: 0.1);
      }
    }

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Row(
          children: [
            Expanded(child: Text(view.name)),
            if (view.type == ViewType.smart)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '智能',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
          ],
        ),
        subtitle: view.description != null
            ? Text(
                view.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                view.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: view.isFavorite ? Colors.red : null,
              ),
              onPressed: onToggleFavorite,
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
