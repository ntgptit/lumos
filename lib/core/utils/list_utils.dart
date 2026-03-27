abstract final class ListUtils {
  static bool isNullOrEmpty<T>(List<T>? values) {
    return values == null || values.isEmpty;
  }

  static List<T> replaceAt<T>(List<T> source, int index, T value) {
    final next = List<T>.of(source);
    next[index] = value;
    return next;
  }

  static List<T> toggle<T>(List<T> source, T value) {
    final next = List<T>.of(source);
    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }
    return next;
  }

  static T? safeElementAt<T>(List<T> source, int index) {
    if (index < 0 || index >= source.length) {
      return null;
    }
    return source[index];
  }

  static List<T> unique<T>(Iterable<T> values) {
    return values.toSet().toList();
  }

  static List<T> separatedBy<T>(Iterable<T> values, T separator) {
    final result = <T>[];
    for (final value in values) {
      if (result.isNotEmpty) {
        result.add(separator);
      }
      result.add(value);
    }
    return result;
  }
}
