import 'dart:async';

import 'package:dio/dio.dart';
import 'package:lumos/core/utils/string_utils.dart';

typedef AuthTokenReader = FutureOr<String?> Function();

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required AuthTokenReader tokenReader,
    this.commonHeaders = const <String, String>{'Accept': 'application/json'},
  }) : _tokenReader = tokenReader;

  static const skipAuthKey = 'skipAuth';

  final AuthTokenReader _tokenReader;
  final Map<String, String> commonHeaders;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll(commonHeaders);

    if (options.extra[skipAuthKey] == true) {
      handler.next(options);
      return;
    }

    final token = await _tokenReader();
    final normalizedToken = StringUtils.trimmedOrNull(token);
    if (normalizedToken != null) {
      options.headers.putIfAbsent(
        'Authorization',
        () => 'Bearer $normalizedToken',
      );
    }

    handler.next(options);
  }
}
