import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../providers/states/flashcard_state.dart';
import '../../../flashcard_content_support.dart';
import '../../states/flashcard_empty_view.dart';
import '../../states/flashcard_error_banner.dart';
import '../header/flashcard_list_header.dart';
import '../header/flashcard_preview_carousel.dart';
import '../header/flashcard_set_metadata_section.dart';
import '../header/flashcard_study_action_section.dart';
import '../header/flashcard_study_progress_section.dart';
import 'flashcard_list_card.dart';

class FlashcardListContent extends StatelessWidget {
  const FlashcardListContent({
    required this.scrollController,
    required this.searchController,
    required this.previewController,
    required this.state,
    required this.l10n,
    required this.title,
    required this.sortLabel,
    required this.studyActions,
    required this.notStartedCount,
    required this.masteredCount,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.onOpenCreateDialog,
    required this.onShowSortSheet,
    required this.onSetPreviewIndex,
    required this.onOpenStudyFromPreview,
    required this.onOpenStudyAtPreview,
    required this.isStarredResolver,
    required this.onAudioPressed,
    required this.onStarPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    super.key,
  });

  final ScrollController scrollController;
  final TextEditingController searchController;
  final PageController previewController;
  final FlashcardState state;
  final AppLocalizations l10n;
  final String title;
  final String sortLabel;
  final List<FlashcardStudyActionSectionItem> studyActions;
  final int notStartedCount;
  final int masteredCount;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;
  final VoidCallback onOpenCreateDialog;
  final VoidCallback onShowSortSheet;
  final ValueChanged<int> onSetPreviewIndex;
  final ValueChanged<int> onOpenStudyFromPreview;
  final VoidCallback onOpenStudyAtPreview;
  final bool Function(FlashcardNode item) isStarredResolver;
  final ValueChanged<FlashcardNode> onAudioPressed;
  final ValueChanged<FlashcardNode> onStarPressed;
  final ValueChanged<FlashcardNode> onEditPressed;
  final ValueChanged<FlashcardNode> onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final bool compactLayout =
        MediaQuery.sizeOf(context).width < Breakpoints.kMobileMaxWidth;
    final double sectionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: compactLayout
          ? LumosSpacing.md
          : FlashcardContentSupportConst.sectionSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double itemSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardContentSupportConst.listItemSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double mediumGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double loadingBottomGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double bottomSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardContentSupportConst.listBottomSpacing,
      minScale: ResponsiveDimensions.compactVerticalInsetScale,
    );
    final List<Widget> leadingSlivers = <Widget>[];
    if (state.inlineErrorMessage case final String message) {
      leadingSlivers.add(
        SliverToBoxAdapter(child: FlashcardErrorBanner(message: message)),
      );
      leadingSlivers.add(
        SliverToBoxAdapter(child: SizedBox(height: mediumGap)),
      );
    }
    if (state.hasItems) {
      leadingSlivers.add(
        SliverToBoxAdapter(
          child: FlashcardPreviewCarousel(
            items: state.items,
            pageController: previewController,
            previewIndex: state.safePreviewIndex,
            onPageChanged: onSetPreviewIndex,
            onExpandPressed: onOpenStudyFromPreview,
          ),
        ),
      );
      leadingSlivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: sectionSpacing),
            child: FlashcardSetMetadataSection(
              title: title,
              totalFlashcards: state.totalElements,
            ),
          ),
        ),
      );
    }
    if (state.isSearchVisible) {
      leadingSlivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: sectionSpacing),
            child: LumosSearchBar(
              controller: searchController,
              autofocus: true,
              hintText: l10n.flashcardSearchHint,
              clearTooltip: l10n.flashcardSearchClearTooltip,
              onChanged: onSearchChanged,
              onClear: onSearchCleared,
            ),
          ),
        ),
      );
    }
    if (state.hasItems) {
      leadingSlivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: sectionSpacing),
            child: FlashcardStudyActionSection(actions: studyActions),
          ),
        ),
      );
      leadingSlivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: sectionSpacing),
            child: FlashcardStudyProgressSection(
              title: l10n.flashcardProgressTitle,
              description: l10n.flashcardProgressDescription,
              notStartedLabel: l10n.flashcardProgressNotStartedLabel,
              learningLabel: l10n.flashcardProgressLearningLabel,
              masteredLabel: l10n.flashcardProgressMasteredLabel,
              notStartedCount: notStartedCount,
              learningCount:
                  FlashcardContentSupportConst.defaultLearningProgressCount,
              masteredCount: masteredCount,
              totalCount: state.totalElements,
              onNotStartedPressed: onOpenStudyAtPreview,
              onLearningPressed: onOpenStudyAtPreview,
              onMasteredPressed: onOpenStudyAtPreview,
            ),
          ),
        ),
      );
      leadingSlivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: sectionSpacing),
            child: FlashcardListHeader(
              title: l10n.flashcardCardSectionTitle,
              subtitle: l10n.flashcardTotalLabel(state.totalElements),
              sortLabel: sortLabel,
              onSortPressed: onShowSortSheet,
            ),
          ),
        ),
      );
      leadingSlivers.add(
        SliverToBoxAdapter(child: SizedBox(height: mediumGap)),
      );
    }

    final List<Widget> trailingSlivers = <Widget>[];
    if (state.isLoadingMore) {
      trailingSlivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: mediumGap, bottom: loadingBottomGap),
            child: const Center(child: LumosLoadingIndicator()),
          ),
        ),
      );
    }
    trailingSlivers.add(
      SliverToBoxAdapter(child: SizedBox(height: bottomSpacing)),
    );

    return LumosPagedSliverList(
      controller: scrollController,
      leadingSlivers: leadingSlivers,
      trailingSlivers: trailingSlivers,
      itemCount: state.items.length,
      itemBuilder: (BuildContext context, int index) {
        final FlashcardNode item = state.items[index];
        final bool isStarred = isStarredResolver(item);
        return Padding(
          key: ValueKey<int>(item.id),
          padding: EdgeInsets.only(bottom: itemSpacing),
          child: FlashcardListCard(
            item: item,
            isStarred: isStarred,
            isAudioPlaying: state.playingFlashcardId == item.id,
            onAudioPressed: () => onAudioPressed(item),
            onStarPressed: () => onStarPressed(item),
            onEditPressed: () => onEditPressed(item),
            onDeletePressed: () => onDeletePressed(item),
          ),
        );
      },
      emptySliver: FlashcardEmptyView(
        isSearchResult: state.searchQuery.isNotEmpty,
        onCreatePressed: onOpenCreateDialog,
      ),
    );
  }
}
