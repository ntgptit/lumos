import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/cards/lumos_action_list_item_card.dart';
import '../../../../../shared/widgets/misc/lumos_misc_widgets.dart';
import '../../../../../../domain/entities/deck_models.dart';

abstract final class DeckTileConst {
  DeckTileConst._();

  static const double leadingSize = WidgetSizes.avatarLarge;
  static const double leadingBorderWidth = WidgetSizes.borderWidthRegular;
  static const double leadingIconSize = IconSizes.iconMedium;
}

abstract final class DeckTileActionKey {
  DeckTileActionKey._();

  static const String rename = 'rename';
  static const String delete = 'delete';
}

class DeckTile extends StatelessWidget {
  const DeckTile({
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosActionListItemCard(
      title: item.name,
      subtitle: _buildSubtitle(l10n),
      onTap: onOpen,
      leading: const _DeckTileLeading(),
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
        key: DeckTileActionKey.rename,
        label: l10n.commonRename,
        icon: Icons.drive_file_rename_outline_rounded,
        supportingText: l10n.deckRenameTitle,
      ),
      LumosActionListItem(
        key: DeckTileActionKey.delete,
        label: l10n.commonDelete,
        icon: Icons.delete_outline_rounded,
        supportingText: l10n.deckDeleteTitle,
        tone: LumosActionListItemTone.critical,
      ),
    ];
  }

  void _handleAction({required String actionKey}) {
    if (actionKey == DeckTileActionKey.rename) {
      onRename();
      return;
    }
    if (actionKey == DeckTileActionKey.delete) {
      onDelete();
      return;
    }
  }
}

class _DeckTileLeading extends StatelessWidget {
  const _DeckTileLeading();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: DeckTileConst.leadingSize,
      height: DeckTileConst.leadingSize,
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadii.large,
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: DeckTileConst.leadingBorderWidth,
        ),
      ),
      child: IconTheme(
        data: IconThemeData(color: colorScheme.onTertiaryContainer),
        child: const LumosIcon(
          Icons.style_rounded,
          size: DeckTileConst.leadingIconSize,
        ),
      ),
    );
  }
}
