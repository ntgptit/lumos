import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class FlashcardProgressStatCard extends StatelessWidget {
  const FlashcardProgressStatCard({
    required this.label,
    required this.value,
    required this.minHeight,
    required this.valueColor,
    required this.onPressed,
    super.key,
  });

  final String label;
  final int value;
  final double minHeight;
  final Color valueColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      minHeight: minHeight,
      variant: LumosCardVariant.outlined,
      padding: EdgeInsets.symmetric(
        horizontal:
            context.spacing.sm,
        vertical:
            context.spacing.md,
      ),
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LumosInlineText(
            '$value',
            align: TextAlign.center,
            style: context.theme.textTheme.headlineSmall?.copyWith(
             
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: context.spacing.xs),
          LumosInlineText(
            label,
            align: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.theme.textTheme.bodySmall?.copyWith(
             
              color: context.theme
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
