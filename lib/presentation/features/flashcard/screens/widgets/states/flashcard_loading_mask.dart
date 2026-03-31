import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../flashcard_content_support.dart';

class FlashcardLoadingMask extends StatelessWidget {
  const FlashcardLoadingMask({required this.isVisible, super.key});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return SizedBox.shrink();
    }
    final double topInset = context.compactValue(
      baseValue: FlashcardContentSupportConst.progressMaskTopInset,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double progressHeight = context.compactValue(
      baseValue: FlashcardContentSupportConst.progressMaskHeight,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: topInset),
          child: ClipRRect(
            borderRadius: context.shapes.control,
            child: LumosLoadingIndicator(isLinear: true, size: progressHeight),
          ),
        ),
      ),
    );
  }
}
