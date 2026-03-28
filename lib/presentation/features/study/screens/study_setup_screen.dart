import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';
import 'package:lumos/presentation/shared/screens/lumos_placeholder_screen.dart';

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
    return LumosPlaceholderScreen(
      title: context.l10n.placeholderStudySetupTitle,
      actions: [
        LumosButton.primary(
          onPressed: onStartSession,
          text: context.l10n.placeholderStudySetupStartAction,
        ),
        LumosButton.outline(
          onPressed: onOpenModePicker,
          text: context.l10n.placeholderStudySetupModePickerAction,
        ),
        LumosButton.outline(
          onPressed: onOpenHistory,
          text: context.l10n.placeholderStudySetupHistoryAction,
        ),
      ],
    );
  }
}
