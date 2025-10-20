import 'package:hive/hive.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/custom_view.dart';
import 'package:todolist/src/domain/entities/task.dart';

/// Service for managing custom views and filters
class CustomViewService {
  CustomViewService({
    required Clock clock,
    required IdGenerator idGenerator,
  })  : _clock = clock,
        _idGenerator = idGenerator;

  final Clock _clock;
  final IdGenerator _idGenerator;

  Box<CustomView> get _viewsBox => Hive.box<CustomView>('custom_views');

  /// Get all custom views
  Future<List<CustomView>> getAllViews() async {
    return _viewsBox.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Get all favorite views
  Future<List<CustomView>> getFavoriteViews() async {
    return _viewsBox.values.where((v) => v.isFavorite).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Get view by ID
  Future<CustomView?> getViewById(String id) async {
    return _viewsBox.get(id);
  }

  /// Create a new custom view
  Future<CustomView> createView({
    required String name,
    required ViewType type, String? description,
    List<FilterCondition>? filters,
    SortConfig? sortConfig,
    bool isFavorite = false,
    String? icon,
    String? color,
  }) async {
    final now = _clock.now();
    final view = CustomView(
      id: _idGenerator.generate(),
      name: name,
      description: description,
      type: type,
      filters: filters ?? [],
      sortConfig: sortConfig,
      isFavorite: isFavorite,
      icon: icon,
      color: color,
      createdAt: now,
      updatedAt: now,
      sortOrder: _viewsBox.length,
    );

    await _viewsBox.put(view.id, view);
    return view;
  }

  /// Update an existing view
  Future<CustomView> updateView(CustomView view) async {
    final updated = view.copyWith(updatedAt: _clock.now());
    await _viewsBox.put(view.id, updated);
    return updated;
  }

  /// Delete a view
  Future<void> deleteView(String id) async {
    await _viewsBox.delete(id);
  }

  /// Toggle favorite status
  Future<CustomView> toggleFavorite(String id) async {
    final view = await getViewById(id);
    if (view == null) throw Exception('View not found');

    final updated = view.copyWith(
      isFavorite: !view.isFavorite,
      updatedAt: _clock.now(),
    );
    await _viewsBox.put(id, updated);
    return updated;
  }

  /// Reorder views
  Future<void> reorderViews(List<String> viewIds) async {
    for (var i = 0; i < viewIds.length; i++) {
      final view = await getViewById(viewIds[i]);
      if (view != null) {
        final updated = view.copyWith(
          sortOrder: i,
          updatedAt: _clock.now(),
        );
        await _viewsBox.put(view.id, updated);
      }
    }
  }

  /// Apply a view's filters to a list of tasks
  List<Task> applyViewToTasks(CustomView view, List<Task> tasks) {
    return tasks.applyView(view);
  }

  /// Initialize smart lists (system-provided views)
  Future<void> initializeSmartLists() async {
    final now = _clock.now();

    // Check if smart lists already exist
    final existingViews = await getAllViews();
    final hasSmartLists =
        existingViews.any((v) => v.type == ViewType.smart);

    if (hasSmartLists) return;

    // Today's overdue tasks
    await _viewsBox.put(
      'smart_overdue',
      CustomView(
        id: 'smart_overdue',
        name: '今天逾期',
        description: '今天之前应完成但未完成的任务',
        type: ViewType.smart,
        filters: [
          FilterCondition(
            field: FilterField.status,
            operator: FilterOperator.notEquals,
            value: TaskStatus.completed.name,
          ),
          FilterCondition(
            field: FilterField.dueDate,
            operator: FilterOperator.lessThan,
            value: now.toIso8601String(),
          ),
        ],
        sortConfig: const SortConfig(
          field: FilterField.dueDate,
          order: SortOrder.ascending,
        ),
        isFavorite: false,
        icon: 'error_outline',
        color: 'red',
        createdAt: now,
        updatedAt: now,
        sortOrder: 0,
      ),
    );

    // This week's important tasks
    final weekEnd = now.add(const Duration(days: 7));
    await _viewsBox.put(
      'smart_week_important',
      CustomView(
        id: 'smart_week_important',
        name: '本周重要',
        description: '本周内需要完成的高优先级任务',
        type: ViewType.smart,
        filters: [
          FilterCondition(
            field: FilterField.status,
            operator: FilterOperator.equals,
            value: TaskStatus.pending.name,
          ),
          FilterCondition(
            field: FilterField.priority,
            operator: FilterOperator.equals,
            value: TaskPriority.high.name,
          ),
          FilterCondition(
            field: FilterField.dueDate,
            operator: FilterOperator.lessThan,
            value: weekEnd.toIso8601String(),
          ),
        ],
        sortConfig: const SortConfig(
          field: FilterField.dueDate,
          order: SortOrder.ascending,
        ),
        isFavorite: true,
        icon: 'star',
        color: 'orange',
        createdAt: now,
        updatedAt: now,
        sortOrder: 1,
      ),
    );

    // Tasks without tags
    await _viewsBox.put(
      'smart_no_tags',
      CustomView(
        id: 'smart_no_tags',
        name: '未分类',
        description: '没有标签的任务',
        type: ViewType.smart,
        filters: [
          const FilterCondition(
            field: FilterField.tags,
            operator: FilterOperator.equals,
            value: '',
          ),
        ],
        sortConfig: const SortConfig(
          field: FilterField.createdDate,
          order: SortOrder.descending,
        ),
        isFavorite: false,
        icon: 'label_off',
        color: 'grey',
        createdAt: now,
        updatedAt: now,
        sortOrder: 2,
      ),
    );

    // Tasks with attachments
    await _viewsBox.put(
      'smart_with_attachments',
      CustomView(
        id: 'smart_with_attachments',
        name: '含附件',
        description: '包含附件的任务',
        type: ViewType.smart,
        filters: [
          const FilterCondition(
            field: FilterField.hasAttachments,
            operator: FilterOperator.equals,
          ),
        ],
        sortConfig: const SortConfig(
          field: FilterField.createdDate,
          order: SortOrder.descending,
        ),
        isFavorite: false,
        icon: 'attach_file',
        color: 'blue',
        createdAt: now,
        updatedAt: now,
        sortOrder: 3,
      ),
    );

    // Recently completed
    final weekAgo = now.subtract(const Duration(days: 7));
    await _viewsBox.put(
      'smart_recently_completed',
      CustomView(
        id: 'smart_recently_completed',
        name: '最近完成',
        description: '最近7天内完成的任务',
        type: ViewType.smart,
        filters: [
          FilterCondition(
            field: FilterField.status,
            operator: FilterOperator.equals,
            value: TaskStatus.completed.name,
          ),
          FilterCondition(
            field: FilterField.completedDate,
            operator: FilterOperator.greaterThan,
            value: weekAgo.toIso8601String(),
          ),
        ],
        sortConfig: const SortConfig(
          field: FilterField.completedDate,
          order: SortOrder.descending,
        ),
        isFavorite: false,
        icon: 'check_circle',
        color: 'green',
        createdAt: now,
        updatedAt: now,
        sortOrder: 4,
      ),
    );
  }
}
