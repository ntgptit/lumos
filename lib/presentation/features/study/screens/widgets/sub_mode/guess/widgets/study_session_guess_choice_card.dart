import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../widgets/study_session_layout_metrics.dart';

const double studySessionGuessChoiceCardDefaultHeight = 64;
const int _guessChoiceMaxLines = 2;
const EdgeInsetsGeometry _guessChoiceCardPadding = EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 8,
);

class StudySessionGuessChoiceCard extends StatelessWidget {
  const StudySessionGuessChoiceCard({
    required this.label,
    required this.onPressed,
    this.height,
    this.isSelected = false,
    this.isSuccessFeedback = false,
    this.isErrorFeedback = false,
    this.isInteractive = true,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final double? height;
  final bool isSelected;
  final bool isSuccessFeedback;
  final bool isErrorFeedback;
  final bool isInteractive;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    final ColorScheme colorScheme = theme.colorScheme;
    final double resolvedHeight =
        height ??
        StudySessionLayoutMetrics.compactHeight(
          context,
          baseValue: studySessionGuessChoiceCardDefaultHeight,
          minScale: ResponsiveDimensions.compactLargeInsetScale,
        );
    final EdgeInsets cardPadding = context.compactInsets(
      baseInsets: _guessChoiceCardPadding as EdgeInsets,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final Color backgroundColor = isSuccessFeedback
        ? context.appColors.successContainer
        : isErrorFeedback
        ? colorScheme.errorContainer
        : colorScheme.surfaceContainerHighest;
    final Color textColor = isSuccessFeedback
        ? context.appColors.onSuccessContainer
        : isErrorFeedback
        ? colorScheme.onErrorContainer
        : colorScheme.onSurfaceVariant;
    return LumosCard(
      margin: EdgeInsets.zero,
      onTap: isInteractive ? onPressed : null,
      isSelected: isSelected && !isSuccessFeedback && !isErrorFeedback,
      variant: LumosCardVariant.filled,
      borderRadius: context.shapes.hero,
      padding: EdgeInsets.zero,
      child: AnimatedContainer(
        duration:
            AppMotion.medium,
        curve: Curves.easeInOutCubic,
        decoration: BoxDecoration(
          color: isSuccessFeedback || isErrorFeedback
              ? backgroundColor
              : colorScheme.surface.withValues(alpha: AppOpacity.transparent),
          borderRadius: context.shapes.hero,
        ),
        child: SizedBox(
          height: resolvedHeight,
          child: Padding(
            padding: cardPadding,
            child: Center(
              child: LumosInlineText(
                label,
                align: TextAlign.center,
                maxLines: _guessChoiceMaxLines,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
