import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

class DividerThemes {
  const DividerThemes._();

  static DividerThemeData build({required ColorScheme colorScheme}) {
    return DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: WidgetSizes.borderWidthRegular,
      space: Insets.spacing16,
    );
  }
}
