import 'package:flutter/material.dart';

import '../../../../../mode/study_mode_view_model.dart';
import '../../../../../providers/study_fill_selection_provider.dart';
import 'study_session_fill_answer_panel.dart';
import 'study_session_fill_input_panel.dart';
import 'package:lumos/core/theme/app_foundation.dart';

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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final EdgeInsets panelInset = ResponsiveDimensions.compactInsets(
          context: context,
          baseInsets: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth < 360
                ? LumosSpacing.xs
                : LumosSpacing.none,
            vertical: constraints.maxHeight < 260
                ? LumosSpacing.xs
                : LumosSpacing.none,
          ),
        );
        if (showsAnswerPanel) {
          return Padding(
            padding: panelInset,
            child: StudySessionFillAnswerPanel(
              content: viewModel.answer,
              submittedAnswer: fillSelectionState.submittedAnswer,
              mismatchStartIndex: fillSelectionState.mismatchStartIndex,
            ),
          );
        }
        if (showsInputPanel) {
          return Padding(
            padding: panelInset,
            child: StudySessionFillInputPanel(
              controller: answerController,
              label: viewModel.inputLabel,
              showsRequiredInputError:
                  fillSelectionState.showsRequiredInputError,
              onChanged: onInputChanged,
              onSubmit: onSubmitTypedAnswer,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

