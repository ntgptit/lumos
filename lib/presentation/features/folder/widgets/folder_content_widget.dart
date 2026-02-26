import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/dimensions.dart';
import '../../../../domain/entities/folder_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../screens/folder_management_screen.dart';
import 'folder_display_widgets.dart';

class FolderContent extends ConsumerWidget {
  const FolderContent({required this.state, super.key});

  final FolderViewState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final FolderAsyncController controller = ref.read(
      folderAsyncControllerProvider.notifier,
    );
    final List<FolderNode> visibleFolders = _resolveVisibleFolders();
    return Stack(
      children: <Widget>[
        _buildRefreshableList(
          context: context,
          ref: ref,
          controller: controller,
          visibleFolders: visibleFolders,
        ),
        _buildCreateButton(context: context, ref: ref, l10n: l10n),
        _buildMutatingOverlay(context: context),
      ],
    );
  }

  List<FolderNode> _resolveVisibleFolders() {
    final List<FolderNode> visibleFolders = state.folders
        .where((FolderNode item) => item.parentId == state.currentParentId)
        .toList();
    visibleFolders.sort(
      (FolderNode a, FolderNode b) => a.name.compareTo(b.name),
    );
    return visibleFolders;
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
        padding: const EdgeInsets.all(Insets.spacing16),
        children: <Widget>[
          FolderHeader(
            breadcrumbItems: state.breadcrumbItems,
            currentParentId: state.currentParentId,
            onOpenRoot: controller.openRoot,
            onOpenBreadcrumb: controller.goToBreadcrumb,
          ),
          const SizedBox(height: Insets.spacing16),
          if (state.inlineErrorMessage != null)
            FolderErrorBanner(message: state.inlineErrorMessage!),
          if (state.inlineErrorMessage != null)
            const SizedBox(height: Insets.spacing12),
          ..._buildFolderTiles(
            context: context,
            ref: ref,
            visibleFolders: visibleFolders,
          ),
          if (visibleFolders.isEmpty) const FolderEmptyView(),
          const SizedBox(height: Insets.spacing64),
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
              onRename: () => _showNameInputDialog(
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
              onDelete: () => _showConfirmDialog(
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
  }) {
    if (state.isMutating) {
      return const SizedBox.shrink();
    }
    return Positioned(
      right: Insets.spacing16,
      bottom: Insets.spacing16,
      child: LumosFloatingActionButton(
        onPressed: () => _showNameInputDialog(
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
          color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.13),
          child: const FolderMutatingOverlay(),
        ),
      ),
    );
  }

  Future<void> _showNameInputDialog({
    required BuildContext context,
    required String Function(AppLocalizations l10n) titleBuilder,
    required String Function(AppLocalizations l10n) actionLabelBuilder,
    required String initialValue,
    required Future<void> Function(String value) onSubmitted,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        final AppLocalizations l10n = AppLocalizations.of(dialogContext)!;
        return LumosPromptDialog(
          title: titleBuilder(l10n),
          label: l10n.folderNameLabel,
          cancelText: l10n.commonCancel,
          confirmText: actionLabelBuilder(l10n),
          initialValue: initialValue,
          onCancel: () => dialogContext.pop(),
          onConfirm: (String value) async {
            dialogContext.pop();
            await onSubmitted(value);
          },
        );
      },
    );
  }

  Future<void> _showConfirmDialog({
    required BuildContext context,
    required String Function(AppLocalizations l10n) titleBuilder,
    required String Function(AppLocalizations l10n) messageBuilder,
    required String Function(AppLocalizations l10n) confirmLabelBuilder,
    required Future<void> Function() onConfirmed,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        final AppLocalizations l10n = AppLocalizations.of(dialogContext)!;
        return LumosDialog(
          title: titleBuilder(l10n),
          content: messageBuilder(l10n),
          cancelText: l10n.commonCancel,
          confirmText: confirmLabelBuilder(l10n),
          onCancel: () => dialogContext.pop(),
          onConfirm: () async {
            dialogContext.pop();
            await onConfirmed();
          },
          isDestructive: true,
        );
      },
    );
  }
}
