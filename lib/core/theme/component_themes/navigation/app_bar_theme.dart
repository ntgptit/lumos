import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosAppBarTheme {
  static AppBarTheme build({
    required ColorScheme colorScheme,
    required DimensionThemeExt dims,
  }) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return AppBarTheme(
      centerTitle: false,
      elevation: AppElevationTokens.level0,
      scrolledUnderElevation: palette.headerScrolledUnderElevation,
      backgroundColor: palette.headerBackground,
      foregroundColor: palette.headerForeground,
      shadowColor: palette.shadow,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: dims.componentSize.toolbarHeight,
      titleSpacing: dims.spacing.lg,
      titleTextStyle: TextStyle(
        color: palette.headerForeground,
        fontSize: dims.typography.title,
        fontWeight: AppTypographyTokens.semibold,
      ),
    );
  }
}
