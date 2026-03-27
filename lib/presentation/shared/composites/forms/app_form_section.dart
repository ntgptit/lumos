import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_surface.dart';

class AppFormSection extends StatelessWidget {
  const AppFormSection({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.footer,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation = 0,
  });

  final Widget child;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? footer;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final hasHeader =
        title != null ||
        subtitle != null ||
        leading != null ||
        trailing != null;
    final sectionPadding = padding ?? EdgeInsets.all(context.spacing.md);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: AppSurface(
        color: backgroundColor ?? context.colorScheme.surface,
        elevation: elevation,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius:
              borderRadius ?? BorderRadius.circular(context.radius.lg),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: sectionPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasHeader) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...(leading != null
                        ? [leading!, SizedBox(width: context.spacing.sm)]
                        : const []),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...(title != null ? [title!] : const []),
                          ...(subtitle != null
                              ? [
                                  SizedBox(height: context.spacing.xxs),
                                  DefaultTextStyle.merge(
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: context
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                    child: subtitle!,
                                  ),
                                ]
                              : const []),
                        ],
                      ),
                    ),
                    ...(trailing != null
                        ? [SizedBox(width: context.spacing.sm), trailing!]
                        : const []),
                  ],
                ),
                SizedBox(height: context.spacing.md),
              ],
              child,
              ...(footer != null
                  ? [SizedBox(height: context.spacing.md), footer!]
                  : const []),
            ],
          ),
        ),
      ),
    );
  }
}
