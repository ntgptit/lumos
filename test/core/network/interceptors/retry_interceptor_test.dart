import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/network/interceptors/retry_interceptor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RetryInterceptor', () {
    test('does not retry unsafe POST requests', () async {
      final Dio dio = Dio();
      int requestCount = 0;
      dio.httpClientAdapter = _CallbackHttpClientAdapter((
        RequestOptions options,
      ) async {
        requestCount += 1;
        throw DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
        );
      });
      dio.interceptors.add(RetryInterceptor(dio: dio));

      await expectLater(
        dio.post<dynamic>('/api/v1/auth/refresh'),
        throwsA(isA<DioException>()),
      );

      expect(requestCount, 1);
    });

    test('retries safe GET requests once network recovers', () async {
      final Dio dio = Dio();
      int requestCount = 0;
      dio.httpClientAdapter = _CallbackHttpClientAdapter((
        RequestOptions options,
      ) async {
        requestCount += 1;
        if (requestCount == 1) {
          throw DioException.connectionError(
            requestOptions: options,
            reason: 'offline',
          );
        }
        return ResponseBody.fromString('{"status":"ok"}', 200);
      });
      dio.interceptors.add(RetryInterceptor(dio: dio));

      final Response<dynamic> response = await dio.get<dynamic>(
        '/api/v1/study/sessions',
      );

      expect(response.data, '{"status":"ok"}');
      expect(requestCount, 2);
    });
  });
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
