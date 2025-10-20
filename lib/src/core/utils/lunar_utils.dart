import 'package:lunar/lunar.dart';

/// 农历工具类
class LunarUtils {
  /// 将公历日期转换为农历信息
  static LunarInfo getLunarInfo(DateTime date) {
    final solar = Solar.fromDate(date);
    final lunar = solar.getLunar();

    return LunarInfo(
      yearInChinese: lunar.getYearInChinese(),
      monthInChinese: lunar.getMonthInChinese(),
      dayInChinese: lunar.getDayInChinese(),
      yearInGanZhi: lunar.getYearInGanZhi(),
      monthInGanZhi: lunar.getMonthInGanZhi(),
      dayInGanZhi: lunar.getDayInGanZhi(),
      festivals: _getFestivals(lunar),
      solarTerms: _getSolarTerms(solar, lunar),
      isLeapMonth: lunar.getMonth() < 0, // 负数表示闰月
    );
  }

  /// 获取农历节日
  static List<String> _getFestivals(Lunar lunar) {
    final festivals = <String>[];

    // 农历节日
    final lunarFestivals = lunar.getFestivals();
    if (lunarFestivals.isNotEmpty) {
      festivals.addAll(lunarFestivals);
    }

    // 农历其他节日
    final otherFestivals = lunar.getOtherFestivals();
    if (otherFestivals.isNotEmpty) {
      festivals.addAll(otherFestivals);
    }

    return festivals;
  }

  /// 获取节气
  static List<String> _getSolarTerms(Solar solar, Lunar lunar) {
    final terms = <String>[];

    // 获取当天的节气
    final jieQi = lunar.getJieQi();
    if (jieQi.isNotEmpty) {
      terms.add(jieQi);
    }

    return terms;
  }

  /// 简化的农历日期显示(只显示日期)
  static String getSimpleLunarDay(DateTime date) {
    final solar = Solar.fromDate(date);
    final lunar = solar.getLunar();

    // 如果是初一,显示月份
    if (lunar.getDay() == 1) {
      return lunar.getMonthInChinese();
    }

    return lunar.getDayInChinese();
  }

  /// 获取节日或节气(优先显示)
  static String? getFestivalOrTerm(DateTime date) {
    final solar = Solar.fromDate(date);
    final lunar = solar.getLunar();

    // 优先显示节气
    final jieQi = lunar.getJieQi();
    if (jieQi.isNotEmpty) {
      return jieQi;
    }

    // 其次显示农历节日
    final lunarFestivals = lunar.getFestivals();
    if (lunarFestivals.isNotEmpty) {
      return lunarFestivals.first;
    }

    // 显示其他节日(如农历十五等)
    final otherFestivals = lunar.getOtherFestivals();
    if (otherFestivals.isNotEmpty) {
      return otherFestivals.first;
    }

    // 显示公历节日(Solar类没有getFestival方法,暂不支持)
    // 可以手动添加公历节日判断
    if (date.month == 1 && date.day == 1) return '元旦';
    if (date.month == 5 && date.day == 1) return '劳动节';
    if (date.month == 10 && date.day == 1) return '国庆节';

    return null;
  }
}

/// 农历信息
class LunarInfo {
  LunarInfo({
    required this.yearInChinese,
    required this.monthInChinese,
    required this.dayInChinese,
    required this.yearInGanZhi,
    required this.monthInGanZhi,
    required this.dayInGanZhi,
    required this.festivals,
    required this.solarTerms,
    required this.isLeapMonth,
  });

  /// 农历年份(中文)
  final String yearInChinese;

  /// 农历月份(中文)
  final String monthInChinese;

  /// 农历日期(中文)
  final String dayInChinese;

  /// 年份(干支)
  final String yearInGanZhi;

  /// 月份(干支)
  final String monthInGanZhi;

  /// 日期(干支)
  final String dayInGanZhi;

  /// 节日列表
  final List<String> festivals;

  /// 节气列表
  final List<String> solarTerms;

  /// 是否闰月
  final bool isLeapMonth;

  /// 获取完整的农历日期字符串
  String get fullDate {
    final leapPrefix = isLeapMonth ? '闰' : '';
    return '$yearInChinese年$leapPrefix$monthInChinese$dayInChinese';
  }

  /// 获取简短的农历日期字符串
  String get shortDate {
    final leapPrefix = isLeapMonth ? '闰' : '';
    return '$leapPrefix$monthInChinese$dayInChinese';
  }
}
