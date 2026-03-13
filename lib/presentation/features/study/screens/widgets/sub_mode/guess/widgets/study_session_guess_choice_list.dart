import 'package:flutter/material.dart';

import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import 'study_session_guess_choice_card.dart';

class StudySessionGuessChoiceList extends StatelessWidget {
  const StudySessionGuessChoiceList({
    required this.choices,
    required this.isInteractive,
    required this.onChoicePressed,
    super.key,
  });

  final List<StudyChoice> choices;
  final bool isInteractive;
  final ValueChanged<String> onChoicePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: choices
          .map(
            (StudyChoice choice) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: StudySessionGuessChoiceCard(
                label: choice.label,
                isInteractive: isInteractive,
                onPressed: () => onChoicePressed(choice.label),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
