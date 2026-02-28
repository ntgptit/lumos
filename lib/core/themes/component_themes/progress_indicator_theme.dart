import 'package:flutter/material.dart';

abstract final class ProgressIndicatorThemes {
  static const double _linearMinHeight = 4.0;

  static ProgressIndicatorThemeData build({required ColorScheme colorScheme}) {
    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.surfaceContainerHighest,
      circularTrackColor: colorScheme.surfaceContainerHighest,
      linearMinHeight: _linearMinHeight,
      refreshBackgroundColor: colorScheme.surfaceContainerHigh,
    );
  }
}
