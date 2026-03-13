import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionChoiceList extends StatelessWidget {
  const StudySessionChoiceList({
    required this.choices,
    required this.onChoicePressed,
    super.key,
  });

  final List<StudyChoice> choices;
  final ValueChanged<String> onChoicePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: choices
          .map(
            (StudyChoice choice) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: LumosOutlineButton(
                onPressed: () => onChoicePressed(choice.label),
                label: choice.label,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
