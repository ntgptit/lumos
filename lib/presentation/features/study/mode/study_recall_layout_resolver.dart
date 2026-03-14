import '../../../../domain/entities/study/study_models.dart';
import 'study_mode_action_view_model.dart';
import 'study_mode_view_model.dart';

abstract final class StudyRecallLayoutResolver {
  StudyRecallLayoutResolver._();

  static const String _revealActionId = 'REVEAL_ANSWER';
  static const String _rememberedActionId = 'MARK_REMEMBERED';
  static const String _retryActionId = 'RETRY_ITEM';
  static const String _nextActionId = 'GO_NEXT';

  static List<StudyModeActionViewModel> resolveVisibleActions({
    required StudyModeViewModel viewModel,
    required bool showsNextActionOnly,
    StudyModeActionViewModel? fallbackNextAction,
  }) {
    if (!viewModel.showAnswer) {
      final StudyModeActionViewModel? revealAction = _findAction(
        actions: viewModel.actions,
        actionId: _revealActionId,
      );
      if (revealAction != null) {
        return <StudyModeActionViewModel>[revealAction];
      }
      return viewModel.actions;
    }
    if (showsNextActionOnly) {
      final StudyModeActionViewModel? nextAction = _findAction(
        actions: viewModel.actions,
        actionId: _nextActionId,
      );
      if (nextAction != null) {
        return <StudyModeActionViewModel>[nextAction];
      }
      if (fallbackNextAction != null) {
        return <StudyModeActionViewModel>[fallbackNextAction];
      }
      return const <StudyModeActionViewModel>[];
    }
    final List<StudyModeActionViewModel> feedbackActions =
        <StudyModeActionViewModel>[];
    final StudyModeActionViewModel? retryAction = _findAction(
      actions: viewModel.actions,
      actionId: _retryActionId,
    );
    if (retryAction != null) {
      feedbackActions.add(retryAction);
    }
    final StudyModeActionViewModel? rememberedAction = _findAction(
      actions: viewModel.actions,
      actionId: _rememberedActionId,
    );
    if (rememberedAction != null) {
      feedbackActions.add(rememberedAction);
    }
    if (feedbackActions.isNotEmpty) {
      return feedbackActions;
    }
    return viewModel.actions;
  }

  static String resolvePromptContent({
    required StudySessionData session,
    required StudyModeViewModel viewModel,
  }) {
    if (viewModel.prompt.isNotEmpty) {
      return viewModel.prompt;
    }
    if (session.currentItem.pronunciation.isNotEmpty) {
      return session.currentItem.pronunciation;
    }
    return resolveAnswerContent(session: session);
  }

  static String resolveAnswerContent({required StudySessionData session}) {
    final String answer = session.currentItem.answer;
    final String note = session.currentItem.note;
    if (note.isEmpty) {
      return answer;
    }
    if (answer.isEmpty) {
      return note;
    }
    return '$answer / $note';
  }

  static StudyModeActionViewModel? _findAction({
    required List<StudyModeActionViewModel> actions,
    required String actionId,
  }) {
    for (final StudyModeActionViewModel action in actions) {
      if (action.actionId != actionId) {
        continue;
      }
      return action;
    }
    return null;
  }
}
