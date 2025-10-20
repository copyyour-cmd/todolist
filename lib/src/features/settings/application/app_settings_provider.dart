import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/domain/entities/app_settings.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

part 'app_settings_provider.g.dart';

@riverpod
Stream<AppSettings> appSettings(AppSettingsRef ref) {
  return ref.watch(appSettingsRepositoryProvider).watch();
}
