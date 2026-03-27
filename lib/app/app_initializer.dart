import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:lumos/app/app_providers.dart';
import 'package:lumos/app/app_router.dart';
import 'package:lumos/core/di/core_providers.dart';
import 'package:lumos/core/di/service_providers.dart';
import 'package:lumos/core/utils/logger.dart';

abstract final class AppInitializer {
  static Future<ProviderContainer> ensureInitialized({
    List<Override> overrides = const <Override>[],
    List<ProviderObserver> observers = const <ProviderObserver>[],
  }) async {
    WidgetsFlutterBinding.ensureInitialized();

    final container = ProviderContainer(
      overrides: overrides,
      observers: observers,
    );

    _installErrorHandlers(container);
    await _warmUp(container);

    return container;
  }

  static void _installErrorHandlers(ProviderContainer container) {
    final crashlytics = container.read(crashlyticsServiceProvider);

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      unawaited(
        crashlytics.recordError(
          details.exception,
          details.stack ?? StackTrace.current,
          reason: details.context?.toDescription(),
        ),
      );
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      unawaited(
        crashlytics.recordError(
          error,
          stackTrace,
          reason: 'PlatformDispatcher',
        ),
      );
      return true;
    };
  }

  static Future<void> _warmUp(ProviderContainer container) async {
    final envConfig = container.read(envConfigProvider);
    Logger.info(
      'Bootstrapping ${envConfig.appName} (${envConfig.environmentLabel}) -> ${envConfig.baseUrl}',
    );

    await _guardedTask('preferences.initialize', () async {
      await container.read(preferencesStorageProvider).initialize();
    });

    container.read(themeTypeControllerProvider);
    container.read(appLocaleProvider);
    container.read(rootNavigatorKeyProvider);
    container.read(rootScaffoldMessengerKeyProvider);
    container.read(appRouterProvider);

    await Future.wait<void>([
      _guardedTask(
        'analytics.initialize',
        () => container.read(analyticsServiceProvider).initialize(),
      ),
      _guardedTask(
        'crashlytics.initialize',
        () => container.read(crashlyticsServiceProvider).initialize(),
      ),
      _guardedTask(
        'notification.initialize',
        () => container.read(notificationServiceProvider).initialize(),
      ),
      _guardedTask('connectivity.check', () async {
        await container.read(connectivityServiceProvider).isConnected;
      }),
    ]);
  }

  static Future<void> _guardedTask(
    String label,
    Future<void> Function() task,
  ) async {
    try {
      await task();
    } catch (error, stackTrace) {
      Logger.warning('Startup task failed: $label');
      Logger.error('Startup task error', error: error, stackTrace: stackTrace);
    }
  }
}
