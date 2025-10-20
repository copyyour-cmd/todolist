import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/theme_config.dart';
import 'package:todolist/src/features/theme/application/theme_service.dart';

final themeServiceProvider = Provider<ThemeService>((ref) {
  return ThemeService();
});

final themeConfigProvider = StateProvider<ThemeConfig>((ref) {
  final service = ref.watch(themeServiceProvider);
  return service.getThemeConfig();
});
