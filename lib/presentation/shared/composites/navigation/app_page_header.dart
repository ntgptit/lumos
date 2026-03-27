import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/layout/app_responsive_container.dart';

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    this.breadcrumb,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.bottom,
    this.maxWidth,
    this.padding,
    this.alignment = CrossAxisAlignment.start,
  });

  final Widget? breadcrumb;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final Widget? bottom;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final resolvedSubtitle = subtitle;
    final resolvedBottom = bottom;
    return AppResponsiveContainer(
      maxWidth: maxWidth,
      padding: padding,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          if (breadcrumb != null) ...[
            breadcrumb!,
            SizedBox(height: context.spacing.xs),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: context.spacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: alignment,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title case final titleWidget?) ...[titleWidget],
                    if (resolvedSubtitle case final subtitleWidget?) ...[
                      SizedBox(height: context.spacing.xxs),
                      subtitleWidget,
                    ],
                  ],
                ),
              ),
              if (actions.isNotEmpty) ...[
                SizedBox(width: context.spacing.sm),
                Wrap(
                  spacing: context.spacing.xs,
                  runSpacing: context.spacing.xs,
                  alignment: WrapAlignment.end,
                  children: actions,
                ),
              ],
            ],
          ),
          if (resolvedBottom case final bottomWidget?) ...[
            SizedBox(height: context.spacing.md),
            bottomWidget,
          ],
        ],
      ),
    );
  }
}
