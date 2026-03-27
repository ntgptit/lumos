abstract final class ObjectUtils {
  static T? castOrNull<T>(Object? value) {
    return value is T ? value : null;
  }

  static T? firstNonNull<T>(Iterable<T?> values) {
    for (final value in values) {
      if (value != null) {
        return value;
      }
    }
    return null;
  }

  static bool equalsAny<T>(T? value, Iterable<T> candidates) {
    for (final candidate in candidates) {
      if (value == candidate) {
        return true;
      }
    }
    return false;
  }

  static List<T>? castListOrNull<T>(Object? value) {
    if (value is! List) {
      return null;
    }
    if (value.any((element) => element is! T)) {
      return null;
    }
    return value.cast<T>();
  }
}
