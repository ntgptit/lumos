import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import 'study_session_layout_metrics.dart';

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
    final double itemSpacing = context.compactValue(
      baseValue: context.spacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    if (useGrid) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool singleColumn = constraints.maxWidth <
              StudySessionLayoutMetrics.narrowContentWidthBreakpoint;
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
                text: choice.label,
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
                text: choice.label,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
