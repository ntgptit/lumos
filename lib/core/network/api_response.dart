import 'package:flutter/foundation.dart';
import 'package:lumos/core/utils/object_utils.dart';

@immutable
class ApiResponse<T> {
  const ApiResponse({
    required this.data,
    this.message,
    this.meta = const <String, Object?>{},
    this.statusCode,
  });

  final T data;
  final String? message;
  final Map<String, Object?> meta;
  final int? statusCode;

  bool get hasMessage => message != null && message!.trim().isNotEmpty;

  factory ApiResponse.fromJson(
    Map<String, Object?> json,
    T Function(Object? rawData) decoder,
  ) {
    final rawData = json.containsKey('data') ? json['data'] : json;

    return ApiResponse<T>(
      data: decoder(rawData),
      message: _readString(json['message']),
      meta: _readMap(json['meta']),
      statusCode: _readInt(json['statusCode']),
    );
  }

  static String? _readString(Object? value) {
    return ObjectUtils.castOrNull<String>(value)?.trim();
  }

  static Map<String, Object?> _readMap(Object? value) {
    if (value is! Map) {
      return const <String, Object?>{};
    }

    return Map<String, Object?>.from(value);
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
}
