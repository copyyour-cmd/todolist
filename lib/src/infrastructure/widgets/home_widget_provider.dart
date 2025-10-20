import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/infrastructure/widgets/home_widget_service.dart';

final homeWidgetServiceProvider = Provider<HomeWidgetService>((ref) {
  return HomeWidgetService();
});
