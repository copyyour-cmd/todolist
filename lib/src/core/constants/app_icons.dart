import 'package:flutter/material.dart';

/// Extended icon library for lists and categories
class AppIcons {
  AppIcons._();

  /// Icon categories
  static const Map<String, List<IconData>> categories = {
    '工作': [
      Icons.work,
      Icons.business_center,
      Icons.laptop,
      Icons.computer,
      Icons.dashboard,
      Icons.analytics,
      Icons.attach_money,
      Icons.trending_up,
    ],
    '生活': [
      Icons.home,
      Icons.shopping_cart,
      Icons.local_grocery_store,
      Icons.restaurant,
      Icons.local_cafe,
      Icons.spa,
      Icons.fitness_center,
      Icons.self_improvement,
    ],
    '学习': [
      Icons.school,
      Icons.library_books,
      Icons.menu_book,
      Icons.quiz,
      Icons.science,
      Icons.calculate,
      Icons.language,
      Icons.psychology,
    ],
    '健康': [
      Icons.favorite,
      Icons.health_and_safety,
      Icons.medical_services,
      Icons.medication,
      Icons.monitor_heart,
      Icons.healing,
      Icons.water_drop,
      Icons.bedtime,
    ],
    '娱乐': [
      Icons.sports_esports,
      Icons.movie,
      Icons.music_note,
      Icons.theater_comedy,
      Icons.celebration,
      Icons.camera,
      Icons.palette,
      Icons.brush,
    ],
    '出行': [
      Icons.flight,
      Icons.directions_car,
      Icons.train,
      Icons.directions_bike,
      Icons.directions_walk,
      Icons.map,
      Icons.explore,
      Icons.place,
    ],
    '社交': [
      Icons.people,
      Icons.groups,
      Icons.forum,
      Icons.chat,
      Icons.phone,
      Icons.email,
      Icons.public,
      Icons.share,
    ],
    '财务': [
      Icons.account_balance,
      Icons.savings,
      Icons.credit_card,
      Icons.payment,
      Icons.receipt_long,
      Icons.currency_exchange,
      Icons.trending_down,
      Icons.pie_chart,
    ],
    '其他': [
      Icons.star,
      Icons.flag,
      Icons.bookmark,
      Icons.label,
      Icons.lightbulb,
      Icons.eco,
      Icons.pets,
      Icons.more_horiz,
    ],
  };

  /// All icons in a flat list
  static List<IconData> get allIcons {
    return categories.values.expand((icons) => icons).toList();
  }

  /// Get icon by name
  static IconData? getByName(String name) {
    final iconMap = {
      // 工作
      'work': Icons.work,
      'business_center': Icons.business_center,
      'laptop': Icons.laptop,
      'computer': Icons.computer,
      'dashboard': Icons.dashboard,
      'analytics': Icons.analytics,
      'attach_money': Icons.attach_money,
      'trending_up': Icons.trending_up,
      // 生活
      'home': Icons.home,
      'shopping_cart': Icons.shopping_cart,
      'local_grocery_store': Icons.local_grocery_store,
      'restaurant': Icons.restaurant,
      'local_cafe': Icons.local_cafe,
      'spa': Icons.spa,
      'fitness_center': Icons.fitness_center,
      'self_improvement': Icons.self_improvement,
      // 学习
      'school': Icons.school,
      'library_books': Icons.library_books,
      'menu_book': Icons.menu_book,
      'quiz': Icons.quiz,
      'science': Icons.science,
      'calculate': Icons.calculate,
      'language': Icons.language,
      'psychology': Icons.psychology,
      // 健康
      'favorite': Icons.favorite,
      'health_and_safety': Icons.health_and_safety,
      'medical_services': Icons.medical_services,
      'medication': Icons.medication,
      'monitor_heart': Icons.monitor_heart,
      'healing': Icons.healing,
      'water_drop': Icons.water_drop,
      'bedtime': Icons.bedtime,
      // 娱乐
      'sports_esports': Icons.sports_esports,
      'movie': Icons.movie,
      'music_note': Icons.music_note,
      'theater_comedy': Icons.theater_comedy,
      'celebration': Icons.celebration,
      'camera': Icons.camera,
      'palette': Icons.palette,
      'brush': Icons.brush,
      // 出行
      'flight': Icons.flight,
      'directions_car': Icons.directions_car,
      'train': Icons.train,
      'directions_bike': Icons.directions_bike,
      'directions_walk': Icons.directions_walk,
      'map': Icons.map,
      'explore': Icons.explore,
      'place': Icons.place,
      // 社交
      'people': Icons.people,
      'groups': Icons.groups,
      'forum': Icons.forum,
      'chat': Icons.chat,
      'phone': Icons.phone,
      'email': Icons.email,
      'public': Icons.public,
      'share': Icons.share,
      // 财务
      'account_balance': Icons.account_balance,
      'savings': Icons.savings,
      'credit_card': Icons.credit_card,
      'payment': Icons.payment,
      'receipt_long': Icons.receipt_long,
      'currency_exchange': Icons.currency_exchange,
      'trending_down': Icons.trending_down,
      'pie_chart': Icons.pie_chart,
      // 其他
      'star': Icons.star,
      'flag': Icons.flag,
      'bookmark': Icons.bookmark,
      'label': Icons.label,
      'lightbulb': Icons.lightbulb,
      'eco': Icons.eco,
      'pets': Icons.pets,
      'more_horiz': Icons.more_horiz,
    };

    return iconMap[name];
  }

  /// Get name from icon
  static String getName(IconData icon) {
    final iconMap = <IconData, String>{};

    for (final entry in categories.entries) {
      for (final iconData in entry.value) {
        // Use icon codePoint as key
        if (!iconMap.containsKey(iconData)) {
          iconMap[iconData] = iconData.toString();
        }
      }
    }

    return iconMap[icon] ?? 'unknown';
  }

  /// Popular icons for quick access
  static const List<IconData> popular = [
    Icons.work,
    Icons.home,
    Icons.school,
    Icons.shopping_cart,
    Icons.favorite,
    Icons.star,
    Icons.flight,
    Icons.people,
  ];
}
