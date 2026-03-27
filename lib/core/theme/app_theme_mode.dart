import 'package:flutter/material.dart';
import 'package:lumos/core/enums/app_theme_type.dart';

enum AppThemeMode { system, light, dark }

extension AppThemeModeX on AppThemeMode {
  AppThemeType get themeType {
    switch (this) {
      case AppThemeMode.system:
        return AppThemeType.system;
      case AppThemeMode.light:
        return AppThemeType.light;
      case AppThemeMode.dark:
        return AppThemeType.dark;
    }
  }

  ThemeMode get materialThemeMode {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  Brightness resolveBrightness(Brightness platformBrightness) {
    switch (this) {
      case AppThemeMode.system:
        return platformBrightness;
      case AppThemeMode.light:
        return Brightness.light;
      case AppThemeMode.dark:
        return Brightness.dark;
    }
  }
}

extension AppThemeTypeX on AppThemeType {
  AppThemeMode get appThemeMode {
    switch (this) {
      case AppThemeType.system:
        return AppThemeMode.system;
      case AppThemeType.light:
        return AppThemeMode.light;
      case AppThemeType.dark:
        return AppThemeMode.dark;
    }
  }
}
