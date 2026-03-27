import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  });

  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? context.spacing.md,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? context.colorScheme.outlineVariant,
    );
  }
}
