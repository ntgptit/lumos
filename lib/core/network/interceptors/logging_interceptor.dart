import 'package:lumos/core/utils/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class LoggingInterceptor extends PrettyDioLogger {
  LoggingInterceptor({required super.enabled})
    : super(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        logPrint: (object) => Logger.debug(object.toString()),
      );
}
