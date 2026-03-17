import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../mode/study_mode_view_model.dart';
import '../sub_mode/study_session_sub_mode_const.dart';
import 'study_session_screen_menu_action_button.dart';

class StudySessionScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const StudySessionScreenAppBar({
    required this.deckName,
    required this.session,
    required this.viewModel,
    required this.onPlaySpeech,
    required this.onStudyMenuSelected,
    super.key,
  });

  final String deckName;
  final StudySessionData? session;
  final StudyModeViewModel? viewModel;
  final VoidCallback onPlaySpeech;
  final ValueChanged<String> onStudyMenuSelected;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final StudySessionData? resolvedSession = session;
    if (resolvedSession == null) {
      return LumosAppBar(title: deckName);
    }
    final bool showsModeChrome =
        resolvedSession.activeMode == StudySessionSubModeConst.reviewMode ||
        resolvedSession.activeMode == StudySessionSubModeConst.matchMode ||
        resolvedSession.activeMode == StudySessionSubModeConst.guessMode ||
        resolvedSession.activeMode == StudySessionSubModeConst.fillMode ||
        resolvedSession.activeMode == StudySessionSubModeConst.recallMode;
    if (!showsModeChrome) {
      return LumosAppBar(
        title: deckName,
        actions: <Widget>[
          StudySessionScreenMenuActionButton(
            session: resolvedSession,
            onSelected: onStudyMenuSelected,
            reviewMenuReplayAudio:
                StudySessionScreenAppBarConst.reviewMenuReplayAudio,
            resetCurrentModeActionId:
                StudySessionScreenAppBarConst.resetCurrentModeActionId,
          ),
        ],
      );
    }
    final bool showsLeadingModeIcon = context.screenWidth >= 390;
    final double leadingModeInset = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.xs,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosAppBar(
      title: viewModel?.modeLabel ?? deckName,
      wrapActions: false,
      actions: <Widget>[
        if (showsLeadingModeIcon)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: leadingModeInset),
            child: const LumosIcon(Icons.text_fields_rounded),
          ),
        LumosIconButton(
          icon: Icons.volume_up_rounded,
          tooltip: l10n.flashcardPlayAudioTooltip,
          onPressed: resolvedSession.currentItem.speech.available
              ? onPlaySpeech
              : null,
        ),
        StudySessionScreenMenuActionButton(
          session: resolvedSession,
          onSelected: onStudyMenuSelected,
          reviewMenuReplayAudio:
              StudySessionScreenAppBarConst.reviewMenuReplayAudio,
          resetCurrentModeActionId:
              StudySessionScreenAppBarConst.resetCurrentModeActionId,
        ),
      ],
    );
  }
}

abstract final class StudySessionScreenAppBarConst {
  StudySessionScreenAppBarConst._();

  static const String reviewMenuReplayAudio = 'REPLAY_AUDIO';
  static const String resetCurrentModeActionId = 'RESET_CURRENT_MODE';
}
