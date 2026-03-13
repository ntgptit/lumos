import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../providers/study_guess_selection_provider.dart';
import 'study_session_guess_choice_card.dart';

const double _guessChoiceGap = AppSpacing.sm;

class StudySessionGuessChoiceList extends StatelessWidget {
  const StudySessionGuessChoiceList({
    required this.choices,
    required this.selectionState,
    required this.isInteractive,
    required this.onChoicePressed,
    super.key,
  });

  final List<StudyChoice> choices;
  final StudyGuessSelectionState selectionState;
  final bool isInteractive;
  final ValueChanged<String> onChoicePressed;

  @override
  Widget build(BuildContext context) {
    final int choiceCount = choices.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List<Widget>.generate(choiceCount, (int index) {
        final StudyChoice choice = choices[index];
        final bool isLastChoice = index == choiceCount - 1;
        return Padding(
          padding: EdgeInsets.only(
            bottom: isLastChoice ? AppSpacing.none : _guessChoiceGap,
          ),
          child: StudySessionGuessChoiceCard(
            label: choice.label,
            isSelected: selectionState.isChoiceSelected(choice.label),
            isSuccessFeedback: selectionState.isSuccessFeedbackFor(
              choice.label,
            ),
            isErrorFeedback: selectionState.isErrorFeedbackFor(choice.label),
            isInteractive: isInteractive,
            onPressed: () => onChoicePressed(choice.label),
          ),
        );
      }, growable: false),
    );
  }
}
