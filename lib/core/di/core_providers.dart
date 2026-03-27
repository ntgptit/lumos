import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lumos/core/config/app_keys.dart';
import 'package:lumos/core/config/env_config.dart';
import 'package:lumos/core/network/api_client.dart';
import 'package:lumos/core/network/network_info.dart';
import 'package:lumos/core/network/interceptors/auth_interceptor.dart';
import 'package:lumos/core/network/interceptors/connectivity_interceptor.dart';
import 'package:lumos/core/network/interceptors/logging_interceptor.dart';
import 'package:lumos/core/network/interceptors/retry_interceptor.dart';
import 'package:lumos/core/network/interceptors/session_refresh_interceptor.dart';
import 'package:lumos/core/services/auth_session_service.dart';
import 'package:lumos/core/storage/cache_manager.dart';
import 'package:lumos/core/storage/preferences_storage.dart';
import 'package:lumos/core/storage/secure_storage.dart';
import 'package:lumos/core/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
GlobalKey<NavigatorState> rootNavigatorKey(Ref ref) {
  return GlobalKey<NavigatorState>(debugLabel: AppKeys.rootNavigatorKeyLabel);
}

@Riverpod(keepAlive: true)
GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey(Ref ref) {
  return GlobalKey<ScaffoldMessengerState>(
    debugLabel: AppKeys.rootScaffoldMessengerKeyLabel,
  );
}

@Riverpod(keepAlive: true)
EnvConfig envConfig(Ref ref) {
  return EnvConfig.fromEnvironment();
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final envConfig = ref.watch(envConfigProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final authSessionService = ref.watch(authSessionServiceProvider);

  return ApiClient(
    baseUrl: envConfig.baseUrl,
    enableLogs: envConfig.enableNetworkLogs,
    interceptorFactories: <DioInterceptorFactory>[
      (_) => ConnectivityInterceptor(networkInfo),
      (_) => AuthInterceptor(
        tokenReader: () => secureStorage.read(StorageKeys.authToken),
      ),
      (dio) => SessionRefreshInterceptor(
        dio: dio,
        secureStorage: secureStorage,
        authSessionService: authSessionService,
      ),
      (dio) => RetryInterceptor(dio: dio),
      (_) => LoggingInterceptor(enabled: envConfig.enableNetworkLogs),
    ],
  );
}

@Riverpod(keepAlive: true)
NetworkInfo networkInfo(Ref ref) {
  return ConnectivityNetworkInfo(Connectivity());
}

@Riverpod(keepAlive: true)
PreferencesStorage preferencesStorage(Ref ref) {
  return PreferencesStorage(allowList: StorageKeys.all);
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) {
  return SecureStorage();
}

@Riverpod(keepAlive: true)
AuthSessionService authSessionService(Ref ref) {
  final service = AuthSessionService();
  ref.onDispose(service.dispose);
  return service;
}

@Riverpod(keepAlive: true)
CacheManager cacheManager(Ref ref) {
  return CacheManager();
}
