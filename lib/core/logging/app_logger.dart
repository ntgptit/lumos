import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_logger.g.dart';

abstract final class AppLoggerConst {
  AppLoggerConst._();

  static const int methodCount = 0;
  static const int errorMethodCount = 8;
  static const int lineLength = 80;
}

/// Provides shared structured logger for app-level events.
@Riverpod(keepAlive: true)
Logger appLogger(Ref ref) {
  return Logger(
    printer: PrettyPrinter(
      methodCount: AppLoggerConst.methodCount,
      errorMethodCount: AppLoggerConst.errorMethodCount,
      lineLength: AppLoggerConst.lineLength,
      colors: true,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
}
