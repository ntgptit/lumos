import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';
import 'package:lumos/presentation/shared/screens/lumos_placeholder_screen.dart';

class StudyModePickerScreen extends StatelessWidget {
  const StudyModePickerScreen({required this.onModeSelected, super.key});

  final ValueChanged<String> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return LumosPlaceholderScreen(
      title: context.l10n.placeholderStudyModePickerTitle,
      actions: [
        LumosButton.primary(
          onPressed: () {
            onModeSelected('review');
          },
          text: context.l10n.placeholderStudyModePickerReviewAction,
        ),
      ],
    );
  }
}
