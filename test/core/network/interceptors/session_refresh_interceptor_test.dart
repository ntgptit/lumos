import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/network/interceptors/auth_interceptor.dart';
import 'package:lumos/core/network/interceptors/retry_interceptor.dart';
import 'package:lumos/core/network/interceptors/session_refresh_interceptor.dart';
import 'package:lumos/core/services/auth_session_service.dart';
import 'package:lumos/core/storage/secure_storage.dart';
import 'package:lumos/core/storage/storage_keys.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SessionRefreshInterceptor', () {
    test('refreshes expired token and retries the original request', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        StorageKeys.authToken: 'expired-token',
        StorageKeys.refreshToken: 'refresh-token',
      });
      final SecureStorage secureStorage = SecureStorage(
        storage: const FlutterSecureStorage(),
      );
      final AuthSessionService authSessionService = AuthSessionService();
      addTearDown(authSessionService.dispose);

      var sessionRequestCount = 0;
      final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _CallbackHttpClientAdapter((RequestOptions options) async {
        if (options.path == _refreshPath) {
          expect(options.extra[AuthInterceptor.skipAuthKey], isTrue);
          expect(options.extra[RetryInterceptor.skipRetryKey], isTrue);
          expect(
            options.extra[SessionRefreshInterceptorConst.bypassRefreshKey],
            isTrue,
          );
          return _jsonResponseBody(
            statusCode: 200,
            payload: <String, dynamic>{
              'accessToken': 'fresh-access-token',
              'refreshToken': 'fresh-refresh-token',
            },
          );
        }

        if (options.path == _studySessionsPath) {
          sessionRequestCount += 1;
          if (sessionRequestCount == 1) {
            return _jsonResponseBody(
              statusCode: 401,
              payload: const <String, dynamic>{},
            );
          }

          expect(
            options.headers['Authorization'],
            'Bearer fresh-access-token',
          );
          expect(
            options.extra[SessionRefreshInterceptor.retriedWithFreshTokenKey],
            isTrue,
          );
          return _jsonResponseBody(
            statusCode: 200,
            payload: <String, dynamic>{'status': 'ok'},
          );
        }

        throw StateError('Unexpected path: ${options.path}');
      });
      dio.interceptors.add(
        SessionRefreshInterceptor(
          dio: dio,
          secureStorage: secureStorage,
          authSessionService: authSessionService,
        ),
      );

      final Response<dynamic> response = await dio.get<dynamic>(
        _studySessionsPath,
      );

      expect(response.data, <String, dynamic>{'status': 'ok'});
      expect(
        await secureStorage.read(StorageKeys.authToken),
        'fresh-access-token',
      );
      expect(
        await secureStorage.read(StorageKeys.refreshToken),
        'fresh-refresh-token',
      );
      expect(sessionRequestCount, 2);
    });

    test('retries with the latest stored token before refreshing again', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        StorageKeys.authToken: 'latest-access-token',
        StorageKeys.refreshToken: 'refresh-token',
      });
      final SecureStorage secureStorage = SecureStorage(
        storage: const FlutterSecureStorage(),
      );
      final AuthSessionService authSessionService = AuthSessionService();
      addTearDown(authSessionService.dispose);

      var refreshCallCount = 0;
      var sessionRequestCount = 0;
      final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _CallbackHttpClientAdapter((RequestOptions options) async {
        if (options.path == _refreshPath) {
          refreshCallCount += 1;
          return _jsonResponseBody(
            statusCode: 200,
            payload: const <String, dynamic>{},
          );
        }

        if (options.path == _studySessionsPath) {
          sessionRequestCount += 1;
          if (sessionRequestCount == 1) {
            expect(
              options.headers['Authorization'],
              'Bearer stale-access-token',
            );
            return _jsonResponseBody(
              statusCode: 401,
              payload: const <String, dynamic>{},
            );
          }

          expect(
            options.headers['Authorization'],
            'Bearer latest-access-token',
          );
          expect(
            options.extra[SessionRefreshInterceptor.retriedWithFreshTokenKey],
            isTrue,
          );
          return _jsonResponseBody(
            statusCode: 200,
            payload: <String, dynamic>{'status': 'ok'},
          );
        }

        throw StateError('Unexpected path: ${options.path}');
      });
      dio.interceptors.add(
        SessionRefreshInterceptor(
          dio: dio,
          secureStorage: secureStorage,
          authSessionService: authSessionService,
        ),
      );

      final Response<dynamic> response = await dio.get<dynamic>(
        _studySessionsPath,
        options: Options(
          headers: <String, String>{
            'Authorization': 'Bearer stale-access-token',
          },
        ),
      );

      expect(response.data, <String, dynamic>{'status': 'ok'});
      expect(refreshCallCount, 0);
      expect(sessionRequestCount, 2);
    });

    test('clears stored tokens and emits expired session when refresh fails', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        StorageKeys.authToken: 'expired-token',
        StorageKeys.refreshToken: 'refresh-token',
      });
      final SecureStorage secureStorage = SecureStorage(
        storage: const FlutterSecureStorage(),
      );
      final AuthSessionService authSessionService = AuthSessionService();
      addTearDown(authSessionService.dispose);

      final Future<AuthSessionEvent> expiredEvent =
          authSessionService.events.first;
      final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _CallbackHttpClientAdapter((RequestOptions options) async {
        if (options.path == _refreshPath) {
          return _jsonResponseBody(
            statusCode: 401,
            payload: const <String, dynamic>{},
          );
        }

        if (options.path == _studySessionsPath) {
          return _jsonResponseBody(
            statusCode: 401,
            payload: const <String, dynamic>{},
          );
        }

        throw StateError('Unexpected path: ${options.path}');
      });
      dio.interceptors.add(
        SessionRefreshInterceptor(
          dio: dio,
          secureStorage: secureStorage,
          authSessionService: authSessionService,
        ),
      );

      await expectLater(
        dio.get<dynamic>(_studySessionsPath),
        throwsA(isA<DioException>()),
      );

      expect(await expiredEvent, AuthSessionEvent.expired);
      expect(await secureStorage.read(StorageKeys.authToken), isNull);
      expect(await secureStorage.read(StorageKeys.refreshToken), isNull);
    });
  });
}

const String _refreshPath = '/api/v1/auth/refresh';
const String _studySessionsPath = '/api/v1/study/sessions';

ResponseBody _jsonResponseBody({
  required int statusCode,
  required Map<String, dynamic> payload,
}) {
  return ResponseBody.fromString(
    jsonEncode(payload),
    statusCode,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );
}

class _CallbackHttpClientAdapter implements HttpClientAdapter {
  _CallbackHttpClientAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}
