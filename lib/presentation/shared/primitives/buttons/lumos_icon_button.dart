import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

enum AppIconButtonVariant { standard, filled, tonal, outline }
enum LumosIconButtonVariant { standard, filled, tonal, outlined }

class LumosIconButton extends StatelessWidget {
  const LumosIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.variant = AppIconButtonVariant.standard,
    this.isSelected = false,
    this.selected = false,
    this.selectedIcon,
    this.style,
    this.size,
  });

  final Object icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Object variant;
  final bool isSelected;
  final bool selected;
  final Object? selectedIcon;
  final ButtonStyle? style;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final constraints = BoxConstraints.tightFor(
      width: context.component.buttonHeight,
      height: context.component.buttonHeight,
    );
    final resolvedIcon = _resolveIcon();
    final resolvedSelectedIcon = _resolveSelectedIcon();
    final resolvedVariant = _resolveVariant();
    final selectedValue = isSelected || selected;

    return switch (resolvedVariant) {
      AppIconButtonVariant.standard => IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        style: style,
        constraints: constraints,
        isSelected: selectedValue,
        selectedIcon: resolvedSelectedIcon,
        icon: resolvedIcon,
      ),
      AppIconButtonVariant.filled => IconButton.filled(
        onPressed: onPressed,
        tooltip: tooltip,
        style: style,
        constraints: constraints,
        isSelected: selectedValue,
        selectedIcon: resolvedSelectedIcon,
        icon: resolvedIcon,
      ),
      AppIconButtonVariant.tonal => IconButton.filledTonal(
        onPressed: onPressed,
        tooltip: tooltip,
        style: style,
        constraints: constraints,
        isSelected: selectedValue,
        selectedIcon: resolvedSelectedIcon,
        icon: resolvedIcon,
      ),
      AppIconButtonVariant.outline => IconButton.outlined(
        onPressed: onPressed,
        tooltip: tooltip,
        style: style,
        constraints: constraints,
        isSelected: selectedValue,
        selectedIcon: resolvedSelectedIcon,
        icon: resolvedIcon,
      ),
    };
  }

  Widget _resolveIcon() {
    if (icon is Widget) {
      return icon as Widget;
    }
    return Icon(icon as IconData, size: size);
  }

  Widget? _resolveSelectedIcon() {
    if (selectedIcon == null) {
      return null;
    }
    if (selectedIcon is Widget) {
      return selectedIcon as Widget;
    }
    return Icon(selectedIcon as IconData, size: size);
  }

  AppIconButtonVariant _resolveVariant() {
    if (variant is AppIconButtonVariant) {
      return variant as AppIconButtonVariant;
    }
    return switch (variant as LumosIconButtonVariant?) {
      LumosIconButtonVariant.filled => AppIconButtonVariant.filled,
      LumosIconButtonVariant.tonal => AppIconButtonVariant.tonal,
      LumosIconButtonVariant.outlined => AppIconButtonVariant.outline,
      _ => AppIconButtonVariant.standard,
    };
  }
}
