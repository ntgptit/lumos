import 'package:flutter/foundation.dart';

@immutable
class Failure {
  const Failure({
    required this.message,
    this.code,
    this.statusCode,
    this.isRetryable = false,
    this.cause,
    this.stackTrace,
  });

  const Failure.validation({
    required String message,
    String? code,
    int? statusCode,
    Object? cause,
    StackTrace? stackTrace,
  }) : this(
         message: message,
         code: code ?? 'validation',
         statusCode: statusCode,
         cause: cause,
         stackTrace: stackTrace,
       );

  const Failure.unknown({
    required String message,
    String? code,
    int? statusCode,
    bool isRetryable = false,
    Object? cause,
    StackTrace? stackTrace,
  }) : this(
         message: message,
         code: code ?? 'unknown',
         statusCode: statusCode,
         isRetryable: isRetryable,
         cause: cause,
         stackTrace: stackTrace,
       );

  final String message;
  final String? code;
  final int? statusCode;
  final bool isRetryable;
  final Object? cause;
  final StackTrace? stackTrace;

  bool get hasCode => code != null && code!.isNotEmpty;

  @override
  String toString() {
    return '$runtimeType(code: $code, statusCode: $statusCode, retryable: $isRetryable, message: $message)';
  }
}
