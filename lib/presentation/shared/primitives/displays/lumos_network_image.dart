import 'package:flutter/material.dart';

class LumosNetworkImage extends StatelessWidget {
  const LumosNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit,
    this.headers,
    this.filterQuality = FilterQuality.low,
    this.semanticLabel,
    this.loadingBuilder,
    this.errorBuilder,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Map<String, String>? headers;
  final FilterQuality filterQuality;
  final String? semanticLabel;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      headers: headers,
      filterQuality: filterQuality,
      semanticLabel: semanticLabel,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
