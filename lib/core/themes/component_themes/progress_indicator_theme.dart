import 'package:flutter/material.dart';

abstract final class ProgressIndicatorThemes {
  static ProgressIndicatorThemeData build({required ColorScheme colorScheme}) {
    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.surfaceContainerHighest,
      circularTrackColor: colorScheme.surfaceContainerHighest,
    );
  }
}
