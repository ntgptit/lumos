import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/folder_models.dart';
import '../../../../../../../l10n/app_localizations.dart';

abstract final class FolderListTileConst {
  FolderListTileConst._();

  static const double leadingBorderWidth = WidgetSizes.borderWidthRegular;
}

abstract final class FolderListTileActionKey {
  FolderListTileActionKey._();

  static const String rename = 'rename';
  static const String delete = 'delete';
}

class FolderListTile extends StatelessWidget {
  const FolderListTile({
    required this.item,
    required this.onOpen,
    required this.onRename,
    required this.onDelete,
    super.key,
  });

  final FolderNode item;
  final VoidCallback onOpen;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String subtitle = _buildSubtitle(l10n: l10n);
    final ColorScheme colorScheme = context.colorScheme;
    final double leadingSize = context.component.listItemLeadingSize;
    return LumosActionListItemCard(
      title: item.name,
      subtitle: subtitle,
      onTap: onOpen,
      leading: SizedBox(
        width: leadingSize,
        height: leadingSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: context.shapes.control,
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: FolderListTileConst.leadingBorderWidth,
            ),
          ),
          child: Center(
            child: IconTheme(
              data: IconThemeData(color: colorScheme.onSecondaryContainer),
              child: LumosIcon(
                Icons.folder_open_rounded,
                size: context.iconSize.md,
              ),
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

  List<LumosActionListItem> _buildActions({required AppLocalizations l10n}) {
    return <LumosActionListItem>[
      LumosActionListItem(
        key: FolderListTileActionKey.rename,
        label: l10n.commonRename,
        icon: Icons.drive_file_rename_outline_rounded,
        supportingText: l10n.folderRenameTitle,
      ),
      LumosActionListItem(
        key: FolderListTileActionKey.delete,
        label: l10n.commonDelete,
        icon: Icons.delete_outline_rounded,
        supportingText: l10n.folderDeleteTitle,
        tone: LumosActionListItemTone.critical,
      ),
    ];
  }

  String _buildSubtitle({required AppLocalizations l10n}) {
    final String childCountLabel = l10n.folderSubfolderCount(
      item.childFolderCount,
    );
    final String deckCountLabel = l10n.folderDeckCount(item.deckCount);
    return '$childCountLabel • $deckCountLabel';
  }

  void _handleAction({required String actionKey}) {
    if (actionKey == FolderListTileActionKey.rename) {
      onRename();
      return;
    }
    if (actionKey == FolderListTileActionKey.delete) {
      onDelete();
      return;
    }
  }
}
