import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/storage_keys.dart';
import '../app_theme.dart';
import '../constants/color_schemes.dart';

part 'theme_provider.g.dart';

/// User-facing theme preference persisted in app state.
enum AppThemePreference { system, light, dark }

/// Shared constants for theme provider defaults.
class ThemeProviderConst {
  const ThemeProviderConst._();

  static const ThemeMode defaultThemeMode = ThemeMode.system;
  static const String themeModeSystem = 'system';
  static const String themeModeLight = 'light';
  static const String themeModeDark = 'dark';
}

/// Provides SharedPreferences instance for app-level persistence.
@Riverpod(keepAlive: true)
Future<SharedPreferences> appSharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}

/// Riverpod controller for the active [ThemeMode].
@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  /// Returns the default theme mode when provider is initialized.
  @override
  ThemeMode build() {
    _restoreThemeMode();
    return ThemeProviderConst.defaultThemeMode;
  }

  /// Updates theme mode and persists the choice.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) {
      return;
    }
    state = mode;
    await _persistThemeMode(mode: mode);
  }

  /// Applies theme mode from persisted or selected preference.
  Future<void> setPreference(AppThemePreference preference) async {
    final ThemeMode mode = _toThemeMode(preference: preference);
    await setThemeMode(mode);
  }

  /// Toggles quickly between light and dark mode.
  Future<void> toggleTheme() async {
    final ThemeMode nextMode = switch (state) {
      ThemeMode.dark => ThemeMode.light,
      _ => ThemeMode.dark,
    };
    await setThemeMode(nextMode);
  }

  ThemeMode _toThemeMode({required AppThemePreference preference}) {
    return switch (preference) {
      AppThemePreference.system => ThemeMode.system,
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
    };
  }

  ThemeMode _fromStorage({required String? rawValue}) {
    return switch (rawValue) {
      ThemeProviderConst.themeModeSystem => ThemeMode.system,
      ThemeProviderConst.themeModeLight => ThemeMode.light,
      ThemeProviderConst.themeModeDark => ThemeMode.dark,
      _ => ThemeProviderConst.defaultThemeMode,
    };
  }

  void _restoreThemeMode() {
    ref.read(appSharedPreferencesProvider.future).then((
      SharedPreferences prefs,
    ) {
      final String? rawValue = prefs.getString(StorageKeys.themeMode);
      final ThemeMode restoredMode = _fromStorage(rawValue: rawValue);
      if (state == restoredMode) {
        return;
      }
      state = restoredMode;
    });
  }

  Future<void> _persistThemeMode({required ThemeMode mode}) async {
    final SharedPreferences prefs = await ref.read(
      appSharedPreferencesProvider.future,
    );
    await prefs.setString(StorageKeys.themeMode, mode.name);
  }
}

/// Riverpod controller for seed color used to build app color schemes.
@Riverpod(keepAlive: true)
class AppSeedColor extends _$AppSeedColor {
  /// Returns the default color seed for theme generation.
  @override
  Color build() {
    return AppColorSchemeConst.seedColor;
  }

  /// Updates theme seed color.
  void setSeedColor(Color seedColor) {
    state = seedColor;
  }

  /// Resets theme seed color to app default.
  void resetSeedColor() {
    state = AppColorSchemeConst.seedColor;
  }
}

/// Provides light [ThemeData] based on current seed color state.
@Riverpod(keepAlive: true)
ThemeData appLightTheme(Ref ref) {
  final Color seedColor = ref.watch(appSeedColorProvider);
  return AppTheme.lightTheme(seedColor: seedColor);
}

/// Provides dark [ThemeData] based on current seed color state.
@Riverpod(keepAlive: true)
ThemeData appDarkTheme(Ref ref) {
  final Color seedColor = ref.watch(appSeedColorProvider);
  return AppTheme.darkTheme(seedColor: seedColor);
}
