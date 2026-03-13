import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const double _guessProgressBarHeight = AppSpacing.lg;

class StudySessionGuessProgressRow extends StatelessWidget {
  const StudySessionGuessProgressRow({
    required this.progressValue,
    super.key,
  });

  final double progressValue;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final int progressPercentage = (progressValue * 100).round();
    return Row(
      children: <Widget>[
        Expanded(
          child: LumosProgressBar(
            value: progressValue,
            height: _guessProgressBarHeight,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        LumosInlineText(
          '$progressPercentage%',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
