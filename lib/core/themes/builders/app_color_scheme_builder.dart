import 'package:flutter/material.dart';

import '../../constants/color_schemes.dart';

final class AppColorSchemeBuilder {
  static ColorScheme light({Color? seedColor}) {
    return buildLightColorScheme(seedColor: seedColor);
  }

  static ColorScheme dark({Color? seedColor}) {
    return buildDarkColorScheme(seedColor: seedColor);
  }
}
