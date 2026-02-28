import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart' show HttpResponse;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../constants/api_endpoints.dart';
import '../../error/error_mapper.dart';
import '../../error/exceptions.dart';
import '../../logging/app_logger.dart';
import '../api_client.dart';
import '../interceptors/auth_token_interceptor.dart';
import '../interceptors/network_error_interceptor.dart';
import '../interceptors/retry_interceptor.dart';

part 'network_providers.g.dart';

abstract final class NetworkProviderConst {
  NetworkProviderConst._();

  static const String apiUrlEnvKey = 'API_URL';
  static const String legacyBaseUrlEnvKey = 'API_BASE_URL';
  static const int connectTimeoutMs = 15000;
  static const int sendTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
}

/// Provides secure storage instance for credential access.
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

/// Provides auth token interceptor that injects bearer token per request.
@Riverpod(keepAlive: true)
AuthTokenInterceptor authTokenInterceptor(Ref ref) {
  final FlutterSecureStorage storage = ref.watch(secureStorageProvider);
  return AuthTokenInterceptor(storage: storage);
}

/// Provides interceptor that normalizes network errors.
@Riverpod(keepAlive: true)
NetworkErrorInterceptor networkErrorInterceptor(Ref ref) {
  return NetworkErrorInterceptor();
}

/// Provides Dio log interceptor for debug builds.
@Riverpod(keepAlive: true)
PrettyDioLogger prettyDioLogger(Ref ref) {
  return PrettyDioLogger(
    requestBody: kDebugMode,
    responseBody: kDebugMode,
    requestHeader: kDebugMode,
    responseHeader: false,
    compact: true,
    maxWidth: 80,
  );
}

/// Provides base Dio options for API calls.
@Riverpod(keepAlive: true)
BaseOptions dioBaseOptions(Ref ref) {
  return BaseOptions(
    baseUrl: _resolveBaseUrl(),
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
    connectTimeout: const Duration(
      milliseconds: NetworkProviderConst.connectTimeoutMs,
    ),
    sendTimeout: const Duration(
      milliseconds: NetworkProviderConst.sendTimeoutMs,
    ),
    receiveTimeout: const Duration(
      milliseconds: NetworkProviderConst.receiveTimeoutMs,
    ),
  );
}

/// Provides shared Dio instance with configured interceptors.
@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  final BaseOptions options = ref.watch(dioBaseOptionsProvider);
  final Logger appLogger = ref.watch(appLoggerProvider);
  final Dio dio = Dio(options);

  dio.interceptors.add(ref.watch(authTokenInterceptorProvider));
  dio.interceptors.add(RetryInterceptor(dio: dio));
  dio.interceptors.add(ref.watch(networkErrorInterceptorProvider));
  if (kDebugMode) {
    dio.interceptors.add(ref.watch(prettyDioLoggerProvider));
  }
  appLogger.i('Dio configured for base URL: ${options.baseUrl}');

  return dio;
}

/// Provides Retrofit API client backed by [Dio].
@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final Dio dio = ref.watch(dioClientProvider);
  return ApiClient(dio);
}

/// Demonstrates centralized error handling using AsyncValue.guard.
@Riverpod(keepAlive: false)
Future<Map<String, dynamic>> networkHealth(Ref ref) async {
  final Logger appLogger = ref.watch(appLoggerProvider);
  final AsyncValue<Map<String, dynamic>> result =
      await AsyncValue.guard<Map<String, dynamic>>(() async {
        final ApiClient client = ref.watch(apiClientProvider);
        final HttpResponse<dynamic> response = await client.getHealth();
        final dynamic data = response.data;
        if (data is Map<String, dynamic>) {
          return data;
        }
        return <String, dynamic>{};
      });

  if (result case AsyncData<Map<String, dynamic>>(:final value)) {
    return value;
  }
  if (result case AsyncError<Map<String, dynamic>>(
    :final error,
    :final stackTrace,
  )) {
    final failure = error.toFailure();
    appLogger.e(
      'Network health request failed.',
      error: failure,
      stackTrace: stackTrace,
    );
    throw failure;
  }

  throw const UnknownException(
    message: 'Unexpected async state while fetching network health.',
  );
}

String _resolveBaseUrl() {
  final String apiUrl = dotenv.env[NetworkProviderConst.apiUrlEnvKey] ?? '';
  if (apiUrl.isNotEmpty) {
    return _normalizeBaseUrlForPlatform(apiUrl);
  }
  final String legacyApiUrl =
      dotenv.env[NetworkProviderConst.legacyBaseUrlEnvKey] ?? '';
  if (legacyApiUrl.isNotEmpty) {
    return _normalizeBaseUrlForPlatform(legacyApiUrl);
  }
  return _normalizeBaseUrlForPlatform(ApiEndpoints.baseUrl);
}

String _normalizeBaseUrlForPlatform(String baseUrl) {
  if (kIsWeb) {
    return baseUrl;
  }
  if (defaultTargetPlatform != TargetPlatform.android) {
    return baseUrl;
  }
  final String normalizedLocalhost = baseUrl.replaceFirst(
    '://localhost',
    '://10.0.2.2',
  );
  return normalizedLocalhost.replaceFirst('://127.0.0.1', '://10.0.2.2');
}
