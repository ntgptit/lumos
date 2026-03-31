import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class FolderHeaderMetaPill extends StatelessWidget {
  const FolderHeaderMetaPill({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.expandLabel = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool expandLabel;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.theme.textTheme;
    final EdgeInsets padding = context.compactInsets(
      baseInsets: EdgeInsets.symmetric(
        horizontal:
            context.spacing.sm,
        vertical:
            context.spacing.xs,
      ),
    );
    final double inlineGap = context.compactValue(
      baseValue: context.spacing.xs,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: context.shapes.pill,
      ),
      child: Row(
        mainAxisSize: expandLabel ? MainAxisSize.max : MainAxisSize.min,
        children: <Widget>[
          IconTheme(
            data: IconThemeData(color: foregroundColor),
            child: LumosIcon(
              icon,
              size: context.iconSize.sm,
            ),
          ),
          SizedBox(width: inlineGap),
          if (expandLabel)
            Expanded(
              child: LumosInlineText(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(color: foregroundColor),
              ),
            ),
          if (!expandLabel)
            LumosInlineText(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelMedium?.copyWith(color: foregroundColor),
            ),
        ],
      ),
    );
  }
}
