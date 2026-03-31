import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'study_session_layout_metrics.dart';

const double _studySessionProgressBarHeight =
    16;

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
      baseValue: context.spacing.md,
    );
    final ThemeData theme = context.theme;
    final ColorScheme colorScheme = theme.colorScheme;
    final int progressPercentage = (progressValue * 100).round();
    return Row(
      children: <Widget>[
        Expanded(
          child: LumosValueBar(value: progressValue, height: barHeight),
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
