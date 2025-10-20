import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TodoList'**
  String get appTitle;

  /// No description provided for @homeFilterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeFilterToday;

  /// No description provided for @homeFilterOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get homeFilterOverdue;

  /// No description provided for @homeFilterUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get homeFilterUpcoming;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned yet'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture a task or schedule a focus block to build momentum.'**
  String get homeEmptySubtitle;

  /// No description provided for @homeEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Add a task'**
  String get homeEmptyAction;

  /// No description provided for @homeErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get homeErrorTitle;

  /// No description provided for @homeErrorDetails.
  ///
  /// In en, this message translates to:
  /// **'{error}'**
  String homeErrorDetails(Object error);

  /// No description provided for @homeFabLabel.
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get homeFabLabel;

  /// No description provided for @homeSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String homeSelectionTitle(int count);

  /// No description provided for @homeQuickIdeaTooltip.
  ///
  /// In en, this message translates to:
  /// **'Quick capture idea'**
  String get homeQuickIdeaTooltip;

  /// No description provided for @homeFilterBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get homeFilterBarTitle;

  /// No description provided for @homeBatchComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get homeBatchComplete;

  /// No description provided for @homeBatchDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get homeBatchDelete;

  /// No description provided for @homeBatchMove.
  ///
  /// In en, this message translates to:
  /// **'Move to list'**
  String get homeBatchMove;

  /// No description provided for @homeBatchTag.
  ///
  /// In en, this message translates to:
  /// **'Add tags'**
  String get homeBatchTag;

  /// No description provided for @homeTagDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Select tags'**
  String get homeTagDialogTitle;

  /// No description provided for @homeCommonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get homeCommonCancel;

  /// No description provided for @homeCommonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get homeCommonConfirm;

  /// No description provided for @homeSubtaskSummary.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} subtasks completed'**
  String homeSubtaskSummary(Object completed, Object total);

  /// No description provided for @taskFormNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get taskFormNewTitle;

  /// No description provided for @taskFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get taskFormEditTitle;

  /// No description provided for @taskFormTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get taskFormTitleLabel;

  /// No description provided for @taskFormTitleValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get taskFormTitleValidation;

  /// No description provided for @taskFormListLabel.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get taskFormListLabel;

  /// No description provided for @taskFormPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get taskFormPriorityLabel;

  /// No description provided for @taskFormNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get taskFormNotesLabel;

  /// No description provided for @taskFormTagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get taskFormTagsLabel;

  /// No description provided for @taskFormDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get taskFormDueDate;

  /// No description provided for @taskFormReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get taskFormReminder;

  /// No description provided for @taskFormSubtasks.
  ///
  /// In en, this message translates to:
  /// **'Subtasks'**
  String get taskFormSubtasks;

  /// No description provided for @taskFormAddSubtask.
  ///
  /// In en, this message translates to:
  /// **'Add subtask'**
  String get taskFormAddSubtask;

  /// No description provided for @taskFormAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get taskFormAdd;

  /// No description provided for @taskFormCreate.
  ///
  /// In en, this message translates to:
  /// **'Create task'**
  String get taskFormCreate;

  /// No description provided for @taskFormUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update task'**
  String get taskFormUpdate;

  /// No description provided for @taskFormSelectList.
  ///
  /// In en, this message translates to:
  /// **'Please select a list'**
  String get taskFormSelectList;

  /// No description provided for @taskFormSaveError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save task'**
  String get taskFormSaveError;

  /// No description provided for @taskPriorityNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get taskPriorityNone;

  /// No description provided for @taskPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get taskPriorityLow;

  /// No description provided for @taskPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get taskPriorityMedium;

  /// No description provided for @taskPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get taskPriorityHigh;

  /// No description provided for @taskPriorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get taskPriorityCritical;

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'Task reminders'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminders for scheduled tasks'**
  String get notificationChannelDescription;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Task reminder'**
  String get notificationTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsRequirePassword.
  ///
  /// In en, this message translates to:
  /// **'Require password on launch'**
  String get settingsRequirePassword;

  /// No description provided for @settingsRequirePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your tasks with a passcode at startup.'**
  String get settingsRequirePasswordSubtitle;

  /// No description provided for @settingsSetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set password'**
  String get settingsSetPasswordTitle;

  /// No description provided for @settingsPasswordField.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get settingsPasswordField;

  /// No description provided for @settingsPasswordConfirmField.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get settingsPasswordConfirmField;

  /// No description provided for @settingsPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get settingsPasswordRequired;

  /// No description provided for @settingsPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 4 characters'**
  String get settingsPasswordTooShort;

  /// No description provided for @settingsPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get settingsPasswordMismatch;

  /// No description provided for @settingsPasswordEnabled.
  ///
  /// In en, this message translates to:
  /// **'Password protection enabled'**
  String get settingsPasswordEnabled;

  /// No description provided for @settingsPasswordDisabled.
  ///
  /// In en, this message translates to:
  /// **'Password protection disabled'**
  String get settingsPasswordDisabled;

  /// No description provided for @settingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settingsChangePassword;

  /// No description provided for @settingsPasswordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get settingsPasswordChanged;

  /// No description provided for @settingsDisablePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable password?'**
  String get settingsDisablePasswordTitle;

  /// No description provided for @settingsDisablePasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'You will no longer need a password when opening the app.'**
  String get settingsDisablePasswordMessage;

  /// No description provided for @settingsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load settings: {error}'**
  String settingsLoadError(Object error);

  /// No description provided for @unlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockTitle;

  /// No description provided for @unlockPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to continue'**
  String get unlockPrompt;

  /// No description provided for @unlockAction.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockAction;

  /// No description provided for @unlockFailed.
  ///
  /// In en, this message translates to:
  /// **'Password incorrect'**
  String get unlockFailed;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonReset.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonReset;

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsNotificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsSection;

  /// No description provided for @settingsEnableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get settingsEnableNotifications;

  /// No description provided for @settingsEnableNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive reminders for scheduled tasks'**
  String get settingsEnableNotificationsSubtitle;

  /// No description provided for @settingsSecuritySection.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecuritySection;

  /// No description provided for @settingsDataSection.
  ///
  /// In en, this message translates to:
  /// **'Data management'**
  String get settingsDataSection;

  /// No description provided for @settingsImportData.
  ///
  /// In en, this message translates to:
  /// **'Import data'**
  String get settingsImportData;

  /// No description provided for @settingsImportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import tasks from a JSON file'**
  String get settingsImportDataSubtitle;

  /// No description provided for @settingsExportData.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get settingsExportData;

  /// No description provided for @settingsExportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save your tasks to a JSON file'**
  String get settingsExportDataSubtitle;

  /// No description provided for @settingsLoadDemoData.
  ///
  /// In en, this message translates to:
  /// **'Load demo data'**
  String get settingsLoadDemoData;

  /// No description provided for @settingsLoadDemoDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add sample tasks and lists'**
  String get settingsLoadDemoDataSubtitle;

  /// No description provided for @settingsLoadDemoDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will add demo tasks to your lists if they are empty.'**
  String get settingsLoadDemoDataConfirm;

  /// No description provided for @settingsDemoDataLoaded.
  ///
  /// In en, this message translates to:
  /// **'Demo data loaded successfully'**
  String get settingsDemoDataLoaded;

  /// No description provided for @settingsClearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get settingsClearAllData;

  /// No description provided for @settingsClearAllDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all tasks, lists, and tags'**
  String get settingsClearAllDataSubtitle;

  /// No description provided for @settingsClearAllDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your tasks, lists, and tags. This cannot be undone.'**
  String get settingsClearAllDataConfirm;

  /// No description provided for @settingsDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All data has been cleared'**
  String get settingsDataCleared;

  /// No description provided for @settingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSection;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get settingsComingSoon;

  /// No description provided for @settingsError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get settingsError;

  /// No description provided for @settingsContentSection.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get settingsContentSection;

  /// No description provided for @settingsManageLists.
  ///
  /// In en, this message translates to:
  /// **'Manage lists'**
  String get settingsManageLists;

  /// No description provided for @settingsManageListsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create, edit, and organize your lists'**
  String get settingsManageListsSubtitle;

  /// No description provided for @listManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Lists'**
  String get listManagementTitle;

  /// No description provided for @listManagementFabLabel.
  ///
  /// In en, this message translates to:
  /// **'New List'**
  String get listManagementFabLabel;

  /// No description provided for @listManagementEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No lists yet'**
  String get listManagementEmptyTitle;

  /// No description provided for @listManagementEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first list to organize your tasks'**
  String get listManagementEmptySubtitle;

  /// No description provided for @listManagementEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Create List'**
  String get listManagementEmptyAction;

  /// No description provided for @listManagementCreated.
  ///
  /// In en, this message translates to:
  /// **'List created'**
  String get listManagementCreated;

  /// No description provided for @listManagementUpdated.
  ///
  /// In en, this message translates to:
  /// **'List updated'**
  String get listManagementUpdated;

  /// No description provided for @listManagementDeleted.
  ///
  /// In en, this message translates to:
  /// **'List deleted'**
  String get listManagementDeleted;

  /// No description provided for @listManagementDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete list?'**
  String get listManagementDeleteTitle;

  /// No description provided for @listManagementDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String listManagementDeleteMessage(String name);

  /// No description provided for @listManagementDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete list'**
  String get listManagementDeleteError;

  /// No description provided for @listManagementDeleteErrorHasTasks.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete list with existing tasks'**
  String get listManagementDeleteErrorHasTasks;

  /// No description provided for @listManagementLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load lists'**
  String get listManagementLoadError;

  /// No description provided for @listManagementReorderError.
  ///
  /// In en, this message translates to:
  /// **'Failed to reorder lists'**
  String get listManagementReorderError;

  /// No description provided for @listManagementDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default list'**
  String get listManagementDefaultLabel;

  /// No description provided for @listFormNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New List'**
  String get listFormNewTitle;

  /// No description provided for @listFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit List'**
  String get listFormEditTitle;

  /// No description provided for @listFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'List name'**
  String get listFormNameLabel;

  /// No description provided for @listFormNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get listFormNameValidation;

  /// No description provided for @listFormIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get listFormIconLabel;

  /// No description provided for @listFormColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get listFormColorLabel;

  /// No description provided for @listFormSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save list'**
  String get listFormSaveError;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get commonCreate;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @settingsManageTags.
  ///
  /// In en, this message translates to:
  /// **'Manage tags'**
  String get settingsManageTags;

  /// No description provided for @settingsManageTagsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create and organize tags for your tasks'**
  String get settingsManageTagsSubtitle;

  /// No description provided for @tagManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Tags'**
  String get tagManagementTitle;

  /// No description provided for @tagManagementFabLabel.
  ///
  /// In en, this message translates to:
  /// **'New Tag'**
  String get tagManagementFabLabel;

  /// No description provided for @tagManagementEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No tags yet'**
  String get tagManagementEmptyTitle;

  /// No description provided for @tagManagementEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first tag to categorize your tasks'**
  String get tagManagementEmptySubtitle;

  /// No description provided for @tagManagementEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Create Tag'**
  String get tagManagementEmptyAction;

  /// No description provided for @tagManagementCreated.
  ///
  /// In en, this message translates to:
  /// **'Tag created'**
  String get tagManagementCreated;

  /// No description provided for @tagManagementUpdated.
  ///
  /// In en, this message translates to:
  /// **'Tag updated'**
  String get tagManagementUpdated;

  /// No description provided for @tagManagementDeleted.
  ///
  /// In en, this message translates to:
  /// **'Tag deleted'**
  String get tagManagementDeleted;

  /// No description provided for @tagManagementDeletedWithTaskUpdate.
  ///
  /// In en, this message translates to:
  /// **'Tag deleted and removed from tasks'**
  String get tagManagementDeletedWithTaskUpdate;

  /// No description provided for @tagManagementDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete tag?'**
  String get tagManagementDeleteTitle;

  /// No description provided for @tagManagementDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String tagManagementDeleteMessage(String name);

  /// No description provided for @tagManagementDeleteMessageWithTasks.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? It is used by {count} tasks and will be removed from them.'**
  String tagManagementDeleteMessageWithTasks(String name, int count);

  /// No description provided for @tagManagementDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete tag'**
  String get tagManagementDeleteError;

  /// No description provided for @tagManagementLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tags'**
  String get tagManagementLoadError;

  /// No description provided for @tagManagementTaskCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tasks'**
  String tagManagementTaskCount(int count);

  /// No description provided for @tagFormNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Tag'**
  String get tagFormNewTitle;

  /// No description provided for @tagFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Tag'**
  String get tagFormEditTitle;

  /// No description provided for @tagFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag name'**
  String get tagFormNameLabel;

  /// No description provided for @tagFormNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get tagFormNameValidation;

  /// No description provided for @tagFormColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get tagFormColorLabel;

  /// No description provided for @tagFormPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview:'**
  String get tagFormPreview;

  /// No description provided for @tagFormPreviewPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tag Name'**
  String get tagFormPreviewPlaceholder;

  /// No description provided for @tagFormSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save tag'**
  String get tagFormSaveError;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search tasks...'**
  String get searchHint;

  /// No description provided for @searchEmptyHistory.
  ///
  /// In en, this message translates to:
  /// **'Start searching to find your tasks'**
  String get searchEmptyHistory;

  /// No description provided for @searchRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get searchRecentSearches;

  /// No description provided for @searchClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get searchClearHistory;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No tasks found'**
  String get searchNoResults;

  /// No description provided for @searchNoResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords or check your spelling'**
  String get searchNoResultsHint;

  /// No description provided for @searchResultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String searchResultsCount(int count);

  /// No description provided for @taskDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get taskDetailTitle;

  /// No description provided for @taskDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Task not found'**
  String get taskDetailNotFound;

  /// No description provided for @taskDetailPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get taskDetailPriority;

  /// No description provided for @taskDetailList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get taskDetailList;

  /// No description provided for @taskDetailTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get taskDetailTags;

  /// No description provided for @taskDetailDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get taskDetailDueDate;

  /// No description provided for @taskDetailReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get taskDetailReminder;

  /// No description provided for @taskDetailNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get taskDetailNotes;

  /// No description provided for @taskDetailSubtasks.
  ///
  /// In en, this message translates to:
  /// **'Subtasks'**
  String get taskDetailSubtasks;

  /// No description provided for @taskDetailMetadata.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get taskDetailMetadata;

  /// No description provided for @taskDetailCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get taskDetailCreated;

  /// No description provided for @taskDetailUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get taskDetailUpdated;

  /// No description provided for @taskDetailCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get taskDetailCompleted;

  /// No description provided for @taskDetailDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get taskDetailDuplicate;

  /// No description provided for @taskDetailDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get taskDetailDelete;

  /// No description provided for @taskDetailDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete task?'**
  String get taskDetailDeleteConfirmTitle;

  /// No description provided for @taskDetailDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String taskDetailDeleteConfirmMessage(String title);

  /// No description provided for @taskDetailDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get taskDetailDeleted;

  /// No description provided for @taskDetailDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete task'**
  String get taskDetailDeleteError;

  /// No description provided for @taskDetailDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Task duplicated'**
  String get taskDetailDuplicated;

  /// No description provided for @homeSortByLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get homeSortByLabel;

  /// No description provided for @homeSortByManual.
  ///
  /// In en, this message translates to:
  /// **'Manual order'**
  String get homeSortByManual;

  /// No description provided for @homeSortByDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get homeSortByDueDate;

  /// No description provided for @homeSortByPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get homeSortByPriority;

  /// No description provided for @homeSortByCreatedDate.
  ///
  /// In en, this message translates to:
  /// **'Created date'**
  String get homeSortByCreatedDate;

  /// No description provided for @homeShowCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get homeShowCompletedLabel;

  /// No description provided for @settingsStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics & Insights'**
  String get settingsStatistics;

  /// No description provided for @settingsStatisticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View task completion rates and productivity trends'**
  String get settingsStatisticsSubtitle;

  /// No description provided for @settingsCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar View'**
  String get settingsCalendar;

  /// No description provided for @settingsCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage tasks in calendar'**
  String get settingsCalendarSubtitle;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarTodayButton.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarTodayButton;

  /// No description provided for @calendarTaskCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tasks'**
  String calendarTaskCount(int count);

  /// No description provided for @calendarNoTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks on this day'**
  String get calendarNoTasks;

  /// No description provided for @calendarTaskMoved.
  ///
  /// In en, this message translates to:
  /// **'Task date updated'**
  String get calendarTaskMoved;

  /// No description provided for @focusTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusTitle;

  /// No description provided for @focusHistoryButton.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get focusHistoryButton;

  /// No description provided for @focusTodayMinutes.
  ///
  /// In en, this message translates to:
  /// **'Focused {minutes} minutes today'**
  String focusTodayMinutes(int minutes);

  /// No description provided for @focusSelectDuration.
  ///
  /// In en, this message translates to:
  /// **'Select focus duration'**
  String get focusSelectDuration;

  /// No description provided for @focusDurationShort.
  ///
  /// In en, this message translates to:
  /// **'5 min'**
  String get focusDurationShort;

  /// No description provided for @focusDurationStandard.
  ///
  /// In en, this message translates to:
  /// **'25 min'**
  String get focusDurationStandard;

  /// No description provided for @focusDurationLong.
  ///
  /// In en, this message translates to:
  /// **'45 min'**
  String get focusDurationLong;

  /// No description provided for @focusStart.
  ///
  /// In en, this message translates to:
  /// **'Start Focus'**
  String get focusStart;

  /// No description provided for @focusPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get focusPause;

  /// No description provided for @focusResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get focusResume;

  /// No description provided for @focusCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get focusCancel;

  /// No description provided for @focusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Focus Completed!'**
  String get focusCompleted;

  /// No description provided for @focusStartNew.
  ///
  /// In en, this message translates to:
  /// **'Start New Session'**
  String get focusStartNew;

  /// No description provided for @focusCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Focus?'**
  String get focusCancelTitle;

  /// No description provided for @focusCancelMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the current focus session?'**
  String get focusCancelMessage;

  /// No description provided for @focusCompleteTask.
  ///
  /// In en, this message translates to:
  /// **'Mark Task Complete'**
  String get focusCompleteTask;

  /// No description provided for @focusTaskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task marked as completed'**
  String get focusTaskCompleted;

  /// No description provided for @settingsFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get settingsFocus;

  /// No description provided for @settingsFocusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use Pomodoro timer to boost focus'**
  String get settingsFocusSubtitle;

  /// No description provided for @statisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics & Insights'**
  String get statisticsTitle;

  /// No description provided for @statisticsCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate Statistics'**
  String get statisticsCompletionRate;

  /// No description provided for @statisticsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statisticsToday;

  /// No description provided for @statisticsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get statisticsThisWeek;

  /// No description provided for @statisticsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get statisticsThisMonth;

  /// No description provided for @statisticsTrend.
  ///
  /// In en, this message translates to:
  /// **'Task Trend (Last 7 Days)'**
  String get statisticsTrend;

  /// No description provided for @statisticsTrendCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get statisticsTrendCreated;

  /// No description provided for @statisticsTrendCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statisticsTrendCompleted;

  /// No description provided for @statisticsByList.
  ///
  /// In en, this message translates to:
  /// **'Statistics by List'**
  String get statisticsByList;

  /// No description provided for @statisticsByTag.
  ///
  /// In en, this message translates to:
  /// **'Statistics by Tag'**
  String get statisticsByTag;

  /// No description provided for @statisticsHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Productivity Heatmap (Last 30 Days)'**
  String get statisticsHeatmap;

  /// No description provided for @statisticsHeatmapTooltip.
  ///
  /// In en, this message translates to:
  /// **'{date}\n{count} tasks completed'**
  String statisticsHeatmapTooltip(String date, int count);

  /// No description provided for @statisticsCompletedTasks.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total}'**
  String statisticsCompletedTasks(Object completed, Object total);

  /// No description provided for @taskFormRecurrence.
  ///
  /// In en, this message translates to:
  /// **'Recurrence'**
  String get taskFormRecurrence;

  /// No description provided for @taskFormRecurrenceNone.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get taskFormRecurrenceNone;

  /// No description provided for @recurrenceDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get recurrenceDaily;

  /// No description provided for @recurrenceWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get recurrenceWeekly;

  /// No description provided for @recurrenceMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get recurrenceMonthly;

  /// No description provided for @recurrenceYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get recurrenceYearly;

  /// No description provided for @recurrenceCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get recurrenceCustom;

  /// No description provided for @recurrenceConfig.
  ///
  /// In en, this message translates to:
  /// **'Configure Recurrence'**
  String get recurrenceConfig;

  /// No description provided for @recurrenceInterval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get recurrenceInterval;

  /// No description provided for @recurrenceDaysOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Days of Week'**
  String get recurrenceDaysOfWeek;

  /// No description provided for @recurrenceSpecificDay.
  ///
  /// In en, this message translates to:
  /// **'Specific Day'**
  String get recurrenceSpecificDay;

  /// No description provided for @recurrenceNeverEnds.
  ///
  /// In en, this message translates to:
  /// **'Never ends'**
  String get recurrenceNeverEnds;

  /// No description provided for @recurrenceEndAfterCount.
  ///
  /// In en, this message translates to:
  /// **'End after occurrences'**
  String get recurrenceEndAfterCount;

  /// No description provided for @recurrenceEndOnDate.
  ///
  /// In en, this message translates to:
  /// **'End on date'**
  String get recurrenceEndOnDate;

  /// No description provided for @recurrenceOccurrences.
  ///
  /// In en, this message translates to:
  /// **'Occurrences'**
  String get recurrenceOccurrences;

  /// No description provided for @recurrenceEveryNDays.
  ///
  /// In en, this message translates to:
  /// **'Every {interval} days'**
  String recurrenceEveryNDays(int interval);

  /// No description provided for @recurrenceEveryNWeeks.
  ///
  /// In en, this message translates to:
  /// **'Every {interval} weeks'**
  String recurrenceEveryNWeeks(int interval);

  /// No description provided for @recurrenceEveryNMonths.
  ///
  /// In en, this message translates to:
  /// **'Every {interval} months'**
  String recurrenceEveryNMonths(int interval);

  /// No description provided for @recurrenceEveryNYears.
  ///
  /// In en, this message translates to:
  /// **'Every {interval} years'**
  String recurrenceEveryNYears(int interval);

  /// No description provided for @recurrenceDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of month'**
  String recurrenceDayOfMonth(int day);

  /// No description provided for @recurrenceUntil.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String recurrenceUntil(DateTime date);

  /// No description provided for @recurrenceCount.
  ///
  /// In en, this message translates to:
  /// **'{count} times'**
  String recurrenceCount(int count);

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @weekdayMondayShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMondayShort;

  /// No description provided for @weekdayTuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTuesdayShort;

  /// No description provided for @weekdayWednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWednesdayShort;

  /// No description provided for @weekdayThursdayShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThursdayShort;

  /// No description provided for @weekdayFridayShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFridayShort;

  /// No description provided for @weekdaySaturdayShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySaturdayShort;

  /// No description provided for @weekdaySundayShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySundayShort;

  /// No description provided for @taskFormAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get taskFormAttachments;

  /// No description provided for @taskDetailAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get taskDetailAttachments;

  /// No description provided for @homeQuickIdeaTitle.
  ///
  /// In en, this message translates to:
  /// **'Capture idea'**
  String get homeQuickIdeaTitle;

  /// No description provided for @homeQuickIdeaHint.
  ///
  /// In en, this message translates to:
  /// **'Write down your idea...'**
  String get homeQuickIdeaHint;

  /// No description provided for @homeQuickIdeaSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get homeQuickIdeaSave;

  /// No description provided for @homeQuickIdeaDefaultTag.
  ///
  /// In en, this message translates to:
  /// **'#idea'**
  String get homeQuickIdeaDefaultTag;

  /// No description provided for @homeBatchCompleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Marked {count} tasks as done'**
  String homeBatchCompleteSuccess(int count);

  /// No description provided for @homeBatchUncompleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reopened {count} tasks'**
  String homeBatchUncompleteSuccess(int count);

  /// No description provided for @homeBatchActionFailure.
  ///
  /// In en, this message translates to:
  /// **'Action failed: {error}'**
  String homeBatchActionFailure(String error);

  /// No description provided for @homeBatchDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete tasks?'**
  String get homeBatchDeleteTitle;

  /// No description provided for @homeBatchDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} tasks? This cannot be undone.'**
  String homeBatchDeleteMessage(int count);

  /// No description provided for @homeBatchDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deleted {count} tasks'**
  String homeBatchDeleteSuccess(int count);

  /// No description provided for @homeBatchMoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Move to list'**
  String get homeBatchMoveTitle;

  /// No description provided for @homeBatchMoveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Moved {count} tasks'**
  String homeBatchMoveSuccess(int count);

  /// No description provided for @homeBatchTagSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tagged {count} tasks'**
  String homeBatchTagSuccess(int count);

  /// No description provided for @smartReminderButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Smart reminders'**
  String get smartReminderButtonLabel;

  /// No description provided for @smartReminderButtonWithCount.
  ///
  /// In en, this message translates to:
  /// **'Smart reminders ({count})'**
  String smartReminderButtonWithCount(int count);

  /// No description provided for @smartReminderSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart reminders'**
  String get smartReminderSheetTitle;

  /// No description provided for @smartReminderSheetDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get smartReminderSheetDone;

  /// No description provided for @smartReminderEveryMinutes.
  ///
  /// In en, this message translates to:
  /// **'Every {minutes} min, {count}×'**
  String smartReminderEveryMinutes(int minutes, int count);

  /// No description provided for @smartReminderAddTime.
  ///
  /// In en, this message translates to:
  /// **'Add time reminder'**
  String get smartReminderAddTime;

  /// No description provided for @smartReminderAddRepeating.
  ///
  /// In en, this message translates to:
  /// **'Add repeating reminder'**
  String get smartReminderAddRepeating;

  /// No description provided for @smartReminderToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get smartReminderToday;

  /// No description provided for @smartReminderTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get smartReminderTomorrow;

  /// No description provided for @smartReminderAt.
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String smartReminderAt(String date, String time);

  /// No description provided for @smartReminderRepeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Repeat configuration'**
  String get smartReminderRepeatTitle;

  /// No description provided for @smartReminderRepeatInterval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get smartReminderRepeatInterval;

  /// No description provided for @smartReminderRepeatEvery.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get smartReminderRepeatEvery;

  /// No description provided for @smartReminderRepeatMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get smartReminderRepeatMinutes;

  /// No description provided for @smartReminderRepeatHours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get smartReminderRepeatHours;

  /// No description provided for @smartReminderRepeatTimes.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get smartReminderRepeatTimes;

  /// No description provided for @smartReminderTimes.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get smartReminderTimes;

  /// No description provided for @smartReminderRepeatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get smartReminderRepeatConfirm;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
