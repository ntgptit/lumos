import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionHeader extends StatelessWidget {
  const StudySessionHeader({
    required this.sessionType,
    required this.modeLabel,
    required this.progressValue,
    super.key,
  });

  final String sessionType;
  final String modeLabel;
  final double progressValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LumosText(
          '$sessionType · $modeLabel',
          style: LumosTextStyle.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        LumosProgressBar(value: progressValue),
      ],
    );
  }
}
