import 'package:lumos/core/theme/app_foundation.dart';

abstract final class FlashcardContentSupportConst {
  FlashcardContentSupportConst._();

  static const Duration searchDebounceDuration =
      AppMotion.medium;
  static const double listBottomSpacing =
      96;
  static const double loadMoreThreshold =
      96;
  static const double listItemSpacing =
      12;
  static const double sectionSpacing =
      16;
  static const double progressMaskTopInset =
      12;
  static const double progressMaskHeight = 6;
  static const double previewViewportFraction = 0.96;
  static const double screenVerticalPadding =
      24;
  static const int defaultLearningProgressCount = 0;
}
