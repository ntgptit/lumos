import 'package:dio/dio.dart';
import 'package:lumos/core/errors/app_exception.dart';
import 'package:lumos/core/network/network_info.dart';

class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor(this._networkInfo);

  static const skipConnectivityCheckKey = 'skipConnectivityCheck';

  final NetworkInfo _networkInfo;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipConnectivityCheckKey] == true) {
      handler.next(options);
      return;
    }

    final isConnected = await _networkInfo.isConnected;
    if (isConnected) {
      handler.next(options);
      return;
    }

    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
        error: const AppException.network(
          'No internet connection.',
          code: 'offline',
        ),
        message: 'No internet connection.',
      ),
    );
  }
}
