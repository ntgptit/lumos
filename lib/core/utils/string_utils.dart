abstract final class StringUtils {
  StringUtils._();

  static String normalizeName(String rawValue) {
    return rawValue.replaceAll(RegExp(r'^\s+|\s+$'), '');
  }
}
