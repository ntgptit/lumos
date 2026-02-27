import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

class SliderThemes {
  const SliderThemes._();

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
    );
  }
}
