import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../providers/study_speech_playback_provider.dart';
import '../../widgets/study_session_content_card.dart';
import '../../widgets/study_session_layout_metrics.dart';

const double _fillHeroIconSize =
    24;
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
    final ThemeData theme = context.theme;
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isSpeechEnabled = speech.available && !playbackState.isBusy;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactHeight =
            constraints.maxHeight < StudySessionLayoutMetrics.compactPanelHeightBreakpoint;
        final double iconSize = context.compactValue(
          baseValue: compactHeight
              ? context.iconSize.sm
              : _fillHeroIconSize,
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
        final EdgeInsets
        bottomTrailingPadding = StudySessionLayoutMetrics.bottomTrailingPadding(
          context,
          right: compactHeight
              ? context.spacing.sm
              : context.spacing.md,
          bottom: compactHeight
              ? context.spacing.sm
              : context.spacing.md,
        );
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
