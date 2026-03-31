import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

abstract final class FlashcardListHeaderConst {
  FlashcardListHeaderConst._();

  static const double titleBottomSpacing =
      8;
  static const double sortGap =
      12;
  static const double compactSortWidthBreakpoint = 360;
}

class FlashcardListHeader extends StatelessWidget {
  const FlashcardListHeader({
    required this.title,
    required this.subtitle,
    required this.sortLabel,
    required this.onSortPressed,
    super.key,
  });

  final String title;
  final String subtitle;
  final String sortLabel;
  final VoidCallback onSortPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    final ColorScheme colorScheme = theme.colorScheme;
    final double titleBottomSpacing = context.compactValue(
      baseValue: FlashcardListHeaderConst.titleBottomSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double sortGap = context.compactValue(
      baseValue: FlashcardListHeaderConst.sortGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final EdgeInsets sortPadding = context.compactInsets(
      baseInsets: EdgeInsets.symmetric(
        horizontal:
            context.spacing.sm,
        vertical:
            context.spacing.xs,
      ),
    );
    final Widget titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LumosInlineText(title, style: theme.textTheme.titleMedium),
        SizedBox(height: titleBottomSpacing),
        LumosInlineText(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
    final Widget sortAction = InkWell(
      onTap: onSortPressed,
      mouseCursor: AppMouseCursors.clickable,
      borderRadius: context.shapes.card,
      child: Padding(
        padding: sortPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LumosInlineText(sortLabel, style: theme.textTheme.titleMedium),
            SizedBox(width: sortGap),
            const LumosIcon(Icons.tune_rounded),
          ],
        ),
      ),
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth <
            FlashcardListHeaderConst.compactSortWidthBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              titleSection,
              SizedBox(height: sortGap),
              sortAction,
            ],
          );
        }
        return Row(
          children: <Widget>[
            Expanded(child: titleSection),
            SizedBox(width: sortGap),
            sortAction,
          ],
        );
      },
    );
  }
}
