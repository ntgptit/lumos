import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosVerticalDivider extends StatelessWidget {
  const LumosVerticalDivider({
    super.key,
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  });

  final double? width;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: width ?? context.spacing.md,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? context.colorScheme.outlineVariant,
    );
  }
}
