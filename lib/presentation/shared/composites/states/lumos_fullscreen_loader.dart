import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_loading_state.dart';

class LumosFullscreenLoader extends StatelessWidget {
  const LumosFullscreenLoader({
    super.key,
    this.child,
    this.message,
    this.subtitle,
    this.backgroundColor,
    this.scrimColor,
  });

  final Widget? child;
  final String? message;
  final String? subtitle;
  final Color? backgroundColor;
  final Color? scrimColor;

  @override
  Widget build(BuildContext context) {
    final loader = ColoredBox(
      color: backgroundColor ?? context.colorScheme.surface,
      child: LumosLoadingState(message: message, subtitle: subtitle),
    );

    if (child == null) {
      return SizedBox.expand(child: loader);
    }

    return Stack(
      children: [
        child!,
        Positioned.fill(
          child: ColoredBox(
            color:
                scrimColor ??
                context.colorScheme.surface.withValues(
                  alpha: AppOpacityTokens.emphasis,
                ),
            child: loader,
          ),
        ),
      ],
    );
  }
}
