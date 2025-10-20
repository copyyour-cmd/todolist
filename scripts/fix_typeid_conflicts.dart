/// 批量修复Hive TypeId冲突的脚本
import 'dart:io';

void main() async {
  print('🔧 开始批量修复Hive TypeId冲突...\n');

  // 定义所有需要修复的文件及其TypeId映射
  final fixes = [
    // 笔记相关
    FileFix(
      'lib/src/features/notes/domain/note_folder.dart',
      [TypeIdChange(6, 'HiveTypeIds.noteFolder', hasAdapterName: false)],
    ),
    FileFix(
      'lib/src/features/notes/domain/note_template.dart',
      [TypeIdChange(32, 'HiveTypeIds.noteTemplate', hasAdapterName: false)],
    ),

    // 语音识别
    FileFix(
      'lib/src/features/speech/domain/speech_recognition_history.dart',
      [TypeIdChange(10, 'HiveTypeIds.speechRecognitionHistory', hasAdapterName: false)],
    ),

    // 主题配置
    FileFix(
      'lib/src/domain/entities/theme_config.dart',
      [
        TypeIdChange(22, 'HiveTypeIds.fontSizePreset', adapterName: 'FontSizePresetAdapter'),
        TypeIdChange(23, 'HiveTypeIds.taskCardStyle', adapterName: 'TaskCardStyleAdapter'),
        TypeIdChange(24, 'HiveTypeIds.colorSchemePreset', adapterName: 'ColorSchemePresetAdapter'),
        TypeIdChange(25, 'HiveTypeIds.customColorConfig', adapterName: 'CustomColorConfigAdapter'),
        TypeIdChange(26, 'HiveTypeIds.themeConfig', adapterName: 'ThemeConfigAdapter'),
      ],
    ),

    // 商店物品
    FileFix(
      'lib/src/domain/entities/shop_item.dart',
      [
        TypeIdChange(25, 'HiveTypeIds.shopItem', adapterName: 'ShopItemAdapter'),
        TypeIdChange(26, 'HiveTypeIds.shopItemCategory', adapterName: 'ShopItemCategoryAdapter'),
        TypeIdChange(27, 'HiveTypeIds.shopItemRarity', adapterName: 'ShopItemRarityAdapter'),
        TypeIdChange(28, 'HiveTypeIds.purchaseRecord', adapterName: 'PurchaseRecordAdapter'),
        TypeIdChange(29, 'HiveTypeIds.userInventory', adapterName: 'UserInventoryAdapter'),
      ],
    ),

    // 任务模板
    FileFix(
      'lib/src/domain/entities/task_template.dart',
      [
        TypeIdChange(27, 'HiveTypeIds.templateCategory', adapterName: 'TemplateCategoryAdapter'),
        TypeIdChange(28, 'HiveTypeIds.taskTemplate', adapterName: 'TaskTemplateAdapter'),
      ],
    ),

    // 天气信息
    FileFix(
      'lib/src/domain/entities/weather_info.dart',
      [
        TypeIdChange(30, 'HiveTypeIds.weatherInfo', adapterName: 'WeatherInfoAdapter'),
        TypeIdChange(31, 'HiveTypeIds.weatherCondition', adapterName: 'WeatherConditionAdapter'),
        TypeIdChange(32, 'HiveTypeIds.weatherTrigger', adapterName: 'WeatherTriggerAdapter'),
      ],
    ),

    // 交通信息
    FileFix(
      'lib/src/domain/entities/traffic_info.dart',
      [
        TypeIdChange(33, 'HiveTypeIds.trafficInfo', adapterName: 'TrafficInfoAdapter'),
        TypeIdChange(34, 'HiveTypeIds.trafficCondition', adapterName: 'TrafficConditionAdapter'),
        TypeIdChange(35, 'HiveTypeIds.travelTrigger', adapterName: 'TravelTriggerAdapter'),
        TypeIdChange(36, 'HiveTypeIds.routePreference', adapterName: 'RoutePreferenceAdapter'),
      ],
    ),

    // 动画设置
    FileFix(
      'lib/src/features/animations/application/animation_settings.dart',
      [
        TypeIdChange(37, 'HiveTypeIds.animationSettings', adapterName: 'AnimationSettingsAdapter'),
        TypeIdChange(38, 'HiveTypeIds.completionAnimationType', adapterName: 'CompletionAnimationTypeAdapter'),
      ],
    ),

    // 成就
    FileFix(
      'lib/src/domain/entities/achievement.dart',
      [TypeIdChange(44, 'HiveTypeIds.achievementType', adapterName: 'AchievementTypeAdapter')],
    ),

    // 每日签到
    FileFix(
      'lib/src/domain/entities/daily_checkin.dart',
      [
        TypeIdChange(45, 'HiveTypeIds.dailyCheckIn', adapterName: 'DailyCheckInAdapter'),
        TypeIdChange(46, 'HiveTypeIds.makeupCard', adapterName: 'MakeupCardAdapter'),
      ],
    ),

    // 挑战
    FileFix(
      'lib/src/domain/entities/challenge.dart',
      [
        TypeIdChange(46, 'HiveTypeIds.challenge', adapterName: 'ChallengeAdapter'),
        TypeIdChange(47, 'HiveTypeIds.challengeType', adapterName: 'ChallengeTypeAdapter'),
        TypeIdChange(48, 'HiveTypeIds.challengePeriod', adapterName: 'ChallengePeriodAdapter'),
      ],
    ),

    // 抽奖
    FileFix(
      'lib/src/domain/entities/lucky_draw.dart',
      [
        TypeIdChange(47, 'HiveTypeIds.luckyDraw', hasAdapterName: false),
        TypeIdChange(48, 'HiveTypeIds.luckyDrawType', hasAdapterName: false),
        TypeIdChange(49, 'HiveTypeIds.prizeConfig', adapterName: 'PrizeConfigAdapter'),
        TypeIdChange(50, 'HiveTypeIds.luckyDrawRecord', adapterName: 'LuckyDrawRecordAdapter'),
        TypeIdChange(51, 'HiveTypeIds.luckyDrawStats', adapterName: 'LuckyDrawStatsAdapter'),
      ],
    ),

    // 提醒模式
    FileFix(
      'lib/src/features/reminders/domain/reminder_mode.dart',
      [TypeIdChange(49, 'HiveTypeIds.reminderMode', adapterName: 'ReminderModeAdapter')],
    ),

    // 称号
    FileFix(
      'lib/src/domain/entities/title.dart',
      [
        TypeIdChange(52, 'HiveTypeIds.title', hasAdapterName: false),
        TypeIdChange(53, 'HiveTypeIds.titleRarity', hasAdapterName: false),
        TypeIdChange(54, 'HiveTypeIds.userTitle', adapterName: 'UserTitleAdapter'),
      ],
    ),
  ];

  int successCount = 0;
  int failCount = 0;

  for (final fix in fixes) {
    try {
      await fix.apply();
      successCount++;
      print('✅ ${fix.filePath}');
    } catch (e) {
      failCount++;
      print('❌ ${fix.filePath}: $e');
    }
  }

  print('\n✨ 修复完成！');
  print('   成功: $successCount 个文件');
  print('   失败: $failCount 个文件');

  if (failCount == 0) {
    print('\n📝 下一步：运行 `flutter pub run build_runner build --delete-conflicting-outputs` 重新生成适配器');
  }
}

class TypeIdChange {
  final int oldTypeId;
  final String newTypeIdConstant;
  final String? adapterName;
  final bool hasAdapterName;

  TypeIdChange(
    this.oldTypeId,
    this.newTypeIdConstant, {
    this.adapterName,
    this.hasAdapterName = true,
  });
}

class FileFix {
  final String filePath;
  final List<TypeIdChange> changes;

  FileFix(this.filePath, this.changes);

  Future<void> apply() async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('文件不存在');
    }

    String content = await file.readAsString();

    // 添加 type_ids.dart 导入（如果还没有）
    if (!content.contains("import '../../infrastructure/hive/type_ids.dart'") &&
        !content.contains('import \'../../infrastructure/hive/type_ids.dart\'')) {
      // 在第一个 import 后面添加
      final importMatch = RegExp(r"^import '[^']+';$", multiLine: true).firstMatch(content);
      if (importMatch != null) {
        final insertPos = importMatch.end;
        content = content.substring(0, insertPos) +
            "\nimport '../../infrastructure/hive/type_ids.dart';" +
            content.substring(insertPos);
      }
    }

    // 替换每个 TypeId
    for (final change in changes) {
      if (change.hasAdapterName && change.adapterName != null) {
        // 有 adapterName 的情况
        final oldPattern = RegExp(
          '@HiveType\\(typeId:\\s*${change.oldTypeId}\\s*,\\s*adapterName:\\s*[\'"]${RegExp.escape(change.adapterName!)}[\'"]\\)',
        );
        content = content.replaceAll(
          oldPattern,
          '@HiveType(typeId: ${change.newTypeIdConstant}, adapterName: \'${change.adapterName}\')',
        );
      } else {
        // 没有 adapterName 的情况
        final oldPattern = RegExp(
          '@HiveType\\(typeId:\\s*${change.oldTypeId}\\)',
        );
        content = content.replaceAll(
          oldPattern,
          '@HiveType(typeId: ${change.newTypeIdConstant})',
        );
      }
    }

    await file.writeAsString(content);
  }
}
