import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../providers/study_speech_playback_provider.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const double _guessHeroCardMinHeight = 300;
const double _guessHeroIconSize = IconSizes.iconLarge;
const EdgeInsetsGeometry _guessHeroCardPadding = EdgeInsets.all(AppSpacing.xl);
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
    super.key,
  });

  final String prompt;
  final SpeechCapability speech;
  final StudySpeechPlaybackState playbackState;
  final VoidCallback onPlayPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isSpeechEnabled = speech.available && !playbackState.isBusy;
    return LumosCard(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _guessHeroCardMinHeight),
        child: Stack(
          children: <Widget>[
            const Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: _guessHeroTopIconPadding,
                child: LumosIcon(Icons.edit_outlined, size: _guessHeroIconSize),
              ),
            ),
            Padding(
              padding: _guessHeroCardPadding,
              child: Center(
                child: LumosInlineText(
                  prompt,
                  align: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    height: 1.15,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: _guessHeroBottomIconPadding,
                child: LumosIconButton(
                  icon: Icons.volume_up_rounded,
                  tooltip: speech.available ? speech.speechText : null,
                  onPressed: isSpeechEnabled ? onPlayPressed : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
