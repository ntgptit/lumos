import 'package:flutter/material.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../../domain/entities/folder_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderTileConst {
  const FolderTileConst._();

  static const int rootDepth = 0;

  static const double leadingSize = WidgetSizes.avatarLarge;
  static const double leadingIconSize = IconSizes.iconMedium;
  static const double leadingBorderWidth = WidgetSizes.borderWidthRegular;
  static const double badgeSize = Insets.spacing16;
  static const double badgeFontSize = FontSizes.fontSizeSmall;
}

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
    final String subtitle = _resolveSubtitle(l10n: l10n);
    return LumosActionListItemCard(
      title: item.name,
      subtitle: subtitle,
      onTap: onOpen,
      leading: _FolderTileLeading(depth: item.depth),
      actions: _buildActions(l10n: l10n),
      onActionSelected: (String actionKey) {
        _handleAction(actionKey: actionKey);
      },
    );
  }

  String _resolveSubtitle({required AppLocalizations l10n}) {
    if (item.depth == FolderTileConst.rootDepth) {
      return l10n.folderRoot;
    }
    return l10n.folderDepth(item.depth);
  }

  List<LumosActionListItem> _buildActions({required AppLocalizations l10n}) {
    return <LumosActionListItem>[
      LumosActionListItem(
        key: FolderTileActionKey.rename,
        label: l10n.commonRename,
        icon: Icons.drive_file_rename_outline_rounded,
        supportingText: l10n.folderRenameTitle,
      ),
      LumosActionListItem(
        key: FolderTileActionKey.delete,
        label: l10n.commonDelete,
        icon: Icons.delete_outline_rounded,
        supportingText: l10n.folderDeleteTitle,
        tone: LumosActionListItemTone.critical,
      ),
    ];
  }

  void _handleAction({required String actionKey}) {
    if (actionKey == FolderTileActionKey.rename) {
      onRename();
      return;
    }
    if (actionKey == FolderTileActionKey.delete) {
      onDelete();
      return;
    }
  }
}

class _FolderTileLeading extends StatelessWidget {
  const _FolderTileLeading({required this.depth});

  final int depth;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isRoot = depth == FolderTileConst.rootDepth;
    final Color backgroundColor = _resolveBackgroundColor(
      colorScheme: colorScheme,
      isRoot: isRoot,
    );
    final Color foregroundColor = _resolveForegroundColor(
      colorScheme: colorScheme,
      isRoot: isRoot,
    );
    final Color borderColor = _resolveBorderColor(
      colorScheme: colorScheme,
      isRoot: isRoot,
    );

    return SizedBox(
      width: FolderTileConst.leadingSize,
      height: FolderTileConst.leadingSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadii.large,
              border: Border.all(
                color: borderColor,
                width: FolderTileConst.leadingBorderWidth,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.folder_open_rounded,
                size: FolderTileConst.leadingIconSize,
                color: foregroundColor,
              ),
            ),
          ),
          Positioned(
            right: Insets.spacing0,
            bottom: Insets.spacing0,
            child: _FolderDepthBadge(depth: depth, isRoot: isRoot),
          ),
        ],
      ),
    );
  }

  Color _resolveBackgroundColor({
    required ColorScheme colorScheme,
    required bool isRoot,
  }) {
    if (isRoot) {
      return colorScheme.secondaryContainer;
    }
    return colorScheme.primaryContainer;
  }

  Color _resolveForegroundColor({
    required ColorScheme colorScheme,
    required bool isRoot,
  }) {
    if (isRoot) {
      return colorScheme.onSecondaryContainer;
    }
    return colorScheme.onPrimaryContainer;
  }

  Color _resolveBorderColor({
    required ColorScheme colorScheme,
    required bool isRoot,
  }) {
    if (isRoot) {
      return colorScheme.tertiary;
    }
    return colorScheme.tertiaryContainer;
  }
}

class _FolderDepthBadge extends StatelessWidget {
  const _FolderDepthBadge({required this.depth, required this.isRoot});

  final int depth;
  final bool isRoot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color badgeColor = _resolveBadgeColor(colorScheme: colorScheme);
    final Color badgeTextColor = _resolveBadgeTextColor(
      colorScheme: colorScheme,
    );
    return SizedBox(
      width: FolderTileConst.badgeSize,
      height: FolderTileConst.badgeSize,
      child: DecoratedBox(
        decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
        child: Center(
          child: Text(
            '$depth',
            style: TextStyle(
              color: badgeTextColor,
              fontSize: FolderTileConst.badgeFontSize,
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveBadgeColor({required ColorScheme colorScheme}) {
    if (isRoot) {
      return colorScheme.secondary;
    }
    return colorScheme.primary;
  }

  Color _resolveBadgeTextColor({required ColorScheme colorScheme}) {
    if (isRoot) {
      return colorScheme.onSecondary;
    }
    return colorScheme.onPrimary;
  }
}
