import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.shadows,
  });

  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final List<Shadow>? shadows;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size ?? context.iconSize.md,
      color: color ?? context.colorScheme.onSurfaceVariant,
      semanticLabel: semanticLabel,
      shadows: shadows,
    );
  }
}
