import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/domain/entities/app_settings.dart';
import 'package:todolist/src/domain/repositories/app_settings_repository.dart';
import 'package:todolist/src/infrastructure/hive/hive_boxes.dart';

class HiveAppSettingsRepository implements AppSettingsRepository {
  HiveAppSettingsRepository(this._box);

  final Box<AppSettings> _box;

  static Future<HiveAppSettingsRepository> create() async {
    final box = Hive.isBoxOpen(HiveBoxes.settings)
        ? Hive.box<AppSettings>(HiveBoxes.settings)
        : await Hive.openBox<AppSettings>(HiveBoxes.settings);
    if (box.isEmpty) {
      await box.put('settings', const AppSettings());
    }
    return HiveAppSettingsRepository(box);
  }

  @override
  Stream<AppSettings> watch() async* {
    yield _current();
    yield* _box.watch(key: 'settings').map((event) {
      return event.value as AppSettings? ?? _current();
    });
  }

  @override
  Future<AppSettings?> get() async => _box.get('settings');

  @override
  Future<void> save(AppSettings settings) async {
    await _box.put(
      'settings',
      settings.copyWith(updatedAt: DateTime.now()),
    );
  }

  AppSettings _current() =>
      _box.get('settings') ?? const AppSettings(updatedAt: null);
}
