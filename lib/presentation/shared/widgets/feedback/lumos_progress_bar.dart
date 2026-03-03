import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../core/themes/semantic/app_color_tokens.dart';

abstract final class LumosProgressBarConst {
  LumosProgressBarConst._();

  static const double defaultHeight = Insets.spacing8;
}

class LumosProgressBar extends StatelessWidget {
  const LumosProgressBar({
    required this.value,
    super.key,
    this.height,
    this.useTertiary = false,
  });

  final double value;
  final double? height;
  final bool useTertiary;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    final ColorScheme colorScheme = context.colorScheme;
    final AppColorTokens appColors = context.appColors;
    final ProgressIndicatorThemeData indicatorTheme =
        theme.progressIndicatorTheme;
    final double normalizedValue = _normalizeValue(value);
    final double resolvedHeight = height ?? LumosProgressBarConst.defaultHeight;
    final Color resolvedBackgroundColor =
        indicatorTheme.linearTrackColor ?? colorScheme.surfaceContainerHighest;
    final Color defaultProgressColor = _resolveDefaultProgressColor(
      colorScheme: colorScheme,
      appColors: appColors,
      indicatorTheme: indicatorTheme,
    );
    return ClipRRect(
      borderRadius: BorderRadii.medium,
      child: LinearProgressIndicator(
        value: normalizedValue,
        minHeight: resolvedHeight,
        backgroundColor: resolvedBackgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(defaultProgressColor),
      ),
    );
  }

  double _normalizeValue(double rawValue) {
    double normalizedValue = rawValue;
    if (normalizedValue < ResponsiveDimensions.minPercentage) {
      normalizedValue = ResponsiveDimensions.minPercentage;
    }
    if (normalizedValue > ResponsiveDimensions.maxPercentage) {
      normalizedValue = ResponsiveDimensions.maxPercentage;
    }
    return normalizedValue;
  }

  Color _resolveDefaultProgressColor({
    required ColorScheme colorScheme,
    required AppColorTokens appColors,
    required ProgressIndicatorThemeData indicatorTheme,
  }) {
    if (useTertiary) {
      return appColors.warning;
    }
    return indicatorTheme.color ?? colorScheme.primary;
  }
}
