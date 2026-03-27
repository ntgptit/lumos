import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  FlutterSecureStorage get rawStorage {
    return _storage;
  }

  Future<bool> contains(String key) {
    return _storage.containsKey(key: key);
  }

  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  Future<Map<String, String>> readAll({Set<String>? allowList}) async {
    final values = await _storage.readAll();
    if (allowList == null) {
      return values;
    }

    return Map<String, String>.fromEntries(
      values.entries.where((entry) => allowList.contains(entry.key)),
    );
  }

  Future<void> write(String key, String? value) {
    return _storage.write(key: key, value: value);
  }

  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }

  Future<void> clear({Set<String>? keys}) async {
    if (keys == null) {
      await _storage.deleteAll();
      return;
    }

    for (final key in keys) {
      await _storage.delete(key: key);
    }
  }
}
