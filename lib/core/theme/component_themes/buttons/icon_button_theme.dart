import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';

abstract final class LumosIconButtonTheme {
  static IconButtonThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    return IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          Size.square(dims.componentSize.buttonHeight),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: dims.shapes.control),
        ),
      ),
    );
  }
}
