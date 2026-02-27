import 'package:flutter/material.dart';

class ProgressIndicatorThemes {
  const ProgressIndicatorThemes._();

  static ProgressIndicatorThemeData build({required ColorScheme colorScheme}) {
    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.surfaceContainerHighest,
      circularTrackColor: colorScheme.surfaceContainerHighest,
    );
  }
}
