import 'package:flutter/material.dart';

import '../../../../../../core/constants/dimensions.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FlashcardStudyAction {
  const FlashcardStudyAction({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
}

class FlashcardStudyActionSection extends StatelessWidget {
  const FlashcardStudyActionSection({required this.actions, super.key});

  final List<FlashcardStudyAction> actions;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: actions
          .map((FlashcardStudyAction action) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Insets.spacing8),
              child: LumosButton(
                label: action.label,
                icon: action.icon,
                expanded: true,
                onPressed: action.onPressed,
                type: LumosButtonType.outline,
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
