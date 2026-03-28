import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosButtonThemes {
  static FilledButtonThemeData filled(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(dims.radius.xs),
    );

    return FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(palette.primary),
        foregroundColor: const WidgetStatePropertyAll(AppColorTokens.white),
        shadowColor: WidgetStatePropertyAll(palette.primaryAccentShadow),
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
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(palette.surface),
        foregroundColor: WidgetStatePropertyAll(palette.textPrimary),
        minimumSize: WidgetStatePropertyAll(
          Size(0, dims.componentSize.buttonHeight),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: dims.spacing.lg),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(color: palette.outline),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dims.radius.xs),
          ),
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
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(palette.primary),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: dims.spacing.md),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dims.radius.xs),
          ),
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
