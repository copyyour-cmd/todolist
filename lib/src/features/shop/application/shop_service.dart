import 'dart:math';

import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/shop_item.dart';
import 'package:todolist/src/domain/entities/user_stats.dart';
import 'package:todolist/src/domain/repositories/gamification_repository.dart';

/// 虚拟商店服务
///
/// 本小姐实现的功能：
/// - 商品浏览和购买
/// - 用户库存管理
/// - 每日免费抽奖
/// - 限时商品管理
class ShopService {
  ShopService({
    required GamificationRepository repository,
    required Clock clock,
    required IdGenerator idGenerator,
  })  : _repository = repository,
        _clock = clock,
        _idGenerator = idGenerator;

  final GamificationRepository _repository;
  final Clock _clock;
  final IdGenerator _idGenerator;

  /// 获取所有商品
  Future<List<ShopItem>> getAllItems() async {
    // TODO: 从repository获取
    // 暂时返回预设商品
    return _getPresetItems();
  }

  /// 获取可购买商品（未购买且可用）
  Future<List<ShopItem>> getAvailableItems() async {
    final allItems = await getAllItems();
    final inventory = await getUserInventory();

    return allItems.where((item) {
      if (!item.isAvailable) return false;
      if (inventory.ownedItemIds.contains(item.id)) return false;

      // 检查限时商品是否过期
      if (item.isLimited && item.limitedUntil != null) {
        return _clock.now().isBefore(item.limitedUntil!);
      }

      return true;
    }).toList();
  }

  /// 获取用户库存
  Future<UserInventory> getUserInventory() async {
    // TODO: 从repository获取
    // 暂时返回空库存
    return UserInventory(
      id: 'user_inventory',
      createdAt: _clock.now(),
      updatedAt: _clock.now(),
    );
  }

  /// 购买商品
  Future<PurchaseResult> purchaseItem(String itemId) async {
    final item = await _getItemById(itemId);
    if (item == null) {
      return const PurchaseResult.failure('商品不存在');
    }

    // 检查是否已购买
    final inventory = await getUserInventory();
    if (inventory.ownedItemIds.contains(itemId)) {
      return const PurchaseResult.failure('您已经拥有此商品');
    }

    // 检查积分是否足够
    final stats = await _repository.getUserStats();
    if (stats == null || stats.totalPoints < item.price) {
      return PurchaseResult.failure('积分不足，需要${item.price}积分');
    }

    // 扣除积分
    final updatedStats = stats.copyWith(
      totalPoints: stats.totalPoints - item.price,
      updatedAt: _clock.now(),
    );
    await _repository.saveUserStats(updatedStats);

    // 添加到库存
    final now = _clock.now();
    final updatedInventory = inventory.copyWith(
      ownedItemIds: [...inventory.ownedItemIds, itemId],
      updatedAt: now,
    );

    // 保存购买记录
    final record = PurchaseRecord(
      id: _idGenerator.generate(),
      itemId: itemId,
      itemName: item.name,
      pricePaid: item.price,
      purchasedAt: now,
    );

    // TODO: 保存到repository
    // await _repository.saveInventory(updatedInventory);
    // await _repository.savePurchaseRecord(record);

    return PurchaseResult.success(
      item: item,
      remainingPoints: updatedStats.totalPoints,
    );
  }

  /// 每日免费抽奖
  Future<LuckyDrawResult> performLuckyDraw() async {
    final inventory = await getUserInventory();
    final now = _clock.now();

    // 检查是否可以抽奖
    if (!inventory.canDrawToday(now)) {
      return const LuckyDrawResult.failure('今天已经抽过奖了，明天再来吧！');
    }

    // 获取可抽奖商品
    final availableItems = await getAvailableItems();
    if (availableItems.isEmpty) {
      return const LuckyDrawResult.failure('暂时没有可抽奖的商品');
    }

    // 根据稀有度权重随机抽取
    final wonItem = _randomDrawItem(availableItems);

    // 更新库存
    final updatedInventory = inventory.copyWith(
      ownedItemIds: [...inventory.ownedItemIds, wonItem.id],
      lastLuckyDrawAt: now,
      luckyDrawCount: inventory.luckyDrawCount + 1,
      updatedAt: now,
    );

    // 保存购买记录
    final record = PurchaseRecord(
      id: _idGenerator.generate(),
      itemId: wonItem.id,
      itemName: wonItem.name,
      pricePaid: 0,
      purchasedAt: now,
      isFromLuckyDraw: true,
    );

    // TODO: 保存到repository
    // await _repository.saveInventory(updatedInventory);
    // await _repository.savePurchaseRecord(record);

    return LuckyDrawResult.success(
      item: wonItem,
      isFirstDraw: inventory.luckyDrawCount == 0,
    );
  }

  /// 根据稀有度权重随机抽取商品
  ShopItem _randomDrawItem(List<ShopItem> items) {
    final random = Random();

    // 稀有度权重：普通40%，稀有30%，史诗20%，传说10%
    final weights = <double>[];
    for (final item in items) {
      switch (item.rarity) {
        case ShopItemRarity.common:
          weights.add(40.0);
          break;
        case ShopItemRarity.rare:
          weights.add(30.0);
          break;
        case ShopItemRarity.epic:
          weights.add(20.0);
          break;
        case ShopItemRarity.legendary:
          weights.add(10.0);
          break;
      }
    }

    final totalWeight = weights.fold<double>(0, (sum, w) => sum + w);
    final randomValue = random.nextDouble() * totalWeight;

    var currentWeight = 0.0;
    for (var i = 0; i < items.length; i++) {
      currentWeight += weights[i];
      if (randomValue <= currentWeight) {
        return items[i];
      }
    }

    return items.first;
  }

  /// 获取商品详情
  Future<ShopItem?> _getItemById(String id) async {
    final items = await getAllItems();
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 获取预设商品
  List<ShopItem> _getPresetItems() {
    final now = _clock.now();
    final limitedUntil = now.add(const Duration(days: 7));

    return [
      // 主题类
      ShopItem(
        id: 'theme_dark_purple',
        name: '暗夜紫罗兰',
        description: '神秘优雅的紫色主题',
        icon: '🌙',
        category: ShopItemCategory.theme,
        price: 500,
        rarity: ShopItemRarity.rare,
        createdAt: now,
        itemData: {
          'primaryColor': '#9370DB',
          'secondaryColor': '#8B7BB8',
        },
      ),
      ShopItem(
        id: 'theme_sakura',
        name: '樱花粉',
        description: '浪漫温柔的粉色主题',
        icon: '🌸',
        category: ShopItemCategory.theme,
        price: 800,
        rarity: ShopItemRarity.epic,
        createdAt: now,
        itemData: {
          'primaryColor': '#FFB7C5',
          'secondaryColor': '#FFC0CB',
        },
      ),
      ShopItem(
        id: 'theme_galaxy',
        name: '星河',
        description: '梦幻星空渐变主题',
        icon: '✨',
        category: ShopItemCategory.theme,
        price: 1500,
        rarity: ShopItemRarity.legendary,
        isLimited: true,
        limitedUntil: limitedUntil,
        createdAt: now,
        itemData: {
          'gradientColors': ['#667eea', '#764ba2', '#f093fb'],
        },
      ),

      // 图标类
      ShopItem(
        id: 'icon_pack_cute',
        name: '可爱图标包',
        description: '萌萌哒卡通风格图标',
        icon: '🎀',
        category: ShopItemCategory.icon,
        price: 300,
        rarity: ShopItemRarity.common,
        createdAt: now,
      ),
      ShopItem(
        id: 'icon_pack_minimal',
        name: '极简图标包',
        description: '简约现代风格图标',
        icon: '⭕',
        category: ShopItemCategory.icon,
        price: 600,
        rarity: ShopItemRarity.rare,
        createdAt: now,
      ),

      // 音效类
      ShopItem(
        id: 'sound_pack_nature',
        name: '大自然音效包',
        description: '包含鸟鸣、流水等自然音效',
        icon: '🌿',
        category: ShopItemCategory.sound,
        price: 400,
        rarity: ShopItemRarity.rare,
        createdAt: now,
      ),
      ShopItem(
        id: 'sound_pack_zen',
        name: '禅意音效包',
        description: '宁静祥和的冥想音效',
        icon: '🎵',
        category: ShopItemCategory.sound,
        price: 700,
        rarity: ShopItemRarity.epic,
        createdAt: now,
      ),

      // 特殊装饰
      ShopItem(
        id: 'special_crown',
        name: '黄金皇冠',
        description: '专属尊贵标识',
        icon: '👑',
        category: ShopItemCategory.special,
        price: 2000,
        rarity: ShopItemRarity.legendary,
        createdAt: now,
      ),
      ShopItem(
        id: 'special_halo',
        name: '天使光环',
        description: '圣洁的装饰效果',
        icon: '😇',
        category: ShopItemCategory.special,
        price: 1000,
        rarity: ShopItemRarity.epic,
        createdAt: now,
      ),

      // 能量道具
      ShopItem(
        id: 'powerup_double_points',
        name: '双倍积分卡',
        description: '使用后24小时内获得双倍积分',
        icon: '⚡',
        category: ShopItemCategory.powerUp,
        price: 500,
        rarity: ShopItemRarity.rare,
        createdAt: now,
        itemData: {
          'duration': 24,
          'multiplier': 2.0,
        },
      ),
      ShopItem(
        id: 'powerup_lucky_boost',
        name: '幸运加成',
        description: '提升抽奖获得稀有物品概率',
        icon: '🍀',
        category: ShopItemCategory.powerUp,
        price: 800,
        rarity: ShopItemRarity.epic,
        createdAt: now,
        itemData: {
          'boostPercentage': 50,
        },
      ),
    ];
  }

  /// 初始化商店（创建预设商品）
  Future<void> initializeShop() async {
    // TODO: 保存预设商品到repository
    final items = _getPresetItems();
    // for (final item in items) {
    //   await _repository.saveShopItem(item);
    // }
  }
}

/// 购买结果
class PurchaseResult {
  const PurchaseResult.success({
    required this.item,
    required this.remainingPoints,
  })  : isSuccess = true,
        errorMessage = null;

  const PurchaseResult.failure(this.errorMessage)
      : isSuccess = false,
        item = null,
        remainingPoints = 0;

  final bool isSuccess;
  final ShopItem? item;
  final int remainingPoints;
  final String? errorMessage;
}

/// 抽奖结果
class LuckyDrawResult {
  const LuckyDrawResult.success({
    required this.item,
    required this.isFirstDraw,
  })  : isSuccess = true,
        errorMessage = null;

  const LuckyDrawResult.failure(this.errorMessage)
      : isSuccess = false,
        item = null,
        isFirstDraw = false;

  final bool isSuccess;
  final ShopItem? item;
  final bool isFirstDraw;
  final String? errorMessage;
}
