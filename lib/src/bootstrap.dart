import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:todolist/src/core/di/app_provider_observer.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/features/notes/application/reading_mode_settings.dart';
import 'package:todolist/src/features/search/application/enhanced_search_service.dart';
import 'package:todolist/src/features/search/application/search_service.dart';
import 'package:todolist/src/infrastructure/hive/hive_initializer.dart';
import 'package:todolist/src/infrastructure/notifications/notification_service.dart';
import 'package:todolist/src/infrastructure/repositories/hive_app_settings_repository.dart';
import 'package:todolist/src/infrastructure/repositories/hive_note_repository.dart';
import 'package:todolist/src/infrastructure/repositories/hive_tag_repository.dart';
import 'package:todolist/src/infrastructure/repositories/hive_task_list_repository.dart';
import 'package:todolist/src/infrastructure/repositories/hive_task_repository.dart';
import 'package:todolist/src/infrastructure/repositories/hive_task_template_repository.dart';
import 'package:todolist/src/infrastructure/repositories/hive_widget_config_repository.dart';
import 'package:todolist/src/infrastructure/repositories/in_memory_habit_repository.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';
import 'package:todolist/src/infrastructure/seed/demo_data_seeder.dart';
import 'package:todolist/src/features/attachments/application/attachment_cleanup_service.dart';
import 'package:todolist/src/features/reminders/application/reminder_preferences_service.dart';
import 'package:todolist/src/features/reminders/application/system_alarm_service.dart';
import 'package:todolist/src/features/onboarding/presentation/onboarding_wrapper.dart';
import 'package:todolist/src/features/gamification/application/gamification_service.dart';
import 'package:todolist/src/infrastructure/repositories/hive_gamification_repository.dart';

typedef AppBuilder = FutureOr<Widget> Function(ProviderContainer container);

const bool _seedDemoData = bool.fromEnvironment(
  'ENABLE_DEMO_SEED',
  defaultValue: true,
);

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Bootstrap: Flutter binding initialized');

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  print('Bootstrap: Orientation locked to portrait');

  const logger = AppLogger();
  final idGenerator = IdGenerator();
  print('Bootstrap: Logger and ID generator created');

  final hiveInitializer = HiveInitializer();
  print('Bootstrap: Starting Hive initialization...');
  await hiveInitializer.init();
  print('Bootstrap: Hive initialized');

  final systemAlarmService = SystemAlarmService(logger: logger);
  print('Bootstrap: System alarm service created');

  final notificationService = NotificationService(
    clock: const SystemClock(),
    logger: logger,
    enabled: true,
    systemAlarmService: systemAlarmService,
  );
  print('Bootstrap: Starting notification service initialization...');
  await notificationService.init();
  print('Bootstrap: Notification service initialized');

  print('Bootstrap: Creating repositories...');
  final taskRepository = await HiveTaskRepository.create();
  print('Bootstrap: Task repository created');
  final taskListRepository = await HiveTaskListRepository.create();
  print('Bootstrap: Task list repository created');
  final tagRepository = await HiveTagRepository.create();
  print('Bootstrap: Tag repository created');
  final appSettingsRepository = await HiveAppSettingsRepository.create();
  print('Bootstrap: App settings repository created');
  final taskTemplateRepository = await HiveTaskTemplateRepository.create();
  print('Bootstrap: Task template repository created');
  final habitRepository = InMemoryHabitRepository();
  print('Bootstrap: Habit repository created');

  // Import widget config repository
  final widgetConfigRepository = await HiveWidgetConfigRepository.create();
  print('Bootstrap: Widget config repository created');
  final noteRepository = await HiveNoteRepository.create();
  print('Bootstrap: Note repository created');

  print('Bootstrap: Creating shared preferences...');
  final sharedPreferences = await SharedPreferences.getInstance();
  print('Bootstrap: Shared preferences created');
  final searchService = SearchService(sharedPreferences);
  final enhancedSearchService = EnhancedSearchService(sharedPreferences);
  final readingModeSettings = ReadingModeSettingsService(sharedPreferences);
  final reminderPreferencesService = ReminderPreferencesService(
    prefs: sharedPreferences,
    logger: logger,
  );
  print('Bootstrap: Reminder preferences service created');

  print('Bootstrap: Creating demo data seeder...');
  final seeder = DemoDataSeeder(
    taskRepository: taskRepository,
    taskListRepository: taskListRepository,
    tagRepository: tagRepository,
    idGenerator: idGenerator,
    isEnabled: _seedDemoData,
  );
  print('Bootstrap: Starting demo data seeding (enabled: $_seedDemoData)...');
  await seeder.seedIfEmpty();
  print('Bootstrap: Demo data seeding complete');

  // 初始化游戏化系统
  print('Bootstrap: Initializing gamification system...');
  final gamificationRepository = HiveGamificationRepository();
  // 确保repository的box都已打开
  await gamificationRepository.getAllBadges();

  final gamificationService = GamificationService(
    repository: gamificationRepository,
    clock: const SystemClock(),
    idGenerator: idGenerator,
  );

  // 初始化用户统计数据（如果不存在会自动创建）
  print('Bootstrap: Initializing user stats...');
  await gamificationService.getUserStats();
  print('Bootstrap: User stats initialized');

  await gamificationService.initializePresets();
  print('Bootstrap: Initializing prize pool...');
  await gamificationService.initializePrizePool();
  print('Bootstrap: Prize pool initialized');
  await gamificationService.initializeTitles();
  print('Bootstrap: Gamification system initialized');

  // 执行附件清理（后台异步，不阻塞启动）
  print('Bootstrap: Scheduling attachment cleanup...');
  Future.delayed(Duration.zero, () async {
    try {
      final cleanupService = AttachmentCleanupService(
        noteRepository: noteRepository,
        taskRepository: taskRepository,
        logger: logger,
      );
      print('AttachmentCleanup: Starting cleanup task...');
      final result = await cleanupService.cleanupOrphanedFiles();
      print('AttachmentCleanup: Cleanup completed - $result');
    } catch (e, stack) {
      logger.error('AttachmentCleanup: Failed to cleanup attachments', e, stack);
      print('AttachmentCleanup ERROR: $e');
    }
  });

  print('Bootstrap: Creating provider container...');
  final container = ProviderContainer(
    observers: [AppProviderObserver(logger: logger)],
    overrides: [
      appLoggerProvider.overrideWithValue(logger),
      idGeneratorProvider.overrideWithValue(idGenerator),
      appSettingsRepositoryProvider.overrideWithValue(appSettingsRepository),
      taskRepositoryProvider.overrideWithValue(taskRepository),
      taskListRepositoryProvider.overrideWithValue(taskListRepository),
      tagRepositoryProvider.overrideWithValue(tagRepository),
      taskTemplateRepositoryProvider.overrideWithValue(taskTemplateRepository),
      habitRepositoryProvider.overrideWithValue(habitRepository),
      widgetConfigRepositoryProvider.overrideWithValue(widgetConfigRepository),
      noteRepositoryProvider.overrideWithValue(noteRepository),
      searchServiceProvider.overrideWithValue(searchService),
      enhancedSearchServiceProvider.overrideWithValue(enhancedSearchService),
      readingModeSettingsProvider.overrideWith((ref) => readingModeSettings),
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      notificationServiceProvider.overrideWithValue(notificationService),
      reminderPreferencesServiceProvider.overrideWithValue(reminderPreferencesService),
    ],
  );
  print('Bootstrap: Provider container created');

  FlutterError.onError = (FlutterErrorDetails details) {
    logger.recordFlutterError(details);
  };

  print('Bootstrap: Setting up zone guard...');
  await runZonedGuarded(
    () async {
      print('Bootstrap: Building app...');
      final app = await builder(container);
      print('Bootstrap: App built, running app...');

      // 使用 OnboardingWrapper 来处理首次启动引导
      print('Bootstrap: Wrapping app with onboarding...');
      runApp(
        UncontrolledProviderScope(
          container: container,
          child: OnboardingWrapper(
            sharedPreferences: sharedPreferences,
            child: app,
          ),
        ),
      );
      print('Bootstrap: App launched successfully');
    },
    (error, stackTrace) {
      logger.error('Uncaught zone error', error, stackTrace);
      print('Bootstrap ERROR: $error');
      print('Bootstrap STACK: $stackTrace');
    },
  );
}
