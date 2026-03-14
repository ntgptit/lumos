import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_guess_selection_provider.dart';
import '../../../../providers/study_speech_playback_provider.dart';
import '../widgets/study_session_action_bar.dart';
import '../widgets/study_session_progress_row.dart';
import 'widgets/study_session_guess_choice_list.dart';
import 'widgets/study_session_guess_prompt_card.dart';

const String _submitAnswerActionId = 'SUBMIT_ANSWER';
const EdgeInsetsGeometry _guessContentPadding = EdgeInsets.fromLTRB(
  AppSpacing.lg,
  AppSpacing.md,
  AppSpacing.lg,
  AppSpacing.xl,
);
const EdgeInsetsGeometry _guessProgressPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.md,
);
const double _guessPromptHeightFactor = 0.45;
const double _guessSectionSpacing = AppSpacing.md;
const double _guessBottomSpacing = AppSpacing.none;
const double _guessMinimumChoiceHeight = 56;
const double _guessScrollableSectionSpacing = AppSpacing.md;
const double _guessScrollableBottomSpacing = AppSpacing.none;

class StudySessionGuessContent extends StatelessWidget {
  const StudySessionGuessContent({
    required this.session,
    required this.viewModel,
    required this.guessSelectionState,
    required this.speechPlaybackState,
    required this.onChoicePressed,
    required this.onActionPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final StudyGuessSelectionState guessSelectionState;
  final StudySpeechPlaybackState speechPlaybackState;
  final ValueChanged<String> onChoicePressed;
  final Future<void> Function(String) onActionPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context) {
    final bool canSubmitChoice =
        session.allowedActions.contains(_submitAnswerActionId) &&
        !guessSelectionState.isInteractionLocked;
    final bool showsActionBar =
        viewModel.actions.isNotEmpty &&
        !guessSelectionState.isInteractionLocked;
    return Padding(
      padding: _guessContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: _guessProgressPadding,
            child: StudySessionProgressRow(
              progressValue: session.progress.sessionProgress,
            ),
          ),
          const SizedBox(height: _guessSectionSpacing),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final ScrollBehavior scrollBehavior = ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false);
                final Widget scrollableContent = ScrollConfiguration(
                  behavior: scrollBehavior,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      StudySessionGuessPromptCard(
                        prompt: viewModel.prompt,
                        speech: session.currentItem.speech,
                        playbackState: speechPlaybackState,
                        onPlayPressed: speechPlaybackState.isPlaying
                            ? onReplaySpeech
                            : onPlaySpeech,
                      ),
                      if (viewModel.choices.isNotEmpty) ...<Widget>[
                        const SizedBox(height: _guessScrollableSectionSpacing),
                        StudySessionGuessChoiceList(
                          choices: viewModel.choices,
                          selectionState: guessSelectionState,
                          isInteractive: canSubmitChoice,
                          onChoicePressed: onChoicePressed,
                        ),
                      ],
                      if (viewModel.actions.isNotEmpty &&
                          !guessSelectionState.isInteractionLocked) ...<Widget>[
                        const SizedBox(height: _guessScrollableSectionSpacing),
                        StudySessionActionBar(
                          actions: viewModel.actions,
                          onActionPressed: onActionPressed,
                        ),
                      ],
                      const SizedBox(height: _guessScrollableBottomSpacing),
                    ],
                  ),
                );
                if (viewModel.choices.isEmpty || showsActionBar) {
                  return scrollableContent;
                }
                final int choiceCount = viewModel.choices.length;
                final double promptHeight =
                    constraints.maxHeight * _guessPromptHeightFactor;
                final double availableChoicesHeight =
                    constraints.maxHeight -
                    promptHeight -
                    _guessSectionSpacing -
                    _guessBottomSpacing;
                final double choiceHeight =
                    (availableChoicesHeight -
                        (studySessionGuessChoiceGap *
                            math.max(0, choiceCount - 1))) /
                    math.max(1, choiceCount);
                if (choiceHeight < _guessMinimumChoiceHeight) {
                  return scrollableContent;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    StudySessionGuessPromptCard(
                      prompt: viewModel.prompt,
                      speech: session.currentItem.speech,
                      playbackState: speechPlaybackState,
                      onPlayPressed: speechPlaybackState.isPlaying
                          ? onReplaySpeech
                          : onPlaySpeech,
                      height: promptHeight,
                    ),
                    const SizedBox(height: _guessSectionSpacing),
                    StudySessionGuessChoiceList(
                      choices: viewModel.choices,
                      selectionState: guessSelectionState,
                      isInteractive: canSubmitChoice,
                      cardHeight: choiceHeight,
                      onChoicePressed: onChoicePressed,
                    ),
                    const SizedBox(height: _guessBottomSpacing),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
