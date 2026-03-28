import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosCard extends StatelessWidget {
  const LumosCard({super.key, required this.child, this.padding, this.margin});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: context.component.cardMinHeight),
        child: Padding(
          padding: padding ?? EdgeInsets.all(context.component.cardPadding),
          child: child,
        ),
      ),
    );
  }
}
