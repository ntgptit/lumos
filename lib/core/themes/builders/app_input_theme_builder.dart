import 'package:flutter/material.dart';

import '../component/app_input_tokens.dart';
import '../extensions/theme_extensions.dart';

abstract final class AppInputThemeBuilder {
  static InputDecorationTheme inputDecorationTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppInputTokens inputTokens,
  }) {
    final BorderRadius borderRadius = BorderRadius.circular(
      inputTokens.borderRadius,
    );
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      isDense: false,
      contentPadding: inputTokens.contentPadding,
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      border: _outlineBorder(
        borderRadius: borderRadius,
        color: colorScheme.outlineVariant,
        width: inputTokens.borderWidth,
      ),
      enabledBorder: _outlineBorder(
        borderRadius: borderRadius,
        color: colorScheme.outlineVariant,
        width: inputTokens.borderWidth,
      ),
      focusedBorder: _outlineBorder(
        borderRadius: borderRadius,
        color: colorScheme.primary,
        width: inputTokens.focusedBorderWidth,
      ),
      errorBorder: _outlineBorder(
        borderRadius: borderRadius,
        color: colorScheme.error,
        width: inputTokens.borderWidth,
      ),
      focusedErrorBorder: _outlineBorder(
        borderRadius: borderRadius,
        color: colorScheme.error,
        width: inputTokens.focusedBorderWidth,
      ),
      disabledBorder: _outlineBorder(
        borderRadius: borderRadius,
        color: colorScheme.disabledContainerColor,
        width: inputTokens.borderWidth,
      ),
    );
  }
}

OutlineInputBorder _outlineBorder({
  required BorderRadius borderRadius,
  required Color color,
  required double width,
}) {
  return OutlineInputBorder(
    borderRadius: borderRadius,
    borderSide: BorderSide(color: color, width: width),
  );
}
