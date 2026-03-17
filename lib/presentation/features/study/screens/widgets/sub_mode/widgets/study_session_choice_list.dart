import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

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
    final double itemSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    if (useGrid) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool singleColumn = constraints.maxWidth < 360;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: singleColumn ? 1 : 2,
              crossAxisSpacing: itemSpacing,
              mainAxisSpacing: itemSpacing,
              childAspectRatio: singleColumn ? 3.2 : 1.2,
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
        },
      );
    }
    return Column(
      children: choices
          .map(
            (StudyChoice choice) => Padding(
              padding: EdgeInsets.only(bottom: itemSpacing),
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
