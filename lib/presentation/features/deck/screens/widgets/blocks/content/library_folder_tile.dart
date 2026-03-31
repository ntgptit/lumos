import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/domain/entities/folder_models.dart';
import 'package:lumos/l10n/app_localizations.dart';

class LibraryFolderTile extends StatelessWidget {
  const LibraryFolderTile({
    required this.folder,
    required this.onOpen,
    super.key,
  });

  final FolderNode folder;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double leadingSize = context.component.listItemLeadingSize;
    return LumosActionListItemCard(
      title: folder.name,
      subtitle:
          '${l10n.folderSubfolderCount(folder.childFolderCount)} • ${l10n.folderDeckCount(folder.deckCount)}',
      onTap: onOpen,
      leading: SizedBox(
        width: leadingSize,
        height: leadingSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.secondaryContainer,
            borderRadius: context.shapes.control,
            border: Border.all(
              color: context.colorScheme.outlineVariant,
              width: WidgetSizes.borderWidthRegular,
            ),
          ),
          child: Center(
            child: IconTheme(
              data: IconThemeData(
                color: context.colorScheme.onSecondaryContainer,
              ),
              child: LumosIcon(
                Icons.folder_open_rounded,
                size: context.iconSize.md,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
