import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/features/tags/application/tag_service.dart';
import 'package:todolist/src/features/tags/presentation/tag_form_dialog.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';

class TagManagementPage extends ConsumerStatefulWidget {
  const TagManagementPage({super.key});

  static const routePath = '/tags';
  static const routeName = 'tags';

  @override
  ConsumerState<TagManagementPage> createState() => _TagManagementPageState();
}

class _TagManagementPageState extends ConsumerState<TagManagementPage> {
  Map<String, int> _taskCounts = {};
  bool _isLoadingCounts = true;

  @override
  void initState() {
    super.initState();
    _loadTaskCounts();
  }

  Future<void> _loadTaskCounts() async {
    setState(() => _isLoadingCounts = true);
    try {
      final service = ref.read(tagServiceProvider);
      final counts = await service.getTaskCountsForAllTags();
      if (mounted) {
        setState(() {
          _taskCounts = counts;
          _isLoadingCounts = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _isLoadingCounts = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tagsAsync = ref.watch(tagsProvider);

    // Reload counts when tags change
    ref.listen(tagsProvider, (_, __) => _loadTaskCounts());

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tagManagementTitle),
        actions: [
          if (_isLoadingCounts)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: tagsAsync.when(
        data: (tags) {
          if (tags.isEmpty) {
            return _EmptyState(
              onCreateTag: () => _showTagForm(context, null),
            );
          }

          // Sort tags by name
          final sortedTags = List<Tag>.from(tags)
            ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedTags.length,
            itemBuilder: (context, index) {
              final tag = sortedTags[index];
              final taskCount = _taskCounts[tag.id] ?? 0;
              return _TagTile(
                tag: tag,
                taskCount: taskCount,
                onTap: () => _showTagForm(context, tag),
                onDelete: () => _deleteTag(context, tag, taskCount),
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
                  l10n.tagManagementLoadError,
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
        onPressed: () => _showTagForm(context, null),
        icon: const Icon(Icons.add),
        label: Text(l10n.tagManagementFabLabel),
      ),
    );
  }

  Future<void> _showTagForm(BuildContext context, Tag? tag) async {
    final result = await TagFormDialog.show(context, tag: tag);
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tag == null
                ? context.l10n.tagManagementCreated
                : context.l10n.tagManagementUpdated,
          ),
        ),
      );
      _loadTaskCounts();
    }
  }

  Future<void> _deleteTag(BuildContext context, Tag tag, int taskCount) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.tagManagementDeleteTitle),
        content: Text(
          taskCount > 0
              ? l10n.tagManagementDeleteMessageWithTasks(tag.name, taskCount)
              : l10n.tagManagementDeleteMessage(tag.name),
        ),
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
      final service = ref.read(tagServiceProvider);
      await service.deleteTag(tag.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              taskCount > 0
                  ? l10n.tagManagementDeletedWithTaskUpdate
                  : l10n.tagManagementDeleted,
            ),
          ),
        );
        _loadTaskCounts();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.tagManagementDeleteError}: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _TagTile extends StatelessWidget {
  const _TagTile({
    required this.tag,
    required this.taskCount,
    required this.onTap,
    required this.onDelete,
  });

  final Tag tag;
  final int taskCount;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorFromHex(tag.colorHex);

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
            Icons.label,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          tag.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          context.l10n.tagManagementTaskCount(taskCount),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (taskCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$taskCount',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              tooltip: context.l10n.commonDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _colorFromHex(String hex) {
    final sanitized = hex.replaceFirst('#', '');
    final value = int.tryParse(sanitized, radix: 16) ?? 0xFF8896AB;
    return Color(0xFF000000 | value);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreateTag});

  final VoidCallback onCreateTag;

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
              Icons.label_outline,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.tagManagementEmptyTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tagManagementEmptySubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreateTag,
              icon: const Icon(Icons.add),
              label: Text(l10n.tagManagementEmptyAction),
            ),
          ],
        ),
      ),
    );
  }
}
