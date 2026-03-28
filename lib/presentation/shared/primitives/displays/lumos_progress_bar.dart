import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosProgressBar extends StatelessWidget {
  const LumosProgressBar({
    super.key,
    this.value,
    this.minHeight,
    this.backgroundColor,
    this.valueColor,
  });

  final double? value;
  final double? minHeight;
  final Color? backgroundColor;
  final Animation<Color?>? valueColor;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      minHeight: minHeight ?? context.spacing.xs,
      backgroundColor:
          backgroundColor ?? context.colorScheme.surfaceContainerHighest,
      valueColor: valueColor,
    );
  }
}
