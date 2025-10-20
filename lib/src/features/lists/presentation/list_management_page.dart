import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/features/lists/application/list_service.dart';
import 'package:todolist/src/features/lists/presentation/list_form_dialog.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';

class ListManagementPage extends ConsumerStatefulWidget {
  const ListManagementPage({super.key});

  static const routePath = '/lists';
  static const routeName = 'lists';

  @override
  ConsumerState<ListManagementPage> createState() =>
      _ListManagementPageState();
}

class _ListManagementPageState extends ConsumerState<ListManagementPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final listsAsync = ref.watch(taskListsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.listManagementTitle),
      ),
      body: listsAsync.when(
        data: (lists) {
          if (lists.isEmpty) {
            return _EmptyState(
              onCreateList: () => _showListForm(context, null),
            );
          }
          return ReorderableListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lists.length,
            onReorder: (oldIndex, newIndex) =>
                _reorderLists(lists, oldIndex, newIndex),
            itemBuilder: (context, index) {
              final list = lists[index];
              return _ListTile(
                key: ValueKey(list.id),
                list: list,
                onTap: () => _showListForm(context, list),
                onDelete: () => _deleteList(context, list),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.listManagementLoadError,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showListForm(context, null),
        icon: const Icon(Icons.add),
        label: Text(l10n.listManagementFabLabel),
      ),
    );
  }

  Future<void> _showListForm(BuildContext context, TaskList? list) async {
    final result = await ListFormDialog.show(context, list: list);
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            list == null
                ? context.l10n.listManagementCreated
                : context.l10n.listManagementUpdated,
          ),
        ),
      );
    }
  }

  Future<void> _deleteList(BuildContext context, TaskList list) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.listManagementDeleteTitle),
        content: Text(l10n.listManagementDeleteMessage(list.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final service = ref.read(listServiceProvider);
      await service.deleteList(list.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.listManagementDeleted)),
        );
      }
    } on ListHasTasksException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.listManagementDeleteErrorHasTasks),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.listManagementDeleteError}: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _reorderLists(
    List<TaskList> lists,
    int oldIndex,
    int newIndex,
  ) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final reorderedLists = List<TaskList>.from(lists);
    final item = reorderedLists.removeAt(oldIndex);
    reorderedLists.insert(newIndex, item);

    try {
      final service = ref.read(listServiceProvider);
      await service.reorderLists(reorderedLists);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.l10n.listManagementReorderError}: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    required super.key,
    required this.list,
    required this.onTap,
    required this.onDelete,
  });

  final TaskList list;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorFromHex(list.colorHex);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIconData(list.iconName),
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          list.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: list.isDefault
            ? Text(
                context.l10n.listManagementDefaultLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              tooltip: context.l10n.commonDelete,
            ),
            ReorderableDragStartListener(
              index: 0,
              child: Icon(
                Icons.drag_handle,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    if (iconName == null) return Icons.list;
    return switch (iconName) {
      'inbox' => Icons.inbox,
      'work' => Icons.work,
      'home' => Icons.home,
      'shopping_cart' => Icons.shopping_cart,
      'favorite' => Icons.favorite,
      'star' => Icons.star,
      'calendar_today' => Icons.calendar_today,
      'school' => Icons.school,
      'fitness_center' => Icons.fitness_center,
      'restaurant' => Icons.restaurant,
      'flight' => Icons.flight,
      'lightbulb' => Icons.lightbulb,
      'brush' => Icons.brush,
      'music_note' => Icons.music_note,
      'sports_soccer' => Icons.sports_soccer,
      _ => Icons.list,
    };
  }

  Color _colorFromHex(String hex) {
    final sanitized = hex.replaceFirst('#', '');
    final value = int.tryParse(sanitized, radix: 16) ?? 0xFF4C83FB;
    return Color(0xFF000000 | value);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreateList});

  final VoidCallback onCreateList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.playlist_add,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.listManagementEmptyTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.listManagementEmptySubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreateList,
              icon: const Icon(Icons.add),
              label: Text(l10n.listManagementEmptyAction),
            ),
          ],
        ),
      ),
    );
  }
}
