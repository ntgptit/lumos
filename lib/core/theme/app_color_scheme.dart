import 'package:flutter/material.dart';

import '../themes/builders/app_color_scheme_builder.dart';

abstract final class AppColorScheme {
  static ColorScheme build({required Brightness brightness, Color? seedColor}) {
    return AppColorSchemeBuilder.build(
      brightness: brightness,
      seedColor: seedColor,
    );
  }

  static ColorScheme light({Color? seedColor}) {
    return AppColorSchemeBuilder.light(seedColor: seedColor);
  }

  static ColorScheme dark({Color? seedColor}) {
    return AppColorSchemeBuilder.dark(seedColor: seedColor);
  }
}
