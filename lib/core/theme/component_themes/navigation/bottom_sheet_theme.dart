import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosBottomSheetTheme {
  static BottomSheetThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return BottomSheetThemeData(
      backgroundColor: palette.surface,
      modalBackgroundColor: palette.surface,
      elevation: AppElevationTokens.level2,
      modalElevation: AppElevationTokens.level3,
      shadowColor: palette.shadow,
      surfaceTintColor: Colors.transparent,
      constraints: BoxConstraints(maxWidth: dims.layout.panelMaxWidth),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(dims.radius.sm),
        ),
      ),
      showDragHandle: true,
      dragHandleColor: palette.outline,
      dragHandleSize: Size(dims.iconSize.xl, AppBorderTokens.thick),
    );
  }
}
