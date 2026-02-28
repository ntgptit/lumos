import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class ProgressIndicatorThemes {
  static const double _linearMinHeight = WidgetSizes.progressTrackHeight;

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
