import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.actions,
    this.showDragHandle = true,
    this.padding,
    this.maxHeightFactor = 0.9,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showDragHandle;
  final EdgeInsetsGeometry? padding;
  final double maxHeightFactor;

  @override
  Widget build(BuildContext context) {
    final sheetPadding =
        padding ??
        EdgeInsets.fromLTRB(
          context.spacing.md,
          context.spacing.sm,
          context.spacing.md,
          context.spacing.md,
        );

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * maxHeightFactor,
        ),
        child: Material(
          color: context.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.radius.lg),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: sheetPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showDragHandle) ...[
                  Center(
                    child: Container(
                      width: context.component.bottomSheetHandleWidth,
                      height: context.component.bottomSheetHandleHeight,
                      decoration: BoxDecoration(
                        color: context.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(
                          context.radius.pill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.spacing.md),
                ],
                if (title != null) ...[
                  Text(
                    title!,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: context.spacing.xxs),
                    Text(
                      subtitle!,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  SizedBox(height: context.spacing.md),
                ],
                Flexible(child: child),
                if (actions != null && actions!.isNotEmpty) ...[
                  SizedBox(height: context.spacing.md),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: context.spacing.sm,
                    runSpacing: context.spacing.sm,
                    children: actions!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
