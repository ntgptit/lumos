import 'package:flutter/material.dart';
import 'package:lumos/core/enums/app_theme_type.dart';
import 'package:lumos/core/theme/app_theme.dart';
import 'package:lumos/core/theme/app_theme_mode.dart';
import 'package:lumos/core/theme/responsive/screen_info.dart';

abstract final class ThemeHelpers {
  static ScreenInfo screenInfoOf(BuildContext context) {
    return ScreenInfo.fromContext(context);
  }

  static AppThemeMode resolveAppThemeMode(AppThemeType themeType) {
    return themeType.appThemeMode;
  }

  static ThemeMode resolveThemeMode(AppThemeType themeType) {
    return resolveAppThemeMode(themeType).materialThemeMode;
  }

  static Brightness resolveBrightness(
    BuildContext context, {
    required AppThemeType themeType,
  }) {
    return resolveAppThemeMode(
      themeType,
    ).resolveBrightness(MediaQuery.platformBrightnessOf(context));
  }

  static ThemeData lightTheme(BuildContext context) {
    return AppTheme.light(screenInfo: screenInfoOf(context));
  }

  static ThemeData darkTheme(BuildContext context) {
    return AppTheme.dark(screenInfo: screenInfoOf(context));
  }

  static ThemeData resolveTheme(
    BuildContext context, {
    required AppThemeType themeType,
  }) {
    return AppTheme.resolve(
      mode: resolveAppThemeMode(themeType),
      screenInfo: screenInfoOf(context),
      platformBrightness: MediaQuery.platformBrightnessOf(context),
    );
  }
}
