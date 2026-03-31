import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_circular_loader.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_label.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_body_text.dart';

class LumosLoadingState extends StatelessWidget {
  const LumosLoadingState({
    super.key,
    this.message,
    this.subtitle,
    this.loader,
    this.maxWidth,
    this.padding,
  });

  final String? message;
  final String? subtitle;
  final Widget? loader;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final resolvedMessage = message ?? context.l10n.loading;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: constraints.hasBoundedHeight
              ? BoxConstraints(minHeight: constraints.maxHeight)
              : const BoxConstraints(),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth ?? context.component.loadingStateMaxWidth,
              ),
              child: Padding(
                padding: padding ?? EdgeInsets.all(context.spacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    loader ?? const LumosCircularLoader(),
                    SizedBox(height: context.spacing.md),
                    LumosLabel(
                      text: resolvedMessage,
                      textAlign: TextAlign.center,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: context.spacing.xxs),
                      LumosBodyText(
                        text: subtitle!,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
