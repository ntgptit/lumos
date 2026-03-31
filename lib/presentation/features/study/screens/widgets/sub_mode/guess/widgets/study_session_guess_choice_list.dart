import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../providers/study_guess_selection_provider.dart';
import '../../widgets/study_session_layout_metrics.dart';
import 'study_session_guess_choice_card.dart';

const double studySessionGuessChoiceGap =
    12;

class StudySessionGuessChoiceList extends StatelessWidget {
  const StudySessionGuessChoiceList({
    required this.choices,
    required this.selectionState,
    required this.isInteractive,
    required this.onChoicePressed,
    this.cardHeight,
    super.key,
  });

  final List<StudyChoice> choices;
  final StudyGuessSelectionState selectionState;
  final bool isInteractive;
  final ValueChanged<String> onChoicePressed;
  final double? cardHeight;

  @override
  Widget build(BuildContext context) {
    final int choiceCount = choices.length;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double choiceGap = StudySessionLayoutMetrics.sectionSpacing(
          context,
          baseValue:
              constraints.maxWidth <
                  StudySessionLayoutMetrics.compactActionWidthBreakpoint
              ? context.spacing.xs
              : studySessionGuessChoiceGap,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List<Widget>.generate(choiceCount, (int index) {
            final StudyChoice choice = choices[index];
            final bool isLastChoice = index == choiceCount - 1;
            return Padding(
              padding: EdgeInsets.only(
                bottom: isLastChoice
                    ? 0
                    : choiceGap,
              ),
              child: StudySessionGuessChoiceCard(
                label: choice.label,
                height: cardHeight,
                isSelected: selectionState.isChoiceSelected(choice.label),
                isSuccessFeedback: selectionState.isSuccessFeedbackFor(
                  choice.label,
                ),
                isErrorFeedback: selectionState.isErrorFeedbackFor(
                  choice.label,
                ),
                isInteractive: isInteractive,
                onPressed: () => onChoicePressed(choice.label),
              ),
            );
          }, growable: false),
        );
      },
    );
  }
}
