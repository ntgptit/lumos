import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

class ErrorMapper {
  const ErrorMapper._();

  static AppException mapDioException(DioException error) {
    if (_isConnectivityError(error.type)) {
      return const NetworkException(message: 'Network unavailable.');
    }
    if (_isTimeoutError(error.type)) {
      return const NetworkException(message: 'Request timeout.');
    }
    if (error.type == DioExceptionType.cancel) {
      return const NetworkException(message: 'Request cancelled.');
    }
    if (error.type == DioExceptionType.badResponse) {
      return _mapHttpStatus(
        statusCode: error.response?.statusCode,
        message: error.message,
      );
    }
    return UnknownException(message: error.message ?? 'Unknown Dio error.');
  }

  static Failure mapToFailure(Object error) {
    if (error is Failure) {
      return error;
    }
    if (error is DioException) {
      final AppException appException = mapDioException(error);
      return mapToFailure(appException);
    }
    if (error is UnauthorizedException) {
      return Failure.unauthorized(
        message: error.message,
        statusCode: error.statusCode,
      );
    }
    if (error is ForbiddenException) {
      return Failure.forbidden(
        message: error.message,
        statusCode: error.statusCode,
      );
    }
    if (error is NotFoundException) {
      return Failure.notFound(
        message: error.message,
        statusCode: error.statusCode,
      );
    }
    if (error is ValidationException) {
      return Failure.validation(
        message: error.message,
        statusCode: error.statusCode,
      );
    }
    if (error is NetworkException) {
      return Failure.network(
        message: error.message,
        statusCode: error.statusCode,
      );
    }
    if (error is ServerException) {
      return Failure.server(
        message: error.message,
        statusCode: error.statusCode,
      );
    }
    if (error is UnknownException) {
      return Failure.unknown(
        message: error.message,
        statusCode: error.statusCode,
      );
    }
    return Failure.unknown(message: error.toString());
  }

  static AppException _mapHttpStatus({
    required int? statusCode,
    required String? message,
  }) {
    if (statusCode == 401) {
      return const UnauthorizedException();
    }
    if (statusCode == 403) {
      return const ForbiddenException();
    }
    if (statusCode == 404) {
      return const NotFoundException();
    }
    if (statusCode == 422) {
      return const ValidationException();
    }
    if (statusCode != null && statusCode >= 500) {
      return ServerException(
        message: message ?? 'Server error.',
        statusCode: statusCode,
      );
    }
    return ServerException(
      message: message ?? 'Request failed.',
      statusCode: statusCode,
    );
  }

  static bool _isConnectivityError(DioExceptionType type) {
    if (type == DioExceptionType.connectionError) {
      return true;
    }
    return false;
  }

  static bool _isTimeoutError(DioExceptionType type) {
    if (type == DioExceptionType.connectionTimeout) {
      return true;
    }
    if (type == DioExceptionType.sendTimeout) {
      return true;
    }
    if (type == DioExceptionType.receiveTimeout) {
      return true;
    }
    return false;
  }
}

extension ErrorToFailureX on Object {
  Failure toFailure() {
    return ErrorMapper.mapToFailure(this);
  }
}
