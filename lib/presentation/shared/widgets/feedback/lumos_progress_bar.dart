import 'package:flutter/material.dart';

import '../../../../core/constants/dimensions.dart';

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
  });

  final double value;
  final double? height;
  final Color? backgroundColor;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double normalizedValue = _normalizeValue(value);
    final double resolvedHeight = height ?? LumosProgressBarConst.defaultHeight;
    final Color resolvedBackgroundColor =
        backgroundColor ?? colorScheme.surfaceContainerHighest;
    final Color resolvedProgressColor = progressColor ?? colorScheme.primary;
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
}
