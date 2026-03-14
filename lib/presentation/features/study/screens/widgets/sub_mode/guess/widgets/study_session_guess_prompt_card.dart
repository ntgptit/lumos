import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../providers/study_speech_playback_provider.dart';
import '../../widgets/study_session_content_card.dart';

const double _guessHeroCardMinHeight = 184;
const double _guessHeroCardMaxHeight = 240;
const double _guessHeroCardHeightFactor = 0.58;
const double _guessHeroIconSize = IconSizes.iconMedium;
const double _guessHeroPromptLineHeight =
    AppTypographyConst.headlineLargeLineHeight /
    AppTypographyConst.headlineLargeFontSize;
const int _guessHeroPromptMaxLines = 2;
const EdgeInsetsGeometry _guessHeroCardPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.xl,
  vertical: AppSpacing.xl,
);
const EdgeInsetsGeometry _guessHeroTopIconPadding = EdgeInsets.only(
  top: AppSpacing.lg,
  right: AppSpacing.lg,
);
const EdgeInsetsGeometry _guessHeroBottomIconPadding = EdgeInsets.only(
  right: AppSpacing.md,
  bottom: AppSpacing.md,
);

class StudySessionGuessPromptCard extends StatelessWidget {
  const StudySessionGuessPromptCard({
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double resolvedHeight =
            height ??
            math.min(
              _guessHeroCardMaxHeight,
              math.max(
                _guessHeroCardMinHeight,
                constraints.maxWidth * _guessHeroCardHeightFactor,
              ),
            );
        return StudySessionContentCard(
          height: resolvedHeight,
          expandToFill: false,
          topTrailing: const LumosIcon(
            Icons.edit_outlined,
            size: _guessHeroIconSize,
          ),
          topTrailingPadding: _guessHeroTopIconPadding,
          bottomTrailing: LumosIconButton(
            icon: Icons.volume_up_rounded,
            tooltip: speech.available ? speech.speechText : null,
            onPressed: isSpeechEnabled ? onPlayPressed : null,
          ),
          bottomTrailingPadding: _guessHeroBottomIconPadding,
          child: Padding(
            padding: _guessHeroCardPadding,
            child: Center(
              child: LumosInlineText(
                prompt,
                align: TextAlign.center,
                maxLines: _guessHeroPromptMaxLines,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  height: _guessHeroPromptLineHeight,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
