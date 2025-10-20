import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/domain/entities/focus_session.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/features/focus/application/focus_providers.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

class FocusHistoryPage extends ConsumerWidget {
  const FocusHistoryPage({super.key});

  static const routeName = 'focus-history';
  static const routePath = '/focus-history';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final sessionsAsync = ref.watch(focusSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.focusHistoryButton),
      ),
      body: sessionsAsync.when(
        data: (sessions) {
          final completedSessions = sessions
              .where((s) => s.isCompleted)
              .toList()
            ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

          if (completedSessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No focus sessions yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: completedSessions.length,
            itemBuilder: (context, index) {
              final session = completedSessions[index];
              return _FocusSessionTile(session: session);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class _FocusSessionTile extends ConsumerWidget {
  const _FocusSessionTile({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('HH:mm');

    return FutureBuilder<Task?>(
      future: session.taskId != null
          ? ref.read(taskRepositoryProvider).getById(session.taskId!)
          : null,
      builder: (context, snapshot) {
        final task = snapshot.data;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.timer,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(
              task?.title ?? 'Focus Session',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${session.durationMinutes} minutes',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${dateFormat.format(session.startedAt)} at ${timeFormat.format(session.startedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}
