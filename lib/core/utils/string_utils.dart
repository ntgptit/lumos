abstract final class StringUtils {
  StringUtils._();

  static String normalizeName(String rawValue) {
    return rawValue.replaceAll(RegExp(r'^\s+|\s+$'), '');
  }

  static String normalizeLower(String rawValue) {
    final String normalized = normalizeName(rawValue);
    return normalized.toLowerCase();
  }

  static String normalizeUpper(String rawValue) {
    final String normalized = normalizeName(rawValue);
    return normalized.toUpperCase();
  }

  static String normalizeLocaleTag(String rawValue) {
    final String normalized = normalizeName(rawValue);
    return normalized.replaceAll('_', '-');
  }

  static String localeLanguageCode(String rawValue) {
    final String normalized = normalizeLower(normalizeLocaleTag(rawValue));
    if (normalized.isEmpty) {
      return '';
    }
    final int separatorIndex = normalized.indexOf('-');
    if (separatorIndex < 0) {
      return normalized;
    }
    return prefix(normalized, separatorIndex);
  }

  static String firstLine(String rawValue) {
    final String normalized = normalizeName(rawValue);
    if (normalized.isEmpty) {
      return '';
    }
    final int lineBreakIndex = normalized.indexOf('\n');
    if (lineBreakIndex < 0) {
      return normalized;
    }
    return prefix(normalized, lineBreakIndex);
  }

  static int compareNormalizedLower(String left, String right) {
    final String normalizedLeft = normalizeLower(left);
    final String normalizedRight = normalizeLower(right);
    return normalizedLeft.compareTo(normalizedRight);
  }

  static String prefix(String rawValue, int endExclusive) {
    final int safeEnd = endExclusive.clamp(0, rawValue.length);
    return rawValue.substring(0, safeEnd);
  }

  static String suffix(String rawValue, int startInclusive) {
    final int safeStart = startInclusive.clamp(0, rawValue.length);
    return rawValue.substring(safeStart);
  }

  static String trailingCharacter(String rawValue) {
    if (rawValue.isEmpty) {
      return '';
    }
    return rawValue.substring(rawValue.length - 1);
  }
}
