import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_theme.dart';
import 'color_schemes.dart';

part 'theme_provider.g.dart';

/// User-facing theme preference persisted in app state.
enum AppThemePreference { system, light, dark }

/// Shared constants for theme provider defaults.
class ThemeProviderConst {
  const ThemeProviderConst._();

  static const ThemeMode defaultThemeMode = ThemeMode.system;
}

/// Riverpod controller for the active [ThemeMode].
@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  /// Returns the default theme mode when provider is initialized.
  @override
  ThemeMode build() {
    return ThemeProviderConst.defaultThemeMode;
  }

  /// Switches to system theme mode.
  void setSystem() {
    state = ThemeMode.system;
  }

  /// Switches to light theme mode.
  void setLight() {
    state = ThemeMode.light;
  }

  /// Switches to dark theme mode.
  void setDark() {
    state = ThemeMode.dark;
  }

  /// Applies theme mode from persisted or selected preference.
  void setPreference(AppThemePreference preference) {
    if (preference == AppThemePreference.system) {
      setSystem();
      return;
    }
    if (preference == AppThemePreference.light) {
      setLight();
      return;
    }
    setDark();
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
