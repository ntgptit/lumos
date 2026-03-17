import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';

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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double scale = _resolveScale(constraints.maxWidth);
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
              children: blobs
                  .map((LumosDecorativeBlob blob) {
                    return _buildBlob(blob, scale: scale);
                  })
                  .toList(growable: false),
            ),
          ),
        );
      },
    );
  }

  double _resolveScale(double maxWidth) {
    if (maxWidth.isInfinite) {
      return ResponsiveDimensions.maxScaleFactor;
    }
    final double rawScale = maxWidth / ResponsiveDimensions.baseDesignWidth;
    if (rawScale < ResponsiveDimensions.minScaleFactor) {
      return ResponsiveDimensions.minScaleFactor;
    }
    if (rawScale > ResponsiveDimensions.maxScaleFactor) {
      return ResponsiveDimensions.maxScaleFactor;
    }
    return rawScale;
  }

  Widget _buildBlob(LumosDecorativeBlob blob, {required double scale}) {
    return Positioned(
      top: _scaleOffset(blob.top, scale: scale),
      right: _scaleOffset(blob.right, scale: scale),
      bottom: _scaleOffset(blob.bottom, scale: scale),
      left: _scaleOffset(blob.left, scale: scale),
      child: DecoratedBox(
        decoration: BoxDecoration(color: blob.fill, shape: BoxShape.circle),
        child: SizedBox(width: blob.size * scale, height: blob.size * scale),
      ),
    );
  }

  double? _scaleOffset(double? value, {required double scale}) {
    if (value == null) {
      return null;
    }
    return value * scale;
  }
}
