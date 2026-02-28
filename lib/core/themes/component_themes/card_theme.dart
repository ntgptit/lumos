import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../shape.dart';

abstract final class CardThemes {
  // Elevation level 1 keeps cards subtly lifted without heavy shadow (M3 style).
  static const double _elevation =
      WidgetOpacities.elevationLevel1 * 10; // → 0.5

  static CardThemeData build({required ColorScheme colorScheme}) {
    final BorderSide borderSide = BorderSide(
      color: colorScheme.outlineVariant.withValues(
        // divider opacity (0.12) fits border semantics better than stateDrag (0.16)
        alpha: WidgetOpacities.divider,
      ),
      width: WidgetSizes.borderWidthRegular,
    );

    return CardThemeData(
      elevation: _elevation,
      shadowColor: colorScheme.shadow.withValues(
        alpha: WidgetOpacities.elevationLevel2,
      ),
      color: colorScheme.surfaceContainer,
      surfaceTintColor: colorScheme.surfaceTint,
      clipBehavior: Clip.antiAlias,
      // Cards should not carry their own margin — let the parent layout decide.
      margin: EdgeInsets.zero,
      shape: AppShape.card(side: borderSide),
    );
  }
}
