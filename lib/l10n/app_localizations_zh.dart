// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '待办清单';

  @override
  String get homeFilterToday => '今天';

  @override
  String get homeFilterOverdue => '已逾期';

  @override
  String get homeFilterUpcoming => '即将到来';

  @override
  String get homeEmptyTitle => '今天还没有计划';

  @override
  String get homeEmptySubtitle => '记录一个任务或安排一段专注时间，开始行动吧。';

  @override
  String get homeEmptyAction => '添加任务';

  @override
  String get homeErrorTitle => '出现了问题';

  @override
  String homeErrorDetails(Object error) {
    return '$error';
  }

  @override
  String get homeFabLabel => '新建任务';

  @override
  String homeSelectionTitle(int count) {
    return '已选择 $count 项';
  }

  @override
  String get homeQuickIdeaTooltip => '快速记录灵感';

  @override
  String get homeFilterBarTitle => '筛选器';

  @override
  String get homeBatchComplete => '完成';

  @override
  String get homeBatchDelete => '删除';

  @override
  String get homeBatchMove => '移动到列表';

  @override
  String get homeBatchTag => '添加标签';

  @override
  String get homeTagDialogTitle => '选择标签';

  @override
  String get homeCommonCancel => '取消';

  @override
  String get homeCommonConfirm => '确定';

  @override
  String homeSubtaskSummary(Object completed, Object total) {
    return '已完成 $completed/$total 个子任务';
  }

  @override
  String get taskFormNewTitle => '新建任务';

  @override
  String get taskFormEditTitle => '编辑任务';

  @override
  String get taskFormTitleLabel => '标题';

  @override
  String get taskFormTitleValidation => '请输入标题';

  @override
  String get taskFormListLabel => '列表';

  @override
  String get taskFormPriorityLabel => '优先级';

  @override
  String get taskFormNotesLabel => '备注';

  @override
  String get taskFormTagsLabel => '标签';

  @override
  String get taskFormDueDate => '截止时间';

  @override
  String get taskFormReminder => '提醒时间';

  @override
  String get taskFormSubtasks => '子任务';

  @override
  String get taskFormAddSubtask => '添加子任务';

  @override
  String get taskFormAdd => '添加';

  @override
  String get taskFormCreate => '创建任务';

  @override
  String get taskFormUpdate => '更新任务';

  @override
  String get taskFormSelectList => '请选择列表';

  @override
  String get taskFormSaveError => '任务保存失败';

  @override
  String get taskPriorityNone => '无';

  @override
  String get taskPriorityLow => '低';

  @override
  String get taskPriorityMedium => '中';

  @override
  String get taskPriorityHigh => '高';

  @override
  String get taskPriorityCritical => '紧急';

  @override
  String get notificationChannelName => '任务提醒';

  @override
  String get notificationChannelDescription => '提醒您处理计划中的任务';

  @override
  String get notificationTitle => '任务提醒';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsRequirePassword => '启动时需要密码';

  @override
  String get settingsRequirePasswordSubtitle => '启用启动口令，保护您的任务数据。';

  @override
  String get settingsSetPasswordTitle => '设置密码';

  @override
  String get settingsPasswordField => '密码';

  @override
  String get settingsPasswordConfirmField => '确认密码';

  @override
  String get settingsPasswordRequired => '请输入密码';

  @override
  String get settingsPasswordTooShort => '密码至少 4 个字符';

  @override
  String get settingsPasswordMismatch => '两次输入的密码不一致';

  @override
  String get settingsPasswordEnabled => '已启用密码保护';

  @override
  String get settingsPasswordDisabled => '已关闭密码保护';

  @override
  String get settingsChangePassword => '修改密码';

  @override
  String get settingsPasswordChanged => '密码已更新';

  @override
  String get settingsDisablePasswordTitle => '确认关闭密码？';

  @override
  String get settingsDisablePasswordMessage => '关闭后启动应用将不再需要输入密码。';

  @override
  String settingsLoadError(Object error) {
    return '设置加载失败：$error';
  }

  @override
  String get unlockTitle => '输入密码';

  @override
  String get unlockPrompt => '请输入密码以继续';

  @override
  String get unlockAction => '解锁';

  @override
  String get unlockFailed => '密码错误';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '确定';

  @override
  String get commonReset => '清除';

  @override
  String get settingsAppearanceSection => '外观';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeSystem => '跟随系统';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get settingsNotificationsSection => '通知';

  @override
  String get settingsEnableNotifications => '启用通知';

  @override
  String get settingsEnableNotificationsSubtitle => '接收计划任务的提醒通知';

  @override
  String get settingsSecuritySection => '安全';

  @override
  String get settingsDataSection => '数据管理';

  @override
  String get settingsImportData => '导入数据';

  @override
  String get settingsImportDataSubtitle => '从 JSON 文件导入任务';

  @override
  String get settingsExportData => '导出数据';

  @override
  String get settingsExportDataSubtitle => '将任务保存为 JSON 文件';

  @override
  String get settingsLoadDemoData => '加载演示数据';

  @override
  String get settingsLoadDemoDataSubtitle => '添加示例任务和列表';

  @override
  String get settingsLoadDemoDataConfirm => '如果您的列表为空，将添加演示任务。';

  @override
  String get settingsDemoDataLoaded => '演示数据加载成功';

  @override
  String get settingsClearAllData => '清除所有数据';

  @override
  String get settingsClearAllDataSubtitle => '删除所有任务、列表和标签';

  @override
  String get settingsClearAllDataConfirm => '这将永久删除您的所有任务、列表和标签。此操作无法撤销。';

  @override
  String get settingsDataCleared => '所有数据已清除';

  @override
  String get settingsAboutSection => '关于';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsComingSoon => '即将推出';

  @override
  String get settingsError => '错误';

  @override
  String get settingsContentSection => '内容';

  @override
  String get settingsManageLists => '管理列表';

  @override
  String get settingsManageListsSubtitle => '创建、编辑和整理您的列表';

  @override
  String get listManagementTitle => '管理列表';

  @override
  String get listManagementFabLabel => '新建列表';

  @override
  String get listManagementEmptyTitle => '还没有列表';

  @override
  String get listManagementEmptySubtitle => '创建您的第一个列表来组织任务';

  @override
  String get listManagementEmptyAction => '创建列表';

  @override
  String get listManagementCreated => '列表已创建';

  @override
  String get listManagementUpdated => '列表已更新';

  @override
  String get listManagementDeleted => '列表已删除';

  @override
  String get listManagementDeleteTitle => '删除列表？';

  @override
  String listManagementDeleteMessage(String name) {
    return '确定要删除\"$name\"吗？';
  }

  @override
  String get listManagementDeleteError => '删除列表失败';

  @override
  String get listManagementDeleteErrorHasTasks => '无法删除包含任务的列表';

  @override
  String get listManagementLoadError => '加载列表失败';

  @override
  String get listManagementReorderError => '重新排序失败';

  @override
  String get listManagementDefaultLabel => '默认列表';

  @override
  String get listFormNewTitle => '新建列表';

  @override
  String get listFormEditTitle => '编辑列表';

  @override
  String get listFormNameLabel => '列表名称';

  @override
  String get listFormNameValidation => '请输入名称';

  @override
  String get listFormIconLabel => '图标';

  @override
  String get listFormColorLabel => '颜色';

  @override
  String get listFormSaveError => '保存列表失败';

  @override
  String get commonSave => '保存';

  @override
  String get commonCreate => '创建';

  @override
  String get commonDelete => '删除';

  @override
  String get settingsManageTags => '管理标签';

  @override
  String get settingsManageTagsSubtitle => '创建和整理任务标签';

  @override
  String get tagManagementTitle => '管理标签';

  @override
  String get tagManagementFabLabel => '新建标签';

  @override
  String get tagManagementEmptyTitle => '还没有标签';

  @override
  String get tagManagementEmptySubtitle => '创建您的第一个标签来分类任务';

  @override
  String get tagManagementEmptyAction => '创建标签';

  @override
  String get tagManagementCreated => '标签已创建';

  @override
  String get tagManagementUpdated => '标签已更新';

  @override
  String get tagManagementDeleted => '标签已删除';

  @override
  String get tagManagementDeletedWithTaskUpdate => '标签已删除，并已从任务中移除';

  @override
  String get tagManagementDeleteTitle => '删除标签？';

  @override
  String tagManagementDeleteMessage(String name) {
    return '确定要删除\"$name\"吗？';
  }

  @override
  String tagManagementDeleteMessageWithTasks(String name, int count) {
    return '确定要删除\"$name\"吗？它被 $count 个任务使用，将从这些任务中移除。';
  }

  @override
  String get tagManagementDeleteError => '删除标签失败';

  @override
  String get tagManagementLoadError => '加载标签失败';

  @override
  String tagManagementTaskCount(int count) {
    return '$count 个任务';
  }

  @override
  String get tagFormNewTitle => '新建标签';

  @override
  String get tagFormEditTitle => '编辑标签';

  @override
  String get tagFormNameLabel => '标签名称';

  @override
  String get tagFormNameValidation => '请输入名称';

  @override
  String get tagFormColorLabel => '颜色';

  @override
  String get tagFormPreview => '预览：';

  @override
  String get tagFormPreviewPlaceholder => '标签名称';

  @override
  String get tagFormSaveError => '保存标签失败';

  @override
  String get searchHint => '搜索任务...';

  @override
  String get searchEmptyHistory => '开始搜索以查找您的任务';

  @override
  String get searchRecentSearches => '最近搜索';

  @override
  String get searchClearHistory => '清空';

  @override
  String get searchNoResults => '未找到任务';

  @override
  String get searchNoResultsHint => '尝试使用不同的关键词或检查拼写';

  @override
  String searchResultsCount(int count) {
    return '$count 个结果';
  }

  @override
  String get taskDetailTitle => '任务详情';

  @override
  String get taskDetailNotFound => '任务未找到';

  @override
  String get taskDetailPriority => '优先级';

  @override
  String get taskDetailList => '列表';

  @override
  String get taskDetailTags => '标签';

  @override
  String get taskDetailDueDate => '截止时间';

  @override
  String get taskDetailReminder => '提醒时间';

  @override
  String get taskDetailNotes => '备注';

  @override
  String get taskDetailSubtasks => '子任务';

  @override
  String get taskDetailMetadata => '信息';

  @override
  String get taskDetailCreated => '创建时间';

  @override
  String get taskDetailUpdated => '更新时间';

  @override
  String get taskDetailCompleted => '完成时间';

  @override
  String get taskDetailDuplicate => '复制';

  @override
  String get taskDetailDelete => '删除';

  @override
  String get taskDetailDeleteConfirmTitle => '删除任务？';

  @override
  String taskDetailDeleteConfirmMessage(String title) {
    return '确定要删除\"$title\"吗？';
  }

  @override
  String get taskDetailDeleted => '任务已删除';

  @override
  String get taskDetailDeleteError => '删除任务失败';

  @override
  String get taskDetailDuplicated => '任务已复制';

  @override
  String get homeSortByLabel => '排序方式';

  @override
  String get homeSortByManual => '手动排序';

  @override
  String get homeSortByDueDate => '截止时间';

  @override
  String get homeSortByPriority => '优先级';

  @override
  String get homeSortByCreatedDate => '创建时间';

  @override
  String get homeShowCompletedLabel => '已完成';

  @override
  String get settingsStatistics => '统计与洞察';

  @override
  String get settingsStatisticsSubtitle => '查看任务完成率和生产力趋势';

  @override
  String get settingsCalendar => '日历视图';

  @override
  String get settingsCalendarSubtitle => '在日历中查看和管理任务';

  @override
  String get calendarTitle => '日历';

  @override
  String get calendarTodayButton => '今天';

  @override
  String calendarTaskCount(int count) {
    return '$count 个任务';
  }

  @override
  String get calendarNoTasks => '当天没有任务';

  @override
  String get calendarTaskMoved => '任务日期已更新';

  @override
  String get focusTitle => '专注模式';

  @override
  String get focusHistoryButton => '历史记录';

  @override
  String focusTodayMinutes(int minutes) {
    return '今天已专注 $minutes 分钟';
  }

  @override
  String get focusSelectDuration => '选择专注时长';

  @override
  String get focusDurationShort => '5分钟';

  @override
  String get focusDurationStandard => '25分钟';

  @override
  String get focusDurationLong => '45分钟';

  @override
  String get focusStart => '开始专注';

  @override
  String get focusPause => '暂停';

  @override
  String get focusResume => '继续';

  @override
  String get focusCancel => '取消';

  @override
  String get focusCompleted => '专注完成！';

  @override
  String get focusStartNew => '开始新专注';

  @override
  String get focusCancelTitle => '取消专注？';

  @override
  String get focusCancelMessage => '确定要取消当前的专注会话吗？';

  @override
  String get focusCompleteTask => '标记任务完成';

  @override
  String get focusTaskCompleted => '任务已标记为完成';

  @override
  String get settingsFocus => '专注模式';

  @override
  String get settingsFocusSubtitle => '使用番茄钟提升专注力';

  @override
  String get statisticsTitle => '统计与洞察';

  @override
  String get statisticsCompletionRate => '完成率统计';

  @override
  String get statisticsToday => '今天';

  @override
  String get statisticsThisWeek => '本周';

  @override
  String get statisticsThisMonth => '本月';

  @override
  String get statisticsTrend => '任务趋势（最近7天）';

  @override
  String get statisticsTrendCreated => '创建';

  @override
  String get statisticsTrendCompleted => '完成';

  @override
  String get statisticsByList => '按列表统计';

  @override
  String get statisticsByTag => '按标签统计';

  @override
  String get statisticsHeatmap => '生产力热力图（最近30天）';

  @override
  String statisticsHeatmapTooltip(String date, int count) {
    return '$date\n完成$count个任务';
  }

  @override
  String statisticsCompletedTasks(Object completed, Object total) {
    return '$completed/$total';
  }

  @override
  String get taskFormRecurrence => '重复';

  @override
  String get taskFormRecurrenceNone => '不重复';

  @override
  String get recurrenceDaily => '每天';

  @override
  String get recurrenceWeekly => '每周';

  @override
  String get recurrenceMonthly => '每月';

  @override
  String get recurrenceYearly => '每年';

  @override
  String get recurrenceCustom => '自定义';

  @override
  String get recurrenceConfig => '配置重复';

  @override
  String get recurrenceInterval => '间隔';

  @override
  String get recurrenceDaysOfWeek => '星期';

  @override
  String get recurrenceSpecificDay => '指定日期';

  @override
  String get recurrenceNeverEnds => '永不结束';

  @override
  String get recurrenceEndAfterCount => '在指定次数后结束';

  @override
  String get recurrenceEndOnDate => '在指定日期后结束';

  @override
  String get recurrenceOccurrences => '次数';

  @override
  String recurrenceEveryNDays(int interval) {
    return '每 $interval 天';
  }

  @override
  String recurrenceEveryNWeeks(int interval) {
    return '每 $interval 周';
  }

  @override
  String recurrenceEveryNMonths(int interval) {
    return '每 $interval 月';
  }

  @override
  String recurrenceEveryNYears(int interval) {
    return '每 $interval 年';
  }

  @override
  String recurrenceDayOfMonth(int day) {
    return '每月 $day 日';
  }

  @override
  String recurrenceUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '直到 $dateString';
  }

  @override
  String recurrenceCount(int count) {
    return '$count 次';
  }

  @override
  String get weekdayMonday => '星期一';

  @override
  String get weekdayTuesday => '星期二';

  @override
  String get weekdayWednesday => '星期三';

  @override
  String get weekdayThursday => '星期四';

  @override
  String get weekdayFriday => '星期五';

  @override
  String get weekdaySaturday => '星期六';

  @override
  String get weekdaySunday => '星期日';

  @override
  String get weekdayMondayShort => '周一';

  @override
  String get weekdayTuesdayShort => '周二';

  @override
  String get weekdayWednesdayShort => '周三';

  @override
  String get weekdayThursdayShort => '周四';

  @override
  String get weekdayFridayShort => '周五';

  @override
  String get weekdaySaturdayShort => '周六';

  @override
  String get weekdaySundayShort => '周日';

  @override
  String get taskFormAttachments => '附件';

  @override
  String get taskDetailAttachments => '附件';

  @override
  String get homeQuickIdeaTitle => '记录灵感';

  @override
  String get homeQuickIdeaHint => '写下你的奇思妙想...';

  @override
  String get homeQuickIdeaSave => '保存';

  @override
  String get homeQuickIdeaDefaultTag => '#灵感';

  @override
  String homeBatchCompleteSuccess(int count) {
    return '已完成 $count 个任务';
  }

  @override
  String homeBatchUncompleteSuccess(int count) {
    return '已取消完成 $count 个任务';
  }

  @override
  String homeBatchActionFailure(String error) {
    return '操作失败：$error';
  }

  @override
  String get homeBatchDeleteTitle => '删除任务？';

  @override
  String homeBatchDeleteMessage(int count) {
    return '确定要删除 $count 个任务吗？此操作无法撤销。';
  }

  @override
  String homeBatchDeleteSuccess(int count) {
    return '已删除 $count 个任务';
  }

  @override
  String get homeBatchMoveTitle => '移动到列表';

  @override
  String homeBatchMoveSuccess(int count) {
    return '已移动 $count 个任务';
  }

  @override
  String homeBatchTagSuccess(int count) {
    return '已为 $count 个任务添加标签';
  }

  @override
  String get smartReminderButtonLabel => '智能提醒';

  @override
  String smartReminderButtonWithCount(int count) {
    return '智能提醒 ($count)';
  }

  @override
  String get smartReminderSheetTitle => '智能提醒';

  @override
  String get smartReminderSheetDone => '完成';

  @override
  String smartReminderEveryMinutes(int minutes, int count) {
    return '每 $minutes 分重复，共 $count 次';
  }

  @override
  String get smartReminderAddTime => '添加时间提醒';

  @override
  String get smartReminderAddRepeating => '添加重复提醒';

  @override
  String get smartReminderToday => '今天';

  @override
  String get smartReminderTomorrow => '明天';

  @override
  String smartReminderAt(String date, String time) {
    return '$date 在 $time';
  }

  @override
  String get smartReminderRepeatTitle => '重复提醒设置';

  @override
  String get smartReminderRepeatInterval => '重复间隔';

  @override
  String get smartReminderRepeatEvery => '每';

  @override
  String get smartReminderRepeatMinutes => '分钟';

  @override
  String get smartReminderRepeatHours => '小时';

  @override
  String get smartReminderRepeatTimes => '次数';

  @override
  String get smartReminderTimes => '次';

  @override
  String get smartReminderRepeatConfirm => '保存';
}
