import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../core/utils/string_utils.dart';
import '../../../../../../../domain/entities/folder_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FolderListTileConst {
  FolderListTileConst._();

  static const int rootDepth = 0;

  static const double leadingSize = WidgetSizes.avatarLarge;
  static const double leadingIconSize = IconSizes.iconMedium;
  static const double leadingBorderWidth = WidgetSizes.borderWidthRegular;
  static const double badgeMinSize = AppSpacing.xl;
  static const double badgeHorizontalPadding = AppSpacing.xs;
  static const double badgeFontSize = FontSizes.fontSizeSmall;
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
    final String subtitle = item.depth == FolderListTileConst.rootDepth
        ? l10n.folderRoot
        : l10n.folderDepth(item.depth);
    final bool isRoot = item.depth == FolderListTileConst.rootDepth;
    final String normalizedHex = StringUtils.normalizeUpper(item.colorHex);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color foregroundColor =
        FolderDomainConst.colorHexPattern.hasMatch(normalizedHex)
        ? Color(
            int.parse(
              normalizedHex.replaceFirst('#', '').length == 6
                  ? 'FF${normalizedHex.replaceFirst('#', '')}'
                  : normalizedHex.replaceFirst('#', ''),
              radix: 16,
            ),
          )
        : colorScheme.primary;
    return LumosActionListItemCard(
      title: item.name,
      subtitle: subtitle,
      onTap: onOpen,
      leading: SizedBox(
        width: FolderListTileConst.leadingSize,
        height: FolderListTileConst.leadingSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                color: isRoot
                    ? colorScheme.secondaryContainer
                    : colorScheme.primaryContainer,
                borderRadius: BorderRadii.large,
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: FolderListTileConst.leadingBorderWidth,
                ),
              ),
              child: Center(
                child: IconTheme(
                  data: IconThemeData(color: foregroundColor),
                  child: const LumosIcon(
                    Icons.folder_open_rounded,
                    size: FolderListTileConst.leadingIconSize,
                  ),
                ),
              ),
            ),
            Positioned(
              right: AppSpacing.none,
              bottom: AppSpacing.none,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: FolderListTileConst.badgeMinSize,
                  minHeight: FolderListTileConst.badgeMinSize,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: FolderListTileConst.badgeHorizontalPadding,
                ),
                decoration: BoxDecoration(
                  color: isRoot ? colorScheme.secondary : colorScheme.primary,
                  borderRadius: BorderRadii.large,
                ),
                child: Center(
                  child: LumosInlineText(
                    '${item.childFolderCount}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isRoot
                          ? colorScheme.onSecondary
                          : colorScheme.onPrimary,
                      fontSize: FolderListTileConst.badgeFontSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
