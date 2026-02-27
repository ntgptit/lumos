import 'package:flutter/material.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../../domain/entities/folder_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderHeader extends StatelessWidget {
  const FolderHeader({
    required this.breadcrumbItems,
    required this.currentParentId,
    required this.onOpenRoot,
    required this.onOpenBreadcrumb,
    super.key,
  });

  final List<BreadcrumbNode> breadcrumbItems;
  final int? currentParentId;
  final Future<void> Function() onOpenRoot;
  final Future<void> Function(int?) onOpenBreadcrumb;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LumosText(
            l10n.folderManagerTitle,
            style: LumosTextStyle.headlineSmall,
          ),
          const SizedBox(height: Insets.spacing8),
          LumosText(
            l10n.folderManagerSubtitle,
            style: LumosTextStyle.bodySmall,
          ),
          const SizedBox(height: Insets.spacing12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: Insets.spacing8,
              children: <Widget>[
                LumosActionChip(
                  label: Text(l10n.folderRoot),
                  onPressed: onOpenRoot,
                  avatar: Icon(
                    Icons.home_filled,
                    size: IconSizes.iconSmall,
                    color: currentParentId == null
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                ...breadcrumbItems.map(
                  (BreadcrumbNode item) => LumosActionChip(
                    label: Text(item.name),
                    onPressed: () => onOpenBreadcrumb(item.id),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
