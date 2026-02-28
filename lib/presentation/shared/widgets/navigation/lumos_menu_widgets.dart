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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return ActionChip(
      label: label,
      onPressed: onPressed,
      avatar: avatar,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      side: BorderSide(
        color: colorScheme.outlineVariant,
        width: WidgetSizes.borderWidthRegular,
      ),
      shape: const StadiumBorder(),
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
      style: IconButton.styleFrom(
        minimumSize: const Size(
          WidgetSizes.minTouchTarget,
          WidgetSizes.minTouchTarget,
        ),
        padding: const EdgeInsets.all(Insets.spacing8),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}
