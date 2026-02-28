import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../extensions/color_scheme_state_extensions.dart';

abstract final class ListTileThemes {
  static ListTileThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return ListTileThemeData(
      iconColor: colorScheme.onSurfaceVariant,
      textColor: colorScheme.onSurface,
      selectedColor: colorScheme.primary,
      tileColor: colorScheme.transparentSurfaceColor,
      selectedTileColor: colorScheme.secondaryContainer,
      dense: false,
      minLeadingWidth: IconSizes.iconLarge,
      minVerticalPadding: Insets.spacing8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radius.radiusLarge),
      ),
      titleTextStyle: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      subtitleTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
