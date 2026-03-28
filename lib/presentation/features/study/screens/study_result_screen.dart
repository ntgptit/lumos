import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';
import 'package:lumos/presentation/shared/screens/lumos_placeholder_screen.dart';

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
    return LumosPlaceholderScreen(
      title: 'Study Result',
      actions: [
        LumosButton.primary(
          onPressed: onRestartSession,
          text: 'Restart',
        ),
        LumosButton.outline(
          onPressed: onOpenHistory,
          text: 'History',
        ),
        LumosButton.outline(
          onPressed: onReturnToDeck,
          text: 'Return',
        ),
      ],
    );
  }
}
