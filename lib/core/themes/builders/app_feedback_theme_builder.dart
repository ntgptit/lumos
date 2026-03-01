import 'package:flutter/material.dart';

import '../../constants/dimensions.dart';
import '../extensions/theme_extensions.dart';

abstract final class AppFeedbackThemeBuilder {
  static ProgressIndicatorThemeData progressIndicatorTheme({
    required ColorScheme colorScheme,
  }) {
    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.secondaryContainer,
      circularTrackColor: colorScheme.secondaryContainer,
      linearMinHeight: WidgetSizes.progressTrackHeight,
    );
  }

  static SnackBarThemeData snackBarTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.inverseOnSurface,
      ),
      actionTextColor: colorScheme.inversePrimary,
      closeIconColor: colorScheme.inverseOnSurface,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: Insets.spacing16,
        vertical: Insets.spacing8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radius.radiusSmall),
      ),
    );
  }
}
