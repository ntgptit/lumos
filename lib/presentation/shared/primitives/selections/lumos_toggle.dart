import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosToggle extends StatelessWidget {
  const LumosToggle({
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
    final Set<int> selectedIndexes = <int>{
      for (int index = 0; index < isSelected.length; index += 1)
        if (isSelected[index]) index,
    };
    final Size resolvedMinimumSize = Size(
      constraints == null || constraints!.minWidth <= 0
          ? context.component.buttonHeight
          : constraints!.minWidth,
      constraints == null || constraints!.minHeight <= 0
          ? context.component.buttonHeight
          : constraints!.minHeight,
    );
    final BorderSide resolvedBorderSide = renderBorder
        ? BorderSide(color: context.colorScheme.outline)
        : BorderSide.none;

    return SegmentedButton<int>(
      segments: List<ButtonSegment<int>>.generate(
        children.length,
        (index) => ButtonSegment<int>(
          value: index,
          label: children[index],
          enabled: enabled,
        ),
      ),
      selected: selectedIndexes,
      onSelectionChanged: enabled && onPressed != null
          ? (Set<int> nextSelection) {
              for (int index = 0; index < children.length; index += 1) {
                final bool wasSelected = selectedIndexes.contains(index);
                final bool isNowSelected = nextSelection.contains(index);
                if (wasSelected == isNowSelected) {
                  continue;
                }
                onPressed?.call(index);
                return;
              }
            }
          : null,
      multiSelectionEnabled: true,
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          textStyle ?? context.textTheme.labelLarge,
        ),
        minimumSize: WidgetStatePropertyAll(resolvedMinimumSize),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? BorderRadius.circular(context.radius.md),
          ),
        ),
        side: WidgetStatePropertyAll(resolvedBorderSide),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return fillColor ?? context.colorScheme.secondaryContainer;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return selectedColor ?? context.colorScheme.onSecondaryContainer;
          }
          return color ?? context.colorScheme.onSurfaceVariant;
        }),
      ),
    );
  }
}
