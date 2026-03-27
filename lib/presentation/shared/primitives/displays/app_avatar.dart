import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.radius,
    this.minRadius,
    this.maxRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.foregroundImage,
    this.backgroundImage,
    this.child,
  });

  final double? radius;
  final double? minRadius;
  final double? maxRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final ImageProvider? foregroundImage;
  final ImageProvider? backgroundImage;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? context.iconSize.xl,
      minRadius: minRadius,
      maxRadius: maxRadius,
      backgroundColor: backgroundColor ?? context.colorScheme.surfaceContainer,
      foregroundColor: foregroundColor ?? context.colorScheme.onSurface,
      foregroundImage: foregroundImage,
      backgroundImage: backgroundImage,
      child: child,
    );
  }
}
