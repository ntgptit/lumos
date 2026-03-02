import 'package:flutter/material.dart';

import '../../constants/dimensions.dart';
import '../semantic/app_elevation_tokens.dart';
import '../foundation/app_radius.dart';

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
      elevation: AppElevationTokens.level3,
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onInverseSurface,
      ),
      actionTextColor: colorScheme.inversePrimary,
      closeIconColor: colorScheme.onInverseSurface,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: Insets.spacing16,
        vertical: Insets.spacing8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    );
  }
}
