import 'package:flutter/material.dart';

class ListTileThemes {
  const ListTileThemes._();

  static ListTileThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return ListTileThemeData(
      iconColor: colorScheme.onSurfaceVariant,
      textColor: colorScheme.onSurface,
      selectedColor: colorScheme.primary,
      titleTextStyle: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
      subtitleTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
