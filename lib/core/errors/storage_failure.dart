import 'package:lumos/core/errors/failure.dart';

class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
    this.operation,
  });

  final String? operation;
}
