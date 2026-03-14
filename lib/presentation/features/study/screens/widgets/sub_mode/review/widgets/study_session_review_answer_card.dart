import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../widgets/study_session_content_card.dart';

const double _reviewAnswerLineHeight =
    AppTypographyConst.headlineLargeLineHeight /
    AppTypographyConst.headlineLargeFontSize;
const EdgeInsetsGeometry _reviewAnswerCardPadding = EdgeInsets.fromLTRB(
  AppSpacing.xl,
  AppSpacing.lg,
  AppSpacing.xl,
  AppSpacing.xl,
);
const EdgeInsetsGeometry _reviewAnswerTopIconPadding = EdgeInsets.only(
  top: AppSpacing.lg,
  right: AppSpacing.lg,
);

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
    return StudySessionContentCard(
      variant: LumosCardVariant.filled,
      topTrailing: LumosIconButton(
        icon: isPlaying ? Icons.volume_off_rounded : Icons.volume_up_rounded,
        tooltip: tooltip,
        onPressed: isSpeechAvailable ? onSpeechPressed : null,
      ),
      topTrailingPadding: _reviewAnswerTopIconPadding,
      child: Padding(
        padding: _reviewAnswerCardPadding,
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
  }
}
