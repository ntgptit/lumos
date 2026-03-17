import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../widgets/study_session_content_card.dart';
import '../../widgets/study_session_layout_metrics.dart';

const double _reviewAnswerLineHeight =
    AppTypographyConst.headlineLargeLineHeight /
    AppTypographyConst.headlineLargeFontSize;

class StudySessionReviewAnswerCard extends StatelessWidget {
  const StudySessionReviewAnswerCard({
    required this.content,
    required this.isSpeechAvailable,
    required this.isPlaying,
    required this.tooltip,
    required this.onSpeechPressed,
    super.key,
  });

  final String content;
  final bool isSpeechAvailable;
  final bool isPlaying;
  final String tooltip;
  final VoidCallback onSpeechPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactHeight = constraints.maxHeight < 260;
        final EdgeInsets cardPadding = StudySessionLayoutMetrics.cardInsets(
          context,
          left: compactHeight ? AppSpacing.lg : AppSpacing.xl,
          top: AppSpacing.lg,
          right: compactHeight ? AppSpacing.lg : AppSpacing.xl,
          bottom: compactHeight ? AppSpacing.lg : AppSpacing.xl,
        );
        final EdgeInsets topTrailingPadding =
            StudySessionLayoutMetrics.topTrailingPadding(
              context,
              top: compactHeight ? AppSpacing.md : AppSpacing.lg,
              right: compactHeight ? AppSpacing.md : AppSpacing.lg,
            );
        return StudySessionContentCard(
          variant: LumosCardVariant.filled,
          topTrailing: LumosIconButton(
            icon: isPlaying
                ? Icons.volume_off_rounded
                : Icons.volume_up_rounded,
            tooltip: tooltip,
            onPressed: isSpeechAvailable ? onSpeechPressed : null,
          ),
          topTrailingPadding: topTrailingPadding,
          child: Padding(
            padding: cardPadding,
            child: Center(
              child: SingleChildScrollView(
                child: LumosInlineText(
                  content,
                  align: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w400,
                    height: _reviewAnswerLineHeight,
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
