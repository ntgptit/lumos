/// Base class for all app exceptions.
abstract class AppException implements Exception {
  const AppException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() {
    return '$runtimeType(message: $message, statusCode: $statusCode)';
  }
}

/// Raised when request cannot reach server due to connectivity/timeouts.
class NetworkException extends AppException {
  const NetworkException({required super.message, super.statusCode});
}

/// Raised when backend returns unauthorized response.
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized request.',
    super.statusCode = 401,
  });
}

/// Raised when backend returns forbidden response.
class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Forbidden request.',
    super.statusCode = 403,
  });
}

/// Raised when requested resource cannot be found.
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found.',
    super.statusCode = 404,
  });
}

/// Raised when backend validates request body and rejects it.
class ValidationException extends AppException {
  const ValidationException({
    super.message = 'Validation failed.',
    super.statusCode = 422,
  });
}

/// Raised when backend reports server-side failure.
class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

/// Raised for uncategorized errors.
class UnknownException extends AppException {
  const UnknownException({super.message = 'Unknown error.', super.statusCode});
}
