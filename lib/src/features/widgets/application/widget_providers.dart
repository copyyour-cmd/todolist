import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/features/widgets/application/widget_service.dart';

final widgetServiceProvider = Provider<WidgetService>((ref) {
  return WidgetService(
    clock: ref.watch(clockProvider),
  );
});
