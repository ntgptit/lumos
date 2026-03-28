import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/deck_models.dart';
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

abstract final class DeckListTileConst {
  DeckListTileConst._();

  static const double leadingSize = WidgetSizes.avatarLarge;
  static const double leadingBorderWidth = WidgetSizes.borderWidthRegular;
  static const double leadingIconSize = IconSizes.iconMedium;
}

abstract final class DeckListTileActionKey {
  DeckListTileActionKey._();

  static const String rename = 'rename';
  static const String delete = 'delete';
}

class DeckListTile extends StatelessWidget {
  const DeckListTile({
    required this.item,
    required this.onOpen,
    required this.onRename,
    required this.onDelete,
    super.key,
  });

  final DeckNode item;
  final VoidCallback onOpen;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final double leadingSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: DeckListTileConst.leadingSize,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double leadingIconSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: DeckListTileConst.leadingIconSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosActionListItemCard(
      title: item.name,
      subtitle: _buildSubtitle(l10n),
      onTap: onOpen,
      leading: Container(
        width: leadingSize,
        height: leadingSize,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadii.large,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: DeckListTileConst.leadingBorderWidth,
          ),
        ),
        child: IconTheme(
          data: IconThemeData(
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          child: LumosIcon(
            Icons.style_rounded,
            size: leadingIconSize,
          ),
        ),
      ),
      actions: _buildActions(l10n: l10n),
      onActionSelected: (String actionKey) {
        _handleAction(actionKey: actionKey);
      },
    );
  }

  String _buildSubtitle(AppLocalizations l10n) {
    return l10n.deckFlashcardCount(item.flashcardCount);
  }

  List<LumosActionListItem> _buildActions({required AppLocalizations l10n}) {
    return <LumosActionListItem>[
      LumosActionListItem(
        key: DeckListTileActionKey.rename,
        label: l10n.commonRename,
        icon: Icons.drive_file_rename_outline_rounded,
        supportingText: l10n.deckRenameTitle,
      ),
      LumosActionListItem(
        key: DeckListTileActionKey.delete,
        label: l10n.commonDelete,
        icon: Icons.delete_outline_rounded,
        supportingText: l10n.deckDeleteTitle,
        tone: LumosActionListItemTone.critical,
      ),
    ];
  }

  void _handleAction({required String actionKey}) {
    if (actionKey == DeckListTileActionKey.rename) {
      onRename();
      return;
    }
    if (actionKey == DeckListTileActionKey.delete) {
      onDelete();
      return;
    }
  }
}

