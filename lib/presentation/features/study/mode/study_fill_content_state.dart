import '../providers/study_fill_selection_provider.dart';
import 'study_mode_action_view_model.dart';
import 'study_mode_view_model.dart';

const String _fillRetryLabel = 'Nhập lại';

class StudyFillContentState {
  const StudyFillContentState({
    required this.showsAnswerPanel,
    required this.showsInputPanel,
    required this.showsRetryAction,
    required this.secondaryAction,
    required this.primaryLabel,
  });

  final bool showsAnswerPanel;
  final bool showsInputPanel;
  final bool showsRetryAction;
  final StudyModeActionViewModel? secondaryAction;
  final String? primaryLabel;

  bool get showsBottomActions {
    return showsRetryAction || showsInputPanel;
  }

  static StudyFillContentState resolve({
    required StudyModeViewModel viewModel,
    required StudyFillSelectionState fillSelectionState,
  }) {
    final bool showsRetryInput = fillSelectionState.showsRetryInput;
    final bool showsIncorrectResult = fillSelectionState.hasIncorrectSubmission;
    final bool showsRecoveredRetryInput =
        viewModel.showAnswer &&
        viewModel.showAnswerInput &&
        !showsIncorrectResult &&
        !showsRetryInput;
    final bool showsInputPanel =
        (viewModel.showAnswerInput && !viewModel.showAnswer) ||
        showsRecoveredRetryInput ||
        showsRetryInput;
    final bool showsRetryAction = showsIncorrectResult && !showsRetryInput;
    final bool showsAnswerPanel = viewModel.showAnswer && !showsInputPanel;
    final StudyModeActionViewModel? secondaryAction =
        showsInputPanel || showsRetryAction
        ? _resolveRevealAction(viewModel.actions)
        : null;
    final String? primaryLabel = _resolvePrimaryLabel(
      showsRetryAction: showsRetryAction,
      showsInputPanel: showsInputPanel,
      submitLabel: viewModel.submitLabel,
    );
    return StudyFillContentState(
      showsAnswerPanel: showsAnswerPanel,
      showsInputPanel: showsInputPanel,
      showsRetryAction: showsRetryAction,
      secondaryAction: secondaryAction,
      primaryLabel: primaryLabel,
    );
  }

  static StudyModeActionViewModel? _resolveRevealAction(
    List<StudyModeActionViewModel> actions,
  ) {
    for (final StudyModeActionViewModel action in actions) {
      if (action.actionId != 'REVEAL_ANSWER') {
        continue;
      }
      return action;
    }
    return null;
  }

  static String? _resolvePrimaryLabel({
    required bool showsRetryAction,
    required bool showsInputPanel,
    required String submitLabel,
  }) {
    if (showsRetryAction) {
      return _fillRetryLabel;
    }
    if (showsInputPanel) {
      return submitLabel;
    }
    return null;
  }
}
