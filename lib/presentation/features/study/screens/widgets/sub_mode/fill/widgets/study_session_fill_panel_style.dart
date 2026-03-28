import 'package:flutter/material.dart';

abstract final class StudySessionFillPanelStyle {
  StudySessionFillPanelStyle._();

  static const InputDecoration termInputDecoration = InputDecoration(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding: EdgeInsets.zero,
    isCollapsed: true,
    filled: false,
  );

  static TextStyle? termTextStyle({
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return theme.textTheme.headlineLarge?.copyWith(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w600,
    );
  }
}
