import 'dart:async';

import 'package:dio/dio.dart';
import 'package:lumos/core/errors/app_exception.dart';
import 'package:lumos/core/errors/auth_failure.dart';
import 'package:lumos/core/errors/failure.dart';
import 'package:lumos/core/errors/network_failure.dart';
import 'package:lumos/core/errors/storage_failure.dart';
import 'package:lumos/core/errors/validation_failure.dart';
import 'package:lumos/core/utils/object_utils.dart';

abstract final class ErrorMapper {
  static const _fallbackMessage = 'Unexpected application error.';

  static Failure map(Object error, {StackTrace? stackTrace}) {
    if (error is Failure) {
      return error;
    }

    if (error is AppException) {
      return _mapAppException(error);
    }

    if (error is DioException) {
      return _mapDioException(error);
    }

    if (error is TimeoutException) {
      return NetworkFailure(
        message: 'Request timed out.',
        code: 'timeout',
        isRetryable: true,
        isTimeout: true,
        cause: error,
        stackTrace: stackTrace,
      );
    }

    if (error is FormatException) {
      return ValidationFailure(
        message: error.message,
        code: 'format',
        cause: error,
        stackTrace: stackTrace,
      );
    }

    if (error is ArgumentError) {
      return ValidationFailure(
        message: error.message?.toString() ?? _fallbackMessage,
        code: 'argument',
        cause: error,
        stackTrace: stackTrace,
      );
    }

    return Failure(
      message: _fallbackMessage,
      code: 'unknown',
      cause: error,
      stackTrace: stackTrace,
    );
  }

  static Failure _mapAppException(AppException error) {
    final normalizedCode = error.code?.trim().toLowerCase();

    switch (error.type) {
      case AppExceptionType.auth:
        return AuthFailure(
          message: error.message,
          code: error.code,
          cause: error.cause,
          stackTrace: error.stackTrace,
          isRetryable: error.isRetryable,
        );
      case AppExceptionType.validation:
        return ValidationFailure(
          message: error.message,
          code: error.code,
          cause: error.cause,
          stackTrace: error.stackTrace,
        );
      case AppExceptionType.storage:
        return StorageFailure(
          message: error.message,
          code: error.code,
          cause: error.cause,
          stackTrace: error.stackTrace,
        );
      case AppExceptionType.network:
        return NetworkFailure(
          message: error.message,
          code: error.code,
          cause: error.cause,
          stackTrace: error.stackTrace,
          isRetryable: error.isRetryable,
        );
      case AppExceptionType.unknown:
        if (normalizedCode == 'unauthorized' || normalizedCode == 'forbidden') {
          return AuthFailure(
            message: error.message,
            code: error.code,
            cause: error.cause,
            stackTrace: error.stackTrace,
          );
        }
        if (normalizedCode == 'validation') {
          return ValidationFailure(
            message: error.message,
            code: error.code,
            cause: error.cause,
            stackTrace: error.stackTrace,
          );
        }
        if (normalizedCode == 'storage') {
          return StorageFailure(
            message: error.message,
            code: error.code,
            cause: error.cause,
            stackTrace: error.stackTrace,
          );
        }
        return NetworkFailure(
          message: error.message,
          code: error.code,
          cause: error.cause,
          stackTrace: error.stackTrace,
          isRetryable: error.isRetryable,
        );
    }
  }

  static Failure _mapDioException(DioException error) {
    final response = error.response;
    final data = response?.data;
    final statusCode = response?.statusCode;
    final code = _extractCode(data) ?? error.type.name;
    final message =
        _extractMessage(data) ??
        response?.statusMessage ??
        error.message ??
        _fallbackMessage;

    if (_isAuthError(statusCode, code)) {
      return AuthFailure(
        message: message,
        code: code,
        cause: error,
        stackTrace: error.stackTrace,
      );
    }

    if (_isValidationError(statusCode, code)) {
      return ValidationFailure(
        message: message,
        code: code,
        cause: error,
        stackTrace: error.stackTrace,
        fieldErrors: _extractFieldErrors(data),
      );
    }

    return NetworkFailure(
      message: message,
      code: code,
      statusCode: statusCode,
      isRetryable: _isRetryable(error.type, statusCode),
      isTimeout: _isTimeout(error.type),
      isOffline:
          error.type == DioExceptionType.connectionError && statusCode == null,
      cause: error,
      stackTrace: error.stackTrace,
    );
  }

  static bool _isAuthError(int? statusCode, String? code) {
    return statusCode == 401 ||
        statusCode == 403 ||
        code == 'unauthorized' ||
        code == 'forbidden';
  }

  static bool _isValidationError(int? statusCode, String? code) {
    return statusCode == 400 ||
        statusCode == 422 ||
        code == 'validation' ||
        code == 'invalid_argument';
  }

  static bool _isRetryable(DioExceptionType type, int? statusCode) {
    if (_isTimeout(type) || type == DioExceptionType.connectionError) {
      return true;
    }

    if (statusCode == null) {
      return false;
    }

    return statusCode == 408 || statusCode == 429 || statusCode >= 500;
  }

  static bool _isTimeout(DioExceptionType type) {
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout;
  }

  static String? _extractMessage(Object? data) {
    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    if (data is Map) {
      return ObjectUtils.castOrNull<String>(data['message'])?.trim();
    }

    return null;
  }

  static String? _extractCode(Object? data) {
    if (data is Map) {
      return ObjectUtils.castOrNull<String>(data['code'])?.trim().toLowerCase();
    }

    return null;
  }

  static Map<String, String> _extractFieldErrors(Object? data) {
    if (data is! Map) {
      return const <String, String>{};
    }

    final rawErrors = data['fieldErrors'];
    if (rawErrors is! Map) {
      return const <String, String>{};
    }

    final fieldErrors = <String, String>{};
    rawErrors.forEach((key, value) {
      if (key is! String || value == null) {
        return;
      }

      if (value is List) {
        fieldErrors[key] = value.map((item) => item.toString()).join(', ');
        return;
      }

      fieldErrors[key] = value.toString();
    });

    return fieldErrors;
  }
}
