import 'package:flutter/material.dart';

abstract final class LumosDecorativeBackgroundConst {
  const LumosDecorativeBackgroundConst._();

  static const Alignment defaultGradientBegin = Alignment.topLeft;
  static const Alignment defaultGradientEnd = Alignment.bottomRight;
}

@immutable
class LumosDecorativeBlob {
  const LumosDecorativeBlob({
    required this.fill,
    required this.size,
    this.top,
    this.right,
    this.bottom,
    this.left,
  }) : assert(size > 0);

  final Color fill;
  final double size;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
}

class LumosDecorativeBackground extends StatelessWidget {
  const LumosDecorativeBackground({
    required this.gradientColors,
    super.key,
    this.gradientBegin = LumosDecorativeBackgroundConst.defaultGradientBegin,
    this.gradientEnd = LumosDecorativeBackgroundConst.defaultGradientEnd,
    this.blobs = const <LumosDecorativeBlob>[],
  }) : assert(gradientColors.length >= 2);

  final List<Color> gradientColors;
  final Alignment gradientBegin;
  final Alignment gradientEnd;
  final List<LumosDecorativeBlob> blobs;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: gradientBegin,
            end: gradientEnd,
            colors: gradientColors,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: blobs.map(_buildBlob).toList(growable: false),
        ),
      ),
    );
  }

  Widget _buildBlob(LumosDecorativeBlob blob) {
    return Positioned(
      top: blob.top,
      right: blob.right,
      bottom: blob.bottom,
      left: blob.left,
      child: DecoratedBox(
        decoration: BoxDecoration(color: blob.fill, shape: BoxShape.circle),
        child: SizedBox(width: blob.size, height: blob.size),
      ),
    );
  }
}
