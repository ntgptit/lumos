import 'package:flutter/material.dart';

import 'app_dark_theme.dart';
import 'app_light_theme.dart';

abstract final class AppTheme {
  static ThemeData get light => AppLightTheme.build();

  static ThemeData get dark => AppDarkTheme.build();

  static ThemeData lightTheme({Color? seedColor}) {
    return AppLightTheme.build(seedColor: seedColor);
  }

  static ThemeData darkTheme({Color? seedColor}) {
    return AppDarkTheme.build(seedColor: seedColor);
  }
}
