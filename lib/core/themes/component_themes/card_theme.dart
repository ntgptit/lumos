import 'package:flutter/material.dart';

import '../shape.dart';

abstract final class CardThemes {
  static const double _elevation = 1.0;
  static const double _darkModeLiftBlend = 0.35;

  static CardThemeData build({required ColorScheme colorScheme}) {
    return CardThemeData(
      elevation: _elevation,
      shadowColor: colorScheme.shadow,
      color: _resolveCardColor(colorScheme: colorScheme),
      surfaceTintColor: colorScheme.surfaceTint,
      clipBehavior: Clip.antiAlias,
      // Cards should not carry their own margin — let the parent layout decide.
      margin: EdgeInsets.zero,
      shape: AppShape.cardLarge(),
    );
  }

  static Color _resolveCardColor({required ColorScheme colorScheme}) {
    if (colorScheme.brightness != Brightness.dark) {
      return colorScheme.surfaceContainerLow;
    }
    return Color.lerp(
          colorScheme.surfaceContainerLow,
          colorScheme.surfaceContainer,
          _darkModeLiftBlend,
        ) ??
        colorScheme.surfaceContainer;
  }
}
