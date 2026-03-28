import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosBadge extends StatelessWidget {
  const LumosBadge({
    super.key,
    required this.child,
    this.label,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.alignment = AlignmentDirectional.topEnd,
    this.offset,
    this.isVisible = true,
  });

  final Widget child;
  final Widget? label;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;
  final Offset? offset;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: isVisible,
      label: label,
      backgroundColor: backgroundColor ?? context.colorScheme.primary,
      textColor: textColor ?? context.colorScheme.onPrimary,
      padding: padding,
      alignment: alignment,
      offset: offset,
      child: child,
    );
  }
}
