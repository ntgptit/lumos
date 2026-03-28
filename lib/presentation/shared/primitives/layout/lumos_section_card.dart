import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';

class LumosSectionCard extends StatelessWidget {
  const LumosSectionCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.variant = LumosCardVariant.outlined,
    this.title,
    this.headerPadding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final LumosCardVariant variant;
  final String? title;
  final EdgeInsetsGeometry? headerPadding;

  @override
  Widget build(BuildContext context) {
    final content = title == null
        ? child
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    headerPadding ??
                    padding ??
                    const EdgeInsets.only(bottom: 16),
                child: LumosText(title!, style: LumosTextStyle.titleMedium),
              ),
              child,
            ],
          );

    return LumosCard(
      padding: title == null ? padding : EdgeInsets.zero,
      margin: margin,
      variant: variant,
      elevation: elevation,
      child: content,
    );
  }
}
