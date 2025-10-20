import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/shop_item.dart';
import 'package:todolist/src/features/gamification/application/gamification_providers.dart';
import 'package:todolist/src/features/shop/application/shop_providers.dart';
import 'package:todolist/src/features/shop/application/shop_service.dart';

/// 虚拟商店页面
class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  static const routePath = '/shop';
  static const routeName = 'shop';

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(userStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🛒'),
            SizedBox(width: 8),
            Text('积分商城'),
          ],
        ),
        actions: [
          // 显示当前积分
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: statsAsync.when(
              data: (stats) => _PointsBadge(points: stats?.totalPoints ?? 0),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Icon(Icons.error),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: '全部'),
            Tab(text: '🌈 主题'),
            Tab(text: '🎨 图标'),
            Tab(text: '🎵 音效'),
            Tab(text: '✨ 特殊'),
            Tab(text: '⚡ 道具'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AllItemsTab(),
          _CategoryTab(category: ShopItemCategory.theme),
          _CategoryTab(category: ShopItemCategory.icon),
          _CategoryTab(category: ShopItemCategory.sound),
          _CategoryTab(category: ShopItemCategory.special),
          _CategoryTab(category: ShopItemCategory.powerUp),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLuckyDrawDialog(context),
        icon: const Text('🎰'),
        label: const Text('每日抽奖'),
      ),
    );
  }

  void _showLuckyDrawDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const _LuckyDrawDialog(),
    );
  }
}

class _PointsBadge extends StatelessWidget {
  const _PointsBadge({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            '$points',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AllItemsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(availableItemsProvider);

    return itemsAsync.when(
      data: (items) => items.isEmpty
          ? const Center(child: Text('暂无商品'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => _ItemCard(item: items[index]),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('加载失败: $error')),
    );
  }
}

class _CategoryTab extends ConsumerWidget {
  const _CategoryTab({required this.category});

  final ShopItemCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(availableItemsProvider);

    return itemsAsync.when(
      data: (allItems) {
        final items = allItems.where((item) => item.category == category).toList();
        return items.isEmpty
            ? const Center(child: Text('该分类暂无商品'))
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) => _ItemCard(item: items[index]),
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('加载失败: $error')),
    );
  }
}

class _ItemCard extends ConsumerWidget {
  const _ItemCard({required this.item});

  final ShopItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final rarityColor = Color(int.parse(item.rarityColorHex.substring(1), radix: 16) + 0xFF000000);

    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => _showPurchaseDialog(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 商品图标和限时标签
              Stack(
                children: [
                  Text(item.icon, style: const TextStyle(fontSize: 48)),
                  if (item.isLimited)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '限时',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
              // 商品名称
              Text(
                item.name,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // 稀有度
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: rarityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.rarityName,
                  style: TextStyle(
                    color: rarityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // 价格
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${item.price}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(item.icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(child: Text(item.name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('价格: '),
                const Icon(Icons.stars, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${item.price}',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _purchaseItem(context, ref);
            },
            child: const Text('购买'),
          ),
        ],
      ),
    );
  }

  Future<void> _purchaseItem(BuildContext context, WidgetRef ref) async {
    final service = ref.read(shopServiceProvider);
    final result = await service.purchaseItem(item.id);

    if (!context.mounted) return;

    if (result.isSuccess) {
      ref.invalidate(availableItemsProvider);
      ref.invalidate(userStatsProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✨ 购买成功！剩余积分：${result.remainingPoints}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? '购买失败'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _LuckyDrawDialog extends ConsumerWidget {
  const _LuckyDrawDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canDrawAsync = ref.watch(canDrawTodayProvider);

    return AlertDialog(
      title: const Row(
        children: [
          Text('🎰'),
          SizedBox(width: 8),
          Text('每日免费抽奖'),
        ],
      ),
      content: canDrawAsync.when(
        data: (canDraw) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('每天可以进行一次免费抽奖！'),
            const SizedBox(height: 8),
            if (!canDraw) const Text('今天已经抽过奖了，明天再来吧！', style: TextStyle(color: Colors.orange)),
          ],
        ),
        loading: () => const CircularProgressIndicator(),
        error: (_, __) => const Text('加载失败'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
        canDrawAsync.when(
          data: (canDraw) => ElevatedButton(
            onPressed: canDraw ? () async {
              Navigator.pop(context);
              await _performDraw(context, ref);
            } : null,
            child: const Text('抽奖'),
          ),
          loading: () => const ElevatedButton(onPressed: null, child: Text('...')),
          error: (_, __) => const ElevatedButton(onPressed: null, child: Text('错误')),
        ),
      ],
    );
  }

  Future<void> _performDraw(BuildContext context, WidgetRef ref) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 1)); // 模拟抽奖动画

    final service = ref.read(shopServiceProvider);
    final result = await service.performLuckyDraw();

    if (!context.mounted) return;
    Navigator.pop(context); // 关闭loading

    if (result.isSuccess && result.item != null) {
      ref.invalidate(availableItemsProvider);
      ref.invalidate(userInventoryProvider);

      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('🎉 恭喜！'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(result.item!.icon, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                result.item!.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(result.item!.description),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('太好了！'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? '抽奖失败'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
