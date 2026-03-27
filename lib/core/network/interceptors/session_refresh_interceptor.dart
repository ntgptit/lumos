import 'package:dio/dio.dart';
import 'package:lumos/core/network/interceptors/auth_interceptor.dart';
import 'package:lumos/core/network/interceptors/retry_interceptor.dart';
import 'package:lumos/core/services/auth_session_service.dart';
import 'package:lumos/core/storage/secure_storage.dart';
import 'package:lumos/core/storage/storage_keys.dart';

abstract final class SessionRefreshInterceptorConst {
  static const bypassRefreshKey =
      SessionRefreshInterceptor.skipSessionRefreshKey;
}

class SessionRefreshInterceptor extends QueuedInterceptor {
  SessionRefreshInterceptor({
    required Dio dio,
    required SecureStorage secureStorage,
    required AuthSessionService authSessionService,
  }) : _dio = dio,
       _secureStorage = secureStorage,
       _authSessionService = authSessionService;

  static const skipSessionRefreshKey = 'skipSessionRefresh';
  static const retriedWithFreshTokenKey = 'retriedWithFreshToken';
  static const _loginPath = '/api/v1/auth/login';
  static const _registerPath = '/api/v1/auth/register';
  static const _refreshPath = '/api/v1/auth/refresh';
  static const _logoutPath = '/api/v1/auth/logout';

  final Dio _dio;
  final SecureStorage _secureStorage;
  final AuthSessionService _authSessionService;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    if (!_shouldHandleUnauthorized(err, requestOptions)) {
      handler.next(err);
      return;
    }

    final latestAccessToken = await _readToken(StorageKeys.authToken);
    final requestAccessToken = _extractBearerToken(
      requestOptions.headers['Authorization'],
    );

    if (_hasNewerAccessToken(latestAccessToken, requestAccessToken)) {
      try {
        final response = await _retryRequest(
          requestOptions,
          latestAccessToken!,
        );
        handler.resolve(response);
        return;
      } on DioException catch (retryError) {
        handler.next(retryError);
        return;
      }
    }

    final refreshToken = await _readToken(StorageKeys.refreshToken);
    if (refreshToken == null) {
      await _expireSession();
      handler.next(err);
      return;
    }

    try {
      final refreshedTokens = await _refreshTokens(refreshToken);
      await _persistTokens(refreshedTokens);
      final response = await _retryRequest(
        requestOptions,
        refreshedTokens.accessToken,
      );
      handler.resolve(response);
    } on DioException catch (refreshError) {
      await _expireSession();
      handler.next(refreshError);
    } catch (_) {
      await _expireSession();
      handler.next(err);
    }
  }

  bool _shouldHandleUnauthorized(
    DioException err,
    RequestOptions requestOptions,
  ) {
    if (err.response?.statusCode != 401) {
      return false;
    }

    if (requestOptions.cancelToken?.isCancelled == true) {
      return false;
    }

    if (requestOptions.extra[skipSessionRefreshKey] == true) {
      return false;
    }

    if (requestOptions.extra[retriedWithFreshTokenKey] == true) {
      return false;
    }

    return !_isSkippedAuthEndpoint(requestOptions.path);
  }

  bool _isSkippedAuthEndpoint(String path) {
    return path.endsWith(_loginPath) ||
        path.endsWith(_registerPath) ||
        path.endsWith(_refreshPath) ||
        path.endsWith(_logoutPath);
  }

  bool _hasNewerAccessToken(String? latestToken, String? requestToken) {
    if (latestToken == null || latestToken.isEmpty) {
      return false;
    }

    if (requestToken == null || requestToken.isEmpty) {
      return false;
    }

    return latestToken != requestToken;
  }

  Future<String?> _readToken(String key) async {
    final value = await _secureStorage.read(key);
    final normalizedValue = value?.trim();
    if (normalizedValue == null || normalizedValue.isEmpty) {
      return null;
    }
    return normalizedValue;
  }

  String? _extractBearerToken(Object? rawAuthorizationHeader) {
    if (rawAuthorizationHeader is! String) {
      return null;
    }

    const prefix = 'Bearer ';
    if (!rawAuthorizationHeader.startsWith(prefix)) {
      return null;
    }

    final token = rawAuthorizationHeader.substring(prefix.length).trim();
    if (token.isEmpty) {
      return null;
    }
    return token;
  }

  Future<_RefreshedTokens> _refreshTokens(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _refreshPath,
      data: <String, String>{'refreshToken': refreshToken},
      options: Options(
        extra: <String, Object?>{
          AuthInterceptor.skipAuthKey: true,
          RetryInterceptor.skipRetryKey: true,
          skipSessionRefreshKey: true,
        },
      ),
    );

    final data = response.data ?? const <String, dynamic>{};
    final accessToken = _normalizeTokenValue(data['accessToken']);
    final nextRefreshToken = _normalizeTokenValue(data['refreshToken']);
    if (accessToken == null || nextRefreshToken == null) {
      throw DioException.badResponse(
        statusCode: response.statusCode ?? 401,
        requestOptions: response.requestOptions,
        response: response,
      );
    }

    return _RefreshedTokens(
      accessToken: accessToken,
      refreshToken: nextRefreshToken,
    );
  }

  String? _normalizeTokenValue(Object? rawValue) {
    if (rawValue is! String) {
      return null;
    }

    final normalizedValue = rawValue.trim();
    if (normalizedValue.isEmpty) {
      return null;
    }
    return normalizedValue;
  }

  Future<void> _persistTokens(_RefreshedTokens tokens) async {
    await _secureStorage.write(StorageKeys.authToken, tokens.accessToken);
    await _secureStorage.write(StorageKeys.refreshToken, tokens.refreshToken);
  }

  Future<Response<Object?>> _retryRequest(
    RequestOptions requestOptions,
    String accessToken,
  ) {
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    headers['Authorization'] = 'Bearer $accessToken';

    final extra = Map<String, dynamic>.from(requestOptions.extra);
    extra[retriedWithFreshTokenKey] = true;

    return _dio.fetch<Object?>(
      requestOptions.copyWith(headers: headers, extra: extra),
    );
  }

  Future<void> _expireSession() async {
    await _secureStorage.clear(
      keys: <String>{StorageKeys.authToken, StorageKeys.refreshToken},
    );
    _authSessionService.notifyExpired();
  }
}

class _RefreshedTokens {
  const _RefreshedTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;
}
