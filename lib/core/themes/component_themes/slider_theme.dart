import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class SliderThemes {
  static const double _trackHeight = 4.0;

  static SliderThemeData build({required ColorScheme colorScheme}) {
    return SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: colorScheme.surfaceContainerHighest,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withValues(
        alpha: WidgetOpacities.statePress,
      ),
      valueIndicatorColor: colorScheme.primaryContainer,
      valueIndicatorTextStyle: TextStyle(color: colorScheme.onPrimaryContainer),
      trackHeight: _trackHeight,
    );
  }
}
