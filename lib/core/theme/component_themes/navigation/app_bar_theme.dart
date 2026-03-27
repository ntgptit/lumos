import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosAppBarTheme {
  static AppBarTheme build({
    required ColorScheme colorScheme,
    required DimensionThemeExt dims,
  }) {
    final isLight = colorScheme.brightness == Brightness.light;
    final foregroundColor = isLight
        ? AppColorTokens.lightHeaderForeground
        : AppColorTokens.darkHeaderForeground;

    return AppBarTheme(
      centerTitle: false,
      elevation: AppElevationTokens.level0,
      scrolledUnderElevation: isLight
          ? AppElevationTokens.level1
          : AppElevationTokens.level2,
      backgroundColor: isLight
          ? AppColorTokens.lightHeaderBackground
          : AppColorTokens.darkHeaderBackgroundFrosted,
      foregroundColor: foregroundColor,
      shadowColor: isLight
          ? AppColorTokens.lightShadow
          : AppColorTokens.darkShadow,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: dims.componentSize.toolbarHeight,
      titleSpacing: dims.spacing.lg,
      titleTextStyle: TextStyle(
        color: foregroundColor,
        fontSize: dims.typography.title,
        fontWeight: AppTypographyTokens.semibold,
      ),
    );
  }
}
