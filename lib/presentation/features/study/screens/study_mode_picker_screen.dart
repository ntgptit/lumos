import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';
import 'package:lumos/presentation/shared/screens/lumos_placeholder_screen.dart';

class StudyModePickerScreen extends StatelessWidget {
  const StudyModePickerScreen({required this.onModeSelected, super.key});

  final ValueChanged<String> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return LumosPlaceholderScreen(
      title: 'Study Mode Picker',
      actions: [
        LumosButton.primary(
          onPressed: () {
            onModeSelected('review');
          },
          text: 'Review',
        ),
      ],
    );
  }
}
