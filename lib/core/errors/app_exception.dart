enum AppExceptionType { unknown, network, validation, storage, auth }

class AppException implements Exception {
  const AppException(
    this.message, {
    this.code,
    this.type = AppExceptionType.unknown,
    this.cause,
    this.stackTrace,
    this.isRetryable = false,
  });

  const AppException.network(
    this.message, {
    this.code,
    this.cause,
    this.stackTrace,
    this.isRetryable = true,
  }) : type = AppExceptionType.network;

  const AppException.validation(
    this.message, {
    this.code = 'validation',
    this.cause,
    this.stackTrace,
  }) : type = AppExceptionType.validation,
       isRetryable = false;

  const AppException.storage(
    this.message, {
    this.code = 'storage',
    this.cause,
    this.stackTrace,
  }) : type = AppExceptionType.storage,
       isRetryable = false;

  const AppException.auth(
    this.message, {
    this.code = 'unauthorized',
    this.cause,
    this.stackTrace,
  }) : type = AppExceptionType.auth,
       isRetryable = false;

  final String message;
  final String? code;
  final AppExceptionType type;
  final Object? cause;
  final StackTrace? stackTrace;
  final bool isRetryable;

  @override
  String toString() {
    return 'AppException(type: $type, code: $code, message: $message)';
  }
}
