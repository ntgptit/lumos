import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosButtonThemes {
  static FilledButtonThemeData filled(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    final isLight = colorScheme.brightness == Brightness.light;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        isLight ? dims.radius.xs : dims.radius.xs,
      ),
    );

    return FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          isLight ? AppColorTokens.lightPrimary : AppColorTokens.darkPrimary,
        ),
        foregroundColor: WidgetStatePropertyAll(
          AppColorTokens.white,
        ),
        shadowColor: WidgetStatePropertyAll(
          isLight
              ? AppColorTokens.primaryAlpha10
              : AppColorTokens.darkPrimaryContainerStrong,
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
    final isLight = colorScheme.brightness == Brightness.light;

    return OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          isLight ? AppColorTokens.lightSurface : AppColorTokens.darkSurface,
        ),
        foregroundColor: WidgetStatePropertyAll(
          isLight
              ? AppColorTokens.lightTextPrimary
              : AppColorTokens.darkTextPrimary,
        ),
        minimumSize: WidgetStatePropertyAll(
          Size(0, dims.componentSize.buttonHeight),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: dims.spacing.lg),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: isLight
                ? AppColorTokens.lightOutlineVariant
                : AppColorTokens.darkOutline,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              isLight ? dims.radius.xs : dims.radius.xs,
            ),
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
    final isLight = colorScheme.brightness == Brightness.light;

    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(
          isLight ? AppColorTokens.lightPrimary : AppColorTokens.darkPrimary,
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: dims.spacing.md),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              isLight ? dims.radius.xs : dims.radius.xs,
            ),
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
