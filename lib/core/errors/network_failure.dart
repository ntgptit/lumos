import 'package:lumos/core/errors/failure.dart';

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.statusCode,
    super.isRetryable = true,
    super.cause,
    super.stackTrace,
    this.isTimeout = false,
    this.isOffline = false,
  });

  final bool isTimeout;
  final bool isOffline;
}
