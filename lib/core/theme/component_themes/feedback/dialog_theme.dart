import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosDialogTheme {
  static DialogThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    final isLight = colorScheme.brightness == Brightness.light;

    return DialogThemeData(
      backgroundColor: isLight
          ? AppColorTokens.lightSurface
          : AppColorTokens.darkDialogSurface,
      surfaceTintColor: Colors.transparent,
      elevation: AppElevationTokens.level3,
      shadowColor: isLight ? AppColorTokens.lightShadow : AppColorTokens.darkShadow,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isLight ? dims.radius.sm : dims.radius.sm,
        ),
      ),
    );
  }
}
