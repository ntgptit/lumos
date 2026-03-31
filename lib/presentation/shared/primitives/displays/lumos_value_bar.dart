import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosValueBar extends StatelessWidget {
  const LumosValueBar({
    super.key,
    this.value,
    this.minHeight,
    this.height,
    this.backgroundColor,
    this.valueColor,
  });

  final double? value;
  final double? minHeight;
  final double? height;
  final Color? backgroundColor;
  final Animation<Color?>? valueColor;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      minHeight: height ?? minHeight ?? context.spacing.xs,
      backgroundColor:
          backgroundColor ?? context.colorScheme.surfaceContainerHighest,
      valueColor: valueColor,
    );
  }
}
