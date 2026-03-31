import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_fab_button.dart';

class LumosFloatingActionButton extends StatelessWidget {
  const LumosFloatingActionButton({
    super.key,
    this.onPressed,
    this.icon,
    this.label,
    this.tooltip,
    this.heroTag,
  });

  final VoidCallback? onPressed;
  final IconData? icon;
  final String? label;
  final String? tooltip;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return LumosFabButton(
      onPressed: onPressed,
      icon: icon == null ? null : Icon(icon),
      label: label,
      tooltip: tooltip,
      heroTag: heroTag,
    );
  }
}
