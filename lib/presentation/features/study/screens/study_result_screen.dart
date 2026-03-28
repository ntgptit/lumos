import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
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
      title: context.l10n.placeholderStudyResultTitle,
      actions: [
        LumosButton.primary(
          onPressed: onRestartSession,
          text: context.l10n.placeholderStudyResultRestartAction,
        ),
        LumosButton.outline(
          onPressed: onOpenHistory,
          text: context.l10n.placeholderStudyResultHistoryAction,
        ),
        LumosButton.outline(
          onPressed: onReturnToDeck,
          text: context.l10n.placeholderStudyResultReturnAction,
        ),
      ],
    );
  }
}
