import '../../../../domain/entities/study/study_models.dart';
import 'study_mode_action_view_model.dart';

class StudyModeViewModel {
  const StudyModeViewModel({
    required this.instruction,
    required this.prompt,
    required this.answer,
    required this.showAnswer,
    required this.showAnswerInput,
    required this.inputLabel,
    required this.choices,
    required this.actions,
  });

  final String instruction;
  final String prompt;
  final String answer;
  final bool showAnswer;
  final bool showAnswerInput;
  final String inputLabel;
  final List<StudyChoice> choices;
  final List<StudyModeActionViewModel> actions;
}
