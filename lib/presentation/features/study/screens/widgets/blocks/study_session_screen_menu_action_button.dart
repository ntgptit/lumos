import 'package:flutter/material.dart';

import '../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../sub_mode/study_session_sub_mode_const.dart';

class StudySessionScreenMenuActionButton extends StatelessWidget {
  const StudySessionScreenMenuActionButton({
    required this.session,
    required this.onSelected,
    required this.reviewMenuReplayAudio,
    required this.resetCurrentModeActionId,
    super.key,
  });

  final StudySessionData session;
  final ValueChanged<String> onSelected;
  final String reviewMenuReplayAudio;
  final String resetCurrentModeActionId;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<PopupMenuEntry<String>> items = <PopupMenuEntry<String>>[];
    if (session.activeMode == StudySessionSubModeConst.reviewMode &&
        session.currentItem.speech.available) {
      items.add(
        PopupMenuItem<String>(
          value: reviewMenuReplayAudio,
          child: LumosText(
            l10n.studySpeechReplayAction,
            style: LumosTextStyle.bodyMedium,
          ),
        ),
      );
    }
    if (session.allowedActions.contains(resetCurrentModeActionId)) {
      if (items.isNotEmpty) {
        items.add(const PopupMenuDivider());
      }
      items.add(
        PopupMenuItem<String>(
          value: resetCurrentModeActionId,
          child: LumosText(
            l10n.studyResetCurrentModeAction,
            style: LumosTextStyle.bodyMedium,
          ),
        ),
      );
    }
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return PopupMenuButton<String>(
      icon: const LumosIcon(Icons.more_vert_rounded),
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => items,
    );
  }
}
