import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/domain/entities/habit.dart';
import 'package:todolist/src/features/habits/application/habit_providers.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  static const routeName = 'habits';
  static const routePath = '/habits';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('习惯追踪'),
      ),
      body: habitsAsync.when(
        data: (habits) {
          if (habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.track_changes, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    '还没有习惯',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '点击下方按钮创建第一个习惯',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return _HabitTile(habit: habit);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('错误: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateHabitDialog(context, ref);
        },
        icon: const Icon(Icons.add),
        label: const Text('新建习惯'),
      ),
    );
  }

  void _showCreateHabitDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新建习惯'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '习惯名称',
                hintText: '例如: 每天阅读30分钟',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: '描述 (可选)',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final service = ref.read(habitServiceProvider);
                await service.createHabit(
                  name: nameController.text,
                  description: descController.text.isEmpty ? null : descController.text,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }
}

class _HabitTile extends ConsumerWidget {
  const _HabitTile({required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final service = ref.read(habitServiceProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: habit.isCompletedToday,
          onChanged: (value) async {
            if (value ?? false) {
              await service.checkIn(habit);
            } else {
              await service.uncheckIn(habit);
            }
          },
        ),
        title: Text(habit.name),
        subtitle: habit.description != null
            ? Text(habit.description!)
            : Text('连续${habit.currentStreak}天 • 最长${habit.longestStreak}天'),
        onTap: () {
          context.push('/habits/${habit.id}/heatmap');
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (habit.currentStreak > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        size: 16, color: theme.colorScheme.onPrimaryContainer),
                    const SizedBox(width: 4),
                    Text(
                      '${habit.currentStreak}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await service.deleteHabit(habit.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
