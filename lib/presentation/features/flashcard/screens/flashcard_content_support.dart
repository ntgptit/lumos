import 'package:lumos/core/theme/app_foundation.dart';

abstract final class FlashcardContentSupportConst {
  FlashcardContentSupportConst._();

  static const Duration searchDebounceDuration = AppDurations.medium;
  static const double listBottomSpacing = LumosSpacing.canvas;
  static const double loadMoreThreshold = LumosSpacing.canvas;
  static const double listItemSpacing = LumosSpacing.sm;
  static const double sectionSpacing = LumosSpacing.lg;
  static const double progressMaskTopInset = LumosSpacing.sm;
  static const double progressMaskHeight = WidgetSizes.progressTrackHeight;
  static const double previewViewportFraction = 0.96;
  static const double screenVerticalPadding = LumosSpacing.lg;
  static const int defaultLearningProgressCount = 0;
}

