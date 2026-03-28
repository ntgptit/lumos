import 'package:flutter/material.dart';

class LumosConstrainedBox extends StatelessWidget {
  const LumosConstrainedBox({
    super.key,
    required this.constraints,
    required this.child,
  });

  final BoxConstraints constraints;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(constraints: constraints, child: child);
  }
}
