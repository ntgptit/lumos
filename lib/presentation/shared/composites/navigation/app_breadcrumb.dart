import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_icon.dart';
import 'package:lumos/presentation/shared/primitives/text/app_link_text.dart';
import 'package:lumos/presentation/shared/primitives/text/app_text.dart';

class AppBreadcrumbItem {
  const AppBreadcrumbItem({
    required this.label,
    this.onTap,
    this.isCurrent = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isCurrent;
}

class AppBreadcrumb extends StatelessWidget {
  const AppBreadcrumb({
    super.key,
    required this.items,
    this.separator,
    this.spacing,
  });

  final List<AppBreadcrumbItem> items;
  final Widget? separator;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final resolvedSeparator =
        separator ??
        AppIcon(
          Icons.chevron_right_rounded,
          size: context.iconSize.xs,
          color: context.colorScheme.onSurfaceVariant,
        );
    final children = <Widget>[];
    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      if (index > 0) {
        children.add(
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing ?? context.spacing.xs,
            ),
            child: resolvedSeparator,
          ),
        );
      }
      children.add(
        item.isCurrent || item.onTap == null
            ? AppText(
                text: item.label,
                color: context.colorScheme.onSurfaceVariant,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : AppLinkText(
                text: item.label,
                onTap: item.onTap,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}
