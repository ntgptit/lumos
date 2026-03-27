import 'package:flutter/foundation.dart';
import 'package:lumos/core/theme/responsive/screen_class.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

@immutable
class AdaptiveComponentSize {
  const AdaptiveComponentSize({
    required this.buttonHeight,
    required this.bottomBarHeight,
    required this.bottomSheetHandleHeight,
    required this.bottomSheetHandleWidth,
    required this.cardPadding,
    required this.emptyStateMinHeight,
    required this.inputHeight,
    required this.chipHeight,
    required this.dialogPadding,
    required this.listItemLeadingSize,
    required this.loadingStateMaxWidth,
    required this.toolbarHeight,
    required this.fabSize,
    required this.navigationRailWidth,
    required this.cardMinHeight,
  });

  factory AdaptiveComponentSize.fromScreen(ScreenClass screenClass) {
    return switch (screenClass) {
      ScreenClass.compact => const AdaptiveComponentSize(
        buttonHeight: AppSizeTokens.compactButtonHeight,
        bottomBarHeight: AppSizeTokens.compactBottomBarHeight,
        bottomSheetHandleHeight: AppSizeTokens.bottomSheetHandleHeight,
        bottomSheetHandleWidth: AppSizeTokens.bottomSheetHandleWidth,
        cardPadding: AppSizeTokens.cardPadding,
        emptyStateMinHeight: AppSizeTokens.compactEmptyStateMinHeight,
        inputHeight: AppSizeTokens.compactInputHeight,
        chipHeight: AppSizeTokens.chipHeight,
        dialogPadding: AppSizeTokens.dialogPadding,
        listItemLeadingSize: AppSizeTokens.compactListItemLeadingSize,
        loadingStateMaxWidth: AppSizeTokens.loadingStateMaxWidth,
        toolbarHeight: AppSizeTokens.compactToolbarHeight,
        fabSize: AppSizeTokens.fabSize,
        navigationRailWidth: 72,
        cardMinHeight: AppSizeTokens.cardMinHeight,
      ),
      ScreenClass.medium => const AdaptiveComponentSize(
        buttonHeight: AppSizeTokens.regularButtonHeight,
        bottomBarHeight: AppSizeTokens.regularBottomBarHeight,
        bottomSheetHandleHeight: AppSizeTokens.bottomSheetHandleHeight,
        bottomSheetHandleWidth: AppSizeTokens.bottomSheetHandleWidth,
        cardPadding: AppSizeTokens.cardPadding,
        emptyStateMinHeight: AppSizeTokens.regularEmptyStateMinHeight,
        inputHeight: AppSizeTokens.regularInputHeight,
        chipHeight: AppSizeTokens.chipHeight,
        dialogPadding: AppSizeTokens.dialogPadding,
        listItemLeadingSize: AppSizeTokens.regularListItemLeadingSize,
        loadingStateMaxWidth: AppSizeTokens.loadingStateMaxWidth,
        toolbarHeight: AppSizeTokens.compactToolbarHeight,
        fabSize: AppSizeTokens.fabSize,
        navigationRailWidth: AppSizeTokens.navigationRailWidth,
        cardMinHeight: AppSizeTokens.cardMinHeight,
      ),
      ScreenClass.expanded => const AdaptiveComponentSize(
        buttonHeight: AppSizeTokens.comfortableButtonHeight,
        bottomBarHeight: AppSizeTokens.comfortableBottomBarHeight,
        bottomSheetHandleHeight: AppSizeTokens.bottomSheetHandleHeight,
        bottomSheetHandleWidth: AppSizeTokens.bottomSheetHandleWidth,
        cardPadding: 20,
        emptyStateMinHeight: AppSizeTokens.comfortableEmptyStateMinHeight,
        inputHeight: 56,
        chipHeight: 36,
        dialogPadding: 32,
        listItemLeadingSize: AppSizeTokens.regularListItemLeadingSize,
        loadingStateMaxWidth: AppSizeTokens.loadingStateMaxWidth,
        toolbarHeight: AppSizeTokens.regularToolbarHeight,
        fabSize: 60,
        navigationRailWidth: 88,
        cardMinHeight: 136,
      ),
      ScreenClass.large => const AdaptiveComponentSize(
        buttonHeight: AppSizeTokens.comfortableButtonHeight,
        bottomBarHeight: AppSizeTokens.comfortableBottomBarHeight,
        bottomSheetHandleHeight: AppSizeTokens.bottomSheetHandleHeight,
        bottomSheetHandleWidth: AppSizeTokens.bottomSheetHandleWidth,
        cardPadding: 24,
        emptyStateMinHeight: AppSizeTokens.comfortableEmptyStateMinHeight,
        inputHeight: 56,
        chipHeight: 38,
        dialogPadding: 40,
        listItemLeadingSize: AppSizeTokens.comfortableListItemLeadingSize,
        loadingStateMaxWidth: AppSizeTokens.loadingStateMaxWidth,
        toolbarHeight: AppSizeTokens.regularToolbarHeight,
        fabSize: 64,
        navigationRailWidth: 96,
        cardMinHeight: 156,
      ),
    };
  }

  final double buttonHeight;
  final double bottomBarHeight;
  final double bottomSheetHandleHeight;
  final double bottomSheetHandleWidth;
  final double cardPadding;
  final double emptyStateMinHeight;
  final double inputHeight;
  final double chipHeight;
  final double dialogPadding;
  final double listItemLeadingSize;
  final double loadingStateMaxWidth;
  final double toolbarHeight;
  final double fabSize;
  final double navigationRailWidth;
  final double cardMinHeight;
}
