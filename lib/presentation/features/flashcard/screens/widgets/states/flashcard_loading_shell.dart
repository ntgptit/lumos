import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../core/utils/string_utils.dart';
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
import '../../../../home/screens/widgets/blocks/footer/home_bottom_nav.dart';

const EdgeInsetsGeometry _flashcardLoadingMaskPadding = EdgeInsets.fromLTRB(
  LumosSpacing.lg,
  LumosSpacing.sm,
  LumosSpacing.lg,
  LumosSpacing.none,
);
const double _flashcardLoadingMaskHeight = WidgetSizes.progressTrackHeight;

class FlashcardLoadingShell extends StatelessWidget {
  const FlashcardLoadingShell({required this.deckName, super.key});

  final String deckName;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String normalizedDeckName = StringUtils.normalizeName(deckName);
    final String title = normalizedDeckName.isEmpty
        ? l10n.flashcardTitle
        : normalizedDeckName;
    return Scaffold(
      appBar: LumosAppBar(title: title),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: _flashcardLoadingMaskPadding,
            child: ClipRRect(
              borderRadius: BorderRadii.medium,
              child: const LumosLoadingIndicator(
                isLinear: true,
                size: _flashcardLoadingMaskHeight,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: context.deviceType == DeviceType.mobile
          ? const HomeBottomNav()
          : null,
    );
  }
}

