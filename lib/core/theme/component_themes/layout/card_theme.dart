import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosCardTheme {
  static CardThemeData build(ColorScheme colorScheme, DimensionThemeExt dims) {
    final isLight = colorScheme.brightness == Brightness.light;
    final side = isLight
        ? BorderSide(color: AppColorTokens.lightOutlineVariant)
        : BorderSide(color: AppColorTokens.darkCardStroke);

    return CardThemeData(
      elevation: isLight ? AppElevationTokens.level2 : AppElevationTokens.level0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: isLight ? colorScheme.surface : AppColorTokens.darkSurface,
      shadowColor: isLight ? AppColorTokens.lightShadow : Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isLight ? dims.radius.sm : dims.radius.sm,
        ),
        side: side,
      ),
    );
  }
}
