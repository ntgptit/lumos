import 'package:flutter/material.dart';
import 'package:lumos/core/theme/app_foundation.dart';

class LumosBottomSheet extends StatelessWidget {
  const LumosBottomSheet({
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
    final sheetPadding = padding ?? EdgeInsets.all(context.spacing.md);
    final ShapeBorder sheetShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: context.shapes.sheet.topLeft,
        topRight: context.shapes.sheet.topRight,
      ),
      side: BorderSide(color: context.colorScheme.outlineVariant),
    );

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * maxHeightFactor,
        ),
        child: Material(
          color: context.colorScheme.surfaceContainerHigh,
          surfaceTintColor: Colors.transparent,
          shape: sheetShape,
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
                        borderRadius: context.shapes.pill,
                      ),
                    ),
                  ),
                  SizedBox(height: context.spacing.md),
                ],
                if (title != null) ...[
                  LumosText(
                    title!,
                    style: LumosTextStyle.titleLarge,
                    tone: LumosTextTone.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: context.spacing.xxs),
                    LumosText(
                      subtitle!,
                      style: LumosTextStyle.bodySmall,
                      tone: LumosTextTone.secondary,
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
