import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../l10n/app_localizations.dart';
import '../buttons/lumos_buttons.dart';
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LumosText(
            l10n.onboardingPlacementTestTitle,
            style: LumosTextStyle.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          LumosText(
            l10n.onboardingQuestionCount(questions.length),
            style: LumosTextStyle.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          LumosPrimaryButton(
            label: l10n.onboardingCompleteTestAction,
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
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
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
