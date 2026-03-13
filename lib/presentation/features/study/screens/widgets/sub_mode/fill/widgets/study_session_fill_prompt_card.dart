import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../providers/study_speech_playback_provider.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const double _fillHeroIconSize = IconSizes.iconMedium;
const double _fillHeroPromptLineHeight =
    AppTypographyConst.headlineLargeLineHeight /
    AppTypographyConst.headlineLargeFontSize;
const int _fillHeroPromptMaxLines = 2;
const EdgeInsetsGeometry _fillHeroCardPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.xl,
  vertical: AppSpacing.xl,
);
const EdgeInsetsGeometry _fillHeroTopIconPadding = EdgeInsets.only(
  top: AppSpacing.lg,
  right: AppSpacing.lg,
);
const EdgeInsetsGeometry _fillHeroBottomIconPadding = EdgeInsets.only(
  right: AppSpacing.md,
  bottom: AppSpacing.md,
);

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
    final Widget promptCardContent = Stack(
      children: <Widget>[
        const Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: _fillHeroTopIconPadding,
            child: LumosIcon(
              Icons.edit_outlined,
              size: _fillHeroIconSize,
            ),
          ),
        ),
        Padding(
          padding: _fillHeroCardPadding,
          child: Center(
            child: SingleChildScrollView(
              child: LumosInlineText(
                prompt,
                align: TextAlign.center,
                maxLines: _fillHeroPromptMaxLines,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  height: _fillHeroPromptLineHeight,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: _fillHeroBottomIconPadding,
            child: LumosIconButton(
              icon: Icons.volume_up_rounded,
              tooltip: speech.available ? speech.speechText : null,
              onPressed: isSpeechEnabled ? onPlayPressed : null,
            ),
          ),
        ),
      ],
    );
    return LumosCard(
      margin: EdgeInsets.zero,
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: height == null
          ? SizedBox.expand(child: promptCardContent)
          : SizedBox(height: height, child: promptCardContent),
    );
  }
}
