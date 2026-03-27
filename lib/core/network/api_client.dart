import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

typedef DioInterceptorFactory = Interceptor Function(Dio dio);
typedef RetrofitServiceFactory<T> = T Function(Dio dio, {String? baseUrl});

@immutable
class ApiClient {
  ApiClient({
    required this.baseUrl,
    required this.enableLogs,
    Dio? dio,
    Iterable<DioInterceptorFactory> interceptorFactories =
        const <DioInterceptorFactory>[],
    Duration connectTimeout = defaultConnectTimeout,
    Duration receiveTimeout = defaultReceiveTimeout,
    Duration sendTimeout = defaultSendTimeout,
    Map<String, Object?> defaultHeaders = const <String, Object?>{},
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: connectTimeout,
               receiveTimeout: receiveTimeout,
               sendTimeout: sendTimeout,
               headers: Map<String, Object?>.from(defaultHeaders),
               responseType: ResponseType.json,
             ),
           ) {
    for (final factory in interceptorFactories) {
      _dio.interceptors.add(factory(_dio));
    }
  }

  static const Duration defaultConnectTimeout = Duration(seconds: 15);
  static const Duration defaultReceiveTimeout = Duration(seconds: 20);
  static const Duration defaultSendTimeout = Duration(seconds: 20);

  final String baseUrl;
  final bool enableLogs;
  final Dio _dio;

  Dio get dio => _dio;
  BaseOptions get options => _dio.options;

  T createService<T>(RetrofitServiceFactory<T> builder, {String? baseUrl}) {
    return builder(_dio, baseUrl: baseUrl ?? this.baseUrl);
  }

  void close({bool force = false}) {
    _dio.close(force: force);
  }
}
