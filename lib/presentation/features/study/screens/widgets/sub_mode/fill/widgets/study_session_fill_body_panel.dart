import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../mode/study_mode_view_model.dart';
import 'study_session_fill_answer_panel.dart';
import 'study_session_fill_input_panel.dart';

const double _fillBodySectionSpacing = AppSpacing.lg;
const int _fillAnswerFlex = 6;
const int _fillInputFlex = 4;

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
        submitLabel: viewModel.submitLabel,
        onSubmit: onSubmitTypedAnswer,
      );
    }
    return const SizedBox.shrink();
  }
}
