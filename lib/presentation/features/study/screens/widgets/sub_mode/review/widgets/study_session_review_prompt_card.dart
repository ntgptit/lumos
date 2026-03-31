import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../widgets/study_session_content_card.dart';
import '../../widgets/study_session_layout_metrics.dart';

const double _reviewPromptIconSize =
    24;

class StudySessionReviewPromptCard extends StatelessWidget {
  const StudySessionReviewPromptCard({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    final ColorScheme colorScheme = theme.colorScheme;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactHeight =
            constraints.maxHeight < StudySessionLayoutMetrics.compactPanelHeightBreakpoint;
        final double iconSize = context.compactValue(
          baseValue: compactHeight
              ? context.iconSize.sm
              : _reviewPromptIconSize,
          minScale: ResponsiveDimensions.compactInsetScale,
        );
        final EdgeInsets cardPadding = StudySessionLayoutMetrics.cardPadding(
          context,
          horizontal: compactHeight
              ? context.spacing.lg
              : context.spacing.xl,
          vertical: compactHeight
              ? context.spacing.lg
              : context.spacing.xl,
        );
        final EdgeInsets
        topTrailingPadding = StudySessionLayoutMetrics.topTrailingPadding(
          context,
          top: compactHeight
              ? context.spacing.md
              : context.spacing.lg,
          right: compactHeight
              ? context.spacing.md
              : context.spacing.lg,
        );
        return StudySessionContentCard(
          variant: LumosCardVariant.filled,
          topTrailing: LumosIcon(Icons.edit_outlined, size: iconSize),
          topTrailingPadding: topTrailingPadding,
          child: Padding(
            padding: cardPadding,
            child: Center(
              child: SingleChildScrollView(
                child: LumosInlineText(
                  content,
                  align: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
