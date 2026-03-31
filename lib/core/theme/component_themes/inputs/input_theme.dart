import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class LumosInputTheme {
  static InputDecorationTheme build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    final border = OutlineInputBorder(
      borderRadius: dims.shapes.control,
      borderSide: BorderSide(
        color: colorScheme.outline,
        width: AppBorderTokens.thin,
      ),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
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
          color: colorScheme.primary,
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
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
