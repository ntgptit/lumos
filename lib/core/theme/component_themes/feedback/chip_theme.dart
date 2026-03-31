import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';

abstract final class LumosChipTheme {
  static ChipThemeData build(ColorScheme colorScheme, DimensionThemeExt dims) {
    return ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: dims.shapes.chip),
      side: BorderSide(color: colorScheme.outline),
      backgroundColor: colorScheme.surfaceContainerLow,
      selectedColor: colorScheme.primaryContainer,
      padding: EdgeInsets.symmetric(horizontal: dims.spacing.sm),
      labelPadding: EdgeInsets.zero,
      showCheckmark: false,
    );
  }
}
