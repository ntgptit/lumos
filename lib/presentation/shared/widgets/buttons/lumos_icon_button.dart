import 'package:flutter/material.dart';

import '../../../../core/constants/dimensions.dart';

class LumosIconButtonConst {
  const LumosIconButtonConst._();

  static const double defaultIconSize = IconSizes.iconMedium;
}

class LumosIconButton extends StatelessWidget {
  const LumosIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.size,
    this.color,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double? size;
  final Color? color;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final double iconSize = size ?? LumosIconButtonConst.defaultIconSize;
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: iconSize,
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(Insets.spacing8),
        minimumSize: const Size(
          WidgetSizes.minTouchTarget,
          WidgetSizes.minTouchTarget,
        ),
      ),
      icon: Icon(icon, color: color),
    );
  }
}
