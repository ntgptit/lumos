abstract final class UrlUtils {
  static bool isAbsolute(String value) {
    final uri = Uri.tryParse(value);
    return uri != null && uri.hasScheme;
  }

  static Uri? tryParse(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return Uri.tryParse(value.trim());
  }

  static bool isWebUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  static Uri appendQueryParameters(
    String value,
    Map<String, String> queryParameters,
  ) {
    final uri = Uri.parse(value);
    return uri.replace(
      queryParameters: <String, String>{
        ...uri.queryParameters,
        ...queryParameters,
      },
    );
  }

  static String normalize(String value) {
    final uri = Uri.parse(value.trim());
    return uri.toString();
  }
}
