import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../shape.dart';

class ChipThemes {
  const ChipThemes._();

  static ChipThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      selectedColor: colorScheme.secondaryContainer,
      disabledColor: colorScheme.onSurface.withValues(
        alpha: WidgetOpacities.divider,
      ),
      side: BorderSide(
        color: colorScheme.outline,
        width: WidgetSizes.borderWidthRegular,
      ),
      shape: AppShape.cardShape(
        side: BorderSide(
          color: colorScheme.outline,
          width: WidgetSizes.borderWidthRegular,
        ),
      ),
      labelStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      secondaryLabelStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSecondaryContainer,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.spacing12,
        vertical: Insets.spacing8,
      ),
      showCheckmark: false,
    );
  }
}
