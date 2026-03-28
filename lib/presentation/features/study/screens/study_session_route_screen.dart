import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
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
      title: context.l10n.placeholderStudySessionTitle,
      actions: [
        LumosButton.primary(
          onPressed: onOpenModePicker,
          text: context.l10n.placeholderStudySessionModePickerAction,
        ),
        LumosButton.primary(
          onPressed: onOpenResult,
          text: context.l10n.placeholderStudySessionFinishAction,
        ),
        LumosButton.outline(
          onPressed: onExit,
          text: context.l10n.placeholderStudySessionExitAction,
        ),
      ],
    );
  }
}
