import 'package:lumos/core/storage/local_storage.dart';
import 'package:lumos/core/storage/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef SharedPreferencesLoader = Future<SharedPreferences> Function();

class PreferencesStorage extends InMemoryLocalStorage {
  PreferencesStorage({
    super.seed = const <String, Object?>{},
    SharedPreferences? preferences,
    SharedPreferencesLoader? preferencesLoader,
    Set<String>? allowList,
  }) : _preferences = preferences,
       _preferencesLoader = preferencesLoader ?? SharedPreferences.getInstance,
       _allowList = allowList ?? StorageKeys.all;

  SharedPreferences? _preferences;
  final SharedPreferencesLoader _preferencesLoader;
  final Set<String> _allowList;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    final preferences = await _ensurePreferences();
    _hydrateFrom(preferences);
    _isInitialized = true;
  }

  @override
  Future<void> write(String key, Object? value) async {
    _assertSupportedValue(value);
    await super.write(key, value);

    final preferences = await _ensurePreferences();
    await _persist(preferences, key, value);
  }

  @override
  Future<void> delete(String key) async {
    await super.delete(key);

    final preferences = await _ensurePreferences();
    await preferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await super.clear();

    final preferences = await _ensurePreferences();
    for (final key in _allowList) {
      await preferences.remove(key);
    }
  }

  Future<SharedPreferences> _ensurePreferences() async {
    final existing = _preferences;
    if (existing != null) {
      return existing;
    }

    final created = await _preferencesLoader();
    _preferences = created;
    return created;
  }

  void _hydrateFrom(SharedPreferences preferences) {
    for (final key in _allowList) {
      final value = preferences.get(key);
      if (value == null) {
        store.remove(key);
        continue;
      }

      store[key] = value is List<String> ? List<String>.of(value) : value;
    }
  }

  Future<void> _persist(
    SharedPreferences preferences,
    String key,
    Object? value,
  ) async {
    if (value == null) {
      await preferences.remove(key);
      return;
    }

    switch (value) {
      case bool boolValue:
        await preferences.setBool(key, boolValue);
      case int intValue:
        await preferences.setInt(key, intValue);
      case double doubleValue:
        await preferences.setDouble(key, doubleValue);
      case String stringValue:
        await preferences.setString(key, stringValue);
      case List<String> stringListValue:
        await preferences.setStringList(key, List<String>.of(stringListValue));
      default:
        throw ArgumentError.value(
          value,
          'value',
          'PreferencesStorage supports only bool, int, double, String, and List<String>.',
        );
    }
  }

  void _assertSupportedValue(Object? value) {
    if (value == null ||
        value is bool ||
        value is int ||
        value is double ||
        value is String ||
        value is List<String>) {
      return;
    }

    throw ArgumentError.value(
      value,
      'value',
      'PreferencesStorage supports only bool, int, double, String, and List<String>.',
    );
  }
}
