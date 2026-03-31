import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../l10n/app_localizations.dart';
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
    final double iconSize = context.compactValue(
      baseValue:
          context.iconSize.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final List<PopupMenuEntry<String>> items = <PopupMenuEntry<String>>[];
    if (session.activeMode == StudySessionSubModeConst.reviewMode &&
        session.currentItem.speech.available) {
      items.add(
        LumosPopupMenuActionItem<String>(
          value: reviewMenuReplayAudio,
          label: l10n.studySpeechReplayAction,
          icon: Icons.replay_rounded,
        ),
      );
    }
    if (session.allowedActions.contains(resetCurrentModeActionId)) {
      if (items.isNotEmpty) {
        items.add(const PopupMenuDivider());
      }
      items.add(
        LumosPopupMenuActionItem<String>(
          value: resetCurrentModeActionId,
          label: l10n.studyResetCurrentModeAction,
          icon: Icons.restart_alt_rounded,
        ),
      );
    }
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return LumosPopupMenuButton<String>(
      icon: LumosIcon(Icons.more_vert_rounded, size: iconSize),
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => items,
    );
  }
}
