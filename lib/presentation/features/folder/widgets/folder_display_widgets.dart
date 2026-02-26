import 'package:flutter/material.dart';

import '../../../../core/constants/dimensions.dart';
import '../../../../domain/entities/folder_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';

class FolderFailureView extends StatelessWidget {
  const FolderFailureView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosErrorState(
      errorMessage: message,
      onRetry: onRetry,
      retryLabel: l10n.commonRetry,
    );
  }
}

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

class FolderErrorBanner extends StatelessWidget {
  const FolderErrorBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Insets.spacing12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadii.medium,
      ),
      child: LumosText(
        message,
        style: LumosTextStyle.bodySmall,
        color: colorScheme.onErrorContainer,
      ),
    );
  }
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
    return LumosCard(
      onTap: onOpen,
      padding: const EdgeInsets.all(Insets.spacing12),
      child: Row(
        children: <Widget>[
          const Icon(Icons.folder_open_rounded, size: IconSizes.iconLarge),
          const SizedBox(width: Insets.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosText(
                  item.name,
                  style: LumosTextStyle.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                LumosText(
                  l10n.folderDepth(item.depth),
                  style: LumosTextStyle.labelSmall,
                ),
              ],
            ),
          ),
          LumosPopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'rename') {
                onRename();
                return;
              }
              onDelete();
            },
            itemBuilder: (BuildContext context) {
              final AppLocalizations l10n = AppLocalizations.of(context)!;
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'rename',
                  child: Text(l10n.commonRename),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text(l10n.commonDelete),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

class FolderEmptyView extends StatelessWidget {
  const FolderEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosEmptyState(
      title: l10n.folderEmptyTitle,
      message: l10n.folderEmptySubtitle,
      icon: Icons.folder_copy_outlined,
    );
  }
}

class FolderSkeletonView extends StatelessWidget {
  const FolderSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Insets.spacing16),
      children: <Widget>[
        const LumosSkeletonBox(height: Insets.spacing64),
        const SizedBox(height: Insets.spacing16),
        ...List<Widget>.generate(
          6,
          (int index) => const Padding(
            padding: EdgeInsets.only(bottom: Insets.spacing8),
            child: LumosSkeletonBox(height: Insets.spacing64),
          ),
        ),
      ],
    );
  }
}

class FolderMutatingOverlay extends StatelessWidget {
  const FolderMutatingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Insets.spacing64 * 2,
        padding: const EdgeInsets.all(Insets.spacing16),
        decoration: BoxDecoration(
          borderRadius: BorderRadii.large,
          color: Theme.of(context).colorScheme.surface,
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LumosSkeletonBox(
              width: Insets.spacing48,
              height: Insets.spacing48,
              borderRadius: BorderRadii.large,
            ),
            SizedBox(height: Insets.spacing12),
            LumosSkeletonBox(height: Insets.spacing12),
          ],
        ),
      ),
    );
  }
}
