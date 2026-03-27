import 'package:flutter/foundation.dart';

abstract interface class LocalStorage {
  bool contains(String key);

  T? read<T>(String key);

  Future<void> write(String key, Object? value);

  Future<void> delete(String key);

  Future<void> clear();
}

class InMemoryLocalStorage implements LocalStorage {
  InMemoryLocalStorage({Map<String, Object?> seed = const <String, Object?>{}})
    : _store = Map<String, Object?>.of(seed);

  @protected
  final Map<String, Object?> _store;

  @protected
  Map<String, Object?> get store => _store;

  @visibleForTesting
  Map<String, Object?> get snapshot =>
      Map<String, Object?>.unmodifiable(_store);

  @override
  bool contains(String key) => _store.containsKey(key);

  @override
  T? read<T>(String key) {
    final value = _store[key];
    return value is T ? value : null;
  }

  @override
  Future<void> write(String key, Object? value) async {
    _store[key] = _cloneValue(value);
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }

  Object? _cloneValue(Object? value) {
    if (value is List<String>) {
      return List<String>.of(value);
    }
    return value;
  }
}

extension LocalStorageX on LocalStorage {
  String? readString(String key) => read<String>(key);

  bool? readBool(String key) => read<bool>(key);

  int? readInt(String key) => read<int>(key);

  double? readDouble(String key) => read<double>(key);

  List<String>? readStringList(String key) => read<List<String>>(key);
}
