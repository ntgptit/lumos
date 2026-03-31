import 'package:flutter/material.dart';

class LumosDecorativeBackground extends StatelessWidget {
  const LumosDecorativeBackground({
    super.key,
    this.child,
    this.blobs = const <LumosDecorativeBlob>[],
    this.gradientColors = const <Color>[],
  });

  final Widget? child;
  final List<LumosDecorativeBlob> blobs;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    final background = DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradientColors.length < 2
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
      ),
      child: const SizedBox.expand(),
    );

    return Stack(
      children: [
        Positioned.fill(child: background),
        Positioned.fill(
          child: IgnorePointer(child: Stack(children: blobs)),
        ),
        if (child != null) child!,
      ],
    );
  }
}

class LumosDecorativeBlob extends StatelessWidget {
  const LumosDecorativeBlob({
    super.key,
    this.alignment,
    required this.size,
    this.color,
    this.fill,
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  final Alignment? alignment;
  final double size;
  final Color? color;
  final Color? fill;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  @override
  Widget build(BuildContext context) {
    final blob = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: fill ?? color, shape: BoxShape.circle),
    );

    final hasPosition =
        top != null || right != null || bottom != null || left != null;
    if (hasPosition) {
      return Positioned(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
        child: blob,
      );
    }

    return Align(alignment: alignment ?? Alignment.center, child: blob);
  }
}
