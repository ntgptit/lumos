import '../../../../domain/entities/study/study_models.dart';
import 'study_mode_view_model.dart';
import 'abstract_study_mode_view_strategy.dart';

class FillStudyModeViewStrategy extends AbstractStudyModeViewStrategy {
  const FillStudyModeViewStrategy();

  @override
  String get supportedMode => 'FILL';

  @override
  StudyModeViewModel buildViewModel({required StudySessionData session}) {
    final StudyModeViewModel baseViewModel = super.buildViewModel(
      session: session,
    );
    return StudyModeViewModel(
      modeLabel: baseViewModel.modeLabel,
      instruction: baseViewModel.instruction,
      prompt: session.currentItem.answer,
      answer: session.currentItem.prompt,
      showAnswer: baseViewModel.showAnswer,
      showAnswerInput: baseViewModel.showAnswerInput,
      inputLabel: baseViewModel.inputLabel,
      submitLabel: baseViewModel.submitLabel,
      useChoiceGrid: baseViewModel.useChoiceGrid,
      choices: baseViewModel.choices,
      matchPairs: baseViewModel.matchPairs,
      actions: baseViewModel.actions,
    );
  }

  @override
  List<String> resolveActionOrder() {
    return const <String>['REVEAL_ANSWER', 'GO_NEXT'];
  }

  @override
  String resolveRevealActionLabel() {
    return 'Trợ giúp';
  }

  @override
  String resolveSubmitLabel() {
    return 'Kiểm tra';
  }
}
