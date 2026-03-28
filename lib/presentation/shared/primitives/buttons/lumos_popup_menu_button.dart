import 'package:flutter/material.dart';

class LumosPopupMenuButton<T> extends StatelessWidget {
  const LumosPopupMenuButton({
    super.key,
    required this.itemBuilder,
    this.onSelected,
    this.tooltip,
    this.icon,
  });

  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T>? onSelected;
  final String? tooltip;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      itemBuilder: itemBuilder,
      onSelected: onSelected,
      tooltip: tooltip,
      icon: icon,
    );
  }
}
