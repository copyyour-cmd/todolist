import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/infrastructure/platform/reminder_protection_service.dart';

final reminderProtectionServiceProvider = Provider<ReminderProtectionService>((ref) {
  final logger = ref.watch(appLoggerProvider);
  return ReminderProtectionService(logger);
});
