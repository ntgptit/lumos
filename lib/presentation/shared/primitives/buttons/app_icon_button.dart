import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

enum AppIconButtonVariant { standard, filled, tonal, outline }

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.variant = AppIconButtonVariant.standard,
    this.isSelected = false,
    this.selectedIcon,
    this.style,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final AppIconButtonVariant variant;
  final bool isSelected;
  final Widget? selectedIcon;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final constraints = BoxConstraints.tightFor(
      width: context.component.buttonHeight,
      height: context.component.buttonHeight,
    );

    return switch (variant) {
      AppIconButtonVariant.standard => IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        style: style,
        constraints: constraints,
        isSelected: isSelected,
        selectedIcon: selectedIcon,
        icon: icon,
      ),
      AppIconButtonVariant.filled => IconButton.filled(
        onPressed: onPressed,
        tooltip: tooltip,
        style: style,
        constraints: constraints,
        isSelected: isSelected,
        selectedIcon: selectedIcon,
        icon: icon,
      ),
      AppIconButtonVariant.tonal => IconButton.filledTonal(
        onPressed: onPressed,
        tooltip: tooltip,
        style: style,
        constraints: constraints,
        isSelected: isSelected,
        selectedIcon: selectedIcon,
        icon: icon,
      ),
      AppIconButtonVariant.outline => IconButton.outlined(
        onPressed: onPressed,
        tooltip: tooltip,
        style: style,
        constraints: constraints,
        isSelected: isSelected,
        selectedIcon: selectedIcon,
        icon: icon,
      ),
    };
  }
}
