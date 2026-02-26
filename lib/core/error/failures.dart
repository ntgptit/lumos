import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({required String message, int? statusCode}) =
      NetworkFailure;

  const factory Failure.unauthorized({
    required String message,
    int? statusCode,
  }) = UnauthorizedFailure;

  const factory Failure.forbidden({required String message, int? statusCode}) =
      ForbiddenFailure;

  const factory Failure.notFound({required String message, int? statusCode}) =
      NotFoundFailure;

  const factory Failure.validation({required String message, int? statusCode}) =
      ValidationFailure;

  const factory Failure.server({required String message, int? statusCode}) =
      ServerFailure;

  const factory Failure.unknown({required String message, int? statusCode}) =
      UnknownFailure;
}
