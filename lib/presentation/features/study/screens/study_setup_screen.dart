import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/screens/app_placeholder_screen.dart';

class StudySetupScreen extends StatelessWidget {
  const StudySetupScreen({
    required this.onStartSession,
    required this.onOpenModePicker,
    required this.onOpenHistory,
    super.key,
  });

  final VoidCallback onStartSession;
  final VoidCallback onOpenModePicker;
  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) {
    return AppPlaceholderScreen(
      title: 'Study Setup',
      actions: [
        FilledButton(
          onPressed: onStartSession,
          child: const Text('Start Session'),
        ),
        OutlinedButton(
          onPressed: onOpenModePicker,
          child: const Text('Mode Picker'),
        ),
        OutlinedButton(
          onPressed: onOpenHistory,
          child: const Text('History'),
        ),
      ],
    );
  }
}
