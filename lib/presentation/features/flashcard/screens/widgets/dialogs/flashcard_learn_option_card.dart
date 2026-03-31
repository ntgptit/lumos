import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/theme/tokens/layout/size_tokens.dart';

class FlashcardLearnOptionCard extends StatelessWidget {
  const FlashcardLearnOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconContainerSize,
    required this.iconSize,
    required this.rowGap,
    required this.cardPadding,
    required this.subtitleGap,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final double iconContainerSize;
  final double iconSize;
  final double rowGap;
  final double cardPadding;
  final double subtitleGap;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      variant: LumosCardVariant.outlined,
      margin: EdgeInsets.zero,
      minHeight: AppSizeTokens.comfortableButtonHeight,
      onTap: onTap,
      padding: EdgeInsets.all(cardPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: iconContainerSize,
            height: iconContainerSize,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: context.shapes.control,
              border: Border.all(color: context.colorScheme.outlineVariant),
            ),
            child: IconTheme(
              data: IconThemeData(color: foregroundColor, size: iconSize),
              child: LumosIcon(icon),
            ),
          ),
          SizedBox(width: rowGap),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LumosText(
                  title,
                  style: LumosTextStyle.bodyMedium,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: subtitleGap),
                LumosText(
                  subtitle,
                  style: LumosTextStyle.bodySmall,
                  tone: LumosTextTone.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
