import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../shape.dart';

class CardThemes {
  const CardThemes._();

  static CardThemeData build({required ColorScheme colorScheme}) {
    return CardThemeData(
      elevation: WidgetSizes.none,
      color: colorScheme.surfaceContainerLow,
      margin: const EdgeInsets.all(Insets.spacing8),
      shape: AppShape.cardShape(),
    );
  }
}
