import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class LumosBottomSheetTheme {
  static BottomSheetThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    return BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      modalBackgroundColor: colorScheme.surface,
      elevation: AppElevationTokens.level2,
      modalElevation: AppElevationTokens.level3,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      constraints: BoxConstraints(maxWidth: dims.layout.panelMaxWidth),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: dims.shapes.sheet.topLeft,
          topRight: dims.shapes.sheet.topRight,
        ),
      ),
      showDragHandle: true,
      dragHandleColor: colorScheme.outline,
      dragHandleSize: Size(dims.iconSize.xl, AppBorderTokens.thick),
    );
  }
}
