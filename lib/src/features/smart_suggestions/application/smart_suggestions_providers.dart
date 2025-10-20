import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/task_suggestion.dart';
import 'package:todolist/src/features/smart_suggestions/application/task_intelligence_service.dart';

/// 智能任务建议列表Provider
final smartSuggestionsProvider = FutureProvider<List<TaskSuggestion>>((ref) async {
  final service = ref.watch(taskIntelligenceServiceProvider);
  return service.getSmartSuggestions(limit: 10);
});

/// 获取指定数量的建议
final smartSuggestionsWithLimitProvider = FutureProvider.family<List<TaskSuggestion>, int>(
  (ref, limit) async {
    final service = ref.watch(taskIntelligenceServiceProvider);
    return service.getSmartSuggestions(limit: limit);
  },
);

/// 刷新建议的Provider
final refreshSuggestionsProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(smartSuggestionsProvider);
  };
});
