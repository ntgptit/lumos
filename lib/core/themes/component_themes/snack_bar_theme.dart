import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../shape.dart';

class SnackBarThemes {
  const SnackBarThemes._();

  static SnackBarThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onInverseSurface,
      ),
      actionTextColor: colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: AppShape.cardShape(),
      elevation: WidgetSizes.none,
    );
  }
}
