import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../providers/study_speech_playback_provider.dart';
import '../../widgets/study_session_content_card.dart';
import '../../widgets/study_session_layout_metrics.dart';

const double _guessHeroCardMinHeight = 184;
const double _guessHeroCardMaxHeight = 240;
const double _guessHeroCardHeightFactor = 0.58;
const double _guessHeroIconSize = IconSizes.iconMedium;
const int _guessHeroPromptMaxLines = 2;

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
    final double resolvedIconSize = StudySessionLayoutMetrics.compactIcon(
      context,
      baseValue: _guessHeroIconSize,
    );
    final EdgeInsets cardPadding = StudySessionLayoutMetrics.cardPadding(
      context,
      horizontal: LumosSpacing.xl,
      vertical: LumosSpacing.xl,
    );
    final EdgeInsets topTrailingPadding =
        StudySessionLayoutMetrics.topTrailingPadding(context);
    final EdgeInsets bottomTrailingPadding =
        StudySessionLayoutMetrics.bottomTrailingPadding(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double resolvedHeight =
            height ??
            math.min(
              StudySessionLayoutMetrics.compactHeight(
                context,
                baseValue: _guessHeroCardMaxHeight,
                minScale: ResponsiveDimensions.compactLargeInsetScale,
              ),
              math.max(
                StudySessionLayoutMetrics.compactHeight(
                  context,
                  baseValue: _guessHeroCardMinHeight,
                ),
                constraints.maxWidth * _guessHeroCardHeightFactor,
              ),
            );
        return StudySessionContentCard(
          height: resolvedHeight,
          expandToFill: false,
          topTrailing: LumosIcon(Icons.edit_outlined, size: resolvedIconSize),
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
              child: LumosInlineText(
                prompt,
                align: TextAlign.center,
                maxLines: _guessHeroPromptMaxLines,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
