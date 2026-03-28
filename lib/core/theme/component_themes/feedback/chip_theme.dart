import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';

abstract final class LumosChipTheme {
  static ChipThemeData build(ColorScheme colorScheme, DimensionThemeExt dims) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dims.radius.xs),
      ),
      side: BorderSide(color: palette.outline),
      backgroundColor: palette.surfaceContainerLow,
      selectedColor: palette.primaryContainer,
      padding: EdgeInsets.symmetric(horizontal: dims.spacing.sm),
      labelPadding: EdgeInsets.zero,
      showCheckmark: false,
    );
  }
}
