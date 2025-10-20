import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Clock {
  DateTime now();

  DateTime today();

  Timer scheduleAt(DateTime moment, void Function() callback);
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();

  @override
  DateTime today() {
    final current = now();
    return DateTime(current.year, current.month, current.day);
  }

  @override
  Timer scheduleAt(DateTime moment, void Function() callback) {
    final duration = moment.difference(now());
    final effective = duration.isNegative ? Duration.zero : duration;
    return Timer(effective, callback);
  }
}

final clockProvider = Provider<Clock>((ref) {
  return const SystemClock();
});
