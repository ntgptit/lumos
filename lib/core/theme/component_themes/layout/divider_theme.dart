import 'package:flutter/material.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosDividerTheme {
  static DividerThemeData build(ColorScheme colorScheme) {
    final isLight = colorScheme.brightness == Brightness.light;

    return DividerThemeData(
      color: isLight
          ? colorScheme.outlineVariant
          : AppColorTokens.darkTextSubtle,
      thickness: AppBorderTokens.thin,
      space: 1,
    );
  }
}
