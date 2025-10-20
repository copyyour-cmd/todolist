import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/focus_session.dart';
import 'package:todolist/src/features/focus/application/focus_audio_service.dart';
import 'package:todolist/src/features/focus/application/focus_notification_service.dart';
import 'package:todolist/src/features/focus/application/focus_timer_service.dart';
import 'package:todolist/src/infrastructure/notifications/notification_service.dart';
import 'package:todolist/src/infrastructure/repositories/focus_session_repository.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

final focusSessionRepositoryProvider =
    FutureProvider<FocusSessionRepository>((ref) async {
  return FocusSessionRepository.create();
});

final focusNotificationServiceProvider = Provider<FocusNotificationService>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return FocusNotificationService(notificationService);
});

final focusAudioServiceProvider = Provider<FocusAudioService>((ref) {
  return FocusAudioService();
});

final focusTimerServiceProvider =
    StateNotifierProvider<FocusTimerService, FocusTimerState>((ref) {
  final repository = ref.watch(focusSessionRepositoryProvider).value;
  if (repository == null) {
    throw Exception('FocusSessionRepository not initialized');
  }

  final clock = ref.watch(clockProvider);
  final idGenerator = ref.watch(idGeneratorProvider);
  final notificationService = ref.watch(focusNotificationServiceProvider);
  final taskRepository = ref.watch(taskRepositoryProvider);
  final audioService = ref.watch(focusAudioServiceProvider);

  return FocusTimerService(
    repository,
    clock,
    idGenerator,
    notificationService,
    taskRepository,
    audioService,
  );
});

final focusSessionsProvider = StreamProvider<List<FocusSession>>((ref) {
  final repository = ref.watch(focusSessionRepositoryProvider).value;
  if (repository == null) {
    return const Stream.empty();
  }

  return repository.watchAll();
});

final todayFocusMinutesProvider = Provider<int>((ref) {
  final repository = ref.watch(focusSessionRepositoryProvider).value;
  if (repository == null) return 0;

  return repository.getTotalFocusMinutesToday();
});

final totalFocusMinutesProvider = Provider<int>((ref) {
  final repository = ref.watch(focusSessionRepositoryProvider).value;
  if (repository == null) return 0;

  return repository.getTotalFocusMinutes();
});
