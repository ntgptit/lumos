import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/deck_models.dart';
import '../../../../../../../l10n/app_localizations.dart';

abstract final class DeckListTileConst {
  DeckListTileConst._();

  static const double leadingBorderWidth = AppStroke.regular;
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
    final double leadingSize = context.component.listItemLeadingSize;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = context.colorScheme;
    return LumosActionListItemCard(
      title: item.name,
      subtitle: _buildSubtitle(l10n),
      onTap: onOpen,
      leading: SizedBox(
        width: leadingSize,
        height: leadingSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer,
            borderRadius: context.shapes.control,
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: DeckListTileConst.leadingBorderWidth,
            ),
          ),
          child: Center(
            child: IconTheme(
              data: IconThemeData(color: colorScheme.onTertiaryContainer),
              child: LumosIcon(Icons.style_rounded, size: context.iconSize.md),
            ),
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
