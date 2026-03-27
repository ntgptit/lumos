import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_icon.dart';
import 'package:lumos/presentation/shared/primitives/text/app_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/app_title_text.dart';

class AppActionCard extends StatelessWidget {
  const AppActionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.onTap,
    this.margin,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? EdgeInsets.all(context.component.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: context.spacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTitleText(text: title),
                    if (subtitle != null) ...[
                      SizedBox(height: context.spacing.xxs),
                      AppBodyText(text: subtitle!),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: context.spacing.sm),
                trailing!,
              ] else if (onTap != null) ...[
                SizedBox(width: context.spacing.xxs),
                const AppIcon(Icons.chevron_right_rounded),
              ],
            ],
          ),
          if (primaryActionLabel != null || secondaryActionLabel != null) ...[
            SizedBox(height: context.spacing.md),
            Wrap(
              spacing: context.spacing.sm,
              runSpacing: context.spacing.sm,
              children: [
                if (secondaryActionLabel != null)
                  AppOutlineButton(
                    text: secondaryActionLabel!,
                    onPressed: onSecondaryAction,
                  ),
                if (primaryActionLabel != null)
                  AppPrimaryButton(
                    text: primaryActionLabel!,
                    onPressed: onPrimaryAction,
                  ),
              ],
            ),
          ],
        ],
      ),
    );

    return AppCard(
      margin: margin,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: content),
      ),
    );
  }
}
