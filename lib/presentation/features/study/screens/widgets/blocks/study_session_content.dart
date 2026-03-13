import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../mode/study_mode_view_model.dart';
import '../../../providers/study_match_selection_provider.dart';
import '../../../providers/study_speech_playback_provider.dart';
import 'study_session_action_bar.dart';
import 'study_session_answer_input.dart';
import 'study_session_choice_list.dart';
import 'study_session_header.dart';
import 'study_session_match_pairs.dart';
import 'study_session_prompt_card.dart';
import 'study_session_review_content.dart';
import 'study_session_speech_panel.dart';

class StudySessionContent extends StatelessWidget {
  const StudySessionContent({
    required this.session,
    required this.viewModel,
    required this.answerController,
    required this.matchSelectionState,
    required this.speechPlaybackState,
    required this.onSubmitTypedAnswer,
    required this.onSubmitMatchedPairs,
    required this.onChoicePressed,
    required this.onSelectMatchLeft,
    required this.onSelectMatchRight,
    required this.onActionPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final TextEditingController answerController;
  final StudyMatchSelectionState matchSelectionState;
  final StudySpeechPlaybackState speechPlaybackState;
  final VoidCallback onSubmitTypedAnswer;
  final VoidCallback onSubmitMatchedPairs;
  final ValueChanged<String> onChoicePressed;
  final ValueChanged<String> onSelectMatchLeft;
  final ValueChanged<String> onSelectMatchRight;
  final ValueChanged<String> onActionPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context) {
    if (session.activeMode == StudySessionReviewContentConst.reviewMode) {
      return StudySessionReviewContent(
        session: session,
        viewModel: viewModel,
        speechPlaybackState: speechPlaybackState,
        onGoNext: () =>
            onActionPressed(StudySessionReviewContentConst.nextActionId),
        onPlaySpeech: onPlaySpeech,
        onReplaySpeech: onReplaySpeech,
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        StudySessionHeader(
          sessionType: session.sessionType,
          modeLabel: viewModel.modeLabel,
          progressValue: session.progress.sessionProgress,
        ),
        const SizedBox(height: AppSpacing.lg),
        StudySessionSpeechPanel(
          speech: session.currentItem.speech,
          playbackState: speechPlaybackState,
          onPlayPressed: onPlaySpeech,
          onReplayPressed: onReplaySpeech,
        ),
        if (session.currentItem.speech.available)
          const SizedBox(height: AppSpacing.lg),
        StudySessionPromptCard(
          instruction: viewModel.instruction,
          prompt: viewModel.prompt,
          showAnswer: false,
          answer: '',
        ),
        if (viewModel.showAnswer) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          StudySessionPromptCard(
            instruction: 'Đáp án',
            prompt: viewModel.answer,
            showAnswer: false,
            answer: '',
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        if (viewModel.matchPairs.isNotEmpty)
          StudySessionMatchPairs(
            pairs: viewModel.matchPairs,
            matchedPairs: matchSelectionState.matchedPairs,
            selectedLeftId: matchSelectionState.selectedLeftId,
            selectedRightId: matchSelectionState.selectedRightId,
            onSelectLeft: onSelectMatchLeft,
            onSelectRight: onSelectMatchRight,
            onSubmit: onSubmitMatchedPairs,
            submitEnabled: matchSelectionState.canSubmit,
          ),
        if (viewModel.choices.isNotEmpty)
          StudySessionChoiceList(
            choices: viewModel.choices,
            useGrid: viewModel.useChoiceGrid,
            onChoicePressed: onChoicePressed,
          ),
        if (viewModel.showAnswerInput)
          StudySessionAnswerInput(
            controller: answerController,
            label: viewModel.inputLabel,
            submitLabel: viewModel.submitLabel,
            onSubmit: onSubmitTypedAnswer,
          ),
        const SizedBox(height: AppSpacing.md),
        StudySessionActionBar(
          actions: viewModel.actions,
          onActionPressed: onActionPressed,
        ),
      ],
    );
  }
}
