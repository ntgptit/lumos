import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../providers/states/folder_state.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

import 'folder_header_meta_pill.dart';

enum _FolderNavigationAction { root, parent }

abstract final class FolderHeaderNavigationSectionLayout {
  FolderHeaderNavigationSectionLayout._();

  static const double contextMetaPillWidth =
      AppSpacing.canvas + AppSpacing.canvas + AppSpacing.lg;
}

class FolderHeaderNavigationSection extends StatefulWidget {
  const FolderHeaderNavigationSection({
    required this.l10n,
    required this.currentDepth,
    required this.isDeckManager,
    required this.isNavigatingParent,
    required this.isNavigatingRoot,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.sortBy,
    required this.sortType,
    required this.onSortChanged,
    required this.onOpenParentFolder,
    required this.onOpenRootFolder,
    super.key,
  });

  final AppLocalizations l10n;
  final int currentDepth;
  final bool isDeckManager;
  final bool isNavigatingParent;
  final bool isNavigatingRoot;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final FolderSortBy sortBy;
  final FolderSortType sortType;
  final void Function(FolderSortBy sortBy, FolderSortType sortType)
  onSortChanged;
  final Future<void> Function() onOpenParentFolder;
  final Future<void> Function() onOpenRootFolder;

  @override
  State<FolderHeaderNavigationSection> createState() =>
      _FolderHeaderNavigationSectionState();
}

class _FolderHeaderNavigationSectionState
    extends State<FolderHeaderNavigationSection> {
  late final TextEditingController _searchController;

  bool get _isNavigating {
    if (widget.isNavigatingParent) {
      return true;
    }
    if (widget.isNavigatingRoot) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant FolderHeaderNavigationSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery == _searchController.text) {
      return;
    }
    _searchController.value = TextEditingValue(
      text: widget.searchQuery,
      selection: TextSelection.collapsed(offset: widget.searchQuery.length),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String currentSortLabel = _buildCurrentSortLabel();
    final IconData contextMetaIcon = widget.searchQuery.isNotEmpty
        ? Icons.search_rounded
        : widget.isDeckManager
        ? Icons.sort_by_alpha_rounded
        : widget.sortBy == FolderSortBy.createdAt
        ? Icons.schedule_rounded
        : Icons.sort_by_alpha_rounded;
    final String contextMetaLabel = widget.searchQuery.isNotEmpty
        ? _buildSearchHint()
        : currentSortLabel;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadii.large,
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: WidgetSizes.borderWidthRegular,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              _buildNavigationSummary(),
              const Spacer(),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: FolderHeaderNavigationSectionLayout.contextMetaPillWidth,
                child: FolderHeaderMetaPill(
                  icon: contextMetaIcon,
                  label: contextMetaLabel,
                  backgroundColor: colorScheme.secondaryContainer,
                  foregroundColor: colorScheme.onSecondaryContainer,
                  expandLabel: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildControlRow(context: context),
        ],
      ),
    );
  }

  Widget _buildNavigationSummary() {
    final bool isAtRoot = widget.currentDepth == FolderStateConst.rootDepth;
    final bool canNavigate = !_isNavigating;
    final bool canOpenRoot = !isAtRoot && canNavigate;
    final bool canOpenParent = !isAtRoot && canNavigate;
    final Widget rootLabel = widget.isNavigatingRoot
        ? const LumosLoadingIndicator(size: IconSizes.iconSmall)
        : const LumosIcon(Icons.home_rounded, size: IconSizes.iconSmall);
    final Widget parentLabel = widget.isNavigatingParent
        ? const LumosLoadingIndicator(size: IconSizes.iconSmall)
        : const LumosIcon(
            Icons.keyboard_arrow_up_rounded,
            size: IconSizes.iconSmall,
          );

    return SegmentedButton<_FolderNavigationAction>(
      showSelectedIcon: false,
      selected: const <_FolderNavigationAction>{},
      emptySelectionAllowed: true,
      style: const ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      segments: <ButtonSegment<_FolderNavigationAction>>[
        ButtonSegment<_FolderNavigationAction>(
          value: _FolderNavigationAction.root,
          enabled: canOpenRoot,
          label: Tooltip(message: widget.l10n.folderRoot, child: rootLabel),
        ),
        ButtonSegment<_FolderNavigationAction>(
          value: _FolderNavigationAction.parent,
          enabled: canOpenParent,
          label: Tooltip(
            message: widget.l10n.folderOpenParentTooltip,
            child: parentLabel,
          ),
        ),
      ],
      onSelectionChanged: _onNavigationGroupChanged,
    );
  }

  Widget _buildControlRow({required BuildContext context}) {
    return Row(
      children: <Widget>[
        Expanded(child: _buildSearchBar()),
        const SizedBox(width: AppSpacing.xs),
        _buildSortButton(context: context),
      ],
    );
  }

  Widget _buildSearchBar() {
    final bool canClearSearch = widget.searchQuery.isNotEmpty;
    return LumosSearchBar(
      controller: _searchController,
      hint: _buildSearchHint(),
      onSearch: widget.onSearchChanged,
      onClear: canClearSearch ? _clearSearch : null,
      clearTooltip: _buildSearchClearTooltip(),
    );
  }

  String _buildSearchHint() {
    if (widget.isDeckManager) {
      return widget.l10n.deckSearchHint;
    }
    return widget.l10n.folderSearchHint;
  }

  String _buildSearchClearTooltip() {
    if (widget.isDeckManager) {
      return widget.l10n.deckSearchClearTooltip;
    }
    return widget.l10n.folderSearchClearTooltip;
  }

  Widget _buildSortButton({required BuildContext context}) {
    return LumosIconButton(
      icon: Icons.sort_rounded,
      tooltip: _buildCurrentSortLabel(),
      variant: LumosIconButtonVariant.outlined,
      onPressed: () => _onSortPressed(context),
    );
  }

  void _clearSearch() {
    widget.onSearchChanged(FolderStateConst.emptySearchQuery);
  }

  void _onSortPressed(BuildContext context) {
    unawaited(_openSortBottomSheet(context));
  }

  void _onNavigationGroupChanged(Set<_FolderNavigationAction> selection) {
    if (selection.isEmpty) {
      return;
    }
    final _FolderNavigationAction action = selection.first;
    if (action == _FolderNavigationAction.root) {
      _onOpenRootFolder();
      return;
    }
    _onOpenParentFolder();
  }

  void _onOpenParentFolder() {
    Feedback.forTap(context);
    unawaited(widget.onOpenParentFolder());
  }

  void _onOpenRootFolder() {
    Feedback.forTap(context);
    unawaited(widget.onOpenRootFolder());
  }

  Future<void> _openSortBottomSheet(BuildContext context) async {
    if (widget.isDeckManager) {
      await _openDeckSortBottomSheet(context);
      return;
    }
    await showLumosSortBottomSheet<FolderSortBy>(
      context: context,
      title: widget.l10n.folderSortTitle,
      subtitle: null,
      optionSectionTitle: widget.l10n.commonSortBy,
      options: <({FolderSortBy value, String label, IconData? icon})>[
        (
          value: FolderSortBy.name,
          label: widget.l10n.folderSortByName,
          icon: Icons.sort_by_alpha_rounded,
        ),
        (
          value: FolderSortBy.createdAt,
          label: widget.l10n.folderSortByCreatedAt,
          icon: Icons.schedule_rounded,
        ),
      ],
      initialValue: widget.sortBy,
      directionSectionTitle: widget.l10n.commonDirection,
      initialDirectionIndex: widget.sortBy.directionIndex(
        sortType: widget.sortType,
      ),
      directionLabelBuilder: (FolderSortBy selectedSortBy, int directionIndex) {
        return _directionLabel(
          sortBy: selectedSortBy,
          directionIndex: directionIndex,
        );
      },
      applyLabel: widget.l10n.commonSave,
      onApply: (FolderSortBy selectedSortBy, int directionIndex) {
        final FolderSortType selectedSortType = selectedSortBy
            .sortTypeForDirectionIndex(directionIndex);
        if (selectedSortBy == widget.sortBy &&
            selectedSortType == widget.sortType) {
          return;
        }
        widget.onSortChanged(selectedSortBy, selectedSortType);
      },
    );
  }

  Future<void> _openDeckSortBottomSheet(BuildContext context) async {
    await showLumosSortBottomSheet<FolderSortBy>(
      context: context,
      title: widget.l10n.deckSortTitle,
      subtitle: null,
      optionSectionTitle: widget.l10n.commonSortBy,
      options: <({FolderSortBy value, String label, IconData? icon})>[
        (
          value: FolderSortBy.name,
          label: widget.l10n.deckSortByName,
          icon: Icons.sort_by_alpha_rounded,
        ),
      ],
      initialValue: FolderSortBy.name,
      directionSectionTitle: widget.l10n.commonDirection,
      initialDirectionIndex: FolderSortBy.name.directionIndex(
        sortType: widget.sortType,
      ),
      directionLabelBuilder: (FolderSortBy _, int directionIndex) {
        return _deckDirectionLabel(directionIndex: directionIndex);
      },
      applyLabel: widget.l10n.commonSave,
      onApply: (FolderSortBy _, int directionIndex) {
        final FolderSortType selectedSortType = FolderSortBy.name
            .sortTypeForDirectionIndex(directionIndex);
        if (widget.sortBy == FolderSortBy.name &&
            selectedSortType == widget.sortType) {
          return;
        }
        widget.onSortChanged(FolderSortBy.name, selectedSortType);
      },
    );
  }

  String _directionLabel({
    required FolderSortBy sortBy,
    required int directionIndex,
  }) {
    if (sortBy == FolderSortBy.name) {
      if (directionIndex == 0) {
        return widget.l10n.folderSortNameAscending;
      }
      return widget.l10n.folderSortNameDescending;
    }
    if (directionIndex == 0) {
      return widget.l10n.folderSortCreatedNewest;
    }
    return widget.l10n.folderSortCreatedOldest;
  }

  String _buildCurrentSortLabel() {
    if (widget.isDeckManager) {
      return _deckDirectionLabel(
        directionIndex: FolderSortBy.name.directionIndex(
          sortType: widget.sortType,
        ),
      );
    }
    return _directionLabel(
      sortBy: widget.sortBy,
      directionIndex: widget.sortBy.directionIndex(sortType: widget.sortType),
    );
  }

  String _deckDirectionLabel({required int directionIndex}) {
    if (directionIndex == 0) {
      return widget.l10n.deckSortNameAscending;
    }
    return widget.l10n.deckSortNameDescending;
  }
}
