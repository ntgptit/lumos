import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';
import 'study_session_layout_metrics.dart';

const double _studySessionProgressBarHeight = LumosSpacing.md;

class StudySessionProgressRow extends StatelessWidget {
  const StudySessionProgressRow({required this.progressValue, super.key});

  final double progressValue;

  @override
  Widget build(BuildContext context) {
    final double barHeight = StudySessionLayoutMetrics.compactHeight(
      context,
      baseValue: _studySessionProgressBarHeight,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double valueGap = StudySessionLayoutMetrics.sectionSpacing(
      context,
      baseValue: LumosSpacing.md,
    );
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final int progressPercentage = (progressValue * 100).round();
    return Row(
      children: <Widget>[
        Expanded(
          child: LumosProgressBar(value: progressValue, height: barHeight),
        ),
        SizedBox(width: valueGap),
        LumosInlineText(
          '$progressPercentage%',
          align: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
