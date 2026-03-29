import 'package:flutter/material.dart';
import 'package:lumos/core/theme/foundation/app_cursor.dart';

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
    return MouseRegion(
      cursor: AppMouseCursors.clickable,
      child: PopupMenuButton<T>(
        itemBuilder: itemBuilder,
        onSelected: onSelected,
        tooltip: tooltip,
        icon: icon,
      ),
    );
  }
}
