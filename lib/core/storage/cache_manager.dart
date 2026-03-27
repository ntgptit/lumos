import 'package:flutter/foundation.dart';

class CacheManager {
  CacheManager({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  final Map<String, _CacheEntry<Object?>> _entries = {};

  bool contains(String key) => read<Object?>(key) != null;

  T? read<T>(String key) {
    final entry = _entries[key];
    if (entry == null) {
      return null;
    }

    if (entry.isExpired(_now())) {
      _entries.remove(key);
      return null;
    }

    final value = entry.value;
    return value is T ? value : null;
  }

  void write(String key, Object? value, {Duration? ttl}) {
    _entries[key] = _CacheEntry<Object?>(
      value: value,
      expiresAt: ttl == null ? null : _now().add(ttl),
    );
  }

  T readOrLoad<T>(String key, T Function() loader, {Duration? ttl}) {
    final cached = read<T>(key);
    if (cached != null) {
      return cached;
    }

    final computed = loader();
    write(key, computed, ttl: ttl);
    return computed;
  }

  void remove(String key) {
    _entries.remove(key);
  }

  void clear() {
    _entries.clear();
  }

  void pruneExpired() {
    final now = _now();
    _entries.removeWhere((_, entry) => entry.isExpired(now));
  }
}

@immutable
class _CacheEntry<T> {
  const _CacheEntry({required this.value, required this.expiresAt});

  final T value;
  final DateTime? expiresAt;

  bool isExpired(DateTime now) {
    final deadline = expiresAt;
    if (deadline == null) {
      return false;
    }

    return !deadline.isAfter(now);
  }
}
