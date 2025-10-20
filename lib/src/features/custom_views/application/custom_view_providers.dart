import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/custom_view.dart';
import 'package:todolist/src/features/custom_views/application/custom_view_service.dart';

final customViewServiceProvider = Provider<CustomViewService>((ref) {
  return CustomViewService(
    clock: ref.watch(clockProvider),
    idGenerator: ref.watch(idGeneratorProvider),
  );
});

final allCustomViewsProvider = StreamProvider<List<CustomView>>((ref) {
  final service = ref.watch(customViewServiceProvider);
  return Stream.periodic(const Duration(milliseconds: 500), (_) async {
    return service.getAllViews();
  }).asyncMap((event) => event);
});

final favoriteViewsProvider = StreamProvider<List<CustomView>>((ref) {
  final service = ref.watch(customViewServiceProvider);
  return Stream.periodic(const Duration(milliseconds: 500), (_) async {
    return service.getFavoriteViews();
  }).asyncMap((event) => event);
});
