import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../buttons/lumos_button.dart';
import '../cards/lumos_card.dart';
import '../lumos_models.dart';
import '../typography/lumos_text.dart';

class LumosLevelTest extends StatelessWidget {
  const LumosLevelTest({
    required this.questions,
    required this.onComplete,
    super.key,
  });

  final List<TestQuestion> questions;
  final ValueChanged<TestResult> onComplete;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const LumosText('Placement Test', style: LumosTextStyle.titleLarge),
          const SizedBox(height: Insets.spacing8),
          LumosText(
            '${questions.length} questions',
            style: LumosTextStyle.bodySmall,
          ),
          const SizedBox(height: Insets.gapBetweenItems),
          LumosButton(
            label: 'Complete test',
            onPressed: () {
              onComplete(
                TestResult(
                  totalQuestions: questions.length,
                  correctAnswers: ResponsiveDimensions.minPercentage.round(),
                ),
              );
            },
            expanded: true,
          ),
        ],
      ),
    );
  }
}

class LumosGoalSelector extends StatelessWidget {
  const LumosGoalSelector({
    required this.options,
    required this.onSelected,
    super.key,
    this.selected,
  });

  final List<GoalOption> options;
  final GoalOption? selected;
  final ValueChanged<GoalOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Insets.spacing8,
      runSpacing: Insets.spacing8,
      children: options
          .map(
            (GoalOption option) => ChoiceChip(
              label: Text(option.label),
              selected: selected == option,
              onSelected: (_) {
                onSelected(option);
              },
            ),
          )
          .toList(),
    );
  }
}

class LumosInterestTag extends StatelessWidget {
  const LumosInterestTag({
    required this.label,
    required this.isSelected,
    required this.onToggle,
    super.key,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label, overflow: TextOverflow.ellipsis),
      selected: isSelected,
      onSelected: onToggle,
    );
  }
}
