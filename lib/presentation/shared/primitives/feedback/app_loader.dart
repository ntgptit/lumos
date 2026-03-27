import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.alignment = Alignment.center,
    this.backgroundColor,
    this.semanticsLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry alignment;
  final Color? backgroundColor;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: margin,
      padding: padding,
      alignment: alignment,
      color: backgroundColor,
      child: child,
    );

    if (semanticsLabel == null) {
      return content;
    }

    return Semantics(label: semanticsLabel, child: content);
  }
}
