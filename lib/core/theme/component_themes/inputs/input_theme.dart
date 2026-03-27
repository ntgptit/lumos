import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosInputTheme {
  static InputDecorationTheme build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    final isLight = colorScheme.brightness == Brightness.light;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        isLight ? dims.radius.sm : dims.radius.sm,
      ),
      borderSide: BorderSide(
        color: isLight
            ? AppColorTokens.lightOutlineVariant
            : AppColorTokens.darkOutline,
        width: AppBorderTokens.thin,
      ),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: isLight
          ? AppColorTokens.lightSurface
          : AppColorTokens.darkSurface,
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
          color: isLight
              ? AppColorTokens.lightPrimary
              : AppColorTokens.darkPrimary,
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
        color: isLight
            ? AppColorTokens.lightTextDisabled
            : AppColorTokens.darkTextDisabled,
      ),
    );
  }
}
