import 'package:flutter/material.dart';

import '../shape.dart';

abstract final class CardThemes {
  static const double _elevation = 1.0;

  static CardThemeData build({required ColorScheme colorScheme}) {
    return CardThemeData(
      elevation: _elevation,
      shadowColor: colorScheme.shadow,
      color: colorScheme.surfaceContainerLow,
      surfaceTintColor: colorScheme.surfaceTint,
      clipBehavior: Clip.antiAlias,
      // Cards should not carry their own margin — let the parent layout decide.
      margin: EdgeInsets.zero,
      shape: AppShape.cardLarge(),
    );
  }
}
