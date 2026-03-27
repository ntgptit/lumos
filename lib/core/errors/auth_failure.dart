import 'package:lumos/core/errors/failure.dart';

class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
    super.isRetryable = false,
    this.requiresReauthentication = true,
  });

  final bool requiresReauthentication;
}
