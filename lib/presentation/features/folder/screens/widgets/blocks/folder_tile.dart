import 'package:flutter/material.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../../domain/entities/folder_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderTileActionKey {
  const FolderTileActionKey._();

  static const String rename = 'rename';
  static const String delete = 'delete';
}

class FolderTile extends StatelessWidget {
  const FolderTile({
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
    return LumosActionListItemCard(
      title: item.name,
      subtitle: l10n.folderDepth(item.depth),
      onTap: onOpen,
      leading: const Icon(Icons.folder_open_rounded, size: IconSizes.iconLarge),
      actions: <LumosActionListItem>[
        LumosActionListItem(
          key: FolderTileActionKey.rename,
          label: l10n.commonRename,
          icon: Icons.drive_file_rename_outline_rounded,
        ),
        LumosActionListItem(
          key: FolderTileActionKey.delete,
          label: l10n.commonDelete,
          icon: Icons.delete_outline_rounded,
          tone: LumosActionListItemTone.critical,
        ),
      ],
      onActionSelected: (String actionKey) {
        if (actionKey == FolderTileActionKey.rename) {
          onRename();
          return;
        }
        onDelete();
      },
    );
  }
}
