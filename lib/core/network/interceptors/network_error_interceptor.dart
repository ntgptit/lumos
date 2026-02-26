import 'package:dio/dio.dart';

import '../../error/error_mapper.dart';
import '../../error/exceptions.dart';

/// Normalizes network errors before bubbling them to upper layers.
class NetworkErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final DioException normalizedError = _normalize(err);
    handler.next(normalizedError);
  }

  DioException _normalize(DioException error) {
    final AppException mappedException = ErrorMapper.mapDioException(error);
    return DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      type: error.type,
      error: mappedException,
      stackTrace: error.stackTrace,
      message: mappedException.message,
    );
  }
}
