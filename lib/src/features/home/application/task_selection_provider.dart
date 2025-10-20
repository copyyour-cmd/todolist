import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing task selection mode
final taskSelectionModeProvider = StateProvider<bool>((ref) => false);

/// Provider for managing selected task IDs
final selectedTaskIdsProvider = StateProvider<Set<String>>((ref) => {});

/// Helper extension to manage selection state
extension TaskSelectionHelper on WidgetRef {
  /// Enter selection mode
  void enterSelectionMode() {
    read(taskSelectionModeProvider.notifier).state = true;
  }

  /// Exit selection mode and clear selections
  void exitSelectionMode() {
    read(taskSelectionModeProvider.notifier).state = false;
    read(selectedTaskIdsProvider.notifier).state = {};
  }

  /// Toggle task selection
  void toggleTaskSelection(String taskId) {
    final current = read(selectedTaskIdsProvider);
    final updated = Set<String>.from(current);

    if (updated.contains(taskId)) {
      updated.remove(taskId);
    } else {
      updated.add(taskId);
    }

    read(selectedTaskIdsProvider.notifier).state = updated;

    // Exit selection mode if no tasks are selected
    if (updated.isEmpty) {
      exitSelectionMode();
    }
  }

  /// Select all tasks
  void selectAllTasks(List<String> taskIds) {
    read(selectedTaskIdsProvider.notifier).state = Set<String>.from(taskIds);
  }

  /// Clear all selections
  void clearSelections() {
    read(selectedTaskIdsProvider.notifier).state = {};
  }

  /// Check if a task is selected
  bool isTaskSelected(String taskId) {
    return read(selectedTaskIdsProvider).contains(taskId);
  }

  /// Get selected task count
  int get selectedTaskCount => read(selectedTaskIdsProvider).length;
}
