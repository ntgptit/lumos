import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/screen_context_ext.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosSplitViewLayout extends StatelessWidget {
  const LumosSplitViewLayout({
    super.key,
    required this.primary,
    required this.secondary,
    this.gap,
    this.primaryFlex = 3,
    this.secondaryFlex = 2,
    this.secondaryOnStart = false,
    this.collapseWhenCompact = true,
  });

  final Widget primary;
  final Widget secondary;
  final double? gap;
  final int primaryFlex;
  final int secondaryFlex;
  final bool secondaryOnStart;
  final bool collapseWhenCompact;

  @override
  Widget build(BuildContext context) {
    final spacing = gap ?? context.layout.gutter;
    final shouldCollapse =
        collapseWhenCompact && !context.screenClass.canUseSplitView;
    if (shouldCollapse) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (secondaryOnStart) secondary else primary,
          SizedBox(height: spacing),
          if (secondaryOnStart) primary else secondary,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: secondaryOnStart
          ? [
              Expanded(flex: secondaryFlex, child: secondary),
              SizedBox(width: spacing),
              Expanded(flex: primaryFlex, child: primary),
            ]
          : [
              Expanded(flex: primaryFlex, child: primary),
              SizedBox(width: spacing),
              Expanded(flex: secondaryFlex, child: secondary),
            ],
    );
  }
}
