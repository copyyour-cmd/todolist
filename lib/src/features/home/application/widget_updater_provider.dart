import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';
import 'package:todolist/src/infrastructure/widgets/home_widget_provider.dart';

/// Provider that automatically updates the home widget when tasks change
final widgetUpdaterProvider = Provider<void>((ref) {
  // Watch for task changes
  ref.listen(taskRepositoryProvider, (_, __) async {
    final homeWidgetService = ref.read(homeWidgetServiceProvider);
    final taskRepository = ref.read(taskRepositoryProvider);

    try {
      // Get all tasks
      final allTasks = await taskRepository.getAll();

      // Filter today's tasks
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final todayTasks = allTasks.where((task) {
        if (task.dueAt == null) return false;
        final dueDate = DateTime(
          task.dueAt!.year,
          task.dueAt!.month,
          task.dueAt!.day,
        );
        return dueDate == today;
      }).toList();

      // Update widget
      await homeWidgetService.updateWidget(todayTasks: todayTasks);
    } catch (e) {
      // Silently fail - don't crash the app if widget update fails
      print('Failed to update home widget: $e');
    }
  });

  return;
});

/// Manual function to trigger widget update
Future<void> updateHomeWidget(WidgetRef ref) async {
  final homeWidgetService = ref.read(homeWidgetServiceProvider);
  final taskRepository = ref.read(taskRepositoryProvider);

  try {
    final allTasks = await taskRepository.getAll();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayTasks = allTasks.where((task) {
      if (task.dueAt == null) return false;
      final dueDate = DateTime(
        task.dueAt!.year,
        task.dueAt!.month,
        task.dueAt!.day,
      );
      return dueDate == today;
    }).toList();

    await homeWidgetService.updateWidget(todayTasks: todayTasks);
  } catch (e) {
    print('Failed to update home widget: $e');
  }
}
