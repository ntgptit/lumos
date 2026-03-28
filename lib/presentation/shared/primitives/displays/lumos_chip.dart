import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosChip extends StatelessWidget {
  const LumosChip({
    super.key,
    required this.label,
    this.avatar,
    this.onSelected,
    this.selected = false,
    this.onDeleted,
    this.enabled = true,
    this.backgroundColor,
    this.selectedColor,
    this.labelStyle,
  });

  final Widget label;
  final Widget? avatar;
  final ValueChanged<bool>? onSelected;
  final bool selected;
  final VoidCallback? onDeleted;
  final bool enabled;
  final Color? backgroundColor;
  final Color? selectedColor;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      avatar: avatar,
      label: label,
      selected: selected,
      isEnabled: enabled,
      onSelected: onSelected,
      onDeleted: onDeleted,
      backgroundColor:
          backgroundColor ?? context.colorScheme.surfaceContainerLow,
      selectedColor: selectedColor ?? context.colorScheme.secondaryContainer,
      labelStyle: labelStyle ?? context.textTheme.labelMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius.pill),
      ),
      side: BorderSide(color: context.colorScheme.outlineVariant),
      padding: EdgeInsets.symmetric(horizontal: context.spacing.sm),
      showCheckmark: false,
    );
  }
}
