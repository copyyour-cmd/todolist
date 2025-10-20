import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/features/cloud/application/cloud_sync_service.dart';
import 'package:todolist/src/infrastructure/http/http_client.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

part 'cloud_sync_provider.g.dart';

/// 云同步服务Provider
@riverpod
CloudSyncService cloudSyncService(CloudSyncServiceRef ref) {
  final logger = ref.watch(appLoggerProvider);
  final httpClient = ref.watch(httpClientProvider);
  final taskRepository = ref.watch(taskRepositoryProvider);
  final listRepository = ref.watch(taskListRepositoryProvider);
  final tagRepository = ref.watch(tagRepositoryProvider);

  return CloudSyncService(
    logger: logger,
    httpClient: httpClient,
    taskRepository: taskRepository,
    listRepository: listRepository,
    tagRepository: tagRepository,
  );
}

