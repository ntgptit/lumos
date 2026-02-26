import 'package:flutter/material.dart';

import '../../constants/dimensions.dart';
import '../shape.dart';

class DialogThemes {
  const DialogThemes._();

  static DialogThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return DialogThemeData(
      elevation: WidgetSizes.none,
      backgroundColor: colorScheme.surface,
      shape: AppShape.dialogShape(),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
