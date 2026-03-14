import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/storage_keys.dart';
import 'auth_token_interceptor.dart';
import 'retry_interceptor.dart';

abstract final class SessionRefreshInterceptorConst {
  SessionRefreshInterceptorConst._();

  static const String refreshPath = '/api/v1/auth/refresh';
  static const String bypassRefreshKey = 'bypass_token_refresh';
  static const String refreshTokenField = 'refreshToken';
  static const String accessTokenField = 'accessToken';
  static const String userField = 'user';
  static const String userIdField = 'id';
}

enum SessionRefreshFailureReason { invalidSession, retryable }

class SessionRefreshResult {
  const SessionRefreshResult._({
    required this.accessToken,
    required this.failureReason,
    this.error,
  });

  const SessionRefreshResult.refreshed(String accessToken)
    : this._(accessToken: accessToken, failureReason: null);

  const SessionRefreshResult.failure({
    required SessionRefreshFailureReason failureReason,
    DioException? error,
  }) : this._(accessToken: null, failureReason: failureReason, error: error);

  final String? accessToken;
  final SessionRefreshFailureReason? failureReason;
  final DioException? error;

  bool get refreshed => (accessToken ?? '').isNotEmpty;
  bool get shouldClearSession =>
      failureReason == SessionRefreshFailureReason.invalidSession;
}

/// Interceptor that refreshes expired access tokens and retries the request once.
class SessionRefreshInterceptor extends Interceptor {
  SessionRefreshInterceptor({
    required FlutterSecureStorage storage,
    required Dio refreshDio,
    this.onSessionInvalidated,
  }) : _storage = storage,
       _refreshDio = refreshDio;

  final FlutterSecureStorage _storage;
  final Dio _refreshDio;
  final FutureOr<void> Function()? onSessionInvalidated;

  Completer<SessionRefreshResult>? _refreshCompleter;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_isUnauthorized(err)) {
      handler.next(err);
      return;
    }
    if (_isRefreshBypassed(err.requestOptions)) {
      handler.next(err);
      return;
    }
    if (_isRefreshRequest(err.requestOptions)) {
      await _clearSessionAndNotify();
      handler.next(err);
      return;
    }

    final String? refreshToken = await _storage.read(
      key: StorageKeys.refreshToken,
    );
    if ((refreshToken ?? '').isEmpty) {
      await _clearSessionAndNotify();
      handler.next(err);
      return;
    }

    final SessionRefreshResult refreshResult = await _refreshAccessToken(
      refreshToken: refreshToken!,
    );
    if (refreshResult.shouldClearSession) {
      await _clearSessionAndNotify();
      handler.next(err);
      return;
    }
    if (!refreshResult.refreshed) {
      handler.next(refreshResult.error ?? err);
      return;
    }

    try {
      final Response<dynamic> response = await _refreshDio.fetch<dynamic>(
        _cloneRequestOptions(
          original: err.requestOptions,
          accessToken: refreshResult.accessToken!,
        ),
      );
      handler.resolve(response);
      return;
    } on DioException catch (retryError) {
      handler.next(retryError);
      return;
    }
  }

  bool _isUnauthorized(DioException error) {
    return error.response?.statusCode == 401;
  }

  bool _isRefreshBypassed(RequestOptions requestOptions) {
    final Object? rawValue =
        requestOptions.extra[SessionRefreshInterceptorConst.bypassRefreshKey];
    if (rawValue is bool) {
      return rawValue;
    }
    return false;
  }

  bool _isRefreshRequest(RequestOptions requestOptions) {
    return requestOptions.path == SessionRefreshInterceptorConst.refreshPath;
  }

  Future<SessionRefreshResult> _refreshAccessToken({
    required String refreshToken,
  }) async {
    final Completer<SessionRefreshResult>? activeRefresh = _refreshCompleter;
    if (activeRefresh != null) {
      return activeRefresh.future;
    }

    final Completer<SessionRefreshResult> refreshCompleter =
        Completer<SessionRefreshResult>();
    _refreshCompleter = refreshCompleter;
    try {
      final Response<dynamic> response = await _refreshDio.post<dynamic>(
        SessionRefreshInterceptorConst.refreshPath,
        data: <String, dynamic>{
          SessionRefreshInterceptorConst.refreshTokenField: refreshToken,
        },
        options: Options(
          extra: <String, dynamic>{
            SessionRefreshInterceptorConst.bypassRefreshKey: true,
            RetryInterceptorConst.bypassRetryKey: true,
          },
        ),
      );
      final Map<String, dynamic> payload = _castMap(response.data);
      final String accessToken = _readAccessToken(payload);
      if (accessToken.isEmpty) {
        const SessionRefreshResult failureResult = SessionRefreshResult.failure(
          failureReason: SessionRefreshFailureReason.invalidSession,
        );
        refreshCompleter.complete(failureResult);
        return failureResult;
      }

      await _persistSession(
        payload: payload,
        currentRefreshToken: refreshToken,
      );
      final SessionRefreshResult successResult = SessionRefreshResult.refreshed(
        accessToken,
      );
      refreshCompleter.complete(successResult);
      return successResult;
    } on DioException catch (error) {
      final SessionRefreshResult failureResult = SessionRefreshResult.failure(
        failureReason: _isRefreshSessionInvalid(error)
            ? SessionRefreshFailureReason.invalidSession
            : SessionRefreshFailureReason.retryable,
        error: error,
      );
      refreshCompleter.complete(failureResult);
      return failureResult;
    } finally {
      _refreshCompleter = null;
    }
  }

  bool _isRefreshSessionInvalid(DioException error) {
    final int? statusCode = error.response?.statusCode;
    if (statusCode == 401) {
      return true;
    }
    if (statusCode == 403) {
      return true;
    }
    return false;
  }

  Future<void> _persistSession({
    required Map<String, dynamic> payload,
    required String currentRefreshToken,
  }) async {
    final String accessToken = _readAccessToken(payload);
    final String nextRefreshToken = _readRefreshToken(
      payload: payload,
      fallbackRefreshToken: currentRefreshToken,
    );
    await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    await _storage.write(
      key: StorageKeys.refreshToken,
      value: nextRefreshToken,
    );

    final String userId = _readUserId(payload);
    if (userId.isEmpty) {
      return;
    }
    await _storage.write(key: StorageKeys.userId, value: userId);
  }

  String _readAccessToken(Map<String, dynamic> payload) {
    return payload[SessionRefreshInterceptorConst.accessTokenField]
            as String? ??
        '';
  }

  String _readRefreshToken({
    required Map<String, dynamic> payload,
    required String fallbackRefreshToken,
  }) {
    final String refreshToken =
        payload[SessionRefreshInterceptorConst.refreshTokenField] as String? ??
        '';
    if (refreshToken.isNotEmpty) {
      return refreshToken;
    }
    return fallbackRefreshToken;
  }

  String _readUserId(Map<String, dynamic> payload) {
    final Object? rawUser = payload[SessionRefreshInterceptorConst.userField];
    if (rawUser is! Map<dynamic, dynamic>) {
      return '';
    }
    final Map<String, dynamic> userPayload = rawUser.cast<String, dynamic>();
    final Object? rawUserId =
        userPayload[SessionRefreshInterceptorConst.userIdField];
    if (rawUserId is int) {
      return '$rawUserId';
    }
    if (rawUserId is String) {
      return rawUserId;
    }
    return '';
  }

  RequestOptions _cloneRequestOptions({
    required RequestOptions original,
    required String accessToken,
  }) {
    final Map<String, dynamic> headers = <String, dynamic>{
      ...original.headers,
      AuthTokenInterceptorConst.authorizationHeader:
          '${AuthTokenInterceptorConst.bearerPrefix}$accessToken',
    };
    final Map<String, dynamic> extra = <String, dynamic>{
      ...original.extra,
      SessionRefreshInterceptorConst.bypassRefreshKey: true,
      RetryInterceptorConst.bypassRetryKey: true,
    };
    extra.remove(RetryInterceptorConst.retryAttemptKey);
    return RequestOptions(
      path: original.path,
      method: original.method,
      baseUrl: original.baseUrl,
      connectTimeout: original.connectTimeout,
      sendTimeout: original.sendTimeout,
      receiveTimeout: original.receiveTimeout,
      headers: headers,
      queryParameters: original.queryParameters,
      data: original.data,
      responseType: original.responseType,
      contentType: original.contentType,
      extra: extra,
      followRedirects: original.followRedirects,
      listFormat: original.listFormat,
      maxRedirects: original.maxRedirects,
      persistentConnection: original.persistentConnection,
      validateStatus: original.validateStatus,
      receiveDataWhenStatusError: original.receiveDataWhenStatusError,
      requestEncoder: original.requestEncoder,
      responseDecoder: original.responseDecoder,
    );
  }

  Future<void> _clearSession() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.userId);
  }

  Future<void> _clearSessionAndNotify() async {
    await _clearSession();
    final FutureOr<void> Function()? callback = onSessionInvalidated;
    if (callback == null) {
      return;
    }
    await callback();
  }

  Map<String, dynamic> _castMap(dynamic rawValue) {
    if (rawValue is Map<dynamic, dynamic>) {
      return rawValue.cast<String, dynamic>();
    }
    return <String, dynamic>{};
  }
}
