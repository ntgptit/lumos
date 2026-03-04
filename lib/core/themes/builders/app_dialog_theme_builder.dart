import 'package:flutter/material.dart';

import '../component/app_dialog_tokens.dart';
import '../foundation/app_foundation.dart';

abstract final class AppDialogThemeBuilder {
  static DialogThemeData dialogTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppDialogTokens dialogTokens,
  }) {
    return DialogThemeData(
      backgroundColor: colorScheme.surfaceContainerHigh,
      surfaceTintColor: colorScheme.surfaceTint,
      titleTextStyle: textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
      ),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dialogTokens.radius),
      ),
      insetPadding: dialogTokens.insetPaddingMobile,
    );
  }

  static BottomSheetThemeData bottomSheetTheme({
    required ColorScheme colorScheme,
    required AppDialogTokens dialogTokens,
  }) {
    return BottomSheetThemeData(
      backgroundColor: colorScheme.surfaceContainerHigh,
      surfaceTintColor: colorScheme.surfaceTint,
      dragHandleColor: colorScheme.outlineVariant,
      dragHandleSize: const Size(AppSpacing.xxxl, AppSpacing.xs),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dialogTokens.radius),
      ),
    );
  }
}
