import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosFormFieldLabel extends StatelessWidget {
  const LumosFormFieldLabel({
    super.key,
    required this.label,
    this.supportingText,
    this.trailing,
    this.isRequired = false,
  });

  final String label;
  final String? supportingText;
  final Widget? trailing;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: context.colorScheme.onSurface,
    );
    final supportingStyle = context.textTheme.bodySmall?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: titleStyle,
                  children: [
                    TextSpan(text: label),
                    if (isRequired)
                      TextSpan(
                        text: context.l10n.requiredFieldMark,
                        style: titleStyle?.copyWith(
                          color: context.colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: context.spacing.sm),
              trailing!,
            ],
          ],
        ),
        if (supportingText != null) ...[
          SizedBox(height: context.spacing.xxs),
          Text(supportingText!, style: supportingStyle),
        ],
      ],
    );
  }
}
