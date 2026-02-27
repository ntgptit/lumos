import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../shape.dart';

class CardThemes {
  const CardThemes._();

  static CardThemeData build({required ColorScheme colorScheme}) {
    final BorderSide borderSide = BorderSide(
      color: colorScheme.outlineVariant.withValues(
        alpha: WidgetOpacities.stateDrag,
      ),
      width: WidgetSizes.borderWidthRegular,
    );
    return CardThemeData(
      elevation: WidgetSizes.none,
      color: colorScheme.surfaceContainerLow,
      surfaceTintColor: colorScheme.surfaceTint,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(Insets.spacing8),
      shape: AppShape.cardShape(side: borderSide),
    );
  }
}
