import 'package:flutter/material.dart';

import '../../../../../mode/study_mode_view_model.dart';
import '../../../../../providers/study_fill_selection_provider.dart';
import 'study_session_fill_answer_panel.dart';
import 'study_session_fill_input_panel.dart';

class StudySessionFillBodyPanel extends StatelessWidget {
  const StudySessionFillBodyPanel({
    required this.viewModel,
    required this.fillSelectionState,
    required this.answerController,
    required this.showsAnswerPanel,
    required this.showsInputPanel,
    required this.onInputChanged,
    required this.onSubmitTypedAnswer,
    super.key,
  });

  final StudyModeViewModel viewModel;
  final StudyFillSelectionState fillSelectionState;
  final TextEditingController answerController;
  final bool showsAnswerPanel;
  final bool showsInputPanel;
  final ValueChanged<String> onInputChanged;
  final VoidCallback onSubmitTypedAnswer;

  @override
  Widget build(BuildContext context) {
    if (showsAnswerPanel) {
      return StudySessionFillAnswerPanel(
        content: viewModel.answer,
        submittedAnswer: fillSelectionState.submittedAnswer,
        mismatchStartIndex: fillSelectionState.mismatchStartIndex,
      );
    }
    if (showsInputPanel) {
      return StudySessionFillInputPanel(
        controller: answerController,
        label: viewModel.inputLabel,
        showsRequiredInputError: fillSelectionState.showsRequiredInputError,
        onChanged: onInputChanged,
        onSubmit: onSubmitTypedAnswer,
      );
    }
    return const SizedBox.shrink();
  }
}
