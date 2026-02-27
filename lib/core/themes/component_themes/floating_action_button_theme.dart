import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../shape.dart';

class FloatingActionButtonThemes {
  const FloatingActionButtonThemes._();

  static FloatingActionButtonThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      elevation: WidgetSizes.none,
      focusElevation: WidgetSizes.none,
      hoverElevation: WidgetSizes.none,
      highlightElevation: WidgetSizes.none,
      disabledElevation: WidgetSizes.none,
      shape: AppShape.buttonShape(),
      extendedTextStyle: textTheme.labelLarge,
    );
  }
}
