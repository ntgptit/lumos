import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../mode/study_mode_view_model.dart';
import 'study_session_action_bar.dart';
import 'study_session_answer_input.dart';
import 'study_session_choice_list.dart';
import 'study_session_header.dart';
import 'study_session_prompt_card.dart';

class StudySessionContent extends StatelessWidget {
  const StudySessionContent({
    required this.session,
    required this.viewModel,
    required this.answerController,
    required this.onSubmitTypedAnswer,
    required this.onChoicePressed,
    required this.onActionPressed,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final TextEditingController answerController;
  final VoidCallback onSubmitTypedAnswer;
  final ValueChanged<String> onChoicePressed;
  final ValueChanged<String> onActionPressed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        StudySessionHeader(
          sessionType: session.sessionType,
          activeMode: session.activeMode,
          progressValue: session.progress.sessionProgress,
        ),
        const SizedBox(height: AppSpacing.lg),
        StudySessionPromptCard(
          instruction: viewModel.instruction,
          prompt: viewModel.prompt,
          showAnswer: viewModel.showAnswer,
          answer: viewModel.answer,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (viewModel.choices.isNotEmpty)
          StudySessionChoiceList(
            choices: viewModel.choices,
            onChoicePressed: onChoicePressed,
          ),
        if (viewModel.showAnswerInput)
          StudySessionAnswerInput(
            controller: answerController,
            label: viewModel.inputLabel,
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
