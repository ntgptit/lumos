import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_surface.dart';

class AppListItem extends StatelessWidget {
  const AppListItem({
    super.key,
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
  });

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

  @override
  Widget build(BuildContext context) {
    final itemRadius = borderRadius ?? BorderRadius.circular(context.radius.md);
    final itemPadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: context.spacing.md,
          vertical: compact ? context.spacing.sm : context.spacing.md,
        );

    return AppSurface(
      color:
          backgroundColor ??
          (selected
              ? context.colorScheme.secondaryContainer.withValues(
                  alpha: AppOpacityTokens.selected,
                )
              : context.colorScheme.surface),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: itemRadius,
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: itemPadding,
          child: Row(
            crossAxisAlignment: subtitle == null
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: context.spacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DefaultTextStyle.merge(
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      child: title,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: context.spacing.xxs),
                      DefaultTextStyle.merge(
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        child: subtitle!,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: context.spacing.md),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
