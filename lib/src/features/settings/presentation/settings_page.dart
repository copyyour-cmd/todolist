import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todolist/l10n/app_localizations.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/app/theme/app_theme.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/app_settings.dart';
import 'package:todolist/src/features/calendar/presentation/calendar_page.dart';
import 'package:todolist/src/features/cloud/application/cloud_auth_provider.dart';
import 'package:todolist/src/features/cloud/presentation/cloud_sync_page.dart';
import 'package:todolist/src/features/cloud/presentation/login_page.dart';
import 'package:todolist/src/features/export/presentation/export_page.dart';
import 'package:todolist/src/features/focus/presentation/focus_mode_page.dart';
import 'package:todolist/src/features/lists/presentation/list_management_page.dart';
import 'package:todolist/src/features/settings/application/app_settings_provider.dart';
import 'package:todolist/src/features/settings/application/app_settings_service.dart';
import 'package:todolist/src/features/statistics/presentation/statistics_page.dart';
import 'package:todolist/src/features/tags/presentation/tag_management_page.dart';
import 'package:todolist/src/features/widgets/presentation/widget_config_page.dart';
import 'package:todolist/src/features/widgets/presentation/widget_settings_page.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';
import 'package:todolist/src/infrastructure/seed/demo_data_seeder.dart';
import 'package:todolist/src/features/attachments/application/attachment_providers.dart';
import 'package:todolist/src/features/settings/presentation/widgets/attachment_cleanup_dialog.dart';
import 'package:todolist/src/features/settings/presentation/widgets/settings_widgets.dart';
import 'package:todolist/src/features/reminders/domain/reminder_mode.dart';
import 'package:todolist/src/features/reminders/application/reminder_preferences_service.dart';
import 'package:todolist/src/features/reminders/presentation/reminder_mode_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const routePath = '/settings';
  static const routeName = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settingsAsync = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: settingsAsync.when(
        data: (settings) {
          final service = ref.read(appSettingsServiceProvider);
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              SettingsSection(
                title: l10n.settingsAppearanceSection,
                icon: Icons.palette_outlined,
                children: [
                  SettingsTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: l10n.settingsTheme,
                    subtitle: _themeModeLabel(settings.themeMode, l10n),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showThemePicker(context, ref, settings.themeMode),
                  ),
                  SettingsNavigationTile(
                    leading: const Icon(Icons.color_lens_outlined),
                    title: '主题颜色',
                    subtitle: '选择预设主题或自定义颜色',
                    onTap: () => context.push('/settings/theme'),
                  ),
                  // 自动切换主题
                  SettingsSwitchTile(
                    leading: const Icon(Icons.brightness_auto),
                    title: '自动切换主题',
                    subtitle: '根据时间自动切换日间/夜间主题',
                    value: settings.autoSwitchTheme,
                    onChanged: service.updateAutoSwitchTheme,
                  ),
                  if (settings.autoSwitchTheme) ...[
                    SettingsNavigationTile(
                      leading: const SizedBox(width: 40),
                      title: '日间主题时段',
                      subtitle: '${settings.dayThemeStartHour}:00 - ${settings.nightThemeStartHour}:00',
                      onTap: () => _showTimeRangePicker(context, ref, settings),
                    ),
                    SettingsNavigationTile(
                      leading: const SizedBox(width: 40),
                      title: '日间主题',
                      subtitle: AppTheme.getThemeName(
                        settings.dayThemeColor ?? AppThemeColor.bahamaBlue,
                      ),
                      onTap: () => _showDayThemeColorPicker(context, ref, settings),
                    ),
                    SettingsNavigationTile(
                      leading: const SizedBox(width: 40),
                      title: '夜间主题',
                      subtitle: AppTheme.getThemeName(
                        settings.nightThemeColor ?? AppThemeColor.deepBlue,
                      ),
                      onTap: () => _showNightThemeColorPicker(context, ref, settings),
                    ),
                  ],
                  // 导入/导出主题
                  SettingsTile(
                    leading: const Icon(Icons.file_download_outlined),
                    title: '导入主题配置',
                    subtitle: '从JSON文件导入主题设置',
                    onTap: () => _importThemeConfig(context, ref),
                  ),
                  SettingsTile(
                    leading: const Icon(Icons.file_upload_outlined),
                    title: '导出主题配置',
                    subtitle: '将当前主题设置保存为JSON文件',
                    onTap: () => _exportThemeConfig(context, settings),
                  ),
                  SettingsTile(
                    leading: const Icon(Icons.language_outlined),
                    title: l10n.settingsLanguage,
                    subtitle: _languageLabel(settings.languageCode, l10n),
                    onTap: () => _showLanguagePicker(context, ref, settings.languageCode),
                  ),
                ],
              ),
              SettingsSection(
                title: '背景设置',
                icon: Icons.wallpaper,
                children: [
                  SettingsTile(
                    leading: const Icon(Icons.wallpaper),
                    title: '首页背景图片',
                    subtitle: settings.homeBackgroundImagePath != null ? '已设置' : '未设置',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (settings.homeBackgroundImagePath != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => service.updateHomeBackgroundImage(null),
                            tooltip: '清除背景',
                          ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () => _pickBackgroundImage(context, ref, true),
                  ),
                  SettingsTile(
                    leading: const Icon(Icons.image_outlined),
                    title: '专注模式背景图片',
                    subtitle: settings.focusBackgroundImagePath != null ? '已设置' : '未设置',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (settings.focusBackgroundImagePath != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => service.updateFocusBackgroundImage(null),
                            tooltip: '清除背景',
                          ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () => _pickBackgroundImage(context, ref, false),
                  ),
                  SettingsSliderTile(
                    leading: const Icon(Icons.blur_on),
                    title: '背景模糊程度',
                    value: settings.backgroundBlurAmount,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    onChanged: service.updateBackgroundBlurAmount,
                    valueFormatter: (v) => '${(v * 100).toInt()}%',
                  ),
                  SettingsSliderTile(
                    leading: const Icon(Icons.brightness_6),
                    title: '背景暗化程度',
                    value: settings.backgroundDarkenAmount,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    onChanged: service.updateBackgroundDarkenAmount,
                    valueFormatter: (v) => '${(v * 100).toInt()}%',
                  ),
                ],
              ),
              _SectionHeader(title: l10n.settingsNotificationsSection),
              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: Text(l10n.settingsEnableNotifications),
                subtitle: Text(l10n.settingsEnableNotificationsSubtitle),
                value: settings.enableNotifications,
                onChanged: service.updateNotificationsEnabled,
              ),
              ListTile(
                leading: const Icon(Icons.bug_report_outlined),
                title: const Text('通知功能测试'),
                subtitle: const Text('诊断和测试通知是否正常工作'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/settings/notification-test'),
              ),
              ListTile(
                leading: const Icon(Icons.shield_outlined),
                title: const Text('提醒保护'),
                subtitle: const Text('防止应用被系统杀死,确保提醒正常工作'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/settings/reminder-protection'),
              ),
              ListTile(
                leading: const Icon(Icons.notification_important_outlined),
                title: const Text('默认提醒方式'),
                subtitle: Text(_getReminderModeSubtitle(ref)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showDefaultReminderModePicker(context, ref),
              ),
              const Divider(),
              _SectionHeader(title: l10n.settingsSecuritySection),
              SwitchListTile(
                secondary: const Icon(Icons.lock_outlined),
                title: Text(l10n.settingsRequirePassword),
                subtitle: Text(l10n.settingsRequirePasswordSubtitle),
                value: settings.requirePassword,
                onChanged: (value) async {
                  if (value) {
                    final password = await _promptForPassword(
                      context,
                      l10n,
                      title: l10n.settingsSetPasswordTitle,
                    );
                    if (password != null) {
                      await service.enablePassword(password);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.settingsPasswordEnabled)),
                        );
                      }
                    }
                  } else {
                    final confirmed = await _confirmDisable(context, l10n);
                    if (confirmed ?? false) {
                      await service.disablePassword();
                      // 同时禁用指纹识别和人脸识别
                      await service.updateFingerprintAuthEnabled(false);
                      await service.updateFaceAuthEnabled(false);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.settingsPasswordDisabled),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
              if (settings.requirePassword)
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint),
                  title: const Text('启用指纹识别'),
                  subtitle: const Text('使用指纹快速解锁应用'),
                  value: settings.enableFingerprintAuth,
                  onChanged: (value) async {
                        if (value) {
                          // 检查设备是否支持指纹识别
                          try {
                            final localAuth = LocalAuthentication();
                            final canCheckBiometrics =
                                await localAuth.canCheckBiometrics;
                            final isDeviceSupported =
                                await localAuth.isDeviceSupported();

                            if (!canCheckBiometrics && !isDeviceSupported) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('您的设备不支持指纹识别'),
                                  ),
                                );
                              }
                              return;
                            }

                            // 测试指纹识别
                            final authenticated =
                                await localAuth.authenticate(
                              localizedReason: '请验证指纹以启用指纹解锁',
                              options: const AuthenticationOptions(
                                stickyAuth: true,
                                biometricOnly: true,
                              ),
                              authMessages: const <AuthMessages>[
                                AndroidAuthMessages(
                                  signInTitle: '验证指纹',
                                  cancelButton: '取消',
                                  biometricHint: '',
                                  biometricNotRecognized: '指纹未识别，请重试',
                                  biometricSuccess: '验证成功',
                                ),
                              ],
                            );

                            if (authenticated) {
                              await service.updateFingerprintAuthEnabled(true);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('指纹识别已启用'),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('启用失败: $e'),
                                ),
                              );
                            }
                          }
                        } else {
                          await service.updateFingerprintAuthEnabled(false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('指纹识别已禁用'),
                              ),
                            );
                          }
                        }
                      },
                ),
              if (settings.requirePassword)
                SwitchListTile(
                  secondary: const Icon(Icons.face),
                  title: const Text('启用人脸识别'),
                  subtitle: const Text('使用人脸快速解锁应用'),
                  value: settings.enableFaceAuth,
                  onChanged: (value) async {
                        if (value) {
                          // 检查设备是否支持人脸识别
                          try {
                            final localAuth = LocalAuthentication();
                            final canCheckBiometrics =
                                await localAuth.canCheckBiometrics;
                            final isDeviceSupported =
                                await localAuth.isDeviceSupported();

                            if (!canCheckBiometrics && !isDeviceSupported) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('您的设备不支持人脸识别'),
                                  ),
                                );
                              }
                              return;
                            }

                            // 测试人脸识别
                            final authenticated =
                                await localAuth.authenticate(
                              localizedReason: '请验证人脸以启用人脸解锁',
                              options: const AuthenticationOptions(
                                stickyAuth: true,
                                biometricOnly: true,
                              ),
                              authMessages: const <AuthMessages>[
                                AndroidAuthMessages(
                                  signInTitle: '验证人脸',
                                  cancelButton: '取消',
                                  biometricHint: '',
                                  biometricNotRecognized: '人脸未识别，请重试',
                                  biometricSuccess: '验证成功',
                                ),
                              ],
                            );

                            if (authenticated) {
                              await service.updateFaceAuthEnabled(true);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('人脸识别已启用'),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('启用失败: $e'),
                                ),
                              );
                            }
                          }
                        } else {
                          await service.updateFaceAuthEnabled(false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('人脸识别已禁用'),
                              ),
                            );
                          }
                        }
                      },
                ),
              if (settings.requirePassword)
                ListTile(
                  leading: const Icon(Icons.lock_reset),
                  title: Text(l10n.settingsChangePassword),
                  onTap: () async {
                    final password = await _promptForPassword(
                      context,
                      l10n,
                      title: l10n.settingsChangePassword,
                    );
                    if (password != null) {
                      await service.changePassword(password);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.settingsPasswordChanged)),
                        );
                      }
                    }
                  },
                ),
              const Divider(),
              const _SectionHeader(title: 'AI功能'),
              ListTile(
                leading: const Icon(Icons.auto_awesome, color: Colors.amber),
                title: const Text('AI设置'),
                subtitle: const Text('配置AI增强功能(摘要/标签/问答)'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/settings/ai'),
              ),
              const Divider(),
              const _SectionHeader(title: '✨ 动画效果'),
              ListTile(
                leading: const Icon(Icons.celebration, color: Colors.purple),
                title: const Text('动画设置'),
                subtitle: const Text('配置任务完成动画、连击奖励等特效'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/settings/animations'),
              ),
              const Divider(),
              const _SectionHeader(title: '🎮 游戏化系统'),
              ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.amber),
                title: const Text('游戏化中心'),
                subtitle: const Text('签到、抽奖、徽章、成就、挑战、称号'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/gamification'),
              ),
              const Divider(),
              _SectionHeader(title: l10n.settingsContentSection),
              ListTile(
                leading: const Icon(Icons.list_alt_outlined),
                title: Text(l10n.settingsManageLists),
                subtitle: Text(l10n.settingsManageListsSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(ListManagementPage.routePath),
              ),
              ListTile(
                leading: const Icon(Icons.label_outlined),
                title: Text(l10n.settingsManageTags),
                subtitle: Text(l10n.settingsManageTagsSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(TagManagementPage.routePath),
              ),
              ListTile(
                leading: const Icon(Icons.analytics_outlined),
                title: Text(l10n.settingsStatistics),
                subtitle: Text(l10n.settingsStatisticsSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(StatisticsPage.routePath),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: Text(l10n.settingsCalendar),
                subtitle: Text(l10n.settingsCalendarSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(CalendarPage.routePath),
              ),
              ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: Text(l10n.settingsFocus),
                subtitle: Text(l10n.settingsFocusSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(FocusModePage.routePath),
              ),
              ListTile(
                leading: const Icon(Icons.insights_outlined),
                title: const Text('专注分析'),
                subtitle: const Text('查看专注时段热力图和生产力分析'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/focus/heatmap'),
              ),
              ListTile(
                leading: const Icon(Icons.compare_arrows_outlined),
                title: const Text('时间预估分析'),
                subtitle: const Text('对比预估时间与实际时间,提升预估能力'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/focus/time-estimation'),
              ),
              const Divider(),
              const _SectionHeader(title: '任务模板'),
              ListTile(
                leading: const Icon(Icons.library_books_outlined),
                title: const Text('浏览模板'),
                subtitle: const Text('使用预设模板快速创建任务'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/templates'),
              ),
              const Divider(),
              const _SectionHeader(title: '小部件设置'),
              ListTile(
                leading: const Icon(Icons.widgets_outlined),
                title: const Text('小部件管理'),
                subtitle: const Text('管理主屏幕小部件'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(WidgetSettingsPage.routePath),
              ),
              ListTile(
                leading: const Icon(Icons.tune_outlined),
                title: const Text('小部件配置'),
                subtitle: const Text('自定义小部件外观和行为'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(WidgetConfigPage.routePath),
              ),
              const Divider(),
              const _SectionHeader(title: '☁️ 云服务'),
              _CloudSyncSection(),
              const Divider(),
              _SectionHeader(title: l10n.settingsDataSection),
              ListTile(
                leading: const Icon(Icons.backup_rounded),
                title: const Text('备份与还原'),
                subtitle: const Text('备份或还原笔记和任务数据'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/settings/backup'),
              ),
              ListTile(
                leading: const Icon(Icons.download_outlined),
                title: Text(l10n.settingsImportData),
                subtitle: Text(l10n.settingsImportDataSubtitle),
                onTap: () => _showComingSoon(context, l10n),
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: const Text('导出为PDF'),
                subtitle: const Text('按时间周期导出任务报告'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(ExportPage.routePath),
              ),
              ListTile(
                leading: const Icon(Icons.upload_outlined),
                title: Text(l10n.settingsExportData),
                subtitle: Text(l10n.settingsExportDataSubtitle),
                onTap: () => _showComingSoon(context, l10n),
              ),
              ListTile(
                leading: const Icon(Icons.refresh_outlined),
                title: Text(l10n.settingsLoadDemoData),
                subtitle: Text(l10n.settingsLoadDemoDataSubtitle),
                onTap: () => _loadDemoData(context, ref, l10n),
              ),
              // 附件清理功能
              ListTile(
                leading: const Icon(Icons.cleaning_services_outlined),
                title: const Text('清理孤立附件'),
                subtitle: const Text('扫描并删除未被使用的图片、录音和文件'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showAttachmentCleanup(context, ref),
              ),
              SettingsDangerTile(
                title: l10n.settingsClearAllData,
                subtitle: l10n.settingsClearAllDataSubtitle,
                icon: Icons.delete_forever,
                onTap: () => _clearAllData(context, ref, l10n),
              ),
              const Divider(),
              _SectionHeader(title: l10n.settingsAboutSection),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.settingsVersion),
                subtitle: const Text('0.1.0+1'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.settingsLoadError('$error')),
          ),
        ),
      ),
    );
  }

  void _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    AppThemeMode current,
  ) {
    final l10n = context.l10n;
    final service = ref.read(appSettingsServiceProvider);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((mode) {
            return RadioListTile<AppThemeMode>(
              title: Text(_themeModeLabel(mode, l10n)),
              value: mode,
              groupValue: current,
              onChanged: (value) {
                if (value != null) {
                  service.updateThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    WidgetRef ref,
    String? current,
  ) {
    final l10n = context.l10n;
    final service = ref.read(appSettingsServiceProvider);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String?>(
              title: Text(l10n.settingsLanguageSystem),
              value: null,
              groupValue: current,
              onChanged: (value) {
                service.updateLanguage(value);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String?>(
              title: const Text('English'),
              value: 'en',
              groupValue: current,
              onChanged: (value) {
                service.updateLanguage(value);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String?>(
              title: const Text('中文'),
              value: 'zh',
              groupValue: current,
              onChanged: (value) {
                service.updateLanguage(value);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.settingsComingSoon)));
  }

  Future<void> _loadDemoData(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsLoadDemoData),
        content: Text(l10n.settingsLoadDemoDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final taskRepository = ref.read(taskRepositoryProvider);
      final taskListRepository = ref.read(taskListRepositoryProvider);
      final tagRepository = ref.read(tagRepositoryProvider);
      final idGenerator = IdGenerator();

      final seeder = DemoDataSeeder(
        taskRepository: taskRepository,
        taskListRepository: taskListRepository,
        tagRepository: tagRepository,
        idGenerator: idGenerator,
        isEnabled: true,
      );

      await seeder.seedIfEmpty();

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.settingsDemoDataLoaded)));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.settingsError}: $error')),
        );
      }
    }
  }

  Future<void> _clearAllData(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsClearAllData),
        content: Text(l10n.settingsClearAllDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final taskRepository = ref.read(taskRepositoryProvider);
      final taskListRepository = ref.read(taskListRepositoryProvider);
      final tagRepository = ref.read(tagRepositoryProvider);

      await taskRepository.clear();
      await taskListRepository.clear();
      await tagRepository.clear();

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.settingsDataCleared)));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.settingsError}: $error')),
        );
      }
    }
  }

  String _themeModeLabel(AppThemeMode mode, AppLocalizations l10n) {
    return switch (mode) {
      AppThemeMode.system => l10n.settingsThemeSystem,
      AppThemeMode.light => l10n.settingsThemeLight,
      AppThemeMode.dark => l10n.settingsThemeDark,
    };
  }

  String _languageLabel(String? code, AppLocalizations l10n) {
    if (code == null) return l10n.settingsLanguageSystem;
    return switch (code) {
      'en' => 'English',
      'zh' => '中文',
      _ => l10n.settingsLanguageSystem,
    };
  }

  Future<String?> _promptForPassword(
    BuildContext context,
    AppLocalizations l10n, {
    required String title,
  }) async {
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    String? errorText;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.settingsPasswordField,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.settingsPasswordRequired;
                        }
                        if (value.length < 4) {
                          return l10n.settingsPasswordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: confirmController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.settingsPasswordConfirmField,
                      ),
                      validator: (value) {
                        if (value != passwordController.text) {
                          return l10n.settingsPasswordMismatch;
                        }
                        return null;
                      },
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.commonCancel),
                ),
                FilledButton(
                  onPressed: () {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) {
                      return;
                    }
                    final value = passwordController.text.trim();
                    if (value.isEmpty) {
                      setState(() {
                        errorText = l10n.settingsPasswordRequired;
                      });
                      return;
                    }
                    Navigator.of(context).pop(value);
                  },
                  child: Text(l10n.commonConfirm),
                ),
              ],
            );
          },
        );
      },
    );

    passwordController.dispose();
    confirmController.dispose();
    return result;
  }

  Future<bool?> _confirmDisable(BuildContext context, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.settingsDisablePasswordTitle),
          content: Text(l10n.settingsDisablePasswordMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.commonConfirm),
            ),
          ],
        );
      },
    );
  }

  // 时间范围选择器
  void _showTimeRangePicker(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => _TimeRangePickerDialog(settings: settings),
    );
  }

  // 日间主题颜色选择
  void _showDayThemeColorPicker(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    final service = ref.read(appSettingsServiceProvider);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择日间主题'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppThemeColor.values.length - 1, // 排除custom
            itemBuilder: (context, index) {
              final color = AppThemeColor.values[index];
              if (color == AppThemeColor.custom) return const SizedBox.shrink();

              final isSelected = settings.dayThemeColor == color;
              return RadioListTile<AppThemeColor>(
                title: Text(AppTheme.getThemeName(color)),
                value: color,
                groupValue: settings.dayThemeColor,
                secondary: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.getPreviewColor(color),
                    shape: BoxShape.circle,
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    service.updateDayThemeColor(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  // 夜间主题颜色选择
  void _showNightThemeColorPicker(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    final service = ref.read(appSettingsServiceProvider);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择夜间主题'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppThemeColor.values.length - 1, // 排除custom
            itemBuilder: (context, index) {
              final color = AppThemeColor.values[index];
              if (color == AppThemeColor.custom) return const SizedBox.shrink();

              final isSelected = settings.nightThemeColor == color;
              return RadioListTile<AppThemeColor>(
                title: Text(AppTheme.getThemeName(color)),
                value: color,
                groupValue: settings.nightThemeColor,
                secondary: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.getPreviewColor(color),
                    shape: BoxShape.circle,
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    service.updateNightThemeColor(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  // 导出主题配置
  Future<void> _exportThemeConfig(
    BuildContext context,
    AppSettings settings,
  ) async {
    try {
      // 构建主题配置JSON
      final config = {
        'themeMode': settings.themeMode.name,
        'themeColor': settings.themeColor.name,
        'customPrimaryColor': settings.customPrimaryColor,
        'autoSwitchTheme': settings.autoSwitchTheme,
        'dayThemeStartHour': settings.dayThemeStartHour,
        'nightThemeStartHour': settings.nightThemeStartHour,
        'dayThemeColor': settings.dayThemeColor?.name,
        'nightThemeColor': settings.nightThemeColor?.name,
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(config);

      // 保存到文件
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/theme_config.json');
      await file.writeAsString(jsonString);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('主题配置已导出到: ${file.path}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出失败: $e')),
        );
      }
    }
  }

  // 导入主题配置
  Future<void> _importThemeConfig(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      // 读取文件
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/theme_config.json');

      if (!await file.exists()) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('未找到主题配置文件')),
          );
        }
        return;
      }

      final jsonString = await file.readAsString();
      final config = jsonDecode(jsonString) as Map<String, dynamic>;

      // 应用配置
      final service = ref.read(appSettingsServiceProvider);

      // 解析主题模式
      final themeModeStr = config['themeMode'] as String?;
      if (themeModeStr != null) {
        final themeMode = AppThemeMode.values.firstWhere(
          (e) => e.name == themeModeStr,
          orElse: () => AppThemeMode.system,
        );
        await service.updateThemeMode(themeMode);
      }

      // 解析主题颜色
      final themeColorStr = config['themeColor'] as String?;
      if (themeColorStr != null) {
        final themeColor = AppThemeColor.values.firstWhere(
          (e) => e.name == themeColorStr,
          orElse: () => AppThemeColor.bahamaBlue,
        );
        await service.updateThemeColor(themeColor);
      }

      // 解析自定义颜色
      final customColor = config['customPrimaryColor'] as int?;
      if (customColor != null) {
        await service.updateCustomPrimaryColor(customColor);
      }

      // 解析自动切换设置
      final autoSwitch = config['autoSwitchTheme'] as bool? ?? false;
      await service.updateAutoSwitchTheme(autoSwitch);

      if (autoSwitch) {
        final dayStart = config['dayThemeStartHour'] as int? ?? 6;
        final nightStart = config['nightThemeStartHour'] as int? ?? 18;
        await service.updateThemeTimeRange(dayStart, nightStart);

        final dayColorStr = config['dayThemeColor'] as String?;
        if (dayColorStr != null) {
          final dayColor = AppThemeColor.values.firstWhere(
            (e) => e.name == dayColorStr,
            orElse: () => AppThemeColor.bahamaBlue,
          );
          await service.updateDayThemeColor(dayColor);
        }

        final nightColorStr = config['nightThemeColor'] as String?;
        if (nightColorStr != null) {
          final nightColor = AppThemeColor.values.firstWhere(
            (e) => e.name == nightColorStr,
            orElse: () => AppThemeColor.deepBlue,
          );
          await service.updateNightThemeColor(nightColor);
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('主题配置已导入')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导入失败: $e')),
        );
      }
    }
  }

  // 选择背景图片
  Future<void> _pickBackgroundImage(
    BuildContext context,
    WidgetRef ref,
    bool isHome,
  ) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      // 复制图片到应用目录
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'bg_${isHome ? 'home' : 'focus'}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = File('${directory.path}/$fileName');
      await savedImage.writeAsBytes(await image.readAsBytes());

      // 更新设置
      final service = ref.read(appSettingsServiceProvider);
      if (isHome) {
        await service.updateHomeBackgroundImage(savedImage.path);
      } else {
        await service.updateFocusBackgroundImage(savedImage.path);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('背景图片已设置')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('设置失败: $e')),
        );
      }
    }
  }

  /// 获取提醒模式的显示文本
  String _getReminderModeSubtitle(WidgetRef ref) {
    final currentMode = ref.watch(defaultReminderModeProvider);
    return '${currentMode.icon} ${currentMode.displayName}';
  }

  /// 显示默认提醒模式选择器
  Future<void> _showDefaultReminderModePicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final currentMode = ref.read(defaultReminderModeProvider);
    final selectedMode = await showReminderModeDialog(
      context,
      currentMode: currentMode,
    );

    if (selectedMode != null && selectedMode != currentMode) {
      await ref.read(defaultReminderModeProvider.notifier).updateMode(selectedMode);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('默认提醒方式已设置为: ${selectedMode.displayName}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// 显示附件清理对话框
  Future<void> _showAttachmentCleanup(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // 先获取存储信息
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final cleanupService = ref.read(attachmentCleanupServiceProvider);
      final storageInfo = await cleanupService.getStorageInfo();

      if (!context.mounted) return;
      Navigator.of(context).pop(); // 关闭loading

      // 显示清理对话框
      await showDialog<void>(
        context: context,
        builder: (context) => AttachmentCleanupDialog(
          storageInfo: storageInfo,
          cleanupService: cleanupService,
        ),
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // 关闭loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('获取存储信息失败: $e')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CloudSyncSection extends ConsumerWidget {
  const _CloudSyncSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final isAuthenticated = authState.isAuthenticated;
    final user = authState.user;

    if (isAuthenticated && user != null) {
      // 已登录状态
      return Column(
        children: [
          ListTile(
            leading: const Icon(Icons.cloud_done, color: Colors.green),
            title: const Text('云同步已启用'),
            subtitle: Text('已登录: ${user.displayName}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(CloudSyncPage.routePath),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: const Text('退出登录'),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('退出登录'),
                  content: const Text('确定要退出云同步账户吗？本地数据将保留。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('退出'),
                    ),
                  ],
                ),
              );

              if (confirmed ?? false) {
                await ref.read(authStateProvider.notifier).logout();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已退出登录')),
                  );
                }
              }
            },
          ),
        ],
      );
    } else {
      // 未登录状态
      return ListTile(
        leading: const Icon(Icons.cloud_outlined),
        title: const Text('云同步登录'),
        subtitle: const Text('登录后可在多设备间同步数据'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(LoginPage.routePath),
      );
    }
  }
}

// 时间范围选择对话框
class _TimeRangePickerDialog extends ConsumerStatefulWidget {
  const _TimeRangePickerDialog({required this.settings});

  final AppSettings settings;

  @override
  ConsumerState<_TimeRangePickerDialog> createState() =>
      _TimeRangePickerDialogState();
}

class _TimeRangePickerDialogState
    extends ConsumerState<_TimeRangePickerDialog> {
  late int _dayStart;
  late int _nightStart;

  @override
  void initState() {
    super.initState();
    _dayStart = widget.settings.dayThemeStartHour;
    _nightStart = widget.settings.nightThemeStartHour;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('设置主题切换时间'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 日间开始时间
          Row(
            children: [
              const Icon(Icons.wb_sunny),
              const SizedBox(width: 16),
              const Text('日间开始时间'),
              const Spacer(),
              DropdownButton<int>(
                value: _dayStart,
                items: List.generate(24, (i) => i).map((hour) {
                  return DropdownMenuItem(
                    value: hour,
                    child: Text('$hour:00'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null && value != _nightStart) {
                    setState(() => _dayStart = value);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 夜间开始时间
          Row(
            children: [
              const Icon(Icons.nightlight_round),
              const SizedBox(width: 16),
              const Text('夜间开始时间'),
              const Spacer(),
              DropdownButton<int>(
                value: _nightStart,
                items: List.generate(24, (i) => i).map((hour) {
                  return DropdownMenuItem(
                    value: hour,
                    child: Text('$hour:00'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null && value != _dayStart) {
                    setState(() => _nightStart = value);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '日间时段: $_dayStart:00 - $_nightStart:00\n'
            '夜间时段: $_nightStart:00 - $_dayStart:00',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            ref
                .read(appSettingsServiceProvider)
                .updateThemeTimeRange(_dayStart, _nightStart);
            Navigator.of(context).pop();
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}

