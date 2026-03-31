import 'package:flutter/material.dart';
import 'package:lumos/core/theme/app_foundation.dart';

import '../../../../../mode/study_mode_view_model.dart';
import '../../../../../providers/study_fill_selection_provider.dart';
import '../../widgets/study_session_layout_metrics.dart';
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final EdgeInsets panelInset = context.compactInsets(
          baseInsets: EdgeInsets.symmetric(
            horizontal:
                constraints.maxWidth <
                    StudySessionLayoutMetrics.narrowContentWidthBreakpoint
                ? context.spacing.xs
                : 0,
            vertical:
                constraints.maxHeight <
                    StudySessionLayoutMetrics.compactPanelHeightBreakpoint
                ? context.spacing.xs
                : 0,
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
