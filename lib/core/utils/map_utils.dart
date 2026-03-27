abstract final class MapUtils {
  static Map<K, V> merge<K, V>(Map<K, V> base, [Map<K, V> extra = const {}]) {
    return <K, V>{...base, ...extra};
  }

  static Map<K, V> compact<K, V>(Map<K, V?> source) {
    final result = <K, V>{};
    source.forEach((key, value) {
      if (value != null) {
        result[key] = value;
      }
    });
    return result;
  }

  static Map<K, V> copyWithout<K, V>(Map<K, V> source, Iterable<K> keys) {
    final next = Map<K, V>.of(source);
    for (final key in keys) {
      next.remove(key);
    }
    return next;
  }

  static Map<K, V> filterValues<K, V>(
    Map<K, V> source,
    bool Function(V value) predicate,
  ) {
    final result = <K, V>{};
    source.forEach((key, value) {
      if (predicate(value)) {
        result[key] = value;
      }
    });
    return result;
  }
}
