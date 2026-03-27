import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_label.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_value_text.dart';
import 'package:lumos/presentation/shared/primitives/text/app_body_text.dart';

class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.margin,
    this.padding,
  });

  final String label;
  final String value;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: margin,
      padding: padding,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
                  Expanded(child: AppLabel(text: label)),
                  if (trailing != null) ...[
                    SizedBox(width: context.spacing.sm),
                    trailing!,
                  ] else if (onTap != null) ...[
                    const AppIcon(Icons.chevron_right_rounded),
                  ],
                ],
              ),
              SizedBox(height: context.spacing.sm),
              AppValueText(text: value),
              if (subtitle != null) ...[
                SizedBox(height: context.spacing.xxs),
                AppBodyText(text: subtitle!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
