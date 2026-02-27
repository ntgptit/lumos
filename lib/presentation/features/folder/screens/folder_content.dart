import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../../../../domain/entities/folder_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../providers/folder_provider.dart';
import '../providers/states/folder_state.dart';
import 'widgets/blocks/folder_header.dart';
import 'widgets/blocks/folder_tile.dart';
import 'widgets/dialogs/folder_dialogs.dart';
import 'widgets/states/folder_empty_view.dart';
import 'widgets/states/folder_error_banner.dart';
import 'widgets/states/folder_mutating_overlay.dart';

class FolderContentConst {
  const FolderContentConst._();

  static const double listBottomSpacing = Insets.spacing64;
}

class FolderContent extends ConsumerWidget {
  const FolderContent({required this.state, super.key});

  final FolderState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double horizontalInset = LumosScreenFrame.resolveHorizontalInset(
      context,
    );
    final FolderAsyncController controller = ref.read(
      folderAsyncControllerProvider.notifier,
    );
    final List<FolderNode> visibleFolders = state.visibleFolders;
    return Stack(
      children: <Widget>[
        _buildRefreshableList(
          context: context,
          ref: ref,
          controller: controller,
          visibleFolders: visibleFolders,
        ),
        _buildCreateButton(
          context: context,
          ref: ref,
          l10n: l10n,
          horizontalInset: horizontalInset,
        ),
        _buildMutatingOverlay(context: context),
      ],
    );
  }

  Widget _buildRefreshableList({
    required BuildContext context,
    required WidgetRef ref,
    required FolderAsyncController controller,
    required List<FolderNode> visibleFolders,
  }) {
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          LumosScreenFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FolderHeader(
                  breadcrumbItems: state.breadcrumbItems,
                  currentParentId: state.currentParentId,
                  onOpenRoot: controller.openRoot,
                  onOpenBreadcrumb: controller.goToBreadcrumb,
                ),
                const SizedBox(height: Insets.spacing16),
                if (state.inlineErrorMessage case final String message)
                  FolderErrorBanner(message: message),
                if (state.inlineErrorMessage != null)
                  const SizedBox(height: Insets.spacing12),
                ..._buildFolderTiles(
                  context: context,
                  ref: ref,
                  visibleFolders: visibleFolders,
                ),
                if (visibleFolders.isEmpty) const FolderEmptyView(),
                const SizedBox(height: FolderContentConst.listBottomSpacing),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFolderTiles({
    required BuildContext context,
    required WidgetRef ref,
    required List<FolderNode> visibleFolders,
  }) {
    return visibleFolders
        .map((FolderNode item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Insets.spacing8),
            child: FolderTile(
              item: item,
              onOpen: () => ref
                  .read(folderAsyncControllerProvider.notifier)
                  .openFolder(item.id),
              onRename: () => showFolderNameDialog(
                context: context,
                titleBuilder: (AppLocalizations l10n) => l10n.folderRenameTitle,
                actionLabelBuilder: (AppLocalizations l10n) => l10n.commonSave,
                initialValue: item.name,
                onSubmitted: (String name) {
                  return ref
                      .read(folderAsyncControllerProvider.notifier)
                      .renameFolder(folderId: item.id, name: name);
                },
              ),
              onDelete: () => showFolderConfirmDialog(
                context: context,
                titleBuilder: (AppLocalizations l10n) => l10n.folderDeleteTitle,
                messageBuilder: (AppLocalizations l10n) {
                  return l10n.folderDeleteConfirm(item.name);
                },
                confirmLabelBuilder: (AppLocalizations l10n) =>
                    l10n.commonDelete,
                onConfirmed: () {
                  return ref
                      .read(folderAsyncControllerProvider.notifier)
                      .deleteFolder(item.id);
                },
              ),
            ),
          );
        })
        .toList(growable: false);
  }

  Widget _buildCreateButton({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations l10n,
    required double horizontalInset,
  }) {
    if (state.isMutating) {
      return const SizedBox.shrink();
    }
    return Positioned(
      right: horizontalInset,
      bottom: Insets.gapBetweenSections,
      child: LumosFloatingActionButton(
        onPressed: () => showFolderNameDialog(
          context: context,
          titleBuilder: (AppLocalizations l10n) => l10n.folderCreateTitle,
          actionLabelBuilder: (AppLocalizations l10n) => l10n.commonCreate,
          initialValue: '',
          onSubmitted: (String name) {
            return ref
                .read(folderAsyncControllerProvider.notifier)
                .createFolder(name);
          },
        ),
        icon: Icons.create_new_folder_outlined,
        label: l10n.folderNewFolder,
      ),
    );
  }

  Widget _buildMutatingOverlay({required BuildContext context}) {
    if (!state.isMutating) {
      return const SizedBox.shrink();
    }
    return Positioned.fill(
      child: IgnorePointer(
        child: ColoredBox(
          color: Theme.of(context).colorScheme.scrim,
          child: const FolderMutatingOverlay(),
        ),
      ),
    );
  }
}
