import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

enum AppIconButtonVariant { standard, filled, tonal, outline }

class LumosIconButton<
  TIcon extends Object,
  TSelectedIcon extends Object
> extends StatelessWidget {
  const LumosIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.variant = AppIconButtonVariant.standard,
    this.isSelected = false,
    this.selectedIcon,
    this.size,
  });

  final TIcon icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final AppIconButtonVariant variant;
  final bool isSelected;
  final TSelectedIcon? selectedIcon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final constraints = BoxConstraints.tightFor(
      width: context.component.buttonHeight,
      height: context.component.buttonHeight,
    );
    final resolvedIcon = _resolveIcon();
    final resolvedSelectedIcon = _resolveSelectedIcon();

    return switch (variant) {
      AppIconButtonVariant.standard => IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        constraints: constraints,
        isSelected: isSelected,
        selectedIcon: resolvedSelectedIcon,
        icon: resolvedIcon,
      ),
      AppIconButtonVariant.filled => IconButton.filled(
        onPressed: onPressed,
        tooltip: tooltip,
        constraints: constraints,
        isSelected: isSelected,
        selectedIcon: resolvedSelectedIcon,
        icon: resolvedIcon,
      ),
      AppIconButtonVariant.tonal => IconButton.filledTonal(
        onPressed: onPressed,
        tooltip: tooltip,
        constraints: constraints,
        isSelected: isSelected,
        selectedIcon: resolvedSelectedIcon,
        icon: resolvedIcon,
      ),
      AppIconButtonVariant.outline => IconButton.outlined(
        onPressed: onPressed,
        tooltip: tooltip,
        constraints: constraints,
        isSelected: isSelected,
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
}
