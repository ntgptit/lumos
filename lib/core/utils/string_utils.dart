abstract final class StringUtils {
  static String normalizeName(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String normalizeText(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value.trim();
  }

  static String normalizeSearchQuery(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool isBlank(String? value) {
    return value == null || value.trim().isEmpty;
  }

  static String? trimmedOrNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static String capitalize(String value) {
    if (value.trim().isEmpty) {
      return value;
    }
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  static String normalizeWhitespace(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool equalsIgnoreCase(String? left, String? right) {
    return trimmedOrNull(left)?.toLowerCase() ==
        trimmedOrNull(right)?.toLowerCase();
  }

  static String initials(String value, {int maxLength = 2}) {
    final words = normalizeWhitespace(
      value,
    ).split(' ').where((word) => word.isNotEmpty);
    final chars = words
        .take(maxLength)
        .map((word) => word[0].toUpperCase())
        .join();
    return chars;
  }

  static String truncate(
    String value, {
    required int maxLength,
    String ellipsis = '...',
  }) {
    if (maxLength <= 0 || value.length <= maxLength) {
      return value;
    }
    if (ellipsis.length >= maxLength) {
      return ellipsis.substring(0, maxLength);
    }
    return '${value.substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
}
