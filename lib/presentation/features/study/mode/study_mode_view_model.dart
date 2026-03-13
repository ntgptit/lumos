import '../../../../domain/entities/study/study_models.dart';
import 'study_mode_action_view_model.dart';

class StudyModeViewModel {
  const StudyModeViewModel({
    required this.modeLabel,
    required this.instruction,
    required this.prompt,
    required this.answer,
    required this.showAnswer,
    required this.showAnswerInput,
    required this.inputLabel,
    required this.submitLabel,
    required this.useChoiceGrid,
    required this.choices,
    required this.matchPairs,
    required this.actions,
  });

  final String modeLabel;
  final String instruction;
  final String prompt;
  final String answer;
  final bool showAnswer;
  final bool showAnswerInput;
  final String inputLabel;
  final String submitLabel;
  final bool useChoiceGrid;
  final List<StudyChoice> choices;
  final List<StudyMatchPair> matchPairs;
  final List<StudyModeActionViewModel> actions;
}
