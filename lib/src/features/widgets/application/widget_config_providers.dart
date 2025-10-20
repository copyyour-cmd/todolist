import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/widget_config.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

final widgetConfigProvider =
    StreamProvider<WidgetConfig>((ref) {
  final repository = ref.watch(widgetConfigRepositoryProvider);
  return repository.watchConfig();
});

class WidgetConfigNotifier extends Notifier<WidgetConfig> {
  @override
  WidgetConfig build() {
    return const WidgetConfig();
  }

  Future<void> updateConfig(WidgetConfig config) async {
    final repository = ref.read(widgetConfigRepositoryProvider);
    await repository.saveConfig(config);
    state = config;
  }

  Future<void> updateSize(WidgetSize size) async {
    await updateConfig(state.copyWith(size: size));
  }

  Future<void> updateTheme(WidgetTheme theme) async {
    await updateConfig(state.copyWith(theme: theme));
  }

  Future<void> updateMaxTasks(int maxTasks) async {
    await updateConfig(state.copyWith(maxTasks: maxTasks));
  }

  Future<void> toggleShowCompleted() async {
    await updateConfig(state.copyWith(showCompleted: !state.showCompleted));
  }

  Future<void> toggleShowOverdue() async {
    await updateConfig(state.copyWith(showOverdue: !state.showOverdue));
  }
}

final widgetConfigNotifierProvider =
    NotifierProvider<WidgetConfigNotifier, WidgetConfig>(
  WidgetConfigNotifier.new,
);
