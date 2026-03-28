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
    final double iconSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: IconSizes.iconMedium,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
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
      icon: LumosIcon(Icons.more_vert_rounded, size: iconSize),
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => items,
    );
  }
}

