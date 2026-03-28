import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
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
import '../../../folder_content_support.dart';

class FolderCreateButton extends StatelessWidget {
  const FolderCreateButton({
    required this.l10n,
    required this.horizontalInset,
    required this.actions,
    required this.isMutating,
    required this.onOpenActionSheet,
    super.key,
  });

  final AppLocalizations l10n;
  final double horizontalInset;
  final List<FolderContentSupportCreateAction> actions;
  final bool isMutating;
  final VoidCallback onOpenActionSheet;

  @override
  Widget build(BuildContext context) {
    if (isMutating) {
      return const SizedBox.shrink();
    }
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    final bool isSingleAction = actions.length == 1;
    final FolderContentSupportCreateAction singleAction = actions.first;
    final double bottomInset = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.xxl,
      minScale: ResponsiveDimensions.compactVerticalInsetScale,
    );
    return Positioned(
      right: horizontalInset,
      bottom: bottomInset,
      child: LumosFloatingActionButton(
        onPressed: () {
          if (isSingleAction) {
            singleAction.onPressed();
            return;
          }
          onOpenActionSheet();
        },
        icon: isSingleAction
            ? singleAction.icon
            : Icons.add_circle_outline_rounded,
        label: isSingleAction ? singleAction.label : l10n.commonCreate,
      ),
    );
  }
}

