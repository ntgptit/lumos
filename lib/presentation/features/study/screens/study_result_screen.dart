import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/screens/app_placeholder_screen.dart';

class StudyResultScreen extends StatelessWidget {
  const StudyResultScreen({
    required this.onRestartSession,
    required this.onOpenHistory,
    required this.onReturnToDeck,
    super.key,
  });

  final VoidCallback onRestartSession;
  final VoidCallback onOpenHistory;
  final VoidCallback onReturnToDeck;

  @override
  Widget build(BuildContext context) {
    return AppPlaceholderScreen(
      title: 'Study Result',
      actions: [
        FilledButton(
          onPressed: onRestartSession,
          child: const Text('Restart'),
        ),
        OutlinedButton(
          onPressed: onOpenHistory,
          child: const Text('History'),
        ),
        OutlinedButton(
          onPressed: onReturnToDeck,
          child: const Text('Return'),
        ),
      ],
    );
  }
}
