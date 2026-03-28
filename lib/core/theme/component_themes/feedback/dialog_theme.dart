import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class LumosDialogTheme {
  static DialogThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return DialogThemeData(
      backgroundColor: palette.dialogBackground,
      surfaceTintColor: Colors.transparent,
      elevation: AppElevationTokens.level3,
      shadowColor: palette.shadow,
      insetPadding: EdgeInsets.all(dims.componentSize.dialogPadding),
      constraints: BoxConstraints(maxWidth: dims.layout.dialogMaxWidth),
      titleTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: dims.typography.title,
        fontWeight: AppTypographyTokens.semibold,
      ),
      contentTextStyle: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: dims.typography.bodyMedium,
        fontWeight: AppTypographyTokens.regular,
        height: AppTypographyTokens.bodyHeight,
      ),
      shape: RoundedRectangleBorder(borderRadius: dims.shapes.dialog),
    );
  }
}
