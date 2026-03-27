import 'package:lumos/core/errors/failure.dart';

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
    this.fieldErrors = const <String, String>{},
  });

  final Map<String, String> fieldErrors;

  bool get hasFieldErrors => fieldErrors.isNotEmpty;
}
