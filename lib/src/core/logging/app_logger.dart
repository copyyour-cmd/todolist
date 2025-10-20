import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LogLevel {
  info,
  warning,
  error,
}

class AppLogger {
  const AppLogger();

  void info(String message, [Object? payload]) =>
      _log(LogLevel.info, message, payload: payload);

  void warning(String message, [Object? payload]) =>
      _log(LogLevel.warning, message, payload: payload);

  void error(String message, Object error, StackTrace stackTrace) =>
      _log(LogLevel.error, message, payload: error, stackTrace: stackTrace);

  void recordFlutterError(FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
    final stack = details.stack ?? StackTrace.current;
    error('Flutter error', details.exception, stack);
  }

  void _log(
    LogLevel level,
    String message, {
    Object? payload,
    StackTrace? stackTrace,
  }) {
    final tag = switch (level) {
      LogLevel.info => '[INFO]',
      LogLevel.warning => '[WARN]',
      LogLevel.error => '[ERROR]',
    };
    final formatted = payload != null ? '$message | $payload' : message;
    debugPrint('$tag $formatted');
    final logLevel = switch (level) {
      LogLevel.info => 500,
      LogLevel.warning => 700,
      LogLevel.error => 1000,
    };
    developer.log(
      formatted,
      name: 'TodoList',
      level: logLevel,
      error: level == LogLevel.error ? payload : null,
      stackTrace: stackTrace,
    );
  }
}

final appLoggerProvider = Provider<AppLogger>((ref) {
  return const AppLogger();
});
