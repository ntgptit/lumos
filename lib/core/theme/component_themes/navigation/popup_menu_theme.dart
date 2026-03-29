import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/visual/elevation_tokens.dart';

abstract final class LumosPopupMenuTheme {
  static PopupMenuThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
    TextTheme textTheme,
  ) {
    final AppThemePalette palette = AppThemePalette.fromBrightness(
      colorScheme.brightness,
    );

    return PopupMenuThemeData(
      color: colorScheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      elevation: AppElevationTokens.level2,
      shadowColor: palette.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: dims.shapes.card,
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      textStyle:
          textTheme.labelLarge ?? const TextStyle(fontWeight: FontWeight.w500),
      menuPadding: EdgeInsets.all(dims.spacing.xs),
      position: PopupMenuPosition.under,
    );
  }
}
