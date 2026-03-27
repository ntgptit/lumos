import 'package:lumos/core/errors/failure.dart';

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.isRetryable = true,
    super.cause,
    super.stackTrace,
    this.statusCode,
    this.isTimeout = false,
    this.isOffline = false,
  });

  final int? statusCode;
  final bool isTimeout;
  final bool isOffline;
}
