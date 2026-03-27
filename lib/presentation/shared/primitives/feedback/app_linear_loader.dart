import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/feedback/app_loader.dart';

class AppLinearLoader extends StatelessWidget {
  const AppLinearLoader({
    super.key,
    this.value,
    this.height,
    this.minWidth,
    this.color,
    this.backgroundColor,
    this.semanticsLabel,
  });

  final double? value;
  final double? height;
  final double? minWidth;
  final Color? color;
  final Color? backgroundColor;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(context.radius.pill),
      child: SizedBox(
        width: minWidth,
        height: height ?? 4,
        child: LinearProgressIndicator(
          value: value,
          color: color ?? context.colorScheme.primary,
          backgroundColor:
              backgroundColor ?? context.colorScheme.surfaceContainerHighest,
        ),
      ),
    );

    return AppLoader(semanticsLabel: semanticsLabel ?? 'Loading', child: bar);
  }
}
