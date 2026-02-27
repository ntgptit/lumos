import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';

class LumosProgressBarConst {
  const LumosProgressBarConst._();

  static const double defaultHeight = Insets.spacing8;
}

class LumosProgressBar extends StatelessWidget {
  const LumosProgressBar({
    required this.value,
    super.key,
    this.height,
    this.backgroundColor,
    this.progressColor,
    this.useTertiary = false,
  });

  final double value;
  final double? height;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool useTertiary;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ProgressIndicatorThemeData indicatorTheme =
        theme.progressIndicatorTheme;
    final double normalizedValue = _normalizeValue(value);
    final double resolvedHeight = height ?? LumosProgressBarConst.defaultHeight;
    final Color resolvedBackgroundColor =
        backgroundColor ??
        indicatorTheme.linearTrackColor ??
        colorScheme.surfaceContainerHighest;
    final Color defaultProgressColor = _resolveDefaultProgressColor(
      colorScheme: colorScheme,
      indicatorTheme: indicatorTheme,
    );
    final Color resolvedProgressColor = progressColor ?? defaultProgressColor;
    return ClipRRect(
      borderRadius: BorderRadii.medium,
      child: LinearProgressIndicator(
        value: normalizedValue,
        minHeight: resolvedHeight,
        backgroundColor: resolvedBackgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(resolvedProgressColor),
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
    required ProgressIndicatorThemeData indicatorTheme,
  }) {
    if (useTertiary) {
      return colorScheme.tertiary;
    }
    return indicatorTheme.color ?? colorScheme.primary;
  }
}
