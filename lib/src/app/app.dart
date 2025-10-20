import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/l10n/app_localizations.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/app/router.dart';
import 'package:todolist/src/app/theme/app_theme.dart';
import 'package:todolist/src/domain/entities/app_settings.dart';
import 'package:todolist/src/features/settings/application/app_settings_provider.dart';
import 'package:todolist/src/features/theme/application/auto_theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settingsAsync = ref.watch(appSettingsProvider);
    final settings = settingsAsync.valueOrNull ?? const AppSettings();

    // 监听自动主题切换
    final autoThemeColorAsync = ref.watch(autoThemeColorProvider);
    final autoThemeModeAsync = ref.watch(autoThemeModeProvider);

    // 确定最终使用的主题颜色
    AppThemeColor effectiveThemeColor = settings.themeColor;
    if (settings.autoSwitchTheme) {
      final autoColor = autoThemeColorAsync.valueOrNull;
      if (autoColor != null) {
        effectiveThemeColor = autoColor;
      }
    }

    // 确定最终使用的主题模式
    ThemeMode effectiveThemeMode;
    if (settings.autoSwitchTheme) {
      final isDayTime = autoThemeModeAsync.valueOrNull;
      if (isDayTime != null) {
        effectiveThemeMode = isDayTime ? ThemeMode.light : ThemeMode.dark;
      } else {
        effectiveThemeMode = switch (settings.themeMode) {
          AppThemeMode.system => ThemeMode.system,
          AppThemeMode.light => ThemeMode.light,
          AppThemeMode.dark => ThemeMode.dark,
        };
      }
    } else {
      effectiveThemeMode = switch (settings.themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      };
    }

    final locale = settings.languageCode != null
        ? Locale(settings.languageCode!)
        : null;

    final customColor = settings.customPrimaryColor != null
        ? Color(settings.customPrimaryColor!)
        : null;

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: AppTheme.light(effectiveThemeColor, customColor),
      darkTheme: AppTheme.dark(effectiveThemeColor, customColor),
      themeMode: effectiveThemeMode,
      locale: locale,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
