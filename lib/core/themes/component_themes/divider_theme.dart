import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class DividerThemes {
  static const double _thickness = WidgetSizes.borderWidthRegular;

  static DividerThemeData build({required ColorScheme colorScheme}) {
    return DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: _thickness,
      space: Insets.spacing16,
    );
  }
}
