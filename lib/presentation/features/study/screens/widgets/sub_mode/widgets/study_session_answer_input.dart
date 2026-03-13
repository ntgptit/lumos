import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionAnswerInput extends StatelessWidget {
  const StudySessionAnswerInput({
    required this.controller,
    required this.label,
    required this.submitLabel,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String submitLabel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LumosTextField(controller: controller, label: label),
        const SizedBox(height: AppSpacing.md),
        LumosPrimaryButton(
          onPressed: onSubmit,
          label: submitLabel,
          icon: Icons.check_rounded,
        ),
      ],
    );
  }
}
