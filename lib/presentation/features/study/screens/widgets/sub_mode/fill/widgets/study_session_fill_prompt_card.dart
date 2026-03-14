import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../providers/study_speech_playback_provider.dart';
import '../../widgets/study_session_content_card.dart';
import '../../widgets/study_session_layout_metrics.dart';

const double _fillHeroIconSize = IconSizes.iconMedium;
const double _fillHeroPromptLineHeight =
    AppTypographyConst.titleMediumLineHeight /
    AppTypographyConst.titleMediumFontSize;
const int _fillHeroPromptMaxLines = 3;

class StudySessionFillPromptCard extends StatelessWidget {
  const StudySessionFillPromptCard({
    required this.prompt,
    required this.speech,
    required this.playbackState,
    required this.onPlayPressed,
    this.height,
    super.key,
  });

  final String prompt;
  final SpeechCapability speech;
  final StudySpeechPlaybackState playbackState;
  final VoidCallback onPlayPressed;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isSpeechEnabled = speech.available && !playbackState.isBusy;
    final double iconSize = StudySessionLayoutMetrics.compactIcon(
      context,
      baseValue: _fillHeroIconSize,
    );
    final EdgeInsets cardPadding = StudySessionLayoutMetrics.cardPadding(
      context,
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.xl,
    );
    final EdgeInsets topTrailingPadding =
        StudySessionLayoutMetrics.topTrailingPadding(context);
    final EdgeInsets bottomTrailingPadding =
        StudySessionLayoutMetrics.bottomTrailingPadding(context);
    return StudySessionContentCard(
      variant: LumosCardVariant.filled,
      height: height,
      expandToFill: height == null,
      topTrailing: LumosIcon(Icons.edit_outlined, size: iconSize),
      topTrailingPadding: topTrailingPadding,
      bottomTrailing: LumosIconButton(
        icon: Icons.volume_up_rounded,
        tooltip: speech.available ? speech.speechText : null,
        onPressed: isSpeechEnabled ? onPlayPressed : null,
      ),
      bottomTrailingPadding: bottomTrailingPadding,
      child: Padding(
        padding: cardPadding,
        child: Center(
          child: SingleChildScrollView(
            child: LumosInlineText(
              prompt,
              align: TextAlign.center,
              maxLines: _fillHeroPromptMaxLines,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                height: _fillHeroPromptLineHeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
