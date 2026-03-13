import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionReviewProgressRow extends StatelessWidget {
  const StudySessionReviewProgressRow({required this.progressValue, super.key});

  final double progressValue;

  @override
  Widget build(BuildContext context) {
    final int progressPercent = (progressValue * 100).round();
    final Color progressColor = context.appColors.success;
    return Row(
      children: <Widget>[
        Expanded(
          child: LumosProgressBar(value: progressValue, height: AppSpacing.sm),
        ),
        const SizedBox(width: AppSpacing.md),
        LumosInlineText(
          '$progressPercent%',
          align: TextAlign.center,
          style: context.textTheme.titleLarge?.copyWith(color: progressColor),
        ),
      ],
    );
  }
}
