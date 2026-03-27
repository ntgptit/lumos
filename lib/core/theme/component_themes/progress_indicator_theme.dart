import 'package:flutter/material.dart';

import '../../themes/builders/app_feedback_theme_builder.dart';

abstract final class AppProgressIndicatorTheme {
  static ProgressIndicatorThemeData build({required ThemeData theme}) {
    return AppFeedbackThemeBuilder.progressIndicatorTheme(
      colorScheme: theme.colorScheme,
    );
  }
}
