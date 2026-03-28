import 'package:lumos/core/utils/string_utils.dart';

abstract final class ValidationUtils {
  static final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );
  static final RegExp _urlPattern = RegExp(
    r'^(https?:\/\/)?([A-Za-z0-9-]+\.)+[A-Za-z]{2,}(\/.*)?$',
  );

  static bool hasText(String? value) {
    return StringUtils.hasText(value);
  }

  static bool isEmail(String? value) {
    if (!hasText(value)) {
      return false;
    }
    return _emailPattern.hasMatch(StringUtils.normalizeText(value!));
  }

  static bool hasMinLength(String? value, int minLength) {
    return (StringUtils.trimmedOrNull(value)?.length ?? 0) >= minLength;
  }

  static bool hasMaxLength(String? value, int maxLength) {
    return (StringUtils.trimmedOrNull(value)?.length ?? 0) <= maxLength;
  }

  static bool isUrl(String? value) {
    if (!hasText(value)) {
      return false;
    }
    return _urlPattern.hasMatch(StringUtils.normalizeText(value!));
  }

  static bool matches(String? value, Pattern pattern) {
    if (!hasText(value)) {
      return false;
    }
    final normalized = StringUtils.normalizeText(value!);
    if (pattern is RegExp) {
      return pattern.hasMatch(normalized);
    }
    return RegExp(pattern.toString()).hasMatch(normalized);
  }
}
