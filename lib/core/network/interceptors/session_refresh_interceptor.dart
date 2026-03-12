import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/storage_keys.dart';
import 'auth_token_interceptor.dart';

abstract final class SessionRefreshInterceptorConst {
  SessionRefreshInterceptorConst._();

  static const String refreshPath = '/api/v1/auth/refresh';
  static const String bypassRefreshKey = 'bypass_token_refresh';
  static const String refreshTokenField = 'refreshToken';
  static const String accessTokenField = 'accessToken';
  static const String userField = 'user';
  static const String userIdField = 'id';
}

/// Interceptor that refreshes expired access tokens and retries the request once.
class SessionRefreshInterceptor extends Interceptor {
  SessionRefreshInterceptor({
    required FlutterSecureStorage storage,
    required Dio refreshDio,
  }) : _storage = storage,
       _refreshDio = refreshDio;

  final FlutterSecureStorage _storage;
  final Dio _refreshDio;

  Completer<String?>? _refreshCompleter;

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
      await _clearSession();
      handler.next(err);
      return;
    }

    final String? refreshToken = await _storage.read(
      key: StorageKeys.refreshToken,
    );
    if ((refreshToken ?? '').isEmpty) {
      await _clearSession();
      handler.next(err);
      return;
    }

    final String? accessToken = await _refreshAccessToken(
      refreshToken: refreshToken!,
    );
    if ((accessToken ?? '').isEmpty) {
      await _clearSession();
      handler.next(err);
      return;
    }

    try {
      final Response<dynamic> response = await _refreshDio.fetch<dynamic>(
        _cloneRequestOptions(
          original: err.requestOptions,
          accessToken: accessToken!,
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

  Future<String?> _refreshAccessToken({required String refreshToken}) async {
    final Completer<String?>? activeRefresh = _refreshCompleter;
    if (activeRefresh != null) {
      return activeRefresh.future;
    }

    final Completer<String?> refreshCompleter = Completer<String?>();
    _refreshCompleter = refreshCompleter;
    try {
      final Response<dynamic> response = await _refreshDio.post<dynamic>(
        SessionRefreshInterceptorConst.refreshPath,
        data: <String, dynamic>{
          SessionRefreshInterceptorConst.refreshTokenField: refreshToken,
        },
      );
      final Map<String, dynamic> payload = _castMap(response.data);
      final String accessToken = _readAccessToken(payload);
      if (accessToken.isEmpty) {
        refreshCompleter.complete(null);
        return null;
      }

      await _persistSession(
        payload: payload,
        currentRefreshToken: refreshToken,
      );
      refreshCompleter.complete(accessToken);
      return accessToken;
    } on Object {
      refreshCompleter.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
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
    };
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

  Map<String, dynamic> _castMap(dynamic rawValue) {
    if (rawValue is Map<dynamic, dynamic>) {
      return rawValue.cast<String, dynamic>();
    }
    return <String, dynamic>{};
  }
}
