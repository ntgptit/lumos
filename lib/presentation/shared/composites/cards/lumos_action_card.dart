import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_title_text.dart';

class LumosActionCard extends StatelessWidget {
  const LumosActionCard({
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
                    LumosTitleText(text: title),
                    if (subtitle != null) ...[
                      SizedBox(height: context.spacing.xxs),
                      LumosBodyText(text: subtitle!),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: context.spacing.sm),
                trailing!,
              ] else if (onTap != null) ...[
                SizedBox(width: context.spacing.xxs),
                const LumosIcon(Icons.chevron_right_rounded),
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
                  LumosOutlineButton(
                    text: secondaryActionLabel!,
                    onPressed: onSecondaryAction,
                  ),
                if (primaryActionLabel != null)
                  LumosPrimaryButton(
                    text: primaryActionLabel!,
                    onPressed: onPrimaryAction,
                  ),
              ],
            ),
          ],
        ],
      ),
    );

    return LumosCard(
      margin: margin,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: content,
    );
  }
}
