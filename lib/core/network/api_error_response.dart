import 'package:flutter/foundation.dart';
import 'package:lumos/core/utils/object_utils.dart';

@immutable
class ApiErrorResponse {
  const ApiErrorResponse({
    required this.message,
    this.code,
    this.statusCode,
    this.fieldErrors = const <String, String>{},
  });

  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, String> fieldErrors;

  bool get hasFieldErrors => fieldErrors.isNotEmpty;

  factory ApiErrorResponse.fromJson(
    Map<String, Object?> json, {
    int? statusCode,
  }) {
    return ApiErrorResponse(
      message: _readString(json['message']) ?? 'Unexpected server error.',
      code: _readString(json['code'])?.toLowerCase(),
      statusCode: statusCode ?? _readInt(json['statusCode']),
      fieldErrors: _readFieldErrors(json['fieldErrors']),
    );
  }

  static String? _readString(Object? value) {
    return ObjectUtils.castOrNull<String>(value)?.trim();
  }

  static int? _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static Map<String, String> _readFieldErrors(Object? value) {
    if (value is! Map) {
      return const <String, String>{};
    }

    final fieldErrors = <String, String>{};
    value.forEach((key, rawValue) {
      if (key is! String || rawValue == null) {
        return;
      }

      if (rawValue is List) {
        fieldErrors[key] = rawValue.map((item) => item.toString()).join(', ');
        return;
      }

      fieldErrors[key] = rawValue.toString();
    });

    return fieldErrors;
  }
}
