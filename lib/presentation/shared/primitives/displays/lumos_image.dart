import 'dart:typed_data';

import 'package:flutter/material.dart';

class LumosImage extends StatelessWidget {
  const LumosImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit,
    this.filterQuality = FilterQuality.low,
    this.semanticLabel,
  });

  factory LumosImage.asset(
    String assetName, {
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    FilterQuality filterQuality = FilterQuality.low,
    String? semanticLabel,
  }) {
    return LumosImage(
      key: key,
      image: AssetImage(assetName),
      width: width,
      height: height,
      fit: fit,
      filterQuality: filterQuality,
      semanticLabel: semanticLabel,
    );
  }

  factory LumosImage.memory(
    Uint8List bytes, {
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    FilterQuality filterQuality = FilterQuality.low,
    String? semanticLabel,
  }) {
    return LumosImage(
      key: key,
      image: MemoryImage(bytes),
      width: width,
      height: height,
      fit: fit,
      filterQuality: filterQuality,
      semanticLabel: semanticLabel,
    );
  }

  final ImageProvider image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final FilterQuality filterQuality;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: image,
      width: width,
      height: height,
      fit: fit,
      filterQuality: filterQuality,
      semanticLabel: semanticLabel,
    );
  }
}
