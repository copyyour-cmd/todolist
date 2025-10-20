import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/app/router.dart';
import 'package:todolist/src/core/logging/app_logger.dart';

/// Global navigation service for handling deep links and notifications
class NavigationService {
  NavigationService({
    required AppLogger logger,
    required ProviderContainer container,
  })  : _logger = logger,
        _container = container;

  final AppLogger _logger;
  final ProviderContainer _container;

  /// Navigate to task detail page from notification payload
  void navigateToTask(String taskId) {
    _logger.info('Navigating to task', {'taskId': taskId});

    try {
      // Get router from provider
      final router = _container.read(routerProvider);
      router.push('/tasks/$taskId');
      _logger.info('Navigation successful', {'path': '/tasks/$taskId'});
    } catch (e, stackTrace) {
      _logger.error('Navigation failed', e, stackTrace);
    }
  }

  /// Handle notification tap
  void handleNotificationTap(String? payload) {
    _logger.info('Handling notification tap', {'payload': payload});

    if (payload == null || payload.isEmpty) {
      _logger.warning('No payload provided');
      return;
    }

    // Payload is the task ID
    navigateToTask(payload);
  }
}
