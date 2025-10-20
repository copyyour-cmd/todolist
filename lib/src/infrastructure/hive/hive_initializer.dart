import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todolist/src/domain/entities/achievement.dart';
import 'package:todolist/src/domain/entities/app_settings.dart';
import 'package:todolist/src/domain/entities/attachment.dart';
import 'package:todolist/src/domain/entities/badge.dart';
import 'package:todolist/src/domain/entities/challenge.dart';
import 'package:todolist/src/domain/entities/custom_view.dart';
import 'package:todolist/src/domain/entities/daily_checkin.dart';
import 'package:todolist/src/domain/entities/focus_session.dart';
import 'package:todolist/src/domain/entities/lucky_draw.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/entities/title.dart';
import 'package:todolist/src/domain/entities/recurrence_rule.dart';
import 'package:todolist/src/features/notes/domain/note_template.dart';
import 'package:todolist/src/domain/entities/smart_reminder.dart';
import 'package:todolist/src/features/speech/domain/speech_recognition_history.dart';
import 'package:todolist/src/domain/entities/sub_task.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/domain/entities/task_template.dart';
import 'package:todolist/src/domain/entities/theme_config.dart';
import 'package:todolist/src/domain/entities/user_stats.dart';
import 'package:todolist/src/domain/entities/widget_config.dart';
import 'package:todolist/src/infrastructure/hive/hive_boxes.dart';
import 'package:todolist/src/features/reminders/domain/reminder_mode.dart';
import 'package:todolist/src/features/animations/application/animation_settings.dart';
import 'package:todolist/src/infrastructure/hive/freezed_hive_adapter.dart';

class HiveInitializer {
  HiveInitializer({
    String? storagePath,
    this.onProgress,
  }) : _storagePath = storagePath;

  final String? _storagePath;
  final void Function(String message, double progress)? onProgress;

  /// 初始化所有 Hive boxes
  ///
  /// 优化策略:
  /// 1. 核心boxes优先并发加载（tasks, task_lists, tags, settings）
  /// 2. 常用boxes批量并发加载（focus_sessions, reminders, templates等）
  /// 3. 次要功能boxes最后批量加载（notes, speech_history, animation_settings）
  ///
  /// 性能提升：
  /// - 通过并发加载核心boxes，预计减少30-40%的初始化时间
  /// - 三阶段加载策略确保关键功能最先可用
  Future<void> init() async {
    _reportProgress('初始化存储路径...', 0.0);
    final path = _storagePath ?? (await getApplicationSupportDirectory()).path;
    await Hive.initFlutter(path);

    _reportProgress('注册适配器...', 0.1);
    _registerAdapters();

    // 清除游戏化相关的旧 Hive boxes (由于切换到 JSON Adapter)
    // 这些 boxes 使用了新的 adapter,旧数据无法读取
    _reportProgress('清理旧数据...', 0.15);
    await _clearGamificationBoxesIfNeeded();

    // 阶段1: 核心boxes并发加载（最高优先级）
    // 这些是应用启动必需的最小数据集，并发加载以最快速度完成
    _reportProgress('加载核心数据...', 0.2);
    await Future.wait([
      Hive.openBox<Task>(HiveBoxes.tasks),
      Hive.openBox<TaskList>(HiveBoxes.taskLists),
      Hive.openBox<Tag>(HiveBoxes.tags),
      Hive.openBox<AppSettings>(HiveBoxes.settings),
    ]);

    // 阶段2: 常用功能boxes并发加载（中优先级）
    // 这些功能常被使用，但不是启动关键路径
    _reportProgress('加载常用功能...', 0.5);
    await Future.wait([
      Hive.openBox<FocusSession>('focus_sessions'),
      Hive.openBox<SmartReminder>('smart_reminders'),
      Hive.openBox<ReminderHistory>('reminder_history'),
      Hive.openBox<CustomView>('custom_views'),
      Hive.openBox<ThemeConfig>('theme_config'),
      Hive.openBox<TaskTemplate>(HiveBoxes.taskTemplates),
      Hive.openBox<WidgetConfig>('widget_config'),
    ]);

    // 阶段3: 次要功能boxes并发加载（低优先级）
    // 这些功能不常用或数据量可能较大
    _reportProgress('加载辅助功能...', 0.8);
    await Future.wait([
      Hive.openBox<Note>(HiveBoxes.notes),
      Hive.openBox<NoteTemplate>('note_templates'),
      Hive.openBox<SpeechRecognitionHistory>('speech_history'),
      Hive.openBox<AnimationSettings>('animation_settings'),
    ]);

    _reportProgress('初始化完成', 1.0);
  }

  /// 仅初始化核心boxes（用于快速启动场景）
  ///
  /// 适用场景：
  /// - 冷启动优化
  /// - 测试环境
  /// - 最小功能启动
  Future<void> initCoreOnly() async {
    final path = _storagePath ?? (await getApplicationSupportDirectory()).path;
    await Hive.initFlutter(path);
    _registerAdapters();
    await _clearGamificationBoxesIfNeeded();

    // 只加载核心4个boxes
    await Future.wait([
      Hive.openBox<Task>(HiveBoxes.tasks),
      Hive.openBox<TaskList>(HiveBoxes.taskLists),
      Hive.openBox<Tag>(HiveBoxes.tags),
      Hive.openBox<AppSettings>(HiveBoxes.settings),
    ]);
  }

  /// 延迟初始化非核心boxes
  ///
  /// 在应用启动后的空闲时间调用，避免阻塞启动
  /// 可用于实现渐进式加载，进一步优化启动体验
  Future<void> initNonCoreBoxes() async {
    // 先加载常用功能boxes
    await Future.wait([
      Hive.openBox<FocusSession>('focus_sessions'),
      Hive.openBox<SmartReminder>('smart_reminders'),
      Hive.openBox<ReminderHistory>('reminder_history'),
      Hive.openBox<CustomView>('custom_views'),
      Hive.openBox<ThemeConfig>('theme_config'),
      Hive.openBox<TaskTemplate>(HiveBoxes.taskTemplates),
      Hive.openBox<WidgetConfig>('widget_config'),
    ]);

    // 再加载次要功能boxes
    await Future.wait([
      Hive.openBox<Note>(HiveBoxes.notes),
      Hive.openBox<NoteTemplate>('note_templates'),
      Hive.openBox<SpeechRecognitionHistory>('speech_history'),
      Hive.openBox<AnimationSettings>('animation_settings'),
    ]);
  }

  void _reportProgress(String message, double progress) {
    onProgress?.call(message, progress);
    print('HiveInitializer: $message (${(progress * 100).toStringAsFixed(0)}%)');
  }

  /// 清除游戏化相关的旧 Hive boxes
  /// 由于切换到 JSON Adapter,旧数据无法读取,需要删除并重新创建
  Future<void> _clearGamificationBoxesIfNeeded() async {
    final boxNames = [
      'user_stats',
      'badges',
      'achievements',
      'challenges',
      'daily_checkins',
      'makeup_cards',
      'prize_configs',
      'draw_records',
      'titles',
    ];

    for (final boxName in boxNames) {
      try {
        if (await Hive.boxExists(boxName)) {
          await Hive.deleteBoxFromDisk(boxName);
          print('Cleared old Hive box: $boxName');
        }
      } catch (e) {
        print('Warning: Failed to clear box $boxName: $e');
      }
    }
  }

  void _registerAdapters() {
    void register<T>(TypeAdapter<T> adapter) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter(adapter);
      }
    }

    register(TaskAdapter());
    register(TaskPriorityAdapter());
    register(TaskStatusAdapter());
    register(SubTaskAdapter());
    register(TaskListAdapter());
    register(TagAdapter());
    register(AppSettingsAdapter());
    register(AppThemeModeAdapter());
    register(AppThemeColorAdapter());
    register(FocusSessionAdapter());
    register(AttachmentAdapter());
    register(TaskAttachmentAdapter());
    register(ReminderTypeAdapter());
    register(LocationTriggerAdapter());
    register(RepeatConfigAdapter());
    register(SmartReminderAdapter());
    register(ReminderHistoryAdapter());
    register(ViewTypeAdapter());
    register(FilterOperatorAdapter());
    register(FilterFieldAdapter());
    register(FilterConditionAdapter());
    register(SortOrderAdapter());
    register(SortConfigAdapter());
    register(CustomViewAdapter());
    register(FontSizePresetAdapter());
    register(TaskCardStyleAdapter());
    register(ColorSchemePresetAdapter());
    register(CustomColorConfigAdapter());
    register(ThemeConfigAdapter());
    register(TemplateCategoryAdapter());
    register(TaskTemplateAdapter());
    register(RecurrenceRuleAdapter());
    register(RecurrenceFrequencyAdapter());
    register(WidgetConfigAdapter());
    register(WidgetSizeAdapter());
    register(WidgetThemeAdapter());
    // 游戏化实体 - 使用 JSON Adapter
    registerFreezedJsonAdapter<UserStats>(
      typeId: 40,
      toJson: (obj) => obj.toJson(),
      fromJson: (json) => UserStats.fromJson(json),
    );
    registerFreezedJsonAdapter<Badge>(
      typeId: 41,
      toJson: (obj) => obj.toJson(),
      fromJson: (json) => Badge.fromJson(json),
    );
    register(BadgeCategoryAdapter());
    register(BadgeRarityAdapter());

    registerFreezedJsonAdapter<Achievement>(
      typeId: 44,
      toJson: (obj) => obj.toJson(),
      fromJson: (json) => Achievement.fromJson(json),
    );
    register(AchievementTypeAdapter());

    registerFreezedJsonAdapter<Challenge>(
      typeId: 48,
      toJson: (obj) => obj.toJson(),
      fromJson: (json) => Challenge.fromJson(json),
    );
    register(ChallengeTypeAdapter());
    register(ChallengePeriodAdapter());
    register(NoteAdapter());
    register(NoteCategoryAdapter());
    register(NoteTemplateAdapter());
    register(SpeechRecognitionHistoryAdapter());
    register(ReminderModeAdapter());
    register(AnimationSettingsAdapter());
    register(CompletionAnimationTypeAdapter());
    // 游戏化相关的 Freezed 实体使用 JSON Adapter
    // 因为 Freezed 生成的 _$XxxImpl 类型与 Hive 的类型系统不兼容
    registerFreezedJsonAdapter<DailyCheckIn>(
      typeId: 46,
      toJson: (obj) => obj.toJson(),
      fromJson: (json) => DailyCheckIn.fromJson(json),
    );
    registerFreezedJsonAdapter<MakeupCard>(
      typeId: 47,
      toJson: (obj) => obj.toJson(),
      fromJson: (json) => MakeupCard.fromJson(json),
    );

    // Enum 类型仍然使用普通 adapter
    register(PrizeTypeAdapter());
    register(PrizeRarityAdapter());

    registerFreezedJsonAdapter<PrizeConfig>(
      typeId: 53,
      toJson: (obj) => obj.toJson(),
      fromJson: (json) => PrizeConfig.fromJson(json),
    );
    registerFreezedJsonAdapter<LuckyDrawRecord>(
      typeId: 54,
      toJson: (obj) => obj.toJson(),
      fromJson: (json) => LuckyDrawRecord.fromJson(json),
    );
    registerFreezedJsonAdapter<LuckyDrawStats>(
      typeId: 55,
      toJson: (obj) => obj.toJson(),
      fromJson: (json) => LuckyDrawStats.fromJson(json),
    );

    // Enum 类型仍然使用普通 adapter
    register(TitleCategoryAdapter());
    register(TitleRarityAdapter());

    registerFreezedJsonAdapter<UserTitle>(
      typeId: 63,
      toJson: (obj) => obj.toJson(),
      fromJson: (json) => UserTitle.fromJson(json),
    );
  }
}
