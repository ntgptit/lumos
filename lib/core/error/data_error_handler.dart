import 'error_mapper.dart';
import 'failures.dart';

/// Utility for data layer to convert unknown errors into [Failure].
abstract final class DataErrorHandler {
  DataErrorHandler._();

  /// Executes [action] and throws [Failure] on error.
  static Future<T> run<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on Object catch (error) {
      throw ErrorMapper.mapToFailure(error);
    }
  }

  /// Executes [action] and returns typed result, without throwing.
  static Future<Result<T>> safe<T>(Future<T> Function() action) async {
    try {
      final T value = await action();
      return Result<T>.success(value);
    } on Object catch (error) {
      final Failure failure = ErrorMapper.mapToFailure(error);
      return Result<T>.failure(failure);
    }
  }
}

class Result<T> {
  const Result._({this.data, this.failure});

  final T? data;
  final Failure? failure;

  bool get isSuccess {
    return data != null;
  }

  bool get isFailure {
    return failure != null;
  }

  factory Result.success(T data) {
    return Result<T>._(data: data);
  }

  factory Result.failure(Failure failure) {
    return Result<T>._(failure: failure);
  }
}
