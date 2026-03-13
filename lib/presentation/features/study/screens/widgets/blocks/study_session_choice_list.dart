import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionChoiceList extends StatelessWidget {
  const StudySessionChoiceList({
    required this.choices,
    required this.useGrid,
    required this.onChoicePressed,
    super.key,
  });

  final List<StudyChoice> choices;
  final bool useGrid;
  final ValueChanged<String> onChoicePressed;

  @override
  Widget build(BuildContext context) {
    if (useGrid) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 1.2,
        ),
        itemCount: choices.length,
        itemBuilder: (BuildContext context, int index) {
          final StudyChoice choice = choices[index];
          return LumosOutlineButton(
            onPressed: () => onChoicePressed(choice.label),
            label: choice.label,
          );
        },
      );
    }
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
