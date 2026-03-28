import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_app_bar.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_action_sheet.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_search_bar.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_sort_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item_card.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/layouts/lumos_screen_transition.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_floating_action_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_secondary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_loading_indicator.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_dropdown.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';
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
      baseValue: LumosSpacing.xs,
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

