import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';

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
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(
        horizontal: Insets.spacing0,
        vertical: Insets.spacing0,
      ),
    );
  }
}

class LumosPopupMenuButton<T> extends StatelessWidget {
  const LumosPopupMenuButton({
    required this.onSelected,
    required this.itemBuilder,
    super.key,
    this.icon,
  });

  final ValueChanged<T> onSelected;
  final PopupMenuItemBuilder<T> itemBuilder;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSelected,
      itemBuilder: itemBuilder,
      icon: icon,
    );
  }
}
