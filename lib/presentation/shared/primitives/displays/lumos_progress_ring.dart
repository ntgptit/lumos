import 'package:flutter/material.dart';

class LumosProgressRing extends StatelessWidget {
  const LumosProgressRing({
    super.key,
    this.value,
    this.progress,
    this.size = 48,
    this.strokeWidth = 6,
    this.centerChild,
  });

  final double? value;
  final double? progress;
  final double size;
  final double strokeWidth;
  final Widget? centerChild;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress ?? value,
            strokeWidth: strokeWidth,
          ),
          if (centerChild != null) centerChild!,
        ],
      ),
    );
  }
}
