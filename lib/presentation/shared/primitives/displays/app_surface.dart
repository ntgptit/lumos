import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppSurface extends StatelessWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.color,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.clipBehavior = Clip.none,
  });

  final Widget child;
  final Color? color;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? context.colorScheme.surface,
      elevation: elevation ?? 0,
      shadowColor: shadowColor ?? context.colorScheme.shadow,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      shape: shape,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
