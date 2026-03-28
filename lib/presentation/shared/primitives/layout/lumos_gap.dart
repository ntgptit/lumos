import 'package:flutter/material.dart';

class LumosGap extends StatelessWidget {
  const LumosGap({super.key, this.size = 8, this.axis = Axis.vertical});

  final double size;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return axis == Axis.horizontal
        ? SizedBox(width: size)
        : SizedBox(height: size);
  }
}
