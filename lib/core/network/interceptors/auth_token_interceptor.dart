import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/storage_keys.dart';

class AuthTokenInterceptorConst {
  const AuthTokenInterceptorConst._();

  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
}

/// Interceptor that injects bearer token from secure storage.
class AuthTokenInterceptor extends Interceptor {
  AuthTokenInterceptor({required FlutterSecureStorage storage})
    : _storage = storage;

  final FlutterSecureStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? accessToken = await _storage.read(
      key: StorageKeys.accessToken,
    );
    if (accessToken == null || accessToken.isEmpty) {
      handler.next(options);
      return;
    }

    options.headers[AuthTokenInterceptorConst.authorizationHeader] =
        '${AuthTokenInterceptorConst.bearerPrefix}$accessToken';
    handler.next(options);
  }
}
