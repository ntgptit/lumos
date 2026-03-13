import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionPromptCard extends StatelessWidget {
  const StudySessionPromptCard({
    required this.instruction,
    required this.prompt,
    required this.showAnswer,
    required this.answer,
    super.key,
  });

  final String instruction;
  final String prompt;
  final bool showAnswer;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LumosText(
              instruction,
              style: LumosTextStyle.labelLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            LumosText(
              prompt,
              style: LumosTextStyle.headlineSmall,
              align: TextAlign.center,
            ),
            if (showAnswer) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              LumosText(
                answer,
                style: LumosTextStyle.titleLarge,
                align: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
