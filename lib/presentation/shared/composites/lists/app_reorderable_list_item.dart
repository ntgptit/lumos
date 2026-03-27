import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/composites/lists/app_list_item.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_icon.dart';

class AppReorderableListItem extends StatelessWidget {
  const AppReorderableListItem({
    super.key,
    required this.index,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.compact = false,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.showDragHandle = true,
  });

  final int index;
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;
  final bool compact;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool showDragHandle;

  @override
  Widget build(BuildContext context) {
    final dragHandle = showDragHandle
        ? ReorderableDragStartListener(
            index: index,
            child: Padding(
              padding: EdgeInsets.all(context.spacing.xs),
              child: AppIcon(
                Icons.drag_handle_rounded,
                size: context.iconSize.lg,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        : null;

    return AppListItem(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: dragHandle == null
          ? trailing
          : (trailing == null
                ? dragHandle
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      trailing!,
                      SizedBox(width: context.spacing.xs),
                      dragHandle,
                    ],
                  )),
      onTap: onTap,
      onLongPress: onLongPress,
      selected: selected,
      compact: compact,
      padding: padding,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
    );
  }
}
