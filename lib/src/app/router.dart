import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/features/ai/presentation/ai_settings_page.dart';
import 'package:todolist/src/features/backup/presentation/backup_restore_page.dart';
import 'package:todolist/src/features/calendar/presentation/calendar_page.dart';
import 'package:todolist/src/features/calendar/presentation/calendar_view_page.dart';
import 'package:todolist/src/features/cloud/presentation/cloud_sync_page.dart';
import 'package:todolist/src/features/cloud/presentation/login_page.dart';
import 'package:todolist/src/features/cloud/presentation/register_page.dart';
import 'package:todolist/src/features/export/presentation/export_page.dart';
import 'package:todolist/src/features/focus/presentation/focus_heatmap_page.dart';
import 'package:todolist/src/features/focus/presentation/focus_history_page.dart';
import 'package:todolist/src/features/focus/presentation/focus_mode_page.dart';
import 'package:todolist/src/features/focus/presentation/time_estimation_page.dart';
import 'package:todolist/src/features/habits/presentation/habit_heatmap_page.dart';
import 'package:todolist/src/features/habits/presentation/habits_page.dart';
import 'package:todolist/src/features/home/presentation/home_page.dart';
import 'package:todolist/src/features/lists/presentation/list_management_page.dart';
import 'package:todolist/src/features/notes/presentation/knowledge_graph_page.dart';
import 'package:todolist/src/features/notes/presentation/note_editor_page.dart';
import 'package:todolist/src/features/notes/presentation/note_reading_page.dart';
import 'package:todolist/src/features/notes/presentation/note_search_page.dart';
import 'package:todolist/src/features/notes/presentation/note_statistics_page.dart';
import 'package:todolist/src/features/notes/presentation/notes_list_page.dart';
import 'package:todolist/src/features/search/presentation/enhanced_search_page.dart';
import 'package:todolist/src/features/search/presentation/search_page.dart';
import 'package:todolist/src/features/settings/application/app_settings_provider.dart';
import 'package:todolist/src/features/settings/application/app_settings_service.dart';
import 'package:todolist/src/features/settings/presentation/notification_test_page.dart';
import 'package:todolist/src/features/shop/presentation/shop_page.dart';
import 'package:todolist/src/features/smart_suggestions/presentation/smart_suggestions_page.dart';
import 'package:todolist/src/features/settings/presentation/reminder_protection_page.dart';
import 'package:todolist/src/features/settings/presentation/settings_page.dart';
import 'package:todolist/src/features/settings/presentation/theme_selection_page.dart';
import 'package:todolist/src/features/settings/presentation/unlock_page.dart';
import 'package:todolist/src/features/speech/presentation/speech_history_page.dart';
import 'package:todolist/src/features/speech/presentation/speech_settings_page.dart';
import 'package:todolist/src/features/statistics/presentation/statistics_page.dart';
import 'package:todolist/src/features/tags/presentation/tag_management_page.dart';
import 'package:todolist/src/features/tasks/presentation/task_detail_page.dart';
import 'package:todolist/src/features/templates/presentation/template_browser_page.dart';
import 'package:todolist/src/features/widgets/presentation/widget_config_page.dart';
import 'package:todolist/src/features/widgets/presentation/widget_settings_page.dart';
import 'package:todolist/src/features/predictive_reminders/presentation/predictive_reminders_page.dart';
import 'package:todolist/src/features/animations/presentation/animation_settings_page.dart';
import 'package:todolist/src/features/gamification/presentation/gamification_page.dart';
import 'package:todolist/src/features/gamification/presentation/badges_page.dart';
import 'package:todolist/src/features/gamification/presentation/achievements_page.dart';
import 'package:todolist/src/features/gamification/presentation/challenges_page.dart';
import 'package:todolist/src/features/gamification/presentation/titles_page.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  // 只监听密码相关的设置，避免主题更新时触发路由器重建
  final settingsAsync = ref.watch(
    appSettingsProvider.select((value) => value.whenData(
      (settings) => (
        requirePassword: settings.requirePassword,
        hasPassword: settings.hasPassword,
      ),
    )),
  );
  final isUnlocked = ref.watch(passwordUnlockedProvider);

  return GoRouter(
    initialLocation: HomePage.routePath,
    routes: [
      GoRoute(
        path: CalendarViewPage.routePath,
        name: CalendarViewPage.routeName,
        builder: (context, state) => const CalendarViewPage(),
      ),
      GoRoute(
        path: HomePage.routePath,
        name: HomePage.routeName,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: SettingsPage.routePath,
        name: SettingsPage.routeName,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: ThemeSelectionPage.routePath,
        name: ThemeSelectionPage.routeName,
        builder: (context, state) => const ThemeSelectionPage(),
      ),
      GoRoute(
        path: UnlockPage.routePath,
        name: UnlockPage.routeName,
        builder: (context, state) => const UnlockPage(),
      ),
      GoRoute(
        path: ListManagementPage.routePath,
        name: ListManagementPage.routeName,
        builder: (context, state) => const ListManagementPage(),
      ),
      GoRoute(
        path: TagManagementPage.routePath,
        name: TagManagementPage.routeName,
        builder: (context, state) => const TagManagementPage(),
      ),
      GoRoute(
        path: SearchPage.routePath,
        name: SearchPage.routeName,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: TaskDetailPage.routePath,
        name: TaskDetailPage.routeName,
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return TaskDetailPage(taskId: taskId);
        },
      ),
      GoRoute(
        path: StatisticsPage.routePath,
        name: StatisticsPage.routeName,
        builder: (context, state) => const StatisticsPage(),
      ),
      GoRoute(
        path: CalendarPage.routePath,
        name: CalendarPage.routeName,
        builder: (context, state) => const CalendarPage(),
      ),
      GoRoute(
        path: FocusModePage.routePath,
        name: FocusModePage.routeName,
        builder: (context, state) => const FocusModePage(),
      ),
      GoRoute(
        path: FocusHistoryPage.routePath,
        name: FocusHistoryPage.routeName,
        builder: (context, state) => const FocusHistoryPage(),
      ),
      GoRoute(
        path: FocusHeatmapPage.routePath,
        name: FocusHeatmapPage.routeName,
        builder: (context, state) => const FocusHeatmapPage(),
      ),
      GoRoute(
        path: TimeEstimationPage.routePath,
        name: TimeEstimationPage.routeName,
        builder: (context, state) => const TimeEstimationPage(),
      ),
      GoRoute(
        path: TemplateBrowserPage.routePath,
        name: TemplateBrowserPage.routeName,
        builder: (context, state) => const TemplateBrowserPage(),
      ),
      GoRoute(
        path: ExportPage.routePath,
        name: ExportPage.routeName,
        builder: (context, state) => const ExportPage(),
      ),
      GoRoute(
        path: HabitsPage.routePath,
        name: HabitsPage.routeName,
        builder: (context, state) => const HabitsPage(),
      ),
      GoRoute(
        path: HabitHeatmapPage.routePath,
        name: HabitHeatmapPage.routeName,
        builder: (context, state) {
          final habitId = state.pathParameters['id']!;
          return HabitHeatmapPage(habitId: habitId);
        },
      ),
      GoRoute(
        path: WidgetSettingsPage.routePath,
        name: WidgetSettingsPage.routeName,
        builder: (context, state) => const WidgetSettingsPage(),
      ),
      GoRoute(
        path: WidgetConfigPage.routePath,
        name: WidgetConfigPage.routeName,
        builder: (context, state) => const WidgetConfigPage(),
      ),
      GoRoute(
        path: LoginPage.routePath,
        name: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.routePath,
        name: RegisterPage.routeName,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: CloudSyncPage.routePath,
        name: CloudSyncPage.routeName,
        builder: (context, state) => const CloudSyncPage(),
      ),
      GoRoute(
        path: '/settings/notification-test',
        name: 'notification-test',
        builder: (context, state) => const NotificationTestPage(),
      ),
      GoRoute(
        path: ReminderProtectionPage.routePath,
        name: ReminderProtectionPage.routeName,
        builder: (context, state) => const ReminderProtectionPage(),
      ),
      GoRoute(
        path: NotesListPage.routePath,
        name: NotesListPage.routeName,
        builder: (context, state) => const NotesListPage(),
      ),
      GoRoute(
        path: NoteEditorPage.routePath,
        name: NoteEditorPage.routeName,
        builder: (context, state) => const NoteEditorPage(),
      ),
      GoRoute(
        path: NoteSearchPage.routePath,
        name: NoteSearchPage.routeName,
        builder: (context, state) => const NoteSearchPage(),
      ),
      GoRoute(
        path: '${NotesListPage.routePath}/:id',
        name: 'note-detail',
        builder: (context, state) {
          final noteId = state.pathParameters['id']!;
          return NoteEditorPage(noteId: noteId);
        },
      ),
      GoRoute(
        path: '/knowledge-graph',
        name: 'knowledge-graph',
        builder: (context, state) => const KnowledgeGraphPage(),
      ),
      GoRoute(
        path: EnhancedSearchPage.routePath,
        name: EnhancedSearchPage.routeName,
        builder: (context, state) => const EnhancedSearchPage(),
      ),
      GoRoute(
        path: NoteStatisticsPage.routePath,
        name: NoteStatisticsPage.routeName,
        builder: (context, state) => const NoteStatisticsPage(),
      ),
      GoRoute(
        path: '/notes/reading/:id',
        name: 'note-reading',
        builder: (context, state) {
          final noteId = state.pathParameters['id']!;
          return NoteReadingPage(noteId: noteId);
        },
      ),
      GoRoute(
        path: SpeechHistoryPage.routePath,
        name: SpeechHistoryPage.routeName,
        builder: (context, state) => const SpeechHistoryPage(),
      ),
      GoRoute(
        path: SpeechSettingsPage.routePath,
        name: SpeechSettingsPage.routeName,
        builder: (context, state) => const SpeechSettingsPage(),
      ),
      GoRoute(
        path: AISettingsPage.routePath,
        name: AISettingsPage.routeName,
        builder: (context, state) => const AISettingsPage(),
      ),
      GoRoute(
        path: '/settings/backup',
        name: 'backup-restore',
        builder: (context, state) => const BackupRestorePage(),
      ),
      GoRoute(
        path: SmartSuggestionsPage.routePath,
        name: SmartSuggestionsPage.routeName,
        builder: (context, state) => const SmartSuggestionsPage(),
      ),
      GoRoute(
        path: ShopPage.routePath,
        name: ShopPage.routeName,
        builder: (context, state) => const ShopPage(),
      ),
      GoRoute(
        path: PredictiveRemindersPage.routePath,
        name: PredictiveRemindersPage.routeName,
        builder: (context, state) => const PredictiveRemindersPage(),
      ),
      GoRoute(
        path: AnimationSettingsPage.routePath,
        name: AnimationSettingsPage.routeName,
        builder: (context, state) => const AnimationSettingsPage(),
      ),
      GoRoute(
        path: GamificationPage.routePath,
        name: GamificationPage.routeName,
        builder: (context, state) => const GamificationPage(),
      ),
      GoRoute(
        path: BadgesPage.routePath,
        name: BadgesPage.routeName,
        builder: (context, state) => const BadgesPage(),
      ),
      GoRoute(
        path: AchievementsPage.routePath,
        name: AchievementsPage.routeName,
        builder: (context, state) => const AchievementsPage(),
      ),
      GoRoute(
        path: ChallengesPage.routePath,
        name: ChallengesPage.routeName,
        builder: (context, state) => const ChallengesPage(),
      ),
      GoRoute(
        path: TitlesPage.routePath,
        name: TitlesPage.routeName,
        builder: (context, state) => const TitlesPage(),
      ),
    ],
    redirect: (context, state) {
      final passwordSettings = settingsAsync.valueOrNull;
      if (passwordSettings == null) {
        return null;
      }
      final requirePassword = passwordSettings.requirePassword && passwordSettings.hasPassword;
      final isOnUnlock = state.fullPath == UnlockPage.routePath;
      if (requirePassword && !isUnlocked && !isOnUnlock) {
        return UnlockPage.routePath;
      }
      if ((!requirePassword || isUnlocked) && isOnUnlock) {
        return CalendarViewPage.routePath;
      }
      return null;
    },
  );
}
