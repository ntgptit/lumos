import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_label.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_value_text.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_body_text.dart';

class LumosStatCard extends StatelessWidget {
  const LumosStatCard({
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
    return LumosCard(
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
                  Expanded(child: LumosLabel(text: label)),
                  if (trailing != null) ...[
                    SizedBox(width: context.spacing.sm),
                    trailing!,
                  ] else if (onTap != null) ...[
                    const LumosIcon(Icons.chevron_right_rounded),
                  ],
                ],
              ),
              SizedBox(height: context.spacing.sm),
              LumosValueText(text: value),
              if (subtitle != null) ...[
                SizedBox(height: context.spacing.xxs),
                LumosBodyText(text: subtitle!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
