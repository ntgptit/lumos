import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';

abstract final class StudySessionFillPanelStyle {
  StudySessionFillPanelStyle._();

  static const double termLineHeight =
      AppTypographyConst.headlineLargeLineHeight /
      AppTypographyConst.headlineLargeFontSize;

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
      height: termLineHeight,
    );
  }
}
