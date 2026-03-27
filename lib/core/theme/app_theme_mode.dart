import 'package:flutter/material.dart';

enum AppThemeModeOption {
  system,
  light,
  dark;

  static AppThemeModeOption fromThemeMode(ThemeMode themeMode) {
    return switch (themeMode) {
      ThemeMode.system => AppThemeModeOption.system,
      ThemeMode.light => AppThemeModeOption.light,
      ThemeMode.dark => AppThemeModeOption.dark,
    };
  }

  static AppThemeModeOption fromStorage(String? rawValue) {
    return switch (rawValue) {
      'system' => AppThemeModeOption.system,
      'light' => AppThemeModeOption.light,
      'dark' => AppThemeModeOption.dark,
      _ => AppThemeModeOption.system,
    };
  }

  ThemeMode get themeMode {
    return switch (this) {
      AppThemeModeOption.system => ThemeMode.system,
      AppThemeModeOption.light => ThemeMode.light,
      AppThemeModeOption.dark => ThemeMode.dark,
    };
  }

  String get storageValue => name;
}
