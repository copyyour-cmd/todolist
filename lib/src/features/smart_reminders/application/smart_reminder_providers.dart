import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/features/smart_reminders/application/location_reminder_service.dart';
import 'package:todolist/src/features/smart_reminders/application/smart_reminder_service.dart';
import 'package:todolist/src/infrastructure/notifications/notification_service.dart';

final locationReminderServiceProvider = Provider<LocationReminderService>((ref) {
  return LocationReminderService();
});

final smartReminderServiceProvider = Provider<SmartReminderService>((ref) {
  return SmartReminderService(
    clock: ref.watch(clockProvider),
    idGenerator: ref.watch(idGeneratorProvider),
    notificationService: ref.watch(notificationServiceProvider),
    locationService: ref.watch(locationReminderServiceProvider),
  );
});
