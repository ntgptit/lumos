import 'dart:async';

import 'package:dio/dio.dart';

abstract final class RetryInterceptorConst {
  static const retryCountKey = RetryInterceptor.retryCountKey;
  static const bypassRetryKey = RetryInterceptor.skipRetryKey;
}

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 1,
    this.baseDelay = const Duration(milliseconds: 400),
    Set<String>? retryableMethods,
  }) : _dio = dio,
       _retryableMethods =
           retryableMethods ?? const <String>{'GET', 'HEAD', 'OPTIONS'};

  static const retryCountKey = 'retryCount';
  static const skipRetryKey = 'skipRetry';

  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;
  final Set<String> _retryableMethods;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final retryCount = (requestOptions.extra[retryCountKey] as int?) ?? 0;

    if (!_shouldRetry(err, requestOptions, retryCount)) {
      handler.next(err);
      return;
    }

    requestOptions.extra[retryCountKey] = retryCount + 1;
    await Future<void>.delayed(_delayFor(retryCount + 1));

    try {
      final response = await _dio.fetch<Object?>(requestOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _shouldRetry(
    DioException err,
    RequestOptions requestOptions,
    int retryCount,
  ) {
    if (retryCount >= maxRetries) {
      return false;
    }

    if (requestOptions.cancelToken?.isCancelled == true) {
      return false;
    }

    if (requestOptions.extra[skipRetryKey] == true) {
      return false;
    }

    if (!_retryableMethods.contains(requestOptions.method.toUpperCase())) {
      return false;
    }

    final statusCode = err.response?.statusCode;
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        statusCode == 408 ||
        statusCode == 429 ||
        (statusCode != null && statusCode >= 500);
  }

  Duration _delayFor(int attempt) {
    return Duration(milliseconds: baseDelay.inMilliseconds * attempt);
  }
}
