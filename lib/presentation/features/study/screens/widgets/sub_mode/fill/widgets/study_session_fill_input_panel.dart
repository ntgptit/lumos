import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const EdgeInsetsGeometry _fillInputPanelPadding = EdgeInsets.all(AppSpacing.xl);

class StudySessionFillInputPanel extends StatelessWidget {
  const StudySessionFillInputPanel({
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
    return LumosCard(
      margin: EdgeInsets.zero,
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: SizedBox.expand(
        child: Padding(
          padding: _fillInputPanelPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LumosTextField(
                controller: controller,
                label: label,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  onSubmit();
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              LumosPrimaryButton(
                onPressed: onSubmit,
                label: submitLabel,
                icon: Icons.check_rounded,
                size: LumosButtonSize.large,
                expanded: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
