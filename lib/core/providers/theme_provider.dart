import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';
import '../theme/app_theme.dart';

part 'theme_provider.g.dart';

/// Shared constants for theme provider defaults.
abstract final class ThemeProviderConst {
  static const ThemeMode defaultThemeMode = ThemeMode.system;
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
  Future<void> setPreference(AppThemeModeOption preference) async {
    await setThemeMode(preference.themeMode);
  }

  /// Toggles quickly between light and dark mode.
  Future<void> toggleTheme() async {
    final ThemeMode nextMode = switch (state) {
      ThemeMode.dark => ThemeMode.light,
      _ => ThemeMode.dark,
    };
    await setThemeMode(nextMode);
  }

  ThemeMode _fromStorage({required String? rawValue}) {
    return AppThemeModeOption.fromStorage(rawValue).themeMode;
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
    final String storageValue = AppThemeModeOption.fromThemeMode(
      mode,
    ).storageValue;
    await prefs.setString(StorageKeys.themeMode, storageValue);
  }
}

/// Riverpod controller for seed color used to build app color schemes.
@Riverpod(keepAlive: true)
class AppSeedColor extends _$AppSeedColor {
  /// Returns the default color seed for theme generation.
  @override
  Color? build() {
    return null;
  }

  /// Updates theme seed color.
  void setSeedColor(Color seedColor) {
    state = seedColor;
  }

  /// Resets theme seed color to app default.
  void resetSeedColor() {
    state = null;
  }
}

/// Provides light [ThemeData] based on current seed color state.
@Riverpod(keepAlive: true)
ThemeData appLightTheme(Ref ref) {
  final Color? seedColor = ref.watch(appSeedColorProvider);
  return AppTheme.lightTheme(seedColor: seedColor);
}

/// Provides dark [ThemeData] based on current seed color state.
@Riverpod(keepAlive: true)
ThemeData appDarkTheme(Ref ref) {
  final Color? seedColor = ref.watch(appSeedColorProvider);
  return AppTheme.darkTheme(seedColor: seedColor);
}
