import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/screens/app_placeholder_screen.dart';

class StudyModePickerScreen extends StatelessWidget {
  const StudyModePickerScreen({required this.onModeSelected, super.key});

  final ValueChanged<String> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return AppPlaceholderScreen(
      title: 'Study Mode Picker',
      actions: [
        FilledButton(
          onPressed: () {
            onModeSelected('review');
          },
          child: const Text('Review'),
        ),
      ],
    );
  }
}
