import 'dart:async';

import 'package:dio/dio.dart';

abstract final class RetryInterceptorConst {
  RetryInterceptorConst._();

  static const String retryAttemptKey = 'retry_attempt';
  static const String bypassRetryKey = 'bypass_retry';
  static const int defaultMaxRetries = 3;
  static const int maxRetryLimit = 5;
  static const int baseDelayMs = 300;
}

/// Retries transient failures (timeouts, connection errors, and 5xx responses).
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    int maxRetries = RetryInterceptorConst.defaultMaxRetries,
  }) : _dio = dio,
       maxRetries = _normalizeMaxRetries(maxRetries);

  final Dio _dio;
  final int maxRetries;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isBypassRetry(err.requestOptions)) {
      handler.next(err);
      return;
    }
    if (!_canRetry(error: err)) {
      handler.next(err);
      return;
    }
    DioException currentError = err;
    int attempt = _readAttempt(err.requestOptions);
    while (attempt < maxRetries && _canRetry(error: currentError)) {
      final int nextAttempt = attempt + 1;
      final RequestOptions requestOptions = _cloneRequestOptions(
        original: currentError.requestOptions,
        nextAttempt: nextAttempt,
      );
      await _delayForAttempt(nextAttempt);
      try {
        final Response<dynamic> response = await _dio.fetch<dynamic>(
          requestOptions,
        );
        handler.resolve(response);
        return;
      } on DioException catch (retryError) {
        currentError = retryError;
        attempt = _readAttempt(retryError.requestOptions);
      }
    }
    handler.next(currentError);
  }

  static int _normalizeMaxRetries(int maxRetries) {
    if (maxRetries < 0) {
      return 0;
    }
    if (maxRetries <= RetryInterceptorConst.maxRetryLimit) {
      return maxRetries;
    }
    return RetryInterceptorConst.maxRetryLimit;
  }

  bool _isBypassRetry(RequestOptions requestOptions) {
    final Object? rawValue =
        requestOptions.extra[RetryInterceptorConst.bypassRetryKey];
    if (rawValue is bool) {
      return rawValue;
    }
    return false;
  }

  bool _canRetry({required DioException error}) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return true;
    }
    if (error.type == DioExceptionType.sendTimeout) {
      return true;
    }
    if (error.type == DioExceptionType.receiveTimeout) {
      return true;
    }
    if (error.type == DioExceptionType.connectionError) {
      return true;
    }
    if (error.type != DioExceptionType.badResponse) {
      return false;
    }
    final int? statusCode = error.response?.statusCode;
    if (statusCode == null) {
      return false;
    }
    return statusCode >= 500;
  }

  int _readAttempt(RequestOptions requestOptions) {
    final Object? rawValue =
        requestOptions.extra[RetryInterceptorConst.retryAttemptKey];
    if (rawValue is int) {
      return rawValue;
    }
    return 0;
  }

  RequestOptions _cloneRequestOptions({
    required RequestOptions original,
    required int nextAttempt,
  }) {
    final Map<String, dynamic> extra = <String, dynamic>{
      ...original.extra,
      RetryInterceptorConst.retryAttemptKey: nextAttempt,
      RetryInterceptorConst.bypassRetryKey: true,
    };
    return RequestOptions(
      path: original.path,
      method: original.method,
      baseUrl: original.baseUrl,
      connectTimeout: original.connectTimeout,
      sendTimeout: original.sendTimeout,
      receiveTimeout: original.receiveTimeout,
      headers: original.headers,
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

  Future<void> _delayForAttempt(int attempt) {
    final int delayMs = RetryInterceptorConst.baseDelayMs * attempt;
    return Future<void>.delayed(Duration(milliseconds: delayMs));
  }
}
