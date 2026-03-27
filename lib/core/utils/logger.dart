import 'package:flutter/foundation.dart';

abstract final class Logger {
  static void trace(String message) {
    if (!kDebugMode) {
      return;
    }
    _log('TRACE', message);
  }

  static void debug(String message) {
    if (!kDebugMode) {
      return;
    }

    _log('DEBUG', message);
  }

  static void info(String message) {
    _log('INFO', message);
  }

  static void warning(String message) {
    _log('WARN', message);
  }

  static void success(String message) {
    _log('SUCCESS', message);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    final buffer = StringBuffer(message);

    if (error != null) {
      buffer.write(' | error: $error');
    }
    if (stackTrace != null && kDebugMode) {
      buffer.write('\n$stackTrace');
    }

    _log('ERROR', buffer.toString());
  }

  static void _log(String level, String message) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp][$level][lumos] $message');
  }
}
