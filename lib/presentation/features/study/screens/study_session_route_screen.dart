import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';
import 'package:lumos/presentation/shared/screens/lumos_placeholder_screen.dart';

class StudySessionScreen extends StatelessWidget {
  const StudySessionScreen({
    required this.onOpenModePicker,
    required this.onOpenResult,
    required this.onExit,
    super.key,
  });

  final VoidCallback onOpenModePicker;
  final VoidCallback onOpenResult;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return LumosPlaceholderScreen(
      title: 'Study Session',
      actions: [
        LumosButton.primary(
          onPressed: onOpenModePicker,
          text: 'Mode Picker',
        ),
        LumosButton.primary(
          onPressed: onOpenResult,
          text: 'Finish Session',
        ),
        LumosButton.outline(onPressed: onExit, text: 'Exit'),
      ],
    );
  }
}
