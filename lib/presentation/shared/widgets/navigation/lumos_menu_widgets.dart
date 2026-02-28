import 'package:flutter/material.dart';

class LumosActionChip extends StatelessWidget {
  const LumosActionChip({
    required this.label,
    super.key,
    this.onPressed,
    this.avatar,
  });

  final Widget label;
  final VoidCallback? onPressed;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: label,
      onPressed: onPressed,
      avatar: avatar,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}

class LumosPopupMenuButton<T> extends StatelessWidget {
  const LumosPopupMenuButton({
    required this.onSelected,
    required this.itemBuilder,
    super.key,
    this.icon,
    this.tooltip,
  });

  final ValueChanged<T> onSelected;
  final PopupMenuItemBuilder<T> itemBuilder;
  final Widget? icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSelected,
      itemBuilder: itemBuilder,
      icon: icon,
      tooltip: tooltip,
    );
  }
}
