import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_title_text.dart';

class LumosEmptyState extends StatelessWidget {
  const LumosEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.child,
    this.actions = const [],
    this.maxWidth,
    this.padding,
  });

  final String title;
  final String? message;
  final Widget? icon;
  final Widget? child;
  final List<Widget> actions;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? context.layout.panelMaxWidth,
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.all(context.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                IconTheme.merge(
                  data: IconThemeData(
                    size: context.iconSize.xxxl,
                    color: context.colorScheme.primary,
                  ),
                  child: icon!,
                ),
                SizedBox(height: context.spacing.md),
              ],
              LumosTitleText(text: title, textAlign: TextAlign.center),
              if (message != null) ...[
                SizedBox(height: context.spacing.xs),
                LumosBodyText(text: message!, textAlign: TextAlign.center),
              ],
              if (child != null) ...[
                SizedBox(height: context.spacing.md),
                child!,
              ],
              if (actions.isNotEmpty) ...[
                SizedBox(height: context.spacing.md),
                Wrap(
                  spacing: context.spacing.sm,
                  runSpacing: context.spacing.sm,
                  alignment: WrapAlignment.center,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
