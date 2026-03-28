import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../providers/states/folder_state.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_app_bar.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_action_sheet.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_search_bar.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_sort_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item_card.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/layouts/lumos_screen_transition.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_floating_action_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_secondary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_loading_indicator.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_dropdown.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';

import 'folder_header_meta_pill.dart';

enum _FolderNavigationAction { root, parent }

abstract final class FolderHeaderNavigationSectionLayout {
  FolderHeaderNavigationSectionLayout._();

  static const double contextMetaPillWidth =
      LumosSpacing.canvas + LumosSpacing.canvas + LumosSpacing.lg;
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
    final double containerPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
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
    final double metaPillWidth = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FolderHeaderNavigationSectionLayout.contextMetaPillWidth,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
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
      padding: EdgeInsets.all(containerPadding),
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
              SegmentedButton<_FolderNavigationAction>(
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
                    enabled:
                        widget.currentDepth != FolderStateConst.rootDepth &&
                        !_isNavigating,
                    label: Tooltip(
                      message: widget.l10n.folderRoot,
                      child: widget.isNavigatingRoot
                          ? const LumosLoadingIndicator(
                              size: IconSizes.iconSmall,
                            )
                          : const LumosIcon(
                              Icons.home_rounded,
                              size: IconSizes.iconSmall,
                            ),
                    ),
                  ),
                  ButtonSegment<_FolderNavigationAction>(
                    value: _FolderNavigationAction.parent,
                    enabled:
                        widget.currentDepth != FolderStateConst.rootDepth &&
                        !_isNavigating,
                    label: Tooltip(
                      message: widget.l10n.folderOpenParentTooltip,
                      child: widget.isNavigatingParent
                          ? const LumosLoadingIndicator(
                              size: IconSizes.iconSmall,
                            )
                          : const LumosIcon(
                              Icons.keyboard_arrow_up_rounded,
                              size: IconSizes.iconSmall,
                            ),
                    ),
                  ),
                ],
                onSelectionChanged: _onNavigationGroupChanged,
              ),
              const Spacer(),
              SizedBox(width: rowGap),
              SizedBox(
                width: metaPillWidth,
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
          SizedBox(height: rowGap),
          Row(
            children: <Widget>[
              Expanded(
                child: LumosSearchBar(
                  controller: _searchController,
                  hint: _buildSearchHint(),
                  onSearch: widget.onSearchChanged,
                  onClear: widget.searchQuery.isNotEmpty ? _clearSearch : null,
                  clearTooltip: _buildSearchClearTooltip(),
                ),
              ),
              SizedBox(width: compactGap),
              LumosIconButton(
                icon: Icons.sort_rounded,
                tooltip: currentSortLabel,
                variant: LumosIconButtonVariant.outlined,
                onPressed: () => _onSortPressed(context),
              ),
            ],
          ),
        ],
      ),
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

