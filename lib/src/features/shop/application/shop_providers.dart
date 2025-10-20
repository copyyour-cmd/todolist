import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/shop_item.dart';
import 'package:todolist/src/features/gamification/application/gamification_providers.dart';
import 'package:todolist/src/features/shop/application/shop_service.dart';

/// 商店服务Provider
final shopServiceProvider = Provider<ShopService>((ref) {
  return ShopService(
    repository: ref.watch(gamificationRepositoryProvider),
    clock: ref.watch(clockProvider),
    idGenerator: ref.watch(idGeneratorProvider),
  );
});

/// 所有商品Provider
final allShopItemsProvider = FutureProvider<List<ShopItem>>((ref) async {
  final service = ref.watch(shopServiceProvider);
  return service.getAllItems();
});

/// 可购买商品Provider
final availableItemsProvider = FutureProvider<List<ShopItem>>((ref) async {
  final service = ref.watch(shopServiceProvider);
  return service.getAvailableItems();
});

/// 按类别分组的商品Provider
final itemsByCategoryProvider = FutureProvider<Map<ShopItemCategory, List<ShopItem>>>((ref) async {
  final items = await ref.watch(availableItemsProvider.future);

  final grouped = <ShopItemCategory, List<ShopItem>>{};
  for (final item in items) {
    grouped.putIfAbsent(item.category, () => []).add(item);
  }

  return grouped;
});

/// 用户库存Provider
final userInventoryProvider = FutureProvider<UserInventory>((ref) async {
  final service = ref.watch(shopServiceProvider);
  return service.getUserInventory();
});

/// 是否可以抽奖Provider
final canDrawTodayProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(shopServiceProvider);
  final inventory = await service.getUserInventory();
  final clock = ref.watch(clockProvider);
  return inventory.canDrawToday(clock.now());
});
