import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_value_bar.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_label.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_title_text.dart';

class LumosMetricCard extends StatelessWidget {
  const LumosMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.leading,
    this.trailing,
    this.progressLabel,
    this.onTap,
    this.margin,
    this.padding,
  });

  final String title;
  final double value;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final String? progressLabel;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final percentage = (value.clamp(0, 1) * 100).round();

    return LumosCard(
      margin: margin,
      onTap: onTap,
      padding: padding,
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
              ] else ...[
                LumosLabel(
                  text: progressLabel ?? '$percentage%',
                  color: context.colorScheme.primary,
                ),
              ],
            ],
          ),
          SizedBox(height: context.spacing.md),
          LumosValueBar(value: value),
        ],
      ),
    );
  }
}
