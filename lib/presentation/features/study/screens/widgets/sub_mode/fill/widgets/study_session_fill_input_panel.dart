import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const EdgeInsetsGeometry _fillInputPanelPadding = EdgeInsets.all(AppSpacing.xl);
const double _fillInputFieldMaxWidth = 360;

class StudySessionFillInputPanel extends StatelessWidget {
  const StudySessionFillInputPanel({
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
    return LumosCard(
      margin: EdgeInsets.zero,
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: SizedBox.expand(
        child: Padding(
          padding: _fillInputPanelPadding,
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: _fillInputFieldMaxWidth,
                ),
                child: LumosTextField(
                  controller: controller,
                  hint: label,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    onSubmit();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
