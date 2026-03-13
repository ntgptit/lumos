import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../providers/study_speech_playback_provider.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const double _recallPromptIconSize = IconSizes.iconMedium;
const double _recallPromptLineHeight =
    AppTypographyConst.headlineLargeLineHeight /
    AppTypographyConst.headlineLargeFontSize;
const int _recallPromptMaxLines = 3;
const EdgeInsetsGeometry _recallPromptCardPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.xl,
  vertical: AppSpacing.xl,
);
const EdgeInsetsGeometry _recallPromptTopIconPadding = EdgeInsets.only(
  top: AppSpacing.lg,
  right: AppSpacing.lg,
);
const EdgeInsetsGeometry _recallPromptBottomIconPadding = EdgeInsets.only(
  right: AppSpacing.md,
  bottom: AppSpacing.md,
);

class StudySessionRecallPromptCard extends StatelessWidget {
  const StudySessionRecallPromptCard({
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
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            const Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: _recallPromptTopIconPadding,
                child: LumosIcon(
                  Icons.edit_outlined,
                  size: _recallPromptIconSize,
                ),
              ),
            ),
            Padding(
              padding: _recallPromptCardPadding,
              child: Center(
                child: SingleChildScrollView(
                  child: LumosInlineText(
                    prompt,
                    align: TextAlign.center,
                    maxLines: _recallPromptMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                      height: _recallPromptLineHeight,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: _recallPromptBottomIconPadding,
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
