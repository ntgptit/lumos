import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_speech_playback_provider.dart';
import '../widgets/study_session_action_bar.dart';
import 'widgets/study_session_guess_answer_card.dart';
import 'widgets/study_session_guess_choice_list.dart';
import 'widgets/study_session_guess_progress_row.dart';
import 'widgets/study_session_guess_prompt_card.dart';

const String _submitAnswerActionId = 'SUBMIT_ANSWER';
const EdgeInsetsGeometry _guessContentPadding = EdgeInsets.fromLTRB(
  AppSpacing.lg,
  AppSpacing.lg,
  AppSpacing.lg,
  AppSpacing.xl,
);
const EdgeInsetsGeometry _guessProgressPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.lg,
);

class StudySessionGuessContent extends StatelessWidget {
  const StudySessionGuessContent({
    required this.session,
    required this.viewModel,
    required this.speechPlaybackState,
    required this.onChoicePressed,
    required this.onActionPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final StudySpeechPlaybackState speechPlaybackState;
  final ValueChanged<String> onChoicePressed;
  final Future<void> Function(String) onActionPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context) {
    final bool canSubmitChoice = session.allowedActions.contains(
      _submitAnswerActionId,
    );
    return Padding(
      padding: _guessContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: _guessProgressPadding,
            child: StudySessionGuessProgressRow(
              progressValue: session.progress.sessionProgress,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
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
                if (viewModel.showAnswer) ...<Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  StudySessionGuessAnswerCard(answer: viewModel.answer),
                ],
                if (viewModel.choices.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  StudySessionGuessChoiceList(
                    choices: viewModel.choices,
                    isInteractive: canSubmitChoice,
                    onChoicePressed: onChoicePressed,
                  ),
                ],
                if (viewModel.actions.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  StudySessionActionBar(
                    actions: viewModel.actions,
                    onActionPressed: onActionPressed,
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
