import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosInputTheme {
  static InputDecorationTheme build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(dims.radius.sm),
      borderSide: BorderSide(
        color: palette.outline,
        width: AppBorderTokens.thin,
      ),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: palette.surface,
      contentPadding: EdgeInsets.symmetric(
        horizontal: dims.spacing.md,
        vertical:
            (dims.componentSize.inputHeight - AppTypographyTokens.bodyLarge) /
            2,
      ),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(
          color: palette.primary,
          width: AppBorderTokens.regular,
        ),
      ),
      errorBorder: border.copyWith(
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(
          color: colorScheme.error,
          width: AppBorderTokens.regular,
        ),
      ),
      hintStyle: TextStyle(
        fontSize: AppTypographyTokens.bodyLarge,
        color: palette.textDisabled,
      ),
    );
  }
}
