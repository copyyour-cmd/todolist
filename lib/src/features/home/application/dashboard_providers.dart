import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/domain/entities/dashboard_stats.dart';
import 'package:todolist/src/features/focus/application/focus_providers.dart';
import 'package:todolist/src/features/home/application/dashboard_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

part 'dashboard_providers.g.dart';

@riverpod
Future<DashboardService> dashboardService(DashboardServiceRef ref) async {
  final focusRepo = await ref.watch(focusSessionRepositoryProvider.future);
  return DashboardService(
    taskRepository: ref.watch(taskRepositoryProvider),
    focusRepository: focusRepo,
    clock: ref.watch(clockProvider),
  );
}

@riverpod
Future<DashboardStats> dashboardStats(DashboardStatsRef ref) async {
  final service = await ref.watch(dashboardServiceProvider.future);
  return service.getDashboardStats();
}
