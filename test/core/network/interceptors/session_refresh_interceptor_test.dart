import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/constants/storage_keys.dart';
import 'package:lumos/core/network/interceptors/auth_token_interceptor.dart';
import 'package:lumos/core/network/interceptors/retry_interceptor.dart';
import 'package:lumos/core/network/interceptors/session_refresh_interceptor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SessionRefreshInterceptor', () {
    test('refreshes expired token and retries the original request', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        StorageKeys.accessToken: 'expired-token',
        StorageKeys.refreshToken: 'refresh-token',
      });
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      final Dio refreshDio = Dio();
      refreshDio.httpClientAdapter = _CallbackHttpClientAdapter((
        RequestOptions options,
      ) async {
        if (options.path == SessionRefreshInterceptorConst.refreshPath) {
          return _jsonResponseBody(
            statusCode: 200,
            payload: <String, dynamic>{
              'user': <String, dynamic>{'id': 7},
              'accessToken': 'fresh-access-token',
              'refreshToken': 'fresh-refresh-token',
            },
          );
        }
        expect(
          options.headers[AuthTokenInterceptorConst.authorizationHeader],
          '${AuthTokenInterceptorConst.bearerPrefix}fresh-access-token',
        );
        expect(options.extra[RetryInterceptorConst.bypassRetryKey], isTrue);
        expect(
          options.extra[SessionRefreshInterceptorConst.bypassRefreshKey],
          isTrue,
        );
        return _jsonResponseBody(
          statusCode: 200,
          payload: <String, dynamic>{'status': 'ok'},
        );
      });
      final Dio dio = Dio();
      dio.httpClientAdapter = _CallbackHttpClientAdapter((
        RequestOptions options,
      ) async {
        return _jsonResponseBody(statusCode: 401, payload: <String, dynamic>{});
      });
      dio.interceptors.add(
        SessionRefreshInterceptor(storage: storage, refreshDio: refreshDio),
      );

      final Response<dynamic> response = await dio.get<dynamic>(
        '/api/v1/study/sessions',
      );

      expect(response.data, <String, dynamic>{'status': 'ok'});
      expect(
        await storage.read(key: StorageKeys.accessToken),
        'fresh-access-token',
      );
      expect(
        await storage.read(key: StorageKeys.refreshToken),
        'fresh-refresh-token',
      );
      expect(await storage.read(key: StorageKeys.userId), '7');
      expect(
        response.requestOptions.headers[AuthTokenInterceptorConst
            .authorizationHeader],
        '${AuthTokenInterceptorConst.bearerPrefix}fresh-access-token',
      );
    });

    test('clears the stored session when refresh fails', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        StorageKeys.accessToken: 'expired-token',
        StorageKeys.refreshToken: 'refresh-token',
        StorageKeys.userId: '7',
      });
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      final Dio refreshDio = Dio();
      refreshDio.httpClientAdapter = _CallbackHttpClientAdapter((
        RequestOptions options,
      ) async {
        return _jsonResponseBody(statusCode: 401, payload: <String, dynamic>{});
      });
      final Dio dio = Dio();
      dio.httpClientAdapter = _CallbackHttpClientAdapter((
        RequestOptions options,
      ) async {
        return _jsonResponseBody(statusCode: 401, payload: <String, dynamic>{});
      });
      dio.interceptors.add(
        SessionRefreshInterceptor(storage: storage, refreshDio: refreshDio),
      );

      await expectLater(
        dio.get<dynamic>('/api/v1/study/sessions'),
        throwsA(isA<DioException>()),
      );

      expect(await storage.read(key: StorageKeys.accessToken), isNull);
      expect(await storage.read(key: StorageKeys.refreshToken), isNull);
      expect(await storage.read(key: StorageKeys.userId), isNull);
    });

    test(
      'serializes concurrent refresh attempts into one refresh request',
      () async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          StorageKeys.accessToken: 'expired-token',
          StorageKeys.refreshToken: 'refresh-token',
        });
        final FlutterSecureStorage storage = const FlutterSecureStorage();
        final Dio refreshDio = Dio();
        int refreshCallCount = 0;
        refreshDio.httpClientAdapter = _CallbackHttpClientAdapter((
          RequestOptions options,
        ) async {
          if (options.path == SessionRefreshInterceptorConst.refreshPath) {
            refreshCallCount += 1;
            await Future<void>.delayed(const Duration(milliseconds: 25));
            return _jsonResponseBody(
              statusCode: 200,
              payload: <String, dynamic>{
                'user': <String, dynamic>{'id': 7},
                'accessToken': 'fresh-access-token',
                'refreshToken': 'fresh-refresh-token',
              },
            );
          }
          return _jsonResponseBody(
            statusCode: 200,
            payload: <String, dynamic>{'path': options.path},
          );
        });
        final Dio dio = Dio();
        dio.httpClientAdapter = _CallbackHttpClientAdapter((
          RequestOptions options,
        ) async {
          return _jsonResponseBody(
            statusCode: 401,
            payload: <String, dynamic>{},
          );
        });
        dio.interceptors.add(
          SessionRefreshInterceptor(storage: storage, refreshDio: refreshDio),
        );

        final List<Response<dynamic>> responses =
            await Future.wait<Response<dynamic>>(<Future<Response<dynamic>>>[
              dio.get<dynamic>('/api/v1/study/sessions/1'),
              dio.get<dynamic>('/api/v1/study/sessions/2'),
            ]);

        expect(refreshCallCount, 1);
        expect(
          responses.map((Response<dynamic> response) => response.data['path']),
          orderedEquals(<String>[
            '/api/v1/study/sessions/1',
            '/api/v1/study/sessions/2',
          ]),
        );
      },
    );

    test(
      'does not re-enter retry loop when replay request fails with network error',
      () async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          StorageKeys.accessToken: 'expired-token',
          StorageKeys.refreshToken: 'refresh-token',
        });
        final FlutterSecureStorage storage = const FlutterSecureStorage();
        final Dio refreshDio = Dio();
        int replayCallCount = 0;
        refreshDio.httpClientAdapter = _CallbackHttpClientAdapter((
          RequestOptions options,
        ) async {
          if (options.path == SessionRefreshInterceptorConst.refreshPath) {
            return _jsonResponseBody(
              statusCode: 200,
              payload: <String, dynamic>{
                'user': <String, dynamic>{'id': 7},
                'accessToken': 'fresh-access-token',
                'refreshToken': 'fresh-refresh-token',
              },
            );
          }
          replayCallCount += 1;
          throw DioException.connectionError(
            requestOptions: options,
            reason: 'Network unavailable.',
          );
        });
        final Dio dio = Dio();
        int originalCallCount = 0;
        dio.httpClientAdapter = _CallbackHttpClientAdapter((
          RequestOptions options,
        ) async {
          originalCallCount += 1;
          return _jsonResponseBody(
            statusCode: 401,
            payload: <String, dynamic>{},
          );
        });
        dio.interceptors.add(RetryInterceptor(dio: dio));
        dio.interceptors.add(
          SessionRefreshInterceptor(storage: storage, refreshDio: refreshDio),
        );

        await expectLater(
          dio.get<dynamic>('/api/v1/study/sessions'),
          throwsA(isA<DioException>()),
        );

        expect(replayCallCount, 1);
        expect(originalCallCount, 1);
      },
    );
  });
}

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
