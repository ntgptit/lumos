import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_loader.dart';

class LumosCircularLoader extends StatelessWidget {
  const LumosCircularLoader({
    super.key,
    this.size,
    this.strokeWidth = 3,
    this.value,
    this.color,
    this.backgroundColor,
    this.semanticsLabel,
  });

  final double? size;
  final double strokeWidth;
  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox.square(
      dimension: size ?? context.iconSize.xl,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? context.colorScheme.primary,
        ),
        backgroundColor:
            backgroundColor ?? context.colorScheme.surfaceContainerHighest,
      ),
    );

    return LumosLoader(
      semanticsLabel: semanticsLabel ?? 'Loading',
      child: indicator,
    );
  }
}
