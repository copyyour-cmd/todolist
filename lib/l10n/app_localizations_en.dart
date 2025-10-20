// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TodoList';

  @override
  String get homeFilterToday => 'Today';

  @override
  String get homeFilterOverdue => 'Overdue';

  @override
  String get homeFilterUpcoming => 'Upcoming';

  @override
  String get homeEmptyTitle => 'Nothing planned yet';

  @override
  String get homeEmptySubtitle => 'Capture a task or schedule a focus block to build momentum.';

  @override
  String get homeEmptyAction => 'Add a task';

  @override
  String get homeErrorTitle => 'Something went wrong';

  @override
  String homeErrorDetails(Object error) {
    return '$error';
  }

  @override
  String get homeFabLabel => 'New Task';

  @override
  String homeSelectionTitle(int count) {
    return '$count selected';
  }

  @override
  String get homeQuickIdeaTooltip => 'Quick capture idea';

  @override
  String get homeFilterBarTitle => 'Filters';

  @override
  String get homeBatchComplete => 'Complete';

  @override
  String get homeBatchDelete => 'Delete';

  @override
  String get homeBatchMove => 'Move to list';

  @override
  String get homeBatchTag => 'Add tags';

  @override
  String get homeTagDialogTitle => 'Select tags';

  @override
  String get homeCommonCancel => 'Cancel';

  @override
  String get homeCommonConfirm => 'Confirm';

  @override
  String homeSubtaskSummary(Object completed, Object total) {
    return '$completed of $total subtasks completed';
  }

  @override
  String get taskFormNewTitle => 'New Task';

  @override
  String get taskFormEditTitle => 'Edit Task';

  @override
  String get taskFormTitleLabel => 'Title';

  @override
  String get taskFormTitleValidation => 'Please enter a title';

  @override
  String get taskFormListLabel => 'List';

  @override
  String get taskFormPriorityLabel => 'Priority';

  @override
  String get taskFormNotesLabel => 'Notes';

  @override
  String get taskFormTagsLabel => 'Tags';

  @override
  String get taskFormDueDate => 'Due date';

  @override
  String get taskFormReminder => 'Reminder';

  @override
  String get taskFormSubtasks => 'Subtasks';

  @override
  String get taskFormAddSubtask => 'Add subtask';

  @override
  String get taskFormAdd => 'Add';

  @override
  String get taskFormCreate => 'Create task';

  @override
  String get taskFormUpdate => 'Update task';

  @override
  String get taskFormSelectList => 'Please select a list';

  @override
  String get taskFormSaveError => 'Unable to save task';

  @override
  String get taskPriorityNone => 'None';

  @override
  String get taskPriorityLow => 'Low';

  @override
  String get taskPriorityMedium => 'Medium';

  @override
  String get taskPriorityHigh => 'High';

  @override
  String get taskPriorityCritical => 'Critical';

  @override
  String get notificationChannelName => 'Task reminders';

  @override
  String get notificationChannelDescription => 'Reminders for scheduled tasks';

  @override
  String get notificationTitle => 'Task reminder';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsRequirePassword => 'Require password on launch';

  @override
  String get settingsRequirePasswordSubtitle => 'Protect your tasks with a passcode at startup.';

  @override
  String get settingsSetPasswordTitle => 'Set password';

  @override
  String get settingsPasswordField => 'Password';

  @override
  String get settingsPasswordConfirmField => 'Confirm password';

  @override
  String get settingsPasswordRequired => 'Please enter a password';

  @override
  String get settingsPasswordTooShort => 'Use at least 4 characters';

  @override
  String get settingsPasswordMismatch => 'Passwords do not match';

  @override
  String get settingsPasswordEnabled => 'Password protection enabled';

  @override
  String get settingsPasswordDisabled => 'Password protection disabled';

  @override
  String get settingsChangePassword => 'Change password';

  @override
  String get settingsPasswordChanged => 'Password updated';

  @override
  String get settingsDisablePasswordTitle => 'Disable password?';

  @override
  String get settingsDisablePasswordMessage => 'You will no longer need a password when opening the app.';

  @override
  String settingsLoadError(Object error) {
    return 'Unable to load settings: $error';
  }

  @override
  String get unlockTitle => 'Unlock';

  @override
  String get unlockPrompt => 'Enter your password to continue';

  @override
  String get unlockAction => 'Unlock';

  @override
  String get unlockFailed => 'Password incorrect';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonReset => 'Clear';

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System language';

  @override
  String get settingsNotificationsSection => 'Notifications';

  @override
  String get settingsEnableNotifications => 'Enable notifications';

  @override
  String get settingsEnableNotificationsSubtitle => 'Receive reminders for scheduled tasks';

  @override
  String get settingsSecuritySection => 'Security';

  @override
  String get settingsDataSection => 'Data management';

  @override
  String get settingsImportData => 'Import data';

  @override
  String get settingsImportDataSubtitle => 'Import tasks from a JSON file';

  @override
  String get settingsExportData => 'Export data';

  @override
  String get settingsExportDataSubtitle => 'Save your tasks to a JSON file';

  @override
  String get settingsLoadDemoData => 'Load demo data';

  @override
  String get settingsLoadDemoDataSubtitle => 'Add sample tasks and lists';

  @override
  String get settingsLoadDemoDataConfirm => 'This will add demo tasks to your lists if they are empty.';

  @override
  String get settingsDemoDataLoaded => 'Demo data loaded successfully';

  @override
  String get settingsClearAllData => 'Clear all data';

  @override
  String get settingsClearAllDataSubtitle => 'Delete all tasks, lists, and tags';

  @override
  String get settingsClearAllDataConfirm => 'This will permanently delete all your tasks, lists, and tags. This cannot be undone.';

  @override
  String get settingsDataCleared => 'All data has been cleared';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsComingSoon => 'Coming soon';

  @override
  String get settingsError => 'Error';

  @override
  String get settingsContentSection => 'Content';

  @override
  String get settingsManageLists => 'Manage lists';

  @override
  String get settingsManageListsSubtitle => 'Create, edit, and organize your lists';

  @override
  String get listManagementTitle => 'Manage Lists';

  @override
  String get listManagementFabLabel => 'New List';

  @override
  String get listManagementEmptyTitle => 'No lists yet';

  @override
  String get listManagementEmptySubtitle => 'Create your first list to organize your tasks';

  @override
  String get listManagementEmptyAction => 'Create List';

  @override
  String get listManagementCreated => 'List created';

  @override
  String get listManagementUpdated => 'List updated';

  @override
  String get listManagementDeleted => 'List deleted';

  @override
  String get listManagementDeleteTitle => 'Delete list?';

  @override
  String listManagementDeleteMessage(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get listManagementDeleteError => 'Failed to delete list';

  @override
  String get listManagementDeleteErrorHasTasks => 'Cannot delete list with existing tasks';

  @override
  String get listManagementLoadError => 'Failed to load lists';

  @override
  String get listManagementReorderError => 'Failed to reorder lists';

  @override
  String get listManagementDefaultLabel => 'Default list';

  @override
  String get listFormNewTitle => 'New List';

  @override
  String get listFormEditTitle => 'Edit List';

  @override
  String get listFormNameLabel => 'List name';

  @override
  String get listFormNameValidation => 'Please enter a name';

  @override
  String get listFormIconLabel => 'Icon';

  @override
  String get listFormColorLabel => 'Color';

  @override
  String get listFormSaveError => 'Failed to save list';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonDelete => 'Delete';

  @override
  String get settingsManageTags => 'Manage tags';

  @override
  String get settingsManageTagsSubtitle => 'Create and organize tags for your tasks';

  @override
  String get tagManagementTitle => 'Manage Tags';

  @override
  String get tagManagementFabLabel => 'New Tag';

  @override
  String get tagManagementEmptyTitle => 'No tags yet';

  @override
  String get tagManagementEmptySubtitle => 'Create your first tag to categorize your tasks';

  @override
  String get tagManagementEmptyAction => 'Create Tag';

  @override
  String get tagManagementCreated => 'Tag created';

  @override
  String get tagManagementUpdated => 'Tag updated';

  @override
  String get tagManagementDeleted => 'Tag deleted';

  @override
  String get tagManagementDeletedWithTaskUpdate => 'Tag deleted and removed from tasks';

  @override
  String get tagManagementDeleteTitle => 'Delete tag?';

  @override
  String tagManagementDeleteMessage(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String tagManagementDeleteMessageWithTasks(String name, int count) {
    return 'Are you sure you want to delete \"$name\"? It is used by $count tasks and will be removed from them.';
  }

  @override
  String get tagManagementDeleteError => 'Failed to delete tag';

  @override
  String get tagManagementLoadError => 'Failed to load tags';

  @override
  String tagManagementTaskCount(int count) {
    return '$count tasks';
  }

  @override
  String get tagFormNewTitle => 'New Tag';

  @override
  String get tagFormEditTitle => 'Edit Tag';

  @override
  String get tagFormNameLabel => 'Tag name';

  @override
  String get tagFormNameValidation => 'Please enter a name';

  @override
  String get tagFormColorLabel => 'Color';

  @override
  String get tagFormPreview => 'Preview:';

  @override
  String get tagFormPreviewPlaceholder => 'Tag Name';

  @override
  String get tagFormSaveError => 'Failed to save tag';

  @override
  String get searchHint => 'Search tasks...';

  @override
  String get searchEmptyHistory => 'Start searching to find your tasks';

  @override
  String get searchRecentSearches => 'Recent searches';

  @override
  String get searchClearHistory => 'Clear all';

  @override
  String get searchNoResults => 'No tasks found';

  @override
  String get searchNoResultsHint => 'Try different keywords or check your spelling';

  @override
  String searchResultsCount(int count) {
    return '$count results';
  }

  @override
  String get taskDetailTitle => 'Task Details';

  @override
  String get taskDetailNotFound => 'Task not found';

  @override
  String get taskDetailPriority => 'Priority';

  @override
  String get taskDetailList => 'List';

  @override
  String get taskDetailTags => 'Tags';

  @override
  String get taskDetailDueDate => 'Due date';

  @override
  String get taskDetailReminder => 'Reminder';

  @override
  String get taskDetailNotes => 'Notes';

  @override
  String get taskDetailSubtasks => 'Subtasks';

  @override
  String get taskDetailMetadata => 'Information';

  @override
  String get taskDetailCreated => 'Created';

  @override
  String get taskDetailUpdated => 'Updated';

  @override
  String get taskDetailCompleted => 'Completed';

  @override
  String get taskDetailDuplicate => 'Duplicate';

  @override
  String get taskDetailDelete => 'Delete';

  @override
  String get taskDetailDeleteConfirmTitle => 'Delete task?';

  @override
  String taskDetailDeleteConfirmMessage(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get taskDetailDeleted => 'Task deleted';

  @override
  String get taskDetailDeleteError => 'Failed to delete task';

  @override
  String get taskDetailDuplicated => 'Task duplicated';

  @override
  String get homeSortByLabel => 'Sort by';

  @override
  String get homeSortByManual => 'Manual order';

  @override
  String get homeSortByDueDate => 'Due date';

  @override
  String get homeSortByPriority => 'Priority';

  @override
  String get homeSortByCreatedDate => 'Created date';

  @override
  String get homeShowCompletedLabel => 'Completed';

  @override
  String get settingsStatistics => 'Statistics & Insights';

  @override
  String get settingsStatisticsSubtitle => 'View task completion rates and productivity trends';

  @override
  String get settingsCalendar => 'Calendar View';

  @override
  String get settingsCalendarSubtitle => 'View and manage tasks in calendar';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get calendarTodayButton => 'Today';

  @override
  String calendarTaskCount(int count) {
    return '$count tasks';
  }

  @override
  String get calendarNoTasks => 'No tasks on this day';

  @override
  String get calendarTaskMoved => 'Task date updated';

  @override
  String get focusTitle => 'Focus Mode';

  @override
  String get focusHistoryButton => 'History';

  @override
  String focusTodayMinutes(int minutes) {
    return 'Focused $minutes minutes today';
  }

  @override
  String get focusSelectDuration => 'Select focus duration';

  @override
  String get focusDurationShort => '5 min';

  @override
  String get focusDurationStandard => '25 min';

  @override
  String get focusDurationLong => '45 min';

  @override
  String get focusStart => 'Start Focus';

  @override
  String get focusPause => 'Pause';

  @override
  String get focusResume => 'Resume';

  @override
  String get focusCancel => 'Cancel';

  @override
  String get focusCompleted => 'Focus Completed!';

  @override
  String get focusStartNew => 'Start New Session';

  @override
  String get focusCancelTitle => 'Cancel Focus?';

  @override
  String get focusCancelMessage => 'Are you sure you want to cancel the current focus session?';

  @override
  String get focusCompleteTask => 'Mark Task Complete';

  @override
  String get focusTaskCompleted => 'Task marked as completed';

  @override
  String get settingsFocus => 'Focus Mode';

  @override
  String get settingsFocusSubtitle => 'Use Pomodoro timer to boost focus';

  @override
  String get statisticsTitle => 'Statistics & Insights';

  @override
  String get statisticsCompletionRate => 'Completion Rate Statistics';

  @override
  String get statisticsToday => 'Today';

  @override
  String get statisticsThisWeek => 'This Week';

  @override
  String get statisticsThisMonth => 'This Month';

  @override
  String get statisticsTrend => 'Task Trend (Last 7 Days)';

  @override
  String get statisticsTrendCreated => 'Created';

  @override
  String get statisticsTrendCompleted => 'Completed';

  @override
  String get statisticsByList => 'Statistics by List';

  @override
  String get statisticsByTag => 'Statistics by Tag';

  @override
  String get statisticsHeatmap => 'Productivity Heatmap (Last 30 Days)';

  @override
  String statisticsHeatmapTooltip(String date, int count) {
    return '$date\n$count tasks completed';
  }

  @override
  String statisticsCompletedTasks(Object completed, Object total) {
    return '$completed/$total';
  }

  @override
  String get taskFormRecurrence => 'Recurrence';

  @override
  String get taskFormRecurrenceNone => 'Does not repeat';

  @override
  String get recurrenceDaily => 'Daily';

  @override
  String get recurrenceWeekly => 'Weekly';

  @override
  String get recurrenceMonthly => 'Monthly';

  @override
  String get recurrenceYearly => 'Yearly';

  @override
  String get recurrenceCustom => 'Custom';

  @override
  String get recurrenceConfig => 'Configure Recurrence';

  @override
  String get recurrenceInterval => 'Interval';

  @override
  String get recurrenceDaysOfWeek => 'Days of Week';

  @override
  String get recurrenceSpecificDay => 'Specific Day';

  @override
  String get recurrenceNeverEnds => 'Never ends';

  @override
  String get recurrenceEndAfterCount => 'End after occurrences';

  @override
  String get recurrenceEndOnDate => 'End on date';

  @override
  String get recurrenceOccurrences => 'Occurrences';

  @override
  String recurrenceEveryNDays(int interval) {
    return 'Every $interval days';
  }

  @override
  String recurrenceEveryNWeeks(int interval) {
    return 'Every $interval weeks';
  }

  @override
  String recurrenceEveryNMonths(int interval) {
    return 'Every $interval months';
  }

  @override
  String recurrenceEveryNYears(int interval) {
    return 'Every $interval years';
  }

  @override
  String recurrenceDayOfMonth(int day) {
    return 'Day $day of month';
  }

  @override
  String recurrenceUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Until $dateString';
  }

  @override
  String recurrenceCount(int count) {
    return '$count times';
  }

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get weekdayMondayShort => 'Mon';

  @override
  String get weekdayTuesdayShort => 'Tue';

  @override
  String get weekdayWednesdayShort => 'Wed';

  @override
  String get weekdayThursdayShort => 'Thu';

  @override
  String get weekdayFridayShort => 'Fri';

  @override
  String get weekdaySaturdayShort => 'Sat';

  @override
  String get weekdaySundayShort => 'Sun';

  @override
  String get taskFormAttachments => 'Attachments';

  @override
  String get taskDetailAttachments => 'Attachments';

  @override
  String get homeQuickIdeaTitle => 'Capture idea';

  @override
  String get homeQuickIdeaHint => 'Write down your idea...';

  @override
  String get homeQuickIdeaSave => 'Save';

  @override
  String get homeQuickIdeaDefaultTag => '#idea';

  @override
  String homeBatchCompleteSuccess(int count) {
    return 'Marked $count tasks as done';
  }

  @override
  String homeBatchUncompleteSuccess(int count) {
    return 'Reopened $count tasks';
  }

  @override
  String homeBatchActionFailure(String error) {
    return 'Action failed: $error';
  }

  @override
  String get homeBatchDeleteTitle => 'Delete tasks?';

  @override
  String homeBatchDeleteMessage(int count) {
    return 'Delete $count tasks? This cannot be undone.';
  }

  @override
  String homeBatchDeleteSuccess(int count) {
    return 'Deleted $count tasks';
  }

  @override
  String get homeBatchMoveTitle => 'Move to list';

  @override
  String homeBatchMoveSuccess(int count) {
    return 'Moved $count tasks';
  }

  @override
  String homeBatchTagSuccess(int count) {
    return 'Tagged $count tasks';
  }

  @override
  String get smartReminderButtonLabel => 'Smart reminders';

  @override
  String smartReminderButtonWithCount(int count) {
    return 'Smart reminders ($count)';
  }

  @override
  String get smartReminderSheetTitle => 'Smart reminders';

  @override
  String get smartReminderSheetDone => 'Done';

  @override
  String smartReminderEveryMinutes(int minutes, int count) {
    return 'Every $minutes min, $count×';
  }

  @override
  String get smartReminderAddTime => 'Add time reminder';

  @override
  String get smartReminderAddRepeating => 'Add repeating reminder';

  @override
  String get smartReminderToday => 'Today';

  @override
  String get smartReminderTomorrow => 'Tomorrow';

  @override
  String smartReminderAt(String date, String time) {
    return '$date at $time';
  }

  @override
  String get smartReminderRepeatTitle => 'Repeat configuration';

  @override
  String get smartReminderRepeatInterval => 'Interval';

  @override
  String get smartReminderRepeatEvery => 'Every';

  @override
  String get smartReminderRepeatMinutes => 'minutes';

  @override
  String get smartReminderRepeatHours => 'hours';

  @override
  String get smartReminderRepeatTimes => 'Times';

  @override
  String get smartReminderTimes => 'times';

  @override
  String get smartReminderRepeatConfirm => 'Save';
}
