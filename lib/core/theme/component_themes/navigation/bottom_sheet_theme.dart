import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosBottomSheetTheme {
  static BottomSheetThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    final isLight = colorScheme.brightness == Brightness.light;

    return BottomSheetThemeData(
      backgroundColor: isLight
          ? AppColorTokens.lightSurface
          : AppColorTokens.darkSurface,
      modalBackgroundColor: isLight
          ? AppColorTokens.lightSurface
          : AppColorTokens.darkSurface,
      elevation: AppElevationTokens.level2,
      modalElevation: AppElevationTokens.level3,
      shadowColor: isLight ? AppColorTokens.lightShadow : AppColorTokens.darkShadow,
      surfaceTintColor: Colors.transparent,
      constraints: BoxConstraints(maxWidth: dims.layout.panelMaxWidth),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isLight ? dims.radius.sm : dims.radius.sm),
        ),
      ),
      showDragHandle: true,
      dragHandleColor: isLight
          ? AppColorTokens.lightOutline
          : AppColorTokens.darkOutline,
      dragHandleSize: Size(dims.iconSize.xl, AppBorderTokens.thick),
    );
  }
}
