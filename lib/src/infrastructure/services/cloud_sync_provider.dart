import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/repositories/task_list_repository.dart';
import 'package:todolist/src/domain/repositories/tag_repository.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';
import 'package:todolist/src/infrastructure/http/dio_client.dart';
import 'package:todolist/src/infrastructure/services/auth_service.dart';
import 'package:todolist/src/infrastructure/services/cloud_sync_manager.dart';
import 'package:todolist/src/infrastructure/services/list_cloud_service.dart';
import 'package:todolist/src/infrastructure/services/sync_service.dart';
import 'package:todolist/src/infrastructure/services/tag_cloud_service.dart';
import 'package:todolist/src/infrastructure/services/task_cloud_service.dart';

/// DioClient Provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

/// AuthService Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(dioClientProvider);
  return AuthService(client);
});

/// SyncService Provider
final syncServiceProvider = Provider<SyncService>((ref) {
  final client = ref.watch(dioClientProvider);
  return SyncService(client);
});

/// TaskCloudService Provider
final taskCloudServiceProvider = Provider<TaskCloudService>((ref) {
  final client = ref.watch(dioClientProvider);
  return TaskCloudService(client);
});

/// ListCloudService Provider
final listCloudServiceProvider = Provider<ListCloudService>((ref) {
  final client = ref.watch(dioClientProvider);
  return ListCloudService(client);
});

/// TagCloudService Provider
final tagCloudServiceProvider = Provider<TagCloudService>((ref) {
  final client = ref.watch(dioClientProvider);
  return TagCloudService(client);
});

/// CloudSyncManager Provider
final cloudSyncManagerProvider = ChangeNotifierProvider<CloudSyncManager>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  final taskCloudService = ref.watch(taskCloudServiceProvider);
  final taskRepository = ref.watch(taskRepositoryProvider);
  final authService = ref.watch(authServiceProvider);

  // 可选的Repository
  ListRepository? listRepository;
  TagRepository? tagRepository;

  try {
    listRepository = ref.watch(listRepositoryProvider);
  } catch (_) {
    // ListRepository可能未定义
  }

  try {
    tagRepository = ref.watch(tagRepositoryProvider);
  } catch (_) {
    // TagRepository可能未定义
  }

  return CloudSyncManager(
    syncService: syncService,
    taskCloudService: taskCloudService,
    taskRepository: taskRepository,
    authService: authService,
    listRepository: listRepository,
    tagRepository: tagRepository,
  );
});

/// 自动同步启用状态Provider
final autoSyncEnabledProvider = StateProvider<bool>((ref) => true);

/// 同步状态Provider
final syncStatusProvider = Provider<SyncStatus>((ref) {
  return ref.watch(cloudSyncManagerProvider).status;
});

/// 是否有冲突Provider
final hasConflictsProvider = Provider<bool>((ref) {
  return ref.watch(cloudSyncManagerProvider).hasConflicts;
});
