import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/app_settings.dart';
import 'package:todolist/src/domain/repositories/app_settings_repository.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

final passwordUnlockedProvider = StateProvider<bool>((ref) => false);

class AppSettingsService {
  AppSettingsService(this._ref);

  final Ref _ref;

  AppSettingsRepository get _repository => _ref.read(appSettingsRepositoryProvider);

  Future<AppSettings> load() async {
    return await _repository.get() ?? const AppSettings();
  }

  Future<void> enablePassword(String password) async {
    final hashed = _hash(password);
    final current = await load();
    final updated = current.copyWith(
      requirePassword: true,
      passwordHash: hashed,
    );
    await _repository.save(updated);
    _ref.read(passwordUnlockedProvider.notifier).state = false;
  }

  Future<void> disablePassword() async {
    final current = await load();
    final updated = current.copyWith(
      requirePassword: false,
      passwordHash: '',
    );
    await _repository.save(updated);
    _ref.read(passwordUnlockedProvider.notifier).state = true;
  }

  Future<void> changePassword(String newPassword) async {
    final current = await load();
    if (!current.requirePassword) {
      await enablePassword(newPassword);
      return;
    }
    final updated = current.copyWith(passwordHash: _hash(newPassword));
    await _repository.save(updated);
    _ref.read(passwordUnlockedProvider.notifier).state = false;
  }

  Future<bool> verifyPassword(String password) async {
    final current = await load();
    if (!current.requirePassword || !current.hasPassword) {
      _ref.read(passwordUnlockedProvider.notifier).state = true;
      return true;
    }
    final hashed = _hash(password);
    final isValid = hashed == current.passwordHash;
    if (isValid) {
      _ref.read(passwordUnlockedProvider.notifier).state = true;
    }
    return isValid;
  }

  Future<void> updateThemeMode(AppThemeMode mode) async {
    final current = await load();
    final updated = current.copyWith(themeMode: mode);
    await _repository.save(updated);
  }

  Future<void> updateLanguage(String? languageCode) async {
    final current = await load();
    final updated = current.copyWith(languageCode: languageCode);
    await _repository.save(updated);
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    final current = await load();
    final updated = current.copyWith(enableNotifications: enabled);
    await _repository.save(updated);
  }

  Future<void> updateThemeColor(AppThemeColor themeColor) async {
    final current = await load();
    final updated = current.copyWith(
      themeColor: themeColor,
      customPrimaryColor: null,
    );
    await _repository.save(updated);
  }

  Future<void> updateCustomColor(Color color) async {
    final current = await load();
    final updated = current.copyWith(
      themeColor: AppThemeColor.custom,
      customPrimaryColor: color.value,
    );
    await _repository.save(updated);
  }

  Future<void> updateCustomPrimaryColor(int colorValue) async {
    final current = await load();
    final updated = current.copyWith(
      themeColor: AppThemeColor.custom,
      customPrimaryColor: colorValue,
    );
    await _repository.save(updated);
  }

  Future<void> updateAutoSwitchTheme(bool enabled) async {
    final current = await load();
    final updated = current.copyWith(autoSwitchTheme: enabled);
    await _repository.save(updated);
  }

  Future<void> updateThemeTimeRange(int dayStart, int nightStart) async {
    final current = await load();
    final updated = current.copyWith(
      dayThemeStartHour: dayStart,
      nightThemeStartHour: nightStart,
    );
    await _repository.save(updated);
  }

  Future<void> updateDayThemeColor(AppThemeColor color) async {
    final current = await load();
    final updated = current.copyWith(dayThemeColor: color);
    await _repository.save(updated);
  }

  Future<void> updateNightThemeColor(AppThemeColor color) async {
    final current = await load();
    final updated = current.copyWith(nightThemeColor: color);
    await _repository.save(updated);
  }

  Future<void> updateHomeBackgroundImage(String? imagePath) async {
    final current = await load();
    final updated = current.copyWith(homeBackgroundImagePath: imagePath);
    await _repository.save(updated);
  }

  Future<void> updateFocusBackgroundImage(String? imagePath) async {
    final current = await load();
    final updated = current.copyWith(focusBackgroundImagePath: imagePath);
    await _repository.save(updated);
  }

  Future<void> updateBackgroundBlurAmount(double amount) async {
    final current = await load();
    final updated = current.copyWith(backgroundBlurAmount: amount);
    await _repository.save(updated);
  }

  Future<void> updateBackgroundDarkenAmount(double amount) async {
    final current = await load();
    final updated = current.copyWith(backgroundDarkenAmount: amount);
    await _repository.save(updated);
  }

  Future<void> updateBiometricAuthEnabled(bool enabled) async {
    final current = await load();
    final updated = current.copyWith(enableBiometricAuth: enabled);
    await _repository.save(updated);
  }

  Future<void> updateFingerprintAuthEnabled(bool enabled) async {
    final current = await load();
    final updated = current.copyWith(enableFingerprintAuth: enabled);
    await _repository.save(updated);
  }

  Future<void> updateFaceAuthEnabled(bool enabled) async {
    final current = await load();
    final updated = current.copyWith(enableFaceAuth: enabled);
    await _repository.save(updated);
  }

  String _hash(String value) {
    return sha256.convert(utf8.encode(value)).toString();
  }
}

final appSettingsServiceProvider = Provider<AppSettingsService>((ref) {
  return AppSettingsService(ref);
});
