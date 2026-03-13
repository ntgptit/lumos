import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionAnswerInput extends StatelessWidget {
  const StudySessionAnswerInput({
    required this.controller,
    required this.label,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LumosTextField(
          controller: controller,
          label: label,
        ),
        const SizedBox(height: AppSpacing.md),
        LumosPrimaryButton(
          onPressed: onSubmit,
          label: 'Submit answer',
          icon: Icons.check_rounded,
        ),
      ],
    );
  }
}
