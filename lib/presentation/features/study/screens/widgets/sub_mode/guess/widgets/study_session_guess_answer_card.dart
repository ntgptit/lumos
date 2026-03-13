import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const String _guessAnswerLabel = 'Đáp án';
const EdgeInsetsGeometry _guessAnswerCardPadding = EdgeInsets.all(
  AppSpacing.xl,
);

class StudySessionGuessAnswerCard extends StatelessWidget {
  const StudySessionGuessAnswerCard({required this.answer, super.key});

  final String answer;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return LumosCard(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadii.xLarge,
      child: Padding(
        padding: _guessAnswerCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LumosInlineText(
              _guessAnswerLabel,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            LumosInlineText(
              answer,
              align: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
