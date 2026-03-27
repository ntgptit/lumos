import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/screens/app_placeholder_screen.dart';

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
    return AppPlaceholderScreen(
      title: 'Study Session',
      actions: [
        FilledButton(
          onPressed: onOpenModePicker,
          child: const Text('Mode Picker'),
        ),
        FilledButton(
          onPressed: onOpenResult,
          child: const Text('Finish Session'),
        ),
        OutlinedButton(onPressed: onExit, child: const Text('Exit')),
      ],
    );
  }
}
