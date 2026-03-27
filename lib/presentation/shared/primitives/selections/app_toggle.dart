import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.children,
    required this.isSelected,
    required this.onPressed,
    this.enabled = true,
    this.borderRadius,
    this.constraints,
    this.renderBorder = true,
    this.fillColor,
    this.selectedColor,
    this.color,
    this.textStyle,
  });

  final List<Widget> children;
  final List<bool> isSelected;
  final void Function(int index)? onPressed;
  final bool enabled;
  final BorderRadius? borderRadius;
  final BoxConstraints? constraints;
  final bool renderBorder;
  final Color? fillColor;
  final Color? selectedColor;
  final Color? color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: isSelected,
      onPressed: enabled ? onPressed : null,
      borderRadius: borderRadius ?? BorderRadius.circular(context.radius.md),
      constraints:
          constraints ??
          BoxConstraints.tightFor(
            width: context.component.buttonHeight,
            height: context.component.buttonHeight,
          ),
      renderBorder: renderBorder,
      fillColor: fillColor ?? context.colorScheme.secondaryContainer,
      selectedColor: selectedColor ?? context.colorScheme.onSecondaryContainer,
      color: color ?? context.colorScheme.onSurfaceVariant,
      textStyle: textStyle ?? context.textTheme.labelLarge,
      children: children,
    );
  }
}
