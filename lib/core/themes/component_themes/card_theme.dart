import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../shape.dart';

class CardThemes {
  const CardThemes._();

  static const double defaultCardElevation = 1;

  static CardThemeData build({required ColorScheme colorScheme}) {
    final BorderSide borderSide = BorderSide(
      color: colorScheme.outlineVariant.withValues(
        alpha: WidgetOpacities.stateDrag,
      ),
      width: WidgetSizes.borderWidthRegular,
    );
    return CardThemeData(
      elevation: defaultCardElevation,
      shadowColor: colorScheme.shadow.withValues(
        alpha: WidgetOpacities.elevationLevel2,
      ),
      color: colorScheme.surfaceContainer,
      surfaceTintColor: colorScheme.surfaceTint,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(Insets.spacing0),
      shape: AppShape.cardShape(side: borderSide),
    );
  }
}
