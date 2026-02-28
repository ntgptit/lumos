import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';

class LumosIconButtonConst {
  const LumosIconButtonConst._();

  static const double defaultIconSize = IconSizes.iconMedium;
}

enum LumosIconButtonVariant { standard, filled, tonal, outlined }

class LumosIconButton extends StatelessWidget {
  const LumosIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.size,
    this.tooltip,
    this.variant = LumosIconButtonVariant.standard,
    this.selected = false,
    this.selectedIcon,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double? size;
  final String? tooltip;
  final LumosIconButtonVariant variant;
  final bool selected;
  final IconData? selectedIcon;

  @override
  Widget build(BuildContext context) {
    final double iconSize = size ?? LumosIconButtonConst.defaultIconSize;
    final ButtonStyle style = IconButton.styleFrom(
      padding: const EdgeInsets.all(Insets.spacing8),
      minimumSize: const Size(
        WidgetSizes.minTouchTarget,
        WidgetSizes.minTouchTarget,
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
    );
    final Widget iconWidget = _buildIcon();
    if (variant == LumosIconButtonVariant.filled) {
      return IconButton.filled(
        onPressed: onPressed,
        tooltip: tooltip,
        iconSize: iconSize,
        style: style,
        icon: iconWidget,
      );
    }
    if (variant == LumosIconButtonVariant.tonal) {
      return IconButton.filledTonal(
        onPressed: onPressed,
        tooltip: tooltip,
        iconSize: iconSize,
        style: style,
        icon: iconWidget,
      );
    }
    if (variant == LumosIconButtonVariant.outlined) {
      return IconButton.outlined(
        onPressed: onPressed,
        tooltip: tooltip,
        iconSize: iconSize,
        style: style,
        icon: iconWidget,
      );
    }
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: iconSize,
      style: style,
      icon: iconWidget,
    );
  }

  Widget _buildIcon() {
    if (selected) {
      if (selectedIcon case final IconData selectedIconValue) {
        return Icon(selectedIconValue);
      }
    }
    return Icon(icon);
  }
}
