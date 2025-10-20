import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/logging/app_logger.dart';

class AppProviderObserver extends ProviderObserver {
  AppProviderObserver({required this.logger});

  final AppLogger logger;

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    super.didAddProvider(provider, value, container);
    final identifier = provider.name ?? provider.runtimeType.toString();
    logger.info('Provider added', identifier);
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    super.didUpdateProvider(provider, previousValue, newValue, container);
    final identifier = provider.name ?? provider.runtimeType.toString();
    logger.info('Provider updated', identifier);
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    super.didDisposeProvider(provider, container);
    final identifier = provider.name ?? provider.runtimeType.toString();
    logger.info('Provider disposed', identifier);
  }
}
