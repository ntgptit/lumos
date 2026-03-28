import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class LumosDividerTheme {
  static DividerThemeData build(ColorScheme colorScheme) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return DividerThemeData(
      color: palette.separator,
      thickness: AppBorderTokens.thin,
      space: 1,
    );
  }
}
