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

  static int compareNormalizedLower(String left, String right) {
    final String normalizedLeft = normalizeLower(left);
    final String normalizedRight = normalizeLower(right);
    return normalizedLeft.compareTo(normalizedRight);
  }
}
