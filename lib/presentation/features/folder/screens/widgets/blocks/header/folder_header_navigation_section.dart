import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../providers/states/folder_state.dart';

enum _FolderNavigationAction { root, parent }

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
    final double rowGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double compactGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.xs,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final String currentSortLabel = _buildCurrentSortLabel();
    final bool showNavigation =
        widget.currentDepth != FolderStateConst.rootDepth;
    final List<Widget> utilityActions = <Widget>[
      if (showNavigation)
        IntrinsicWidth(
          child: LumosSegmentedControl<_FolderNavigationAction>(
            showSelectedIcon: false,
            selected: const <_FolderNavigationAction>{},
            emptySelectionAllowed: true,
            segments: <ButtonSegment<_FolderNavigationAction>>[
              ButtonSegment<_FolderNavigationAction>(
                value: _FolderNavigationAction.root,
                enabled: !_isNavigating,
                label: Tooltip(
                  message: widget.l10n.folderRoot,
                  child: widget.isNavigatingRoot
                      ? const LumosLoadingIndicator(size: IconSizes.iconSmall)
                      : const LumosIcon(
                          Icons.home_rounded,
                          size: IconSizes.iconSmall,
                        ),
                ),
              ),
              ButtonSegment<_FolderNavigationAction>(
                value: _FolderNavigationAction.parent,
                enabled: !_isNavigating,
                label: Tooltip(
                  message: widget.l10n.folderOpenParentTooltip,
                  child: widget.isNavigatingParent
                      ? const LumosLoadingIndicator(size: IconSizes.iconSmall)
                      : const LumosIcon(
                          Icons.keyboard_arrow_up_rounded,
                          size: IconSizes.iconSmall,
                        ),
                ),
              ),
            ],
            onSelectionChanged: _onNavigationGroupChanged,
          ),
        ),
      LumosUtilityChipButton(
        label: currentSortLabel,
        onPressed: () => _onSortPressed(context),
        leading: const LumosIcon(Icons.sort_rounded, size: IconSizes.iconSmall),
        trailing: const LumosIcon(
          Icons.keyboard_arrow_down_rounded,
          size: IconSizes.iconSmall,
        ),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LumosSearchBar(
          controller: _searchController,
          hintText: _buildSearchHint(),
          onChanged: widget.onSearchChanged,
          onClear: widget.searchQuery.isNotEmpty ? _clearSearch : null,
          clearTooltip: _buildSearchClearTooltip(),
        ),
        SizedBox(height: rowGap),
        Wrap(spacing: rowGap, runSpacing: compactGap, children: utilityActions),
      ],
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
