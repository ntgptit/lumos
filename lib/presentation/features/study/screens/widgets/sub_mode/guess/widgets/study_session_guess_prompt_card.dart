import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:lumos/core/theme/foundation/app_typography_const.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_app_bar.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_action_sheet.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_search_bar.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_sort_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item_card.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/layouts/lumos_screen_transition.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_floating_action_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_secondary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_loading_indicator.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_dropdown.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';
import '../../../../../providers/study_speech_playback_provider.dart';
import '../../widgets/study_session_content_card.dart';
import '../../widgets/study_session_layout_metrics.dart';

const double _guessHeroCardMinHeight = 184;
const double _guessHeroCardMaxHeight = 240;
const double _guessHeroCardHeightFactor = 0.58;
const double _guessHeroIconSize = IconSizes.iconMedium;
const double _guessHeroPromptLineHeight =
    AppTypographyConst.headlineLargeLineHeight /
    AppTypographyConst.headlineLargeFontSize;
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

