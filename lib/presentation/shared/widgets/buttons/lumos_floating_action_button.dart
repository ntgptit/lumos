import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';

enum LumosFabSize { small, regular, large }

class LumosFloatingActionButton extends StatelessWidget {
  const LumosFloatingActionButton({
    required this.onPressed,
    super.key,
    this.icon = Icons.add,
    this.label,
    this.tooltip,
    this.size = LumosFabSize.regular,
  }) : assert(label != null || tooltip != null);

  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  final String? tooltip;
  final LumosFabSize size;

  @override
  Widget build(BuildContext context) {
    final String? resolvedTooltip = _resolveTooltip();
    if (label == null) {
      if (size == LumosFabSize.small) {
        return FloatingActionButton.small(
          onPressed: onPressed,
          tooltip: resolvedTooltip,
          child: Icon(icon, size: IconSizes.iconMedium),
        );
      }
      if (size == LumosFabSize.large) {
        return FloatingActionButton.large(
          onPressed: onPressed,
          tooltip: resolvedTooltip,
          child: Icon(icon, size: IconSizes.iconLarge),
        );
      }
      return FloatingActionButton(
        onPressed: onPressed,
        tooltip: resolvedTooltip,
        child: Icon(icon, size: IconSizes.iconMedium),
      );
    }
    return FloatingActionButton.extended(
      onPressed: onPressed,
      tooltip: resolvedTooltip,
      icon: Icon(icon, size: IconSizes.iconMedium),
      label: Text(label!, overflow: TextOverflow.ellipsis),
    );
  }

  String? _resolveTooltip() {
    if (tooltip != null) {
      return tooltip;
    }
    if (label != null) {
      return label;
    }
    return null;
  }
}
