import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosFabButton extends StatelessWidget {
  const LumosFabButton({
    super.key,
    this.onPressed,
    this.icon,
    this.label,
    this.tooltip,
    this.heroTag,
  });

  final VoidCallback? onPressed;
  final Widget? icon;
  final String? label;
  final String? tooltip;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        tooltip: tooltip,
        heroTag: heroTag,
        icon: icon,
        label: Text(label!),
      );
    }

    return SizedBox.square(
      dimension: context.component.fabSize,
      child: FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        heroTag: heroTag,
        child: icon,
      ),
    );
  }
}
