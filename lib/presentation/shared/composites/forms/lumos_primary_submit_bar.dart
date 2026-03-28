import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_submit_bar.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';

class LumosPrimarySubmitBar extends StatelessWidget {
  const LumosPrimarySubmitBar({
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.leading,
    this.secondaryAction,
    this.actions = const <Widget>[],
    this.alignment = MainAxisAlignment.end,
    this.spacing,
    this.padding,
    this.backgroundColor,
    this.sticky = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? leading;
  final Widget? secondaryAction;
  final List<Widget> actions;
  final MainAxisAlignment alignment;
  final double? spacing;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool sticky;

  @override
  Widget build(BuildContext context) {
    return LumosSubmitBar(
      primaryAction: LumosButton.primary(
        onPressed: onPressed,
        isLoading: isLoading,
        text: label,
        expand: true,
        leading: leading,
      ),
      secondaryAction: secondaryAction,
      actions: actions,
      alignment: alignment,
      spacing: spacing,
      padding: padding,
      backgroundColor: backgroundColor,
      sticky: sticky,
    );
  }
}
