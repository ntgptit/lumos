import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../widgets/study_session_content_card.dart';
import '../../widgets/study_session_layout_metrics.dart';

const double _recallHiddenAnswerWidth = 88;
const double _recallHiddenAnswerHeight = 18;
const double _recallHiddenAnswerBlurRadius = 28;
const double _recallHiddenAnswerSpreadRadius = 6;

class StudySessionRecallAnswerPanel extends StatelessWidget {
  const StudySessionRecallAnswerPanel({
    required this.content,
    required this.isRevealed,
    super.key,
  });

  final String content;
  final bool isRevealed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final EdgeInsets cardPadding = StudySessionLayoutMetrics.cardPadding(
      context,
      horizontal: LumosSpacing.xl,
      vertical: LumosSpacing.xl,
    );
    final double hiddenAnswerWidth = StudySessionLayoutMetrics.compactHeight(
      context,
      baseValue: _recallHiddenAnswerWidth,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double hiddenAnswerHeight = StudySessionLayoutMetrics.compactHeight(
      context,
      baseValue: _recallHiddenAnswerHeight,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double hiddenAnswerBlurRadius =
        StudySessionLayoutMetrics.compactHeight(
          context,
          baseValue: _recallHiddenAnswerBlurRadius,
          minScale: ResponsiveDimensions.compactLargeInsetScale,
        );
    final double hiddenAnswerSpreadRadius =
        StudySessionLayoutMetrics.compactHeight(
          context,
          baseValue: _recallHiddenAnswerSpreadRadius,
          minScale: ResponsiveDimensions.compactLargeInsetScale,
        );
    final Widget panelContent = isRevealed
        ? Padding(
            key: const ValueKey<String>('revealed-answer'),
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
          )
        : Center(
            key: const ValueKey<String>('hidden-answer'),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(
                  alpha: AppOpacity.stateHover,
                ),
                borderRadius: context.shapes.pill,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(
                      alpha: AppOpacity.scrimLight,
                    ),
                    blurRadius: hiddenAnswerBlurRadius,
                    spreadRadius: hiddenAnswerSpreadRadius,
                  ),
                ],
              ),
              child: SizedBox(
                width: hiddenAnswerWidth,
                height: hiddenAnswerHeight,
              ),
            ),
          );
    return StudySessionContentCard(
      variant: LumosCardVariant.filled,
      child: AnimatedSwitcher(
        duration: AppDurations.medium,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: panelContent,
      ),
    );
  }
}
