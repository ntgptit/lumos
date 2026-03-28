import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class LumosCardTheme {
  static CardThemeData build(ColorScheme colorScheme, DimensionThemeExt dims) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return CardThemeData(
      elevation: colorScheme.brightness == Brightness.light
          ? AppElevationTokens.level2
          : AppElevationTokens.level0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: palette.cardBackground,
      shadowColor: colorScheme.brightness == Brightness.light
          ? palette.shadow
          : Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: dims.shapes.card,
        side: BorderSide(color: palette.cardBorder),
      ),
    );
  }
}
