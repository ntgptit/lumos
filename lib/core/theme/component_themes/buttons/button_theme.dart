import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class LumosButtonThemes {
  static FilledButtonThemeData filled(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    final shape = RoundedRectangleBorder(borderRadius: dims.shapes.control);

    return FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
        foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
        shadowColor: WidgetStatePropertyAll(
          colorScheme.shadow.withValues(alpha: AppOpacityTokens.strong),
        ),
        minimumSize: WidgetStatePropertyAll(
          Size(0, dims.componentSize.buttonHeight),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: dims.spacing.lg),
        ),
        shape: WidgetStatePropertyAll(shape),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: AppTypographyTokens.labelLarge,
            fontWeight: AppTypographyTokens.semibold,
          ),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData outlined(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(colorScheme.surface),
        foregroundColor: WidgetStatePropertyAll(colorScheme.onSurface),
        minimumSize: WidgetStatePropertyAll(
          Size(0, dims.componentSize.buttonHeight),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: dims.spacing.lg),
        ),
        side: WidgetStatePropertyAll(BorderSide(color: colorScheme.outline)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: dims.shapes.control),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: AppTypographyTokens.labelLarge,
            fontWeight: AppTypographyTokens.medium,
          ),
        ),
      ),
    );
  }

  static TextButtonThemeData text(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(colorScheme.primary),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: dims.spacing.md),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: dims.shapes.control),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: AppTypographyTokens.labelLarge,
            fontWeight: AppTypographyTokens.medium,
          ),
        ),
      ),
    );
  }
}
