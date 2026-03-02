import 'package:flutter/material.dart';

import 'app_dark_theme.dart';
import 'app_light_theme.dart';

abstract final class AppTheme {
  static final ThemeData _light = AppLightTheme.build();
  static final ThemeData _dark = AppDarkTheme.build();

  static ThemeData get light => _light;

  static ThemeData get dark => _dark;

  static ThemeData lightTheme({Color? seedColor}) {
    return AppLightTheme.build(seedColor: seedColor);
  }

  static ThemeData darkTheme({Color? seedColor}) {
    return AppDarkTheme.build(seedColor: seedColor);
  }
}
