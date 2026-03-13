import 'package:flutter/material.dart';

import '../../../../../mode/study_mode_view_model.dart';
import 'study_session_fill_answer_panel.dart';
import 'study_session_fill_input_panel.dart';

class StudySessionFillBodyPanel extends StatelessWidget {
  const StudySessionFillBodyPanel({
    required this.viewModel,
    required this.answerController,
    required this.showsAnswerPanel,
    required this.showsInputPanel,
    required this.onSubmitTypedAnswer,
    super.key,
  });

  final StudyModeViewModel viewModel;
  final TextEditingController answerController;
  final bool showsAnswerPanel;
  final bool showsInputPanel;
  final VoidCallback onSubmitTypedAnswer;

  @override
  Widget build(BuildContext context) {
    if (showsAnswerPanel) {
      return StudySessionFillAnswerPanel(content: viewModel.answer);
    }
    if (showsInputPanel) {
      return StudySessionFillInputPanel(
        controller: answerController,
        label: viewModel.inputLabel,
        onSubmit: onSubmitTypedAnswer,
      );
    }
    return const SizedBox.shrink();
  }
}
