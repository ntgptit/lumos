import '../../../../core/themes/foundation/app_foundation.dart';

abstract final class FlashcardContentSupportConst {
  FlashcardContentSupportConst._();

  static const Duration searchDebounceDuration = AppDurations.medium;
  static const double listBottomSpacing = AppSpacing.canvas;
  static const double loadMoreThreshold = AppSpacing.canvas;
  static const double listItemSpacing = AppSpacing.sm;
  static const double sectionSpacing = AppSpacing.lg;
  static const double progressMaskTopInset = AppSpacing.sm;
  static const double progressMaskHeight = WidgetSizes.progressTrackHeight;
  static const double previewViewportFraction = 0.96;
  static const double screenVerticalPadding = AppSpacing.lg;
  static const int defaultLearningProgressCount = 0;
}
