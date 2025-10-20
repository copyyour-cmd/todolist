/// Hive TypeId 集中注册表
///
/// 此文件集中管理所有 Hive TypeAdapter 的 TypeId，防止冲突
///
/// TypeId 分配规则：
/// - 0-19: 核心实体 (Task, SubTask, TaskList, Tag, etc.)
/// - 20-39: 附加功能实体 (Attachment, Settings, Views, etc.)
/// - 40-59: 游戏化系统 (Stats, Badge, Achievement, etc.)
/// - 60-79: 智能功能 (Reminders, Weather, Traffic, etc.)
/// - 80-99: 其他功能 (Notes, Templates, etc.)
/// - 100+: 保留扩展
class HiveTypeIds {
  // ==================== 核心实体 (0-19) ====================

  /// Task - 任务主实体
  static const int task = 0;

  /// SubTask - 子任务
  static const int subTask = 1;

  /// TaskList - 任务列表
  static const int taskList = 2;

  /// Tag - 标签
  static const int tag = 3;

  /// TaskPriority - 任务优先级枚举
  static const int taskPriority = 4;

  /// TaskStatus - 任务状态枚举
  static const int taskStatus = 5;

  /// RecurrenceRule - 重复规则
  static const int recurrenceRule = 6;

  /// RecurrenceFrequency - 重复频率枚举
  static const int recurrenceFrequency = 7;

  /// Attachment - 附件
  static const int attachment = 8;

  /// TaskAttachment - 任务附件
  static const int taskAttachment = 9;

  // 10-19: 核心功能保留

  // ==================== 附加功能实体 (20-39) ====================

  /// AppSettings - 应用设置
  static const int appSettings = 20;

  /// AppThemeMode - 主题模式枚举
  static const int appThemeMode = 21;

  /// AppThemeColor - 主题颜色枚举
  static const int appThemeColor = 22;

  /// ThemeConfig - 主题配置
  static const int themeConfig = 23;

  /// FontSizePreset - 字体大小预设枚举
  static const int fontSizePreset = 24;

  /// TaskCardStyle - 任务卡片样式枚举
  static const int taskCardStyle = 25;

  /// ColorSchemePreset - 配色方案预设枚举
  static const int colorSchemePreset = 26;

  /// CustomColorConfig - 自定义颜色配置
  static const int customColorConfig = 27;

  /// ViewType - 视图类型枚举
  static const int viewType = 28;

  /// FilterOperator - 过滤器操作符枚举
  static const int filterOperator = 29;

  /// FilterField - 过滤字段枚举
  static const int filterField = 30;

  /// FilterCondition - 过滤条件
  static const int filterCondition = 31;

  /// SortOrder - 排序顺序枚举
  static const int sortOrder = 32;

  /// SortConfig - 排序配置
  static const int sortConfig = 33;

  /// CustomView - 自定义视图
  static const int customView = 34;

  /// WidgetConfig - 小部件配置
  static const int widgetConfig = 35;

  /// WidgetSize - 小部件大小枚举
  static const int widgetSize = 36;

  /// WidgetTheme - 小部件主题枚举
  static const int widgetTheme = 37;

  /// AnimationSettings - 动画设置
  static const int animationSettings = 38;

  /// CompletionAnimationType - 完成动画类型枚举
  static const int completionAnimationType = 39;

  // ==================== 游戏化系统 (40-59) ====================

  /// UserStats - 用户统计
  static const int userStats = 40;

  /// Badge - 徽章
  static const int badge = 41;

  /// BadgeCategory - 徽章分类枚举
  static const int badgeCategory = 42;

  /// BadgeRarity - 徽章稀有度枚举
  static const int badgeRarity = 43;

  /// Achievement - 成就
  static const int achievement = 44;

  /// AchievementType - 成就类型枚举
  static const int achievementType = 45;

  /// DailyCheckIn - 每日签到
  static const int dailyCheckIn = 46;

  /// MakeupCard - 补签卡
  static const int makeupCard = 47;

  /// Challenge - 挑战
  static const int challenge = 48;

  /// ChallengeType - 挑战类型枚举
  static const int challengeType = 49;

  /// ChallengePeriod - 挑战周期枚举
  static const int challengePeriod = 50;

  /// LuckyDraw - 抽奖
  static const int luckyDraw = 51;

  /// LuckyDrawType - 抽奖类型枚举
  static const int luckyDrawType = 52;

  /// PrizeConfig - 奖品配置
  static const int prizeConfig = 53;

  /// LuckyDrawRecord - 抽奖记录
  static const int luckyDrawRecord = 54;

  /// LuckyDrawStats - 抽奖统计
  static const int luckyDrawStats = 55;

  /// ShopItem - 商店物品
  static const int shopItem = 56;

  /// ShopItemCategory - 商店物品分类枚举
  static const int shopItemCategory = 57;

  /// ShopItemRarity - 商店物品稀有度枚举
  static const int shopItemRarity = 58;

  /// PurchaseRecord - 购买记录
  static const int purchaseRecord = 59;

  // ==================== 智能功能 (60-79) ====================

  /// UserInventory - 用户库存
  static const int userInventory = 60;

  /// Title - 称号
  static const int title = 61;

  /// TitleRarity - 称号稀有度枚举
  static const int titleRarity = 62;

  /// UserTitle - 用户称号
  static const int userTitle = 63;

  /// ReminderType - 提醒类型枚举
  static const int reminderType = 64;

  /// LocationTrigger - 位置触发器
  static const int locationTrigger = 65;

  /// RepeatConfig - 重复配置
  static const int repeatConfig = 66;

  /// SmartReminder - 智能提醒
  static const int smartReminder = 67;

  /// ReminderHistory - 提醒历史
  static const int reminderHistory = 68;

  /// ReminderMode - 提醒模式枚举
  static const int reminderMode = 69;

  /// FocusSession - 专注会话
  static const int focusSession = 70;

  /// Interruption - 中断记录
  static const int interruption = 71;

  /// WeatherInfo - 天气信息
  static const int weatherInfo = 72;

  /// WeatherCondition - 天气状况枚举
  static const int weatherCondition = 73;

  /// WeatherTrigger - 天气触发器
  static const int weatherTrigger = 74;

  /// TrafficInfo - 交通信息
  static const int trafficInfo = 75;

  /// TrafficCondition - 交通状况枚举
  static const int trafficCondition = 76;

  /// TravelTrigger - 出行触发器
  static const int travelTrigger = 77;

  /// RoutePreference - 路线偏好枚举
  static const int routePreference = 78;

  // 79: 智能功能保留

  // ==================== 其他功能 (80-99) ====================

  /// Note - 笔记
  static const int note = 80;

  /// NoteAdapter - 笔记适配器
  static const int noteAdapter = 81;

  /// NoteTemplate - 笔记模板
  static const int noteTemplate = 82;

  /// NoteFolder - 笔记文件夹
  static const int noteFolder = 83;

  /// TaskTemplate - 任务模板
  static const int taskTemplate = 84;

  /// TemplateCategory - 模板分类枚举
  static const int templateCategory = 85;

  /// SpeechRecognitionHistory - 语音识别历史
  static const int speechRecognitionHistory = 86;

  // 87-99: 其他功能保留

  // ==================== 保留扩展 (100+) ====================

  // 预留给未来功能使用
}
