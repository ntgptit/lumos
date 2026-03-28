import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_surface.dart';

class LumosSubmitBar extends StatelessWidget {
  const LumosSubmitBar({
    super.key,
    required this.primaryAction,
    this.secondaryAction,
    this.actions = const [],
    this.alignment = MainAxisAlignment.end,
    this.spacing,
    this.padding,
    this.backgroundColor,
    this.sticky = false,
  });

  final Widget primaryAction;
  final Widget? secondaryAction;
  final List<Widget> actions;
  final MainAxisAlignment alignment;
  final double? spacing;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool sticky;

  @override
  Widget build(BuildContext context) {
    final gap = spacing ?? context.spacing.sm;
    final children = <Widget>[
      ...actions,
      ...(secondaryAction != null ? [secondaryAction!] : const []),
      primaryAction,
    ];

    final content = LumosSurface(
      color: backgroundColor ?? context.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? EdgeInsets.all(context.spacing.md),
        child: Wrap(
          alignment: _wrapAlignment(alignment),
          spacing: gap,
          runSpacing: gap,
          children: children,
        ),
      ),
    );

    if (!sticky) {
      return content;
    }

    return SafeArea(top: false, child: content);
  }

  WrapAlignment _wrapAlignment(MainAxisAlignment alignment) {
    return switch (alignment) {
      MainAxisAlignment.start => WrapAlignment.start,
      MainAxisAlignment.center => WrapAlignment.center,
      MainAxisAlignment.end => WrapAlignment.end,
      MainAxisAlignment.spaceBetween => WrapAlignment.spaceBetween,
      MainAxisAlignment.spaceAround => WrapAlignment.spaceAround,
      MainAxisAlignment.spaceEvenly => WrapAlignment.spaceEvenly,
    };
  }
}
