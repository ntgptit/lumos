import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosChipTheme {
  static ChipThemeData build(ColorScheme colorScheme, DimensionThemeExt dims) {
    final isLight = colorScheme.brightness == Brightness.light;

    return ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isLight ? dims.radius.xs : dims.radius.xs,
        ),
      ),
      side: BorderSide(
        color: isLight
            ? AppColorTokens.lightOutlineVariant
            : AppColorTokens.darkOutline,
      ),
      backgroundColor: isLight
          ? AppColorTokens.lightSurfaceContainerLow
          : AppColorTokens.darkSurfaceContainerLow,
      selectedColor: isLight
          ? AppColorTokens.lightPrimaryContainer
          : AppColorTokens.darkPrimaryContainer,
      padding: EdgeInsets.symmetric(horizontal: dims.spacing.sm),
      labelPadding: EdgeInsets.zero,
      showCheckmark: false,
    );
  }
}
