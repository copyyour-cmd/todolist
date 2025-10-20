import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/features/attachments/application/attachment_cleanup_service.dart';
import 'package:todolist/src/features/attachments/application/attachment_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

final attachmentServiceProvider = Provider<AttachmentService>((ref) {
  final clock = ref.watch(clockProvider);
  final idGenerator = ref.watch(idGeneratorProvider);
  return AttachmentService(clock, idGenerator);
});

/// 附件清理服务Provider
final attachmentCleanupServiceProvider =
    Provider<AttachmentCleanupService>((ref) {
  return AttachmentCleanupService(
    noteRepository: ref.watch(noteRepositoryProvider),
    taskRepository: ref.watch(taskRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
