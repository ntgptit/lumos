import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../providers/states/folder_state.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

import 'folder_header_meta_pill.dart';

class FolderHeaderNavigationSection extends StatefulWidget {
  const FolderHeaderNavigationSection({
    required this.l10n,
    required this.currentDepth,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.sortBy,
    required this.sortType,
    required this.onSortChanged,
    required this.onOpenParentFolder,
    super.key,
  });

  final AppLocalizations l10n;
  final int currentDepth;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final FolderSortBy sortBy;
  final FolderSortType sortType;
  final void Function(FolderSortBy sortBy, FolderSortType sortType)
  onSortChanged;
  final Future<void> Function() onOpenParentFolder;

  @override
  State<FolderHeaderNavigationSection> createState() =>
      _FolderHeaderNavigationSectionState();
}

class _FolderHeaderNavigationSectionState
    extends State<FolderHeaderNavigationSection> {
  late final TextEditingController _searchController;

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
    return Container(
      padding: const EdgeInsets.all(Insets.spacing8),
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
              Expanded(
                child: _buildCurrentNodeSummary(colorScheme: colorScheme),
              ),
              const SizedBox(width: Insets.spacing8),
              FolderHeaderMetaPill(
                icon: Icons.account_tree_rounded,
                label: widget.l10n.folderDepth(widget.currentDepth),
                backgroundColor: colorScheme.tertiaryContainer,
                foregroundColor: colorScheme.onTertiaryContainer,
              ),
            ],
          ),
          const SizedBox(height: Insets.spacing8),
          _buildControlRow(context: context),
        ],
      ),
    );
  }

  Widget _buildCurrentNodeSummary({required ColorScheme colorScheme}) {
    final bool canOpenParent = widget.currentDepth > FolderStateConst.rootDepth;
    final String currentNodeLabel =
        widget.currentDepth == FolderStateConst.rootDepth
        ? widget.l10n.folderRoot
        : widget.l10n.folderDepth(widget.currentDepth);
    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadii.medium,
      child: InkWell(
        borderRadius: BorderRadii.medium,
        onTap: canOpenParent ? _onOpenParentFolder : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Insets.spacing8,
            vertical: Insets.spacing8,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: Insets.spacing24,
                height: Insets.spacing24,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadii.medium,
                ),
                child: IconTheme(
                  data: IconThemeData(color: colorScheme.onSecondaryContainer),
                  child: const LumosIcon(
                    Icons.route_rounded,
                    size: IconSizes.iconSmall,
                  ),
                ),
              ),
              const SizedBox(width: Insets.spacing8),
              Expanded(
                child: LumosText(
                  currentNodeLabel,
                  style: LumosTextStyle.labelLarge,
                  tone: LumosTextTone.primary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (canOpenParent)
                const LumosIcon(
                  Icons.keyboard_arrow_up_rounded,
                  size: IconSizes.iconSmall,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlRow({required BuildContext context}) {
    return Row(
      children: <Widget>[
        Expanded(child: _buildSearchBar()),
        const SizedBox(width: Insets.spacing4),
        _buildSortButton(context: context),
      ],
    );
  }

  Widget _buildSearchBar() {
    final bool canClearSearch = widget.searchQuery.isNotEmpty;
    return LumosSearchBar(
      controller: _searchController,
      hint: widget.l10n.folderSearchHint,
      onSearch: widget.onSearchChanged,
      onClear: canClearSearch ? _clearSearch : null,
      clearTooltip: widget.l10n.folderSearchClearTooltip,
    );
  }

  Widget _buildSortButton({required BuildContext context}) {
    final String currentSortLabel =
        widget.sortBy == FolderSortBy.name &&
            widget.sortType == FolderSortType.asc
        ? widget.l10n.folderSortNameAscending
        : widget.sortBy == FolderSortBy.name &&
              widget.sortType == FolderSortType.desc
        ? widget.l10n.folderSortNameDescending
        : widget.sortBy == FolderSortBy.createdAt &&
              widget.sortType == FolderSortType.desc
        ? widget.l10n.folderSortCreatedNewest
        : widget.l10n.folderSortCreatedOldest;
    return LumosIconButton(
      icon: Icons.sort_rounded,
      tooltip: currentSortLabel,
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

  void _onOpenParentFolder() {
    unawaited(widget.onOpenParentFolder());
  }

  Future<void> _openSortBottomSheet(BuildContext context) async {
    final _FolderSortSelection? selectedSort =
        await showModalBottomSheet<_FolderSortSelection>(
          context: context,
          showDragHandle: true,
          builder: (BuildContext bottomSheetContext) {
            return _FolderSortBottomSheet(
              sortBy: widget.sortBy,
              sortType: widget.sortType,
              l10n: AppLocalizations.of(bottomSheetContext)!,
            );
          },
        );
    if (selectedSort == null) {
      return;
    }
    if (selectedSort.sortBy == widget.sortBy &&
        selectedSort.sortType == widget.sortType) {
      return;
    }
    widget.onSortChanged(selectedSort.sortBy, selectedSort.sortType);
  }
}

class _FolderSortBottomSheet extends StatelessWidget {
  const _FolderSortBottomSheet({
    required this.sortBy,
    required this.sortType,
    required this.l10n,
  });

  final FolderSortBy sortBy;
  final FolderSortType sortType;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Insets.spacing16,
          Insets.spacing8,
          Insets.spacing16,
          Insets.spacing16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LumosText(l10n.folderSortTitle, style: LumosTextStyle.titleMedium),
            const SizedBox(height: Insets.spacing8),
            _buildSortOptionTile(
              context: context,
              option: const _FolderSortSelection(
                sortBy: FolderSortBy.name,
                sortType: FolderSortType.asc,
              ),
              icon: Icons.sort_by_alpha_rounded,
              label: l10n.folderSortNameAscending,
            ),
            _buildSortOptionTile(
              context: context,
              option: const _FolderSortSelection(
                sortBy: FolderSortBy.name,
                sortType: FolderSortType.desc,
              ),
              icon: Icons.sort_by_alpha_rounded,
              label: l10n.folderSortNameDescending,
            ),
            _buildSortOptionTile(
              context: context,
              option: const _FolderSortSelection(
                sortBy: FolderSortBy.createdAt,
                sortType: FolderSortType.desc,
              ),
              icon: Icons.schedule_rounded,
              label: l10n.folderSortCreatedNewest,
            ),
            _buildSortOptionTile(
              context: context,
              option: const _FolderSortSelection(
                sortBy: FolderSortBy.createdAt,
                sortType: FolderSortType.asc,
              ),
              icon: Icons.history_rounded,
              label: l10n.folderSortCreatedOldest,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOptionTile({
    required BuildContext context,
    required _FolderSortSelection option,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected =
        sortBy == option.sortBy && sortType == option.sortType;
    return LumosListTile(
      contentPadding: EdgeInsets.zero,
      leading: LumosIcon(icon, size: IconSizes.iconMedium),
      title: LumosText(label, style: LumosTextStyle.bodyMedium),
      trailing: isSelected
          ? const LumosIcon(Icons.check_rounded, size: IconSizes.iconSmall)
          : null,
      onTap: () => context.pop(option),
    );
  }
}

class _FolderSortSelection {
  const _FolderSortSelection({required this.sortBy, required this.sortType});

  final FolderSortBy sortBy;
  final FolderSortType sortType;
}
