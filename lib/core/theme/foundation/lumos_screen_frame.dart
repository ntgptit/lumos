import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosScreenFrame extends StatelessWidget {
  const LumosScreenFrame({
    super.key,
    required this.child,
    this.padding,
    this.verticalPadding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? verticalPadding;

  static double resolveHorizontalInset(BuildContext context) {
    return context.layout.pageHorizontalPadding;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: resolveHorizontalInset(context),
            vertical: verticalPadding ?? context.layout.pageVerticalPadding,
          ),
      child: child,
    );
  }
}
