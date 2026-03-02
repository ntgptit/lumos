import 'package:flutter/material.dart';

import '../../constants/color_schemes.dart' as app_color_schemes;

abstract final class AppColorSchemeBuilder {
  static ColorScheme build({required Brightness brightness, Color? seedColor}) {
    return switch (brightness) {
      Brightness.light => buildLightColorScheme(seedColor: seedColor),
      Brightness.dark => buildDarkColorScheme(seedColor: seedColor),
    };
  }

  static ColorScheme light({Color? seedColor}) {
    return buildLightColorScheme(seedColor: seedColor);
  }

  static ColorScheme dark({Color? seedColor}) {
    return buildDarkColorScheme(seedColor: seedColor);
  }

  static ColorScheme buildLightColorScheme({Color? seedColor}) {
    return app_color_schemes.buildLightColorScheme(seedColor: seedColor);
  }

  static ColorScheme buildDarkColorScheme({Color? seedColor}) {
    return app_color_schemes.buildDarkColorScheme(seedColor: seedColor);
  }
}
