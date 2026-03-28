import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_responsive_container.dart';

class LumosScrollView extends StatelessWidget {
  const LumosScrollView({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth,
    this.controller,
    this.physics,
    this.primary,
    this.scrollDirection = Axis.vertical,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool? primary;
  final Axis scrollDirection;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      physics: physics,
      primary: primary,
      scrollDirection: scrollDirection,
      keyboardDismissBehavior: keyboardDismissBehavior,
      child: LumosResponsiveContainer(
        maxWidth: maxWidth,
        padding: padding,
        child: child,
      ),
    );
  }
}
